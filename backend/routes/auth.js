const express = require('express');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const router = express.Router();
const users = require('../data/users');
const { JWT_SECRET, authMiddleware } = require('../middleware/auth');

// POST /v1/auth/signup
router.post('/signup', async (req, res) => {
  const { email, password, displayName } = req.body;

  if (!email || !password) {
    return res.status(400).json({ error: 'Email and password required' });
  }

  const existing = users.find((u) => u.email === email);
  if (existing) {
    return res.status(409).json({ error: 'Email already registered' });
  }

  const hashedPassword = await bcrypt.hash(password, 10);
  const newUser = {
    id: String(users.length + 1),
    email,
    password: hashedPassword,
    displayName: displayName || email.split('@')[0],
    role: 'user',
    createdAt: new Date().toISOString(),
  };

  users.push(newUser);

  const token = jwt.sign(
    { id: newUser.id, email: newUser.email, role: newUser.role },
    JWT_SECRET,
    { expiresIn: '7d' }
  );

  res.status(201).json({
    data: {
      id: newUser.id,
      email: newUser.email,
      displayName: newUser.displayName,
      role: newUser.role,
      token,
    },
  });
});

// POST /v1/auth/signin
router.post('/signin', async (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({ error: 'Email and password required' });
  }

  const user = users.find((u) => u.email === email);
  if (!user) {
    return res.status(401).json({ error: 'Invalid credentials' });
  }

  let valid = false;
  if (user.password.startsWith('$2a$') || user.password.startsWith('$2b$')) {
    valid = await bcrypt.compare(password, user.password);
  } else {
    valid = password === user.password;
  }
  if (!valid) {
    return res.status(401).json({ error: 'Invalid credentials' });
  }

  const token = jwt.sign(
    { id: user.id, email: user.email, role: user.role },
    JWT_SECRET,
    { expiresIn: '7d' }
  );

  res.json({
    data: {
      id: user.id,
      email: user.email,
      displayName: user.displayName,
      role: user.role,
      token,
    },
  });
});

// POST /v1/auth/signout
router.post('/signout', (req, res) => {
  res.json({ message: 'Signed out' });
});

// GET /v1/auth/me
router.get('/me', authMiddleware, (req, res) => {
  const user = users.find((u) => u.id === req.user.id);
  if (!user) {
    return res.status(404).json({ error: 'User not found' });
  }

  res.json({
    data: {
      id: user.id,
      email: user.email,
      displayName: user.displayName,
      role: user.role,
    },
  });
});

module.exports = router;
