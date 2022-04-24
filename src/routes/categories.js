const express = require('express');
const { query } = require('../db');
const router = express.Router();

router.get('/', async (req, res) => {
  const sql = 'SELECT * FROM categories;';
  const { rows } = await query(sql);
  const categoriesList = rows.map((row) => {
    const { name, description } = row;
    return { name, description };
  });

  res.send(categoriesList);
});

router.get('/:name', async (req, res) => {
  const { name: categoryName } = req.params;
  const sql = 'SELECT * FROM categories c WHERE c.name = $1;';
  const { rows } = await query(sql, [categoryName]);
  const { name, description } = rows[0];

  res.send({ name, description });
});

module.exports = router;
