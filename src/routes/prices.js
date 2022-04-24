const express = require('express');
const { query } = require('../db');
const router = express.Router();

router.get('/', async (req, res) => {
  const sql =
    'SELECT b.name, p.base_price, p.price_history, p.volatility FROM prices p, blightsources b WHERE p.blightsource_id = b.id;';
  const { rows } = await query(sql);
  const pricesList = rows.map((row) => {
    const {
      name,
      base_price: basePrice,
      price_history: priceHistory,
      volatility,
    } = row;
    return { name, basePrice, priceHistory, volatility };
  });

  res.send(pricesList);
});

router.get('/:name', async (req, res) => {
  const { name: blightsourceName } = req.params;
  const sql =
    'SELECT b.name, p.base_price, p.price_history, p.volatility FROM prices p, blightsources b WHERE p.blightsource_id = b.id AND b.name = $1;';
  const { rows } = await query(sql, [blightsourceName]);
  const {
    name,
    base_price: basePrice,
    price_history: priceHistory,
    volatility,
  } = rows[0];

  res.send({ name, basePrice, priceHistory, volatility });
});

// POST WILL ERROR OUT
// router.post('/', async (req, res) => {
//   const { name, basePrice, priceHistory, volatility } = req.body;
//   const sql = 'INSERT INTO prices (blightsource_id, base_price, priceHistory, volatility) VALUES ((SELECT id from blightsources b WHERE b.bname = $1), $2, $3, $3, $4);';
//   const data = await query(sql, [name, basePrice, priceHistory, volatility]);
//   res.send(data);
// });

// PATCH WILL ERROR OUT
// router.patch('/:name', async (req, res) => {
//   const { name } = req.params;
//   const { newPrice } = req.body;
//   const sql = 'UPDATE prices SET priceHistory = array_append(priceHistory, $2) WHERE blightsource_id IN (SELECT id FROM blightsources b WHERE b.name = $1);';
//   const data = await query(sql, [name, newPrice]);
//   res.send(data);
// })

module.exports = router;
