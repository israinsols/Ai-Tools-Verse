require('dotenv').config();
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const rateLimit = require('express-rate-limit');
const path = require('path');
const toolsRouter = require('./routes/tools');
const categoriesRouter = require('./routes/categories');
const authRouter = require('./routes/auth');
const bookmarksRouter = require('./routes/bookmarks');
const reviewsRouter = require('./routes/reviews');
const uploadRouter = require('./routes/upload');
const paymentsRouter = require('./routes/payments');
const notificationsRouter = require('./routes/notifications');

const app = express();
const PORT = process.env.PORT || 3000;

// Security
app.use(helmet());

// Rate limiting
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // 100 requests per window
  standardHeaders: true,
  legacyHeaders: false,
  message: { error: 'Too many requests, please try again later' },
});
app.use(limiter);

const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 20,
  standardHeaders: true,
  legacyHeaders: false,
  message: { error: 'Too many auth attempts, please try again later' },
});

// Middleware
app.use(cors());
app.use(express.json({ limit: '10mb' }));
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

// Routes
app.use('/v1/tools', toolsRouter);
app.use('/v1/categories', categoriesRouter);
app.use('/v1/auth', authLimiter, authRouter);
app.use('/v1/bookmarks', bookmarksRouter);
app.use('/v1/reviews', reviewsRouter);
app.use('/v1/upload', uploadRouter);
app.use('/v1/payments', paymentsRouter);
app.use('/v1/notifications', notificationsRouter);

// Health check
app.get('/v1/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

// 404 handler
app.use((req, res) => {
  res.status(404).json({ error: 'Not found' });
});

// Error handler
app.use((err, req, res, _next) => {
  console.error(err.stack);
  res.status(err.status || 500).json({
    error: err.message || 'Internal server error',
  });
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`AIVerse API running on http://localhost:${PORT}`);
});
