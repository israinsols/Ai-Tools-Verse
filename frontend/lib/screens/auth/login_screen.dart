import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import '../../constants/theme_helper.dart';
import '../../providers/providers.dart';
import '../../widgets/widgets.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _isSignUpMode = false;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadRememberedCredentials();
    _nameController.addListener(_onFieldChanged);
    _emailController.addListener(_onFieldChanged);
    _passwordController.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    setState(() {});
  }

  bool get _isFormValid {
    if (_isSignUpMode) {
      return _nameController.text.trim().isNotEmpty &&
          _emailController.text.trim().isNotEmpty &&
          _passwordController.text.length >= 6;
    } else {
      return _emailController.text.trim().isNotEmpty &&
          _passwordController.text.length >= 6;
    }
  }

  void _loadRememberedCredentials() {
    final storage = ref.read(storageServiceProvider);
    final savedEmail = storage.getSetting<String>('remembered_email');
    final savedPassword = storage.getSetting<String>('remembered_password');
    final isRemembered = storage.getSetting<bool>('remember_me') ?? false;

    if (isRemembered && savedEmail != null && savedPassword != null) {
      setState(() {
        _rememberMe = true;
        _emailController.text = savedEmail;
        _passwordController.text = savedPassword;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 40),
              _buildForm(),
              const SizedBox(height: 24),
              _buildGuestOption(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios,
            color: context.textPrimary,
          ),
          alignment: Alignment.centerLeft,
        ),
        const SizedBox(height: 24),
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            gradient: AppColors.gradientLogo,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.auto_awesome,
            color: Colors.white,
            size: 32,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          _isSignUpMode ? 'Create account' : 'Welcome back',
          style: GoogleFonts.inter(
            color: context.textPrimary,
            fontSize: 28,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _isSignUpMode ? 'Sign up to get started' : 'Sign in to continue',
          style: GoogleFonts.inter(
            color: context.textSecondary,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_isSignUpMode) ...[
            Text(
              'Name',
              style: GoogleFonts.inter(
                color: context.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nameController,
              style: GoogleFonts.inter(
                color: context.textPrimary,
                fontSize: 14,
              ),
              decoration: InputDecoration(
                hintText: 'Enter your name',
                prefixIcon: Icon(
                  Icons.person_outlined,
                  color: context.textMuted,
                ),
              ),
              validator: (value) {
                if (_isSignUpMode && (value == null || value.isEmpty)) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
          ],
          Text(
            'Email',
            style: GoogleFonts.inter(
              color: context.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            style: GoogleFonts.inter(
              color: context.textPrimary,
              fontSize: 14,
            ),
            decoration: InputDecoration(
              hintText: 'Enter your email',
              prefixIcon: Icon(
                Icons.email_outlined,
                color: context.textMuted,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!value.contains('@')) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          Text(
            'Password',
            style: GoogleFonts.inter(
              color: context.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _passwordController,
            obscureText: !_isPasswordVisible,
            style: GoogleFonts.inter(
              color: context.textPrimary,
              fontSize: 14,
            ),
            decoration: InputDecoration(
              hintText: 'Enter your password',
              prefixIcon: Icon(
                Icons.lock_outlined,
                color: context.textMuted,
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
                icon: Icon(
                  _isPasswordVisible
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: context.textMuted,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          if (!_isSignUpMode) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: _rememberMe,
                    onChanged: (value) {
                      setState(() {
                        _rememberMe = value ?? false;
                      });
                    },
                    activeColor: AppColors.purplePrimary,
                    side: BorderSide(color: context.borderColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Remember me',
                  style: GoogleFonts.inter(
                    color: context.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'Forgot password?',
                    style: GoogleFonts.inter(
                      color: AppColors.purplePrimary,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 24),
          GradientButton(
            text: _isSignUpMode ? 'Sign Up' : 'Sign In',
            isLoading: _isLoading,
            isEnabled: _isFormValid,
            onPressed: _isSignUpMode ? _handleSignUp : _handleSignIn,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _isSignUpMode ? 'Already have an account? ' : "Don't have an account? ",
                style: GoogleFonts.inter(
                  color: context.textSecondary,
                  fontSize: 12,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isSignUpMode = !_isSignUpMode;
                  });
                },
                child: Text(
                  _isSignUpMode ? 'Sign In' : 'Sign Up',
                  style: GoogleFonts.inter(
                    color: AppColors.purplePrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGuestOption() {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Center(
        child: Text(
          'Continue as guest',
          style: GoogleFonts.inter(
            color: context.textSecondary,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Future<void> _handleSignIn() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    setState(() {
      _isLoading = true;
    });

    try {
      await ref.read(authStateProvider.notifier).signIn(
        email: email,
        password: password,
      );

      // Save or clear remembered credentials
      final storage = ref.read(storageServiceProvider);
      if (_rememberMe) {
        await storage.setSetting('remember_me', true);
        await storage.setSetting('remembered_email', email);
        await storage.setSetting('remembered_password', password);
      } else {
        await storage.setSetting('remember_me', false);
        await storage.setSetting('remembered_email', null);
        await storage.setSetting('remembered_password', null);
      }

      // Clear fields
      _nameController.clear();
      _emailController.clear();
      _passwordController.clear();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Signed in successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sign in failed: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    try {
      await ref.read(authStateProvider.notifier).signUp(
        email: email,
        password: password,
        displayName: name,
      );

      // Clear fields
      _nameController.clear();
      _emailController.clear();
      _passwordController.clear();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sign up failed: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }

    setState(() {
      _isLoading = false;
    });
  }
}
