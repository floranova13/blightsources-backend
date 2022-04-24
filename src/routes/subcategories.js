const express = require('express');
const { query } = require('../db');
const router = express.Router();

router.get('/', async (req, res) => {
  const sql = 'SELECT s.id s.name, c.name AS category, s.description FROM subcategories s, categories c WHERE s.category_id = c.id;';
  const { rows } = await query(sql);
  const subcategoriesList = rows.map((row) => {
    const { name, category, description } = row;
    return { name, category, description };
  });

  res.send(subcategoriesList);
});

router.get('/:name', async (req, res) => {
  const { name: subcategoryName } = req.params;
  const sql = 'SELECT s.id s.name, c.name AS category, s.description FROM subcategories s, categories c WHERE s.category_id = c.id AND s.name = $1;';
  const { rows } = await query(sql, [subcategoryName]);
  const { name, category, description } = rows[0];

  res.send({ name, category, description });
});

// POST WILL ERROR OUT
// router.post('/', async (req, res) => { // eventually add the ability to input a description
//   const { name, category_name } = req.body;
//   const sql = 'INSERT INTO subcategories (name, category_name) VALUES ($1, (SELECT id from categories c WHERE c.name = $2));';
//   const data = await query(sql, [name, category_name]);
//   res.send(data);
// });

module.exports = router;
