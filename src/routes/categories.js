const express = require('express');
const { query } = require('../..');
const router = express.Router();

router.get('/', async (req, res) => {
  const sql = 'SELECT * FROM categories;';
  const data = await query(sql);
  res.send(data);
});

router.get('/:name', async (req, res) => {
  const { name } = req.params;
  const sql = 'SELECT * FROM categories c WHERE c.name = $1;';
  const data = await query(sql, [name]);
  res.send(data);
});

module.exports = router;