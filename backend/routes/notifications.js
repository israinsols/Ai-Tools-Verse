const express = require('express');
const router = express.Router();
const { authMiddleware, adminMiddleware } = require('../middleware/auth');

const notifications = [];

function createNotification({ title, message, type, toolId, userId }) {
  const notification = {
    id: `notif_${Date.now()}_${Math.random().toString(36).slice(2, 6)}`,
    title,
    message,
    type,
    toolId: toolId || null,
    userId,
    isRead: false,
    createdAt: new Date().toISOString(),
  };
  notifications.push(notification);
  return notification;
}

// GET /v1/notifications — user ki notifications
router.get('/', authMiddleware, (req, res) => {
  const userNotifs = notifications
    .filter((n) => n.userId === req.user.id)
    .sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt));

  const unreadCount = userNotifs.filter((n) => !n.isRead).length;

  res.json({ data: userNotifs, unreadCount });
});

// GET /v1/notifications/unread-count
router.get('/unread-count', authMiddleware, (req, res) => {
  const count = notifications.filter(
    (n) => n.userId === req.user.id && !n.isRead
  ).length;
  res.json({ data: { count } });
});

// PUT /v1/notifications/:id/read — mark as read
router.put('/:id/read', authMiddleware, (req, res) => {
  const notif = notifications.find(
    (n) => n.id === req.params.id && n.userId === req.user.id
  );
  if (!notif) return res.status(404).json({ error: 'Notification not found' });

  notif.isRead = true;
  res.json({ data: notif });
});

// PUT /v1/notifications/read-all — mark all as read
router.put('/read-all', authMiddleware, (req, res) => {
  let count = 0;
  notifications.forEach((n) => {
    if (n.userId === req.user.id && !n.isRead) {
      n.isRead = true;
      count++;
    }
  });
  res.json({ message: `${count} notifications marked as read` });
});

// DELETE /v1/notifications/:id
router.delete('/:id', authMiddleware, (req, res) => {
  const index = notifications.findIndex(
    (n) => n.id === req.params.id && n.userId === req.user.id
  );
  if (index === -1) return res.status(404).json({ error: 'Notification not found' });

  notifications.splice(index, 1);
  res.json({ message: 'Notification deleted' });
});

module.exports = router;
module.exports.createNotification = createNotification;
