const express = require('express');
const router = express.Router();
const tools = require('../data/tools');
const { authMiddleware, adminMiddleware } = require('../middleware/auth');
const { createNotification } = require('./notifications');

// GET /v1/tools — all approved tools (with optional filters)
router.get('/', (req, res) => {
  const { search, category, sortBy, page = 1, limit = 50 } = req.query;
  let result = tools.filter((t) => t.status === 'approved');

  if (search) {
    const q = search.toLowerCase();
    result = result.filter(
      (t) =>
        t.name.toLowerCase().includes(q) ||
        t.tags.some((tag) => tag.toLowerCase().includes(q))
    );
  }

  if (category) {
    result = result.filter((t) => t.categoryId === category);
  }

  if (sortBy === 'rating') {
    result.sort((a, b) => b.rating - a.rating);
  } else if (sortBy === 'views') {
    result.sort((a, b) => b.viewCount - a.viewCount);
  } else if (sortBy === 'newest') {
    result.sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt));
  }

  const start = (parseInt(page) - 1) * parseInt(limit);
  const paged = result.slice(start, start + parseInt(limit));

  res.json({ data: paged, total: result.length });
});

// GET /v1/tools/trending
router.get('/trending', (req, res) => {
  const trending = tools.filter((t) => t.isTrending && t.status === 'approved');
  res.json({ data: trending });
});

// GET /v1/tools/featured
router.get('/featured', (req, res) => {
  const featured = tools.filter((t) => t.isFeatured && t.status === 'approved');
  res.json({ data: featured });
});

// GET /v1/tools/new
router.get('/new', (req, res) => {
  const newTools = tools.filter((t) => t.isNew && t.status === 'approved');
  res.json({ data: newTools });
});

// GET /v1/tools/search?q=query
router.get('/search', (req, res) => {
  const { q } = req.query;
  if (!q) return res.json({ data: [] });

  const query = q.toLowerCase();
  const results = tools.filter(
    (t) =>
      t.status === 'approved' &&
      (t.name.toLowerCase().includes(query) ||
        t.tags.some((tag) => tag.toLowerCase().includes(query)))
  );

  res.json({ data: results });
});

// GET /v1/tools/pending — admin only
router.get('/pending', authMiddleware, adminMiddleware, (req, res) => {
  const pending = tools.filter((t) => t.status === 'pending');
  res.json({ data: pending });
});

// GET /v1/tools/rejected — admin only
router.get('/rejected', authMiddleware, adminMiddleware, (req, res) => {
  const rejected = tools.filter((t) => t.status === 'rejected');
  res.json({ data: rejected });
});

// POST /v1/tools/submit (protected)
router.post('/submit', authMiddleware, (req, res) => {
  const { v4: uuidv4 } = require('uuid');
  const newTool = {
    id: `user_${uuidv4().slice(0, 8)}`,
    ...req.body,
    rating: 0,
    viewCount: 0,
    isVerified: false,
    isFeatured: false,
    isTrending: false,
    isNew: true,
    status: 'pending',
    submittedBy: req.user.id,
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString(),
  };
  tools.push(newTool);

  createNotification({
    title: 'Tool Submitted',
    message: `Your tool "${newTool.name}" has been submitted and is under review.`,
    type: 'tool_submitted',
    toolId: newTool.id,
    userId: req.user.id,
  });

  res.status(201).json({
    data: newTool,
    message: 'Tool submitted successfully. Waiting for admin approval.',
  });
});

// PUT /v1/tools/:id/approve — admin only
router.put('/:id/approve', authMiddleware, adminMiddleware, (req, res) => {
  const tool = tools.find((t) => t.id === req.params.id);
  if (!tool) return res.status(404).json({ error: 'Tool not found' });

  tool.status = 'approved';
  tool.updatedAt = new Date().toISOString();

  if (tool.submittedBy) {
    createNotification({
      title: 'Tool Approved',
      message: `Your tool "${tool.name}" has been approved and is now live!`,
      type: 'tool_approved',
      toolId: tool.id,
      userId: tool.submittedBy,
    });
  }

  res.json({ data: tool, message: 'Tool approved successfully' });
});

// PUT /v1/tools/:id/reject — admin only
router.put('/:id/reject', authMiddleware, adminMiddleware, (req, res) => {
  const tool = tools.find((t) => t.id === req.params.id);
  if (!tool) return res.status(404).json({ error: 'Tool not found' });

  tool.status = 'rejected';
  tool.updatedAt = new Date().toISOString();

  if (tool.submittedBy) {
    createNotification({
      title: 'Tool Rejected',
      message: `Your tool "${tool.name}" was not approved. Please review our guidelines.`,
      type: 'tool_rejected',
      toolId: tool.id,
      userId: tool.submittedBy,
    });
  }

  res.json({ data: tool, message: 'Tool rejected' });
});

// GET /v1/tools/stats — admin only (counts)
router.get('/stats', authMiddleware, adminMiddleware, (req, res) => {
  const total = tools.length;
  const approved = tools.filter((t) => t.status === 'approved').length;
  const pending = tools.filter((t) => t.status === 'pending').length;
  const rejected = tools.filter((t) => t.status === 'rejected').length;

  res.json({ data: { total, approved, pending, rejected } });
});

// GET /v1/tools/:id
router.get('/:id', (req, res) => {
  const tool = tools.find((t) => t.id === req.params.id);
  if (!tool) return res.status(404).json({ error: 'Tool not found' });
  res.json({ data: tool });
});

module.exports = router;
