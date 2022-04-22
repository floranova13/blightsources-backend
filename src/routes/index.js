const express = require('express');
const router = express.Router();
const blightsourcesRouter = require('./blightsources');
const pricesRouter = require('./prices');
const categoriesRouter = require('./categories');
const subcategoriesRouter = require('./subcategories');

// middleware that is specific to this router
router.use((err, req, res, next) => {
  res.status(403).send(err.message);
});

router.use('/blightsources', blightsourcesRouter);
router.use('/prices', pricesRouter);
router.use('/categories', categoriesRouter);
router.use('/subcategories', subcategoriesRouter);

module.exports = router;
