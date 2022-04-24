const express = require('express');
const { query } = require('../db');
const router = express.Router();

router.get('/', async (req, res) => {
  const sql =
    'SELECT b.id, b.name, c.name AS category, s.name AS subcategory, b.description, b.rarity FROM blightsources b, subcategories s, categories c WHERE b.subcategory_id = s.id AND b.category_id = c.id;';
  const { rows } = await query(sql);
  const blightsourcesList = rows.map((row) => {
    const { name, category, subcategory, description, rarity } = row;
    return { name, category, subcategory, description, rarity };
  });

  res.send(blightsourcesList);
});

router.get('/:name', async (req, res) => {
  const { name: blightsourceName } = req.params;
  const sql =
    'SELECT b.id, b.name, c.name AS category, s.name AS subcategory, b.description, b.rarity FROM blightsources b, subcategories s, categories c WHERE b.subcategory_id = s.id AND b.category_id = c.id AND b.name = $1;';
  const { rows } = await query(sql, [blightsourceName]);
  const { name, category, subcategory, description, rarity } = rows[0];

  res.send({ name, category, subcategory, description, rarity });
});

// // IT WILL CURRENTLY ERROR OUT ON A POST
// router.post('/', async (req, res) => {
//   const { name } = req.body;
//   const sql = 'INSERT INTO blightsources (name) VALUES ($1);';
//   const data = await query(sql, [name]);
//   res.send(data);
// });

module.exports = router;
