const express = require('express');
const router = express.Router();
const multer = require('multer');
const path = require('path');
const { v4: uuidv4 } = require('uuid');
const { authMiddleware } = require('../middleware/auth');

// Configure multer for file uploads
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, path.join(__dirname, '../uploads'));
  },
  filename: (req, file, cb) => {
    const ext = path.extname(file.originalname);
    cb(null, `${uuidv4()}${ext}`);
  },
});

const fileFilter = (req, file, cb) => {
  const allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'image/webp'];
  if (allowedTypes.includes(file.mimetype)) {
    cb(null, true);
  } else {
    cb(new Error('Invalid file type. Only JPEG, PNG, GIF, and WebP are allowed.'), false);
  }
};

const upload = multer({
  storage,
  fileFilter,
  limits: {
    fileSize: 5 * 1024 * 1024, // 5MB limit
  },
});

// POST /upload - Upload a single image
router.post('/', authMiddleware, (req, res) => {
  try {
    upload.single('image')(req, res, (err) => {
      if (err) {
        if (err instanceof multer.MulterError) {
          if (err.code === 'LIMIT_FILE_SIZE') {
            return res.status(400).json({
              success: false,
              error: 'File size too large. Maximum size is 5MB.',
            });
          }
          return res.status(400).json({
            success: false,
            error: err.message,
          });
        }
        return res.status(400).json({
          success: false,
          error: err.message,
        });
      }

      if (!req.file) {
        return res.status(400).json({
          success: false,
          error: 'No image file provided',
        });
      }

      // In production, this would upload to Cloudinary and return the URL
      // For now, return a local URL
      const imageUrl = `/uploads/${req.file.filename}`;

      res.json({
        success: true,
        data: {
          url: imageUrl,
          filename: req.file.filename,
          originalName: req.file.originalname,
          size: req.file.size,
          mimetype: req.file.mimetype,
        },
      });
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: 'Failed to upload image',
    });
  }
});

// POST /upload/multiple - Upload multiple images
router.post('/multiple', authMiddleware, (req, res) => {
  try {
    upload.array('images', 5)(req, res, (err) => {
      if (err) {
        return res.status(400).json({
          success: false,
          error: err.message,
        });
      }

      if (!req.files || req.files.length === 0) {
        return res.status(400).json({
          success: false,
          error: 'No image files provided',
        });
      }

      const imageUrls = req.files.map((file) => ({
        url: `/uploads/${file.filename}`,
        filename: file.filename,
        originalName: file.originalname,
        size: file.size,
        mimetype: file.mimetype,
      }));

      res.json({
        success: true,
        data: imageUrls,
      });
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: 'Failed to upload images',
    });
  }
});

module.exports = router;
