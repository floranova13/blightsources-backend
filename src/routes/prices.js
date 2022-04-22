const express = require('express');
const { query } = require('../../');
const router = express.Router();

router.get('/', async (req, res) => {
  const sql = 'SELECT * FROM prices;';
  const data = await query(sql);
  res.send(data);
});

router.get('/:name', async (req, res) => {
  const { name } = req.params;
  const sql = 'SELECT * FROM prices WHERE blightsource_id IN (SELECT id FROM blightsources b WHERE b.name = $1);';
  const data = await query(sql, [name]);
  res.send(data);
});

router.post('/', async (req, res) => {
  const { name, basePrice, priceHistory, volatility } = req.body;
  const sql = 'INSERT INTO prices (blightsource_id, base_price, priceHistory, volatility) VALUES ((SELECT id from blightsources b WHERE b.bname = $1), $2, $3, $3, $4);';
  const data = await query(sql, [name, basePrice, priceHistory, volatility]);
  res.send(data);
});

router.patch('/:name', async (req, res) => {
  const { name } = req.params;
  const { newPrice } = req.body;
  const sql = 'UPDATE prices SET priceHistory = array_append(priceHistory, $2) WHERE blightsource_id IN (SELECT id FROM blightsources b WHERE b.name = $1);';
  const data = await query(sql, [name, newPrice]);
  res.send(data);
})

module.exports = router;
