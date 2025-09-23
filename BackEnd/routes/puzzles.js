const express = require("express");
const router = express.Router();
const pool = require("../db");

// Get all puzzles
router.get("/", async (req, res) => {
  try {
    const result = await pool.query("SELECT id, prompt, difficulty FROM puzzles");
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
