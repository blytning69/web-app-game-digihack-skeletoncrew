const express = require("express");
const router = express.Router();
const pool = require("../db");

// Register user
router.post("/register", async (req, res) => {
  const { username, email, password } = req.body;
  try {
    const result = await pool.query(
      "INSERT INTO users (username, email, password_hash) VALUES ($1,$2,$3) RETURNING id, username, email, created_at",
      [username, email, password]
    );
    res.json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
