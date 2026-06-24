const express = require("express");
const router = express.Router();
const { sql } = require("../db");

// Get all students
router.get("/", async (req, res) => {
  try {
    const result = await sql.query("SELECT * FROM dbo.students");
    res.json(result.recordset);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Add new student
router.post("/", async (req, res) => {
  try {
    const { name, age, department } = req.body;

    await sql.query`
      INSERT INTO dbo.students (name, age, department)
      VALUES (${name}, ${age}, ${department})
    `;

    res.status(201).json({ message: "Student added successfully" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;