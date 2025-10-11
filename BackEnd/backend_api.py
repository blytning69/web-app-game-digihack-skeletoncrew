from fastapi import FastAPI, HTTPException, Request
import requests
import os

app = FastAPI()

# Xendit secret key (set in Railway environment variables)
XENDIT_KEY = os.getenv("XENDIT_SANDBOX_KEY")

# Mock player data (for demo)
players = {
    "moreno": {"points": 1500, "status": "idle"}
}

POINT_VALUE = 10000 / 1000  # 1000 points = Rp10,000


@app.get("/")
def home():
    return {"status": "ok", "service": "railway-backend"}


@app.post("/redeem/{player}")
def redeem_points(player: str):
    """Create a Xendit disbursement for the given player"""
    player_data = players.get(player)
    if not player_data:
        raise HTTPException(404, "Player not found")

    if player_data["points"] < 1000:
        raise HTTPException(400, "Not enough points to redeem")

    amount = int(player_data["points"] * POINT_VALUE)

    data = {
        "external_id": f"redeem-{player}",
        "amount": amount,
        "bank_code": "BRI",
        "account_holder_name": player,
        "account_number": "1234567890",
        "description": f"Redeem points for {player}",
    }

    response = requests.post(
        "https://api.xendit.co/disbursements",
        json=data,
        auth=(XENDIT_KEY, "")
    )

    if response.status_code != 200:
        raise HTTPException(status_code=500, detail=response.text)

    player_data["status"] = "processing"
    player_data["points"] = 0

    return {"redeem": "ok", "xendit_response": response.json()}


@app.post("/webhook/xendit")
async def webhook_xendit(request: Request):
    """Receive status updates from Xendit"""
    try:
        payload = await request.json()
        print("Webhook payload:", payload)

        external_id = payload.get("external_id", "")
        status = payload.get("status", "")

        # Match disbursement to player
        if external_id.startswith("redeem-"):
            player_name = external_id.replace("redeem-", "")
            if player_name in players:
                players[player_name]["status"] = status
                print(f"Updated {player_name} status -> {status}")

        return {"ok": True}

    except Exception as e:
        print("Webhook error:", e)
        raise HTTPException(400, f"Invalid payload: {e}")


@app.get("/player/{player}")
def get_player_status(player: str):
    """Check current status and points for a player"""
    player_data = players.get(player)
    if not player_data:
        raise HTTPException(404, "Player not found")
    return player_data
