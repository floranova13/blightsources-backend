const express = require('express');
const { query } = require('../db');
const router = express.Router();

router.get('/', async (req, res) => {
  const sql = 'SELECT b.id, b.name, c.name AS category, s.name AS subcategory FROM blightsources b, subcategories s, categories c WHERE b.subcategory_id = s.id AND b.category_id = c.id;';
  const { rows } = await query(sql);

  // const blightsourcesArr = rows.map(row => {
  //   const { name } = row;
  // })

  res.send(rows);
});

router.get('/:name', async (req, res) => {
  const { name } = req.params;
  const sql = 'SELECT * FROM blightsources WHERE blightsources.name = $1;';
  const { rows } = await query(sql, [name]);
  res.send(rows);
});

router.post('/', async (req, res) => {
  const { name } = req.body;
  const sql = 'INSERT INTO blightsources (name) VALUES ($1);';
  const data = await query(sql, [name]);
  res.send(data);
});

module.exports = router;
