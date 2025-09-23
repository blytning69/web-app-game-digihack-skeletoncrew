const express = require("express");
const router = express.Router();
const pool = require("../db");

// Get leaderboard (top 10)
router.get("/", async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT u.username, COALESCE(SUM(a.is_correct::int),0) as score
      FROM users u
      LEFT JOIN attempts a ON u.id = a.user_id
      GROUP BY u.id
      ORDER BY score DESC
      LIMIT 10
    `);
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
