const express = require('express');
const { query } = require('../db');
const router = express.Router();

router.get('/', async (req, res) => {
  const sql = 'SELECT * FROM categories;';
  const { rows } = await query(sql);
  res.send(rows);
});

router.get('/:name', async (req, res) => {
  const { name } = req.params;
  const sql = 'SELECT * FROM categories c WHERE c.name = $1;';
  const { rows } = await query(sql, [name]);
  res.send(rows);
});

module.exports = router;
