from fastapi import FastAPI, HTTPException, Request, Depends, Form
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from jose import jwt, JWTError
from passlib.context import CryptContext
from datetime import datetime, timedelta
from sqlalchemy import create_engine, Column, String, Integer, ForeignKey, DateTime
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, relationship
import requests
import os
import hashlib

# ---------------- CONFIG ----------------
app = FastAPI()
XENDIT_KEY = os.getenv("XENDIT_SANDBOX_KEY")
SECRET_KEY = os.getenv("JWT_SECRET_KEY", "supersecret")
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 60
POINT_CONVERSION_RATE = 10 / 10000  # Rp10,000 = 1000 points

# ✅ Gunakan Argon2 untuk password
pwd_context = CryptContext(schemes=["argon2"], deprecated="auto")
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="login")

# ---------------- DATABASE ----------------
DATABASE_URL = "postgresql://game_db_zt66_user:A485vrVtwAjZQKn5ncQWDSbasn74VNRB@dpg-d3mfq015pdvs73b7v6f0-a/game_db_zt66"

if DATABASE_URL and DATABASE_URL.startswith("sqlite"):
    engine = create_engine(DATABASE_URL, connect_args={"check_same_thread": False})
else:
    engine = create_engine(DATABASE_URL)

Base = declarative_base()
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# ---------------- MODELS ----------------
class Player(Base):
    __tablename__ = "players"
    username = Column(String, primary_key=True, index=True)
    password_hash = Column(String, nullable=False)
    points = Column(Integer, default=0)
    status = Column(String, default="idle")
    payment_method = Column(String, nullable=True)
    hashed_account_number = Column(String, nullable=True)
    hashed_account_name = Column(String, nullable=True)
    hashed_bank_code = Column(String, nullable=True)
    transactions = relationship("Transaction", back_populates="player_obj")

class Transaction(Base):
    __tablename__ = "transactions"
    id = Column(Integer, primary_key=True, index=True)
    reference_id = Column(String, unique=True, index=True)
    player = Column(String, ForeignKey("players.username"))
    type = Column(String)
    method = Column(String)
    amount = Column(Integer)
    status = Column(String)
    timestamp = Column(DateTime, default=datetime.utcnow)
    player_obj = relationship("Player", back_populates="transactions")

Base.metadata.create_all(bind=engine)

# ---------------- HELPERS ----------------
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

def verify_password(plain, hashed):
    return pwd_context.verify(plain, hashed)

def get_password_hash(password):
    return pwd_context.hash(password)

def hash_sensitive_data(data: str):
    """Hash data sensitif (nomor rekening, nama pemilik) menggunakan SHA256"""
    return hashlib.sha256(data.encode()).hexdigest()

def create_access_token(data: dict, expires_delta: timedelta | None = None):
    to_encode = data.copy()
    expire = datetime.utcnow() + (expires_delta or timedelta(minutes=15))
    to_encode.update({"exp": expire})
    return jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)

def get_current_player(token: str = Depends(oauth2_scheme), db: SessionLocal = Depends(get_db)):
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        username = payload.get("sub")
        player = db.query(Player).filter(Player.username == username).first()
        if not player:
            raise HTTPException(401, "Invalid user")
        return player
    except JWTError:
        raise HTTPException(401, "Invalid token")

# ---------------- ROUTES ----------------
@app.get("/")
def home():
    return {"status": "ok", "service": "mathmaze-backend"}

# ✅ FIXED: register now accepts form data (GameMaker & curl compatible)
@app.post("/register")
def register(
    username: str = Form(...),
    password: str = Form(...),
    db: SessionLocal = Depends(get_db)
):
    if db.query(Player).filter(Player.username == username).first():
        raise HTTPException(400, "User already exists")
    player = Player(username=username, password_hash=get_password_hash(password))
    db.add(player)
    db.commit()
    return {"msg": f"Player {username} registered successfully"}

# ✅ already accepts x-www-form-urlencoded
@app.post("/login")
def login(form_data: OAuth2PasswordRequestForm = Depends(), db: SessionLocal = Depends(get_db)):
    player = db.query(Player).filter(Player.username == form_data.username).first()
    if not player or not verify_password(form_data.password, player.password_hash):
        raise HTTPException(401, "Invalid username or password")
    token = create_access_token({"sub": player.username},
                                timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES))
    return {"access_token": token, "token_type": "bearer"}

@app.post("/link_payment")
def link_payment(method: str, player: Player = Depends(get_current_player), db: SessionLocal = Depends(get_db)):
    if method not in ["gopay", "card"]:
        raise HTTPException(400, "Unsupported payment method")
    player.payment_method = method
    db.commit()
    return {"msg": f"{method.capitalize()} linked successfully"}

