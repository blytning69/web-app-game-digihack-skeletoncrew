// BackEnd/routes.js
const express = require("express");
const pool = require("./db");
const bcrypt = require("bcrypt");

const router = express.Router();

/* ---------------- USERS ---------------- */

// register
router.post("/users/register", async (req, res) => {
  const { username, email, password } = req.body;
  if (!username || !email || !password) return res.status(400).json({ error: "Missing fields" });

  try {
    const hash = await bcrypt.hash(password, 10);
    const q = `INSERT INTO users (username, email, password_hash) VALUES ($1, $2, $3) RETURNING id, username, email, created_at`;
    const { rows } = await pool.query(q, [username, email, hash]);
    res.json(rows[0]);
  } catch (err) {
    console.error(err);
    if (err.code === "23505") return res.status(409).json({ error: "Username or email already exists" });
    res.status(500).json({ error: "DB error" });
  }
});

// simple login (returns user basic info; add JWT later)
router.post("/users/login", async (req, res) => {
  const { email, password } = req.body;
  try {
    const { rows } = await pool.query("SELECT id, username, email, password_hash FROM users WHERE email = $1", [email]);
    const user = rows[0];
    if (!user) return res.status(401).json({ error: "Invalid credentials" });
    const ok = await bcrypt.compare(password, user.password_hash);
    if (!ok) return res.status(401).json({ error: "Invalid credentials" });
    // remove password_hash before returning
    delete user.password_hash;
    res.json(user);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "DB error" });
  }
});

/* ---------------- PUZZLES ---------------- */

// create puzzle
router.post("/puzzles", async (req, res) => {
  const { maze_data, difficulty } = req.body;
  if (!maze_data || !difficulty) return res.status(400).json({ error: "Missing fields" });

  try {
    const q = `INSERT INTO puzzles (maze_data, difficulty, created_at) VALUES ($1, $2, NOW()) RETURNING *`;
    const { rows } = await pool.query(q, [maze_data, difficulty]);
    res.json(rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "DB error" });
  }
});

// get puzzles (optionally filter by difficulty)
router.get("/puzzles", async (req, res) => {
  const { difficulty } = req.query;
  try {
    const q = difficulty ? `SELECT * FROM puzzles WHERE difficulty = $1 ORDER BY id` : `SELECT * FROM puzzles ORDER BY id`;
    const { rows } = await pool.query(q, difficulty ? [difficulty] : []);
    res.json(rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "DB error" });
  }
});

/* ---------------- ATTEMPTS ---------------- */

// create attempt
router.post("/attempts", async (req, res) => {
  const { user_id, puzzle_id, time_taken, solved } = req.body;
  if (!user_id || !puzzle_id || time_taken == null) return res.status(400).json({ error: "Missing fields" });

  try {
    const q = `INSERT INTO attempts (user_id, puzzle_id, time_taken, solved, attempted_at) VALUES ($1, $2, $3, $4, NOW()) RETURNING *`;
    const { rows } = await pool.query(q, [user_id, puzzle_id, time_taken, solved ?? false]);
    res.json(rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "DB error" });
  }
});

// get attempts for a user
router.get("/attempts/user/:user_id", async (req, res) => {
  const user_id = Number(req.params.user_id);
  try {
    const q = `SELECT a.*, p.difficulty, p.maze_data FROM attempts a JOIN puzzles p ON a.puzzle_id = p.id WHERE a.user_id = $1 ORDER BY a.attempted_at DESC`;
    const { rows } = await pool.query(q, [user_id]);
    res.json(rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "DB error" });
  }
});

/* ---------------- LEADERBOARD ---------------- */

// get leaderboard (top N)
router.get("/leaderboard", async (req, res) => {
  const limit = Number(req.query.limit) || 10;
  try {
    const q = `SELECT l.rank, l.total_score, u.id as user_id, u.username FROM leaderboard l JOIN users u ON l.user_id = u.id ORDER BY l.total_score DESC LIMIT $1`;
    const { rows } = await pool.query(q, [limit]);
    res.json(rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "DB error" });
  }
});

module.exports = router;
