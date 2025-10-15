from fastapi import FastAPI, HTTPException, Request, Depends
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from jose import jwt, JWTError
from passlib.context import CryptContext
from datetime import datetime, timedelta
from sqlalchemy import create_engine, Column, String, Integer, ForeignKey, DateTime
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, relationship
import requests
import os

# ---------------- CONFIG ----------------
app = FastAPI()
XENDIT_KEY = os.getenv("XENDIT_SANDBOX_KEY")
SECRET_KEY = os.getenv("JWT_SECRET_KEY", "supersecret")
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 60
POINT_CONVERSION_RATE = 10 / 10000  # Rp10,000 = 1000 points

# ✅ Use Argon2 instead of bcrypt
pwd_context = CryptContext(schemes=["argon2"], deprecated="auto")
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="login")

# ---------------- DATABASE ----------------
DATABASE_URL = "postgresql://game_db_zt66_user:A485vrVtwAjZQKn5ncQWDSbasn74VNRB@dpg-d3mfq015pdvs73b7v6f0-a/game_db_zt66"
engine = create_engine(DATABASE_URL, connect_args={"check_same_thread": False})
Base = declarative_base()
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

class Player(Base):
    __tablename__ = "players"
    username = Column(String, primary_key=True, index=True)
    password_hash = Column(String, nullable=False)
    points = Column(Integer, default=0)
    status = Column(String, default="idle")
    payment_method = Column(String, nullable=True)
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

@app.post("/register")
def register(username: str, password: str, db: SessionLocal = Depends(get_db)):
    if db.query(Player).filter(Player.username == username).first():
        raise HTTPException(400, "User already exists")
    player = Player(username=username, password_hash=get_password_hash(password))
    db.add(player)
    db.commit()
    return {"msg": f"Player {username} registered successfully"}

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
    if method not in ["gopay", "dana", "card"]:
        raise HTTPException(400, "Unsupported payment method")
    player.payment_method = method
    db.commit()
    return {"msg": f"{method.capitalize()} linked successfully"}

@app.post("/payment/topup")
def topup_points(amount: int, method: str, player: Player = Depends(get_current_player), db: SessionLocal = Depends(get_db)):
    method = method.upper()
    if method not in ["GOPAY", "DANA", "CARD"]:
        raise HTTPException(400, "Invalid method")

    ref_id = f"topup-{player.username}-{method}-{int(datetime.now().timestamp())}"
    tx = Transaction(reference_id=ref_id, player=player.username, type="topup",
                     method=method, amount=amount, status="PENDING")
    db.add(tx)
    db.commit()

    if method in ["GOPAY", "DANA"]:
        data = {
            "reference_id": ref_id,
            "currency": "IDR",
            "amount": amount,
            "checkout_method": "ONE_TIME_PAYMENT",
            "channel_code": f"ID_{method}",
            "channel_properties": {
                "success_redirect_url": "https://web-app-game-digihack-skeletoncrew.onrender.com/topup-success",
                "failure_redirect_url": "https://web-app-game-digihack-skeletoncrew.onrender.com/topup-failed",
            },
        }
        response = requests.post("https://api.xendit.co/ewallets/charges",
                                 json=data, auth=(XENDIT_KEY, ""))
        if response.status_code not in [200, 201]:
            raise HTTPException(500, response.text)
        res = response.json()
        checkout_url = (
            res.get("actions", {}).get("mobile_web_checkout_url")
            or res.get("actions", {}).get("desktop_web_checkout_url")
        )
        return {"msg": f"{method} top-up initiated",
                "redirect_url": checkout_url, "reference_id": ref_id}

    else:  # CARD
        data = {
            "external_id": ref_id,
            "amount": amount,
            "payer_email": f"{player.username}@example.com",
            "description": f"Top-up for {player.username}",
            "invoice_duration": 86400,
            "currency": "IDR",
            "success_redirect_url": "https://yourgame.com/topup-success",
            "failure_redirect_url": "https://yourgame.com/topup-failed",
        }
        response = requests.post("https://api.xendit.co/v2/invoices",
                                 json=data, auth=(XENDIT_KEY, ""))
        if response.status_code not in [200, 201]:
            raise HTTPException(500, response.text)
        invoice = response.json()
        return {"msg": "Card payment created",
                "invoice_url": invoice["invoice_url"], "reference_id": ref_id}

@app.post("/redeem")
def redeem_points(player: Player = Depends(get_current_player), db: SessionLocal = Depends(get_db)):
    if player.points < 1000:
        raise HTTPException(400, "Not enough points")
    if not player.payment_method:
        raise HTTPException(400, "Payment method not linked")

    amount = int(player.points * (10000 / 1000))
    ref_id = f"redeem-{player.username}-{int(datetime.now().timestamp())}"
    tx = Transaction(reference_id=ref_id, player=player.username, type="redeem",
                     method=player.payment_method, amount=amount, status="PROCESSING")
    db.add(tx)
    db.commit()

    data = {
        "external_id": ref_id,
        "amount": amount,
        "bank_code": "BRI",
        "account_holder_name": player.username,
        "account_number": "1234567890",
        "description": f"Redeem points for {player.username}",
    }
    response = requests.post("https://api.xendit.co/disbursements",
                             json=data, auth=(XENDIT_KEY, ""))
    if response.status_code != 200:
        raise HTTPException(500, response.text)

    player.status = "processing"
    player.points = 0
    db.commit()
    return {"redeem": "ok", "reference_id": ref_id, "xendit_response": response.json()}

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

@app.get("/transactions/{reference_id}")
def transaction_detail(reference_id: str, player: Player = Depends(get_current_player), db: SessionLocal = Depends(get_db)):
    tx = db.query(Transaction).filter(Transaction.reference_id == reference_id,
                                      Transaction.player == player.username).first()
    if not tx:
        raise HTTPException(404, "Transaction not found")
    return {
        "reference_id": tx.reference_id,
        "player": tx.player,
        "type": tx.type,
        "method": tx.method,
        "amount": tx.amount,
        "status": tx.status,
        "timestamp": tx.timestamp.isoformat(),
    }

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
                    print(f"{player.username} top-up success: +{added_points} points")
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
