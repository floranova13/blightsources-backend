const express = require('express');
const { query } = require('../db');
const router = express.Router();

router.get('/', async (req, res) => {
  const sql = 'SELECT * FROM subcategories;';
  const data = await query(sql);
  res.send(data);
});

router.get('/:name', async (req, res) => {
  const { name } = req.params;
  const sql = 'SELECT * FROM subcategories s WHERE s.name = $1;';
  const data = await query(sql, [name]);
  res.send(data);
});

router.post('/', async (req, res) => { // eventually add the ability to input a description
  const { name, category_name } = req.body;
  const sql = 'INSERT INTO subcategories (name, category_name) VALUES ($1, (SELECT id from categories c WHERE c.name = $2));';
  const data = await query(sql, [name, category_name]);
  res.send(data);
});

module.exports = router;