# ---------------- REDEEM ----------------
@app.post("/redeem")
def redeem_points(
    amount: int | None = None,
    account_number: str | None = None,
    account_holder_name: str | None = None,
    bank_code: str | None = None,
    player: Player = Depends(get_current_player),
    db: SessionLocal = Depends(get_db)
):
    if player.points < 1000:
        raise HTTPException(400, "Minimal 1000 poin diperlukan untuk redeem.")
    if not player.payment_method:
        raise HTTPException(400, "Metode pembayaran belum ditautkan.")
    if not account_number or not account_holder_name:
        raise HTTPException(400, "Nomor akun dan nama pemilik wajib diisi.")

    if not bank_code:
        bank_code = "BRI" if player.payment_method.lower() == "card" else "ID_DANA"

    redeem_points = amount if amount else player.points
    if redeem_points > player.points:
        raise HTTPException(400, "Jumlah poin melebihi saldo kamu.")

    rupiah_amount = int(redeem_points * (10000 / 1000))
    ref_id = f"redeem-{player.username}-{int(datetime.now().timestamp())}"

    player.hashed_account_number = hash_sensitive_data(account_number)
    player.hashed_account_name = hash_sensitive_data(account_holder_name)
    player.hashed_bank_code = hash_sensitive_data(bank_code)

    tx = Transaction(
        reference_id=ref_id,
        player=player.username,
        type="redeem",
        method=player.payment_method.upper(),
        amount=rupiah_amount,
        status="PROCESSING"
    )
    db.add(tx)
    db.commit()

    data = {
        "external_id": ref_id,
        "amount": rupiah_amount,
        "bank_code": bank_code,
        "account_holder_name": account_holder_name,
        "account_number": account_number,
        "description": f"Redeem {redeem_points} poin oleh {player.username} ({player.payment_method.upper()})"
    }

    try:
        response = requests.post(
            "https://api.xendit.co/disbursements",
            json=data,
            auth=(XENDIT_KEY, "")
        )
    except Exception as e:
        raise HTTPException(500, f"Gagal menghubungi Xendit: {e}")

    if response.status_code not in [200, 201]:
        raise HTTPException(500, f"Gagal membuat disbursement: {response.text}")

    player.points -= redeem_points
    player.status = "processing"
    tx.status = "PROCESSING"
    db.commit()

    return {
        "msg": "Redeem berhasil diproses.",
        "player": player.username,
        "method": player.payment_method,
        "redeemed_points": redeem_points,
        "amount_rupiah": rupiah_amount,
        "reference_id": ref_id,
        "xendit_response": response.json()
    }

# ---------------- TRANSACTIONS ----------------
@app.get("/transactions")
def list_transactions(player: Player = Depends(get_current_player), db: SessionLocal = Depends(get_db)):
    txs = db.query(Transaction).filter(Transaction.player == player.username)\
        .order_by(Transaction.timestamp.desc()).all()
    return {"player": player.username, "transactions": [
        {
            "reference_id": t.reference_id,
            "type": t.type,
            "method": t.method,
            "amount": t.amount,
            "status": t.status,
            "timestamp": t.timestamp.isoformat(),
        } for t in txs
    ]}

# ---------------- WEBHOOK ----------------
@app.post("/webhook/xendit")
async def webhook_xendit(request: Request, db: SessionLocal = Depends(get_db)):
    payload = await request.json()
    print("Webhook:", payload)

    if "data" in payload:
        data = payload["data"]
        ref_id = data.get("reference_id") or data.get("external_id")
        status = data.get("status", "").upper()
        tx = db.query(Transaction).filter(Transaction.reference_id == ref_id).first()
        if tx:
            tx.status = status
            db.commit()
            if tx.type == "topup" and status == "SUCCEEDED":
                player = db.query(Player).filter(Player.username == tx.player).first()
                if player:
                    added_points = int(tx.amount * POINT_CONVERSION_RATE)
                    player.points += added_points
                    db.commit()
    elif payload.get("external_id", "").startswith("redeem-"):
        ref_id = payload["external_id"]
        status = payload.get("status", "UNKNOWN")
        tx = db.query(Transaction).filter(Transaction.reference_id == ref_id).first()
        if tx:
            tx.status = status
            db.commit()
            player = db.query(Player).filter(Player.username == tx.player).first()
            if player:
                player.status = status
                db.commit()
    return {"ok": True}

@app.get("/topup-success")
def topup_success():
    return {"status": "ok", "message": "Top-up succeeded!"}

@app.get("/topup-failed")
def topup_failed():
    return {"status": "failed", "message": "Top-up failed or cancelled."}
