const express = require('express');
const router = express.Router();
const blightsourcesRouter = require('./blightsources');
const pricesRouter = require('./prices');

// middleware that is specific to this router
router.use((err, req, res, next) => {
  res.status(403).send(err.message);
});

router.use('/blightsources', blightsourcesRouter);
router.use('/prices', pricesRouter);

module.exports = router;
