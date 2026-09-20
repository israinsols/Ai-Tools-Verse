import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../constants/app_colors.dart';
import '../../constants/theme_helper.dart';
import '../../providers/providers.dart';
import '../../widgets/widgets.dart';

class SubmitToolScreen extends ConsumerStatefulWidget {
  const SubmitToolScreen({super.key});

  @override
  ConsumerState<SubmitToolScreen> createState() => _SubmitToolScreenState();
}

class _SubmitToolScreenState extends ConsumerState<SubmitToolScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _urlController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _tagsController = TextEditingController();

  String? _selectedCategory;
  String _selectedPricing = 'free';
  File? _logoFile;
  File? _screenshotFile;
  bool _isLoading = false;
  bool _isSubmitted = false;

  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _nameController.dispose();
    _urlController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _pickImage({required bool isLogo}) async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: isLogo ? 256 : 1200,
      maxHeight: isLogo ? 256 : 800,
      imageQuality: 85,
    );

    if (image != null) {
      setState(() {
        if (isLogo) {
          _logoFile = File(image.path);
        } else {
          _screenshotFile = File(image.path);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isSubmitted) {
      return _buildSuccessState();
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildGuidelines(context),
                    const SizedBox(height: 24),
                    _buildImageUploadSection(context),
                    const SizedBox(height: 24),
                    _buildForm(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios,
              color: context.textPrimary,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Submit Tool',
            style: GoogleFonts.inter(
              color: context.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuidelines(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardBgSecondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.borderColor,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline,
                color: AppColors.purplePrimary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Submission Guidelines',
                style: GoogleFonts.inter(
                  color: context.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '• Tool must be functional and publicly accessible\n'
            '• Description should be accurate and concise\n'
            '• One submission per tool please\n'
            '• Reviews typically take 24-48 hours',
            style: GoogleFonts.inter(
              color: context.textSecondary,
              fontSize: 12,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageUploadSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tool Images',
          style: GoogleFonts.inter(
            color: context.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildImagePicker(
                context: context,
                label: 'Logo',
                image: _logoFile,
                onTap: () => _pickImage(isLogo: true),
                icon: Icons.add_photo_alternate_outlined,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildImagePicker(
                context: context,
                label: 'Screenshot',
                image: _screenshotFile,
                onTap: () => _pickImage(isLogo: false),
                icon: Icons.add_a_photo_outlined,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImagePicker({
    required BuildContext context,
    required String label,
    required File? image,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: context.cardBgSecondary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: context.borderColor,
            width: 1,
          ),
        ),
        child: image != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    color: context.textMuted,
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    label,
                    style: GoogleFonts.inter(
                      color: context.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFieldLabel(context, 'Tool Name *'),
          const SizedBox(height: 8),
          TextFormField(
            controller: _nameController,
            style: GoogleFonts.inter(
              color: context.textPrimary,
              fontSize: 14,
            ),
            decoration: const InputDecoration(
              hintText: 'Enter tool name',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter tool name';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          _buildFieldLabel(context, 'Website URL *'),
          const SizedBox(height: 8),
          TextFormField(
            controller: _urlController,
            keyboardType: TextInputType.url,
            style: GoogleFonts.inter(
              color: context.textPrimary,
              fontSize: 14,
            ),
            decoration: const InputDecoration(
              hintText: 'https://example.com',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter website URL';
              }
              if (!value.startsWith('http')) {
                return 'Please enter a valid URL';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          _buildFieldLabel(context, 'Category *'),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: _selectedCategory,
            style: GoogleFonts.inter(
              color: context.textPrimary,
              fontSize: 14,
            ),
            dropdownColor: context.cardBg,
            decoration: const InputDecoration(
              hintText: 'Select category',
            ),
            items: const [
              DropdownMenuItem(
                value: 'image',
                child: Text('AI Image Generators'),
              ),
              DropdownMenuItem(
                value: 'video',
                child: Text('AI Video Tools'),
              ),
              DropdownMenuItem(
                value: 'music',
                child: Text('AI Music Tools'),
              ),
              DropdownMenuItem(
                value: 'writing',
                child: Text('AI Writing Tools'),
              ),
              DropdownMenuItem(
                value: 'coding',
                child: Text('AI Coding Tools'),
              ),
              DropdownMenuItem(
                value: 'voice',
                child: Text('AI Voice Generators'),
              ),
              DropdownMenuItem(
                value: 'logo',
                child: Text('AI Logo Makers'),
              ),
              DropdownMenuItem(
                value: 'presentation',
                child: Text('AI Presentation Tools'),
              ),
              DropdownMenuItem(
                value: 'productivity',
                child: Text('AI Productivity Tools'),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _selectedCategory = value;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a category';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          _buildFieldLabel(context, 'Description *'),
          const SizedBox(height: 8),
          TextFormField(
            controller: _descriptionController,
            maxLines: 4,
            style: GoogleFonts.inter(
              color: context.textPrimary,
              fontSize: 14,
            ),
            decoration: const InputDecoration(
              hintText: 'Describe what the tool does...',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter description';
              }
              if (value.length < 20) {
                return 'Description should be at least 20 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          _buildFieldLabel(context, 'Tags'),
          const SizedBox(height: 8),
          TextFormField(
            controller: _tagsController,
            style: GoogleFonts.inter(
              color: context.textPrimary,
              fontSize: 14,
            ),
            decoration: const InputDecoration(
              hintText: 'chatbot, writing, productivity (comma separated)',
            ),
          ),
          const SizedBox(height: 20),
          _buildFieldLabel(context, 'Pricing Type *'),
          const SizedBox(height: 12),
          _buildPricingOptions(context),
          const SizedBox(height: 32),
          GradientButton(
            text: 'Submit Tool',
            isLoading: _isLoading,
            onPressed: _handleSubmit,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(BuildContext context, String label) {
    return Text(
      label,
      style: GoogleFonts.inter(
        color: context.textPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildPricingOptions(BuildContext context) {
    return Row(
      children: [
        _buildPricingOption(context, 'free', 'Free'),
        const SizedBox(width: 12),
        _buildPricingOption(context, 'freemium', 'Freemium'),
        const SizedBox(width: 12),
        _buildPricingOption(context, 'paid', 'Paid'),
      ],
    );
  }

  Widget _buildPricingOption(BuildContext context, String value, String label) {
    final isSelected = _selectedPricing == value;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedPricing = value;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.purplePrimary : context.cardBgSecondary,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.purplePrimary : context.borderColor,
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.inter(
                color: context.textPrimary,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessState() {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: AppColors.freemiumBg,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: AppColors.freemiumText,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Under Review',
                  style: GoogleFonts.inter(
                    color: context.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Your tool submission has been received and is now under review. We\'ll notify you once it\'s approved.',
                  style: GoogleFonts.inter(
                    color: context.textSecondary,
                    fontSize: 14,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                GradientButton(
                  text: 'Back to Home',
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final api = ref.read(apiServiceProvider);
      final tags = _tagsController.text
          .split(',')
          .map((t) => t.trim())
          .where((t) => t.isNotEmpty)
          .toList();

      final toolData = {
        'name': _nameController.text.trim(),
        'websiteUrl': _urlController.text.trim(),
        'categoryId': _selectedCategory,
        'description': _descriptionController.text.trim(),
        'pricingType': _selectedPricing,
        'tags': tags,
      };

      // Upload logo if selected
      if (_logoFile != null) {
        final logoUrl = await api.uploadImage(_logoFile!.path);
        toolData['logoUrl'] = logoUrl;
      }

      // Upload screenshot if selected
      if (_screenshotFile != null) {
        final screenshotUrl = await api.uploadImage(_screenshotFile!.path);
        toolData['screenshotUrl'] = screenshotUrl;
      }

      await api.submitTool(toolData);

      if (mounted) {
        setState(() {
          _isLoading = false;
          _isSubmitted = true;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit tool: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
