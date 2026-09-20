const express = require('express');
const router = express.Router();
const categories = require('../data/categories');
const tools = require('../data/tools');

// GET /v1/categories
router.get('/', (req, res) => {
  res.json({ data: categories });
});

// GET /v1/categories/:id
router.get('/:id', (req, res) => {
  const cat = categories.find((c) => c.id === req.params.id);
  if (!cat) return res.status(404).json({ error: 'Category not found' });
  res.json({ data: cat });
});

// GET /v1/categories/:id/tools
router.get('/:id/tools', (req, res) => {
  const catTools = tools.filter((t) => t.categoryId === req.params.id);
  res.json({ data: catTools });
});

module.exports = router;
