import modal
import os

# -------------------------------
# Modal App Setup
# -------------------------------
app = modal.App("math-ai-server")

MODEL_REPO = "ArchdukeLemon/phi3-lora-quantized"

# Image with all dependencies
image = (
    modal.Image.debian_slim()
    .pip_install(
        "fastapi",
        "uvicorn",
        "transformers",
        "torch",
        "accelerate",
        "bitsandbytes"
    )
)

# -------------------------------
# FastAPI App with Preloaded Model
# -------------------------------
@app.function(
    image=image,
    secrets=[modal.Secret.from_name("huggingface-token")],  # Hugging Face token secret
    gpu="T4",               #ini ganti ganti aja kalo soo expensive alahmak no money in this economy why GPU soo expensive
    max_containers=1,
    keep_warm=1,          # Keep 1 container always warm
    timeout=600,
)
@modal.asgi_app()
def fastapi_app():
    from fastapi import FastAPI, Request
    from fastapi.responses import StreamingResponse, JSONResponse
    from transformers import AutoModelForCausalLM, AutoTokenizer, TextIteratorStreamer
    import torch, threading

    fastapi = FastAPI()

    # -------------------------------
    # Load Model Once at Startup
    # -------------------------------
    print("⏳ Preloading model into A100 GPU...")
    hf_token = os.environ.get("HF_TOKEN")
    tokenizer = AutoTokenizer.from_pretrained(MODEL_REPO, token=hf_token)
    model = AutoModelForCausalLM.from_pretrained(
        MODEL_REPO,
        device_map="auto",
        torch_dtype="auto",
        token=hf_token
    )
    print("Model ready in GPU memory")

    # -------------------------------
    # Routes
    # -------------------------------
    @fastapi.get("/")
    async def home():
        return {"status": "ok", "device": "A100 (preloaded, warm)"}

    @fastapi.get("/ask")
    async def ask_get(q: str):
        if not q:
            return JSONResponse({"error": "No question provided"}, status_code=400)

        prompt = f"Solve this math problem step by step:\n{q}\nExplain clearly."
        inputs = tokenizer(prompt, return_tensors="pt").to("cuda")

        output = model.generate(
            inputs["input_ids"],
            max_new_tokens=128,
            temperature=0.3,
            top_p=0.9
        )

        raw_answer = tokenizer.decode(output[0], skip_special_tokens=True)
        answer = raw_answer.replace(prompt, "").strip()

        return {"answer": answer}

    @fastapi.post("/ask")
    async def ask_post(request: Request):
        data = await request.json()
        q = data.get("q", "")

        if not q:
            return JSONResponse({"error": "No question provided"}, status_code=400)

        prompt = f"Solve this math problem step by step:\n{q}\nExplain clearly."
        inputs = tokenizer(prompt, return_tensors="pt").to("cuda")

        output = model.generate(
            inputs["input_ids"],
            max_new_tokens=128,
            temperature=0.3,
            top_p=0.9
        )

        raw_answer = tokenizer.decode(output[0], skip_special_tokens=True)
        answer = raw_answer.replace(prompt, "").strip()

        return {"answer": answer}

    @fastapi.get("/ask/stream")
    async def ask_stream(q: str):
        if not q:
            return JSONResponse({"error": "No question provided"}, status_code=400)

        prompt = f"Solve this math problem step by step:\n{q}\nExplain clearly."
        inputs = tokenizer(prompt, return_tensors="pt").to("cuda")

        streamer = TextIteratorStreamer(tokenizer, skip_prompt=True, skip_special_tokens=True)

        def generate():
            buffer = ""

            thread = threading.Thread(
                target=lambda: model.generate(
                    inputs["input_ids"],
                    max_new_tokens=256,
                    temperature=0.3,
                    top_p=0.9,
                    streamer=streamer
                )
            )
            thread.start()

            for token in streamer:
                buffer += token
                yield token

            # Clean once finished
            clean_output = buffer.replace(prompt, "").strip()
            yield f"\n\n[END]\n{clean_output}"

        return StreamingResponse(generate(), media_type="text/plain")

    return fastapi
