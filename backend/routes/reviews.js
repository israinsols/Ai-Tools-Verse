const express = require('express');
const router = express.Router();
const { v4: uuidv4 } = require('uuid');
const reviews = require('../data/reviews');
const users = require('../data/users');
const { authMiddleware, optionalAuth } = require('../middleware/auth');

// GET /reviews/:toolId - Get reviews for a tool
router.get('/:toolId', (req, res) => {
  try {
    const { toolId } = req.params;
    const { sortBy = 'newest', limit = 50 } = req.query;

    let toolReviews = reviews.filter(r => r.toolId === toolId);

    // Sort
    if (sortBy === 'newest') {
      toolReviews.sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt));
    } else if (sortBy === 'highest') {
      toolReviews.sort((a, b) => b.rating - a.rating);
    } else if (sortBy === 'lowest') {
      toolReviews.sort((a, b) => a.rating - b.rating);
    } else if (sortBy === 'helpful') {
      toolReviews.sort((a, b) => b.helpful - a.helpful);
    }

    // Limit
    toolReviews = toolReviews.slice(0, parseInt(limit));

    // Calculate average rating
    const allToolReviews = reviews.filter(r => r.toolId === toolId);
    const avgRating = allToolReviews.length > 0
      ? allToolReviews.reduce((sum, r) => sum + r.rating, 0) / allToolReviews.length
      : 0;

    res.json({
      success: true,
      data: toolReviews,
      meta: {
        total: allToolReviews.length,
        averageRating: Math.round(avgRating * 10) / 10,
      },
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: 'Failed to fetch reviews',
    });
  }
});

// POST /reviews/:toolId - Add a review
router.post('/:toolId', authMiddleware, (req, res) => {
  try {
    const { toolId } = req.params;
    const { rating, title, comment } = req.body;

    if (!rating || rating < 1 || rating > 5) {
      return res.status(400).json({
        success: false,
        error: 'Rating must be between 1 and 5',
      });
    }

    if (!comment || comment.trim().length === 0) {
      return res.status(400).json({
        success: false,
        error: 'Comment is required',
      });
    }

    // Check if user already reviewed this tool
    const existingReview = reviews.find(
      r => r.toolId === toolId && r.userId === req.user.id
    );

    if (existingReview) {
      return res.status(400).json({
        success: false,
        error: 'You have already reviewed this tool',
      });
    }

    const user = users.find(u => u.id === req.user.id);
    const userName = user?.displayName || req.user.email;

    const newReview = {
      id: `rev${uuidv4().slice(0, 8)}`,
      toolId,
      userId: req.user.id,
      userName,
      rating: parseInt(rating),
      title: title || '',
      comment: comment.trim(),
      helpful: 0,
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString(),
    };

    reviews.push(newReview);

    res.status(201).json({
      success: true,
      data: newReview,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: 'Failed to add review',
    });
  }
});

// PUT /reviews/:reviewId - Update a review
router.put('/:reviewId', authMiddleware, (req, res) => {
  try {
    const { reviewId } = req.params;
    const { rating, title, comment } = req.body;

    const reviewIndex = reviews.findIndex(
      r => r.id === reviewId && r.userId === req.user.id
    );

    if (reviewIndex === -1) {
      return res.status(404).json({
        success: false,
        error: 'Review not found or not authorized',
      });
    }

    if (rating !== undefined) reviews[reviewIndex].rating = parseInt(rating);
    if (title !== undefined) reviews[reviewIndex].title = title;
    if (comment !== undefined) reviews[reviewIndex].comment = comment.trim();
    reviews[reviewIndex].updatedAt = new Date().toISOString();

    res.json({
      success: true,
      data: reviews[reviewIndex],
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: 'Failed to update review',
    });
  }
});

// DELETE /reviews/:reviewId - Delete a review
router.delete('/:reviewId', authMiddleware, (req, res) => {
  try {
    const { reviewId } = req.params;
    const reviewIndex = reviews.findIndex(
      r => r.id === reviewId && r.userId === req.user.id
    );

    if (reviewIndex === -1) {
      return res.status(404).json({
        success: false,
        error: 'Review not found or not authorized',
      });
    }

    reviews.splice(reviewIndex, 1);

    res.json({
      success: true,
      message: 'Review deleted',
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: 'Failed to delete review',
    });
  }
});

// POST /reviews/:reviewId/helpful - Mark review as helpful
router.post('/:reviewId/helpful', (req, res) => {
  try {
    const { reviewId } = req.params;
    const review = reviews.find(r => r.id === reviewId);

    if (!review) {
      return res.status(404).json({
        success: false,
        error: 'Review not found',
      });
    }

    review.helpful += 1;

    res.json({
      success: true,
      data: review,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: 'Failed to mark review as helpful',
    });
  }
});

module.exports = router;
