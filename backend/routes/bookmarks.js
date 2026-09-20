const express = require('express');
const router = express.Router();
const { authMiddleware } = require('../middleware/auth');

// In-memory bookmarks (per user)
const bookmarks = {};

// GET /v1/bookmarks
router.get('/', authMiddleware, (req, res) => {
  const userBookmarks = bookmarks[req.user.id] || [];
  res.json({ data: userBookmarks });
});

// POST /v1/bookmarks/:toolId
router.post('/:toolId', authMiddleware, (req, res) => {
  const userId = req.user.id;
  const { toolId } = req.params;

  if (!bookmarks[userId]) bookmarks[userId] = [];

  if (!bookmarks[userId].includes(toolId)) {
    bookmarks[userId].push(toolId);
  }

  res.json({ data: bookmarks[userId] });
});

// DELETE /v1/bookmarks/:toolId
router.delete('/:toolId', authMiddleware, (req, res) => {
  const userId = req.user.id;
  const { toolId } = req.params;

  if (bookmarks[userId]) {
    bookmarks[userId] = bookmarks[userId].filter((id) => id !== toolId);
  }

  res.json({ data: bookmarks[userId] || [] });
});

module.exports = router;
