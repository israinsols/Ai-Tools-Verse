import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import '../../constants/theme_helper.dart';
import '../../models/payment_card.dart';
import '../../providers/payment_provider.dart';

class PaymentMethodsScreen extends ConsumerStatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  ConsumerState<PaymentMethodsScreen> createState() =>
      _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends ConsumerState<PaymentMethodsScreen> {
  bool _showAddForm = false;
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _cardHolderController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  String _detectCardType(String number) {
    final clean = number.replaceAll(RegExp(r'\s'), '');
    if (clean.startsWith('4')) return 'Visa';
    if (clean.startsWith(RegExp(r'^5[1-5]'))) return 'Mastercard';
    if (clean.startsWith(RegExp(r'^3[47]'))) return 'Amex';
    if (clean.startsWith('6')) return 'Discover';
    return 'Visa';
  }

  Widget _getCardIcon(String type, {double size = 20}) {
    switch (type) {
      case 'Visa':
        return Container(
          padding: EdgeInsets.symmetric(horizontal: size * 0.4, vertical: size * 0.2),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1F71),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            'VISA',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: size * 0.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        );
      case 'Mastercard':
        return SizedBox(
          width: size * 1.8,
          height: size,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.8),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                right: 0,
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.8),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        );
      case 'Amex':
        return Container(
          padding: EdgeInsets.symmetric(horizontal: size * 0.3, vertical: size * 0.2),
          decoration: BoxDecoration(
            color: const Color(0xFF006FCF),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            'AMEX',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: size * 0.45,
              fontWeight: FontWeight.w700,
            ),
          ),
        );
      default:
        return Container(
          padding: EdgeInsets.symmetric(horizontal: size * 0.3, vertical: size * 0.2),
          decoration: BoxDecoration(
            color: Colors.grey.shade700,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            type.toUpperCase(),
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: size * 0.45,
              fontWeight: FontWeight.w700,
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final cards = ref.watch(paymentCardsProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.bg : AppColors.bgLight,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.bg : AppColors.bgLight,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Payment Methods',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            if (cards.isNotEmpty) ...[
              Text(
                'YOUR CARDS',
                style: GoogleFonts.inter(
                  color: context.textMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              ...cards.map((card) => _buildCardItem(card, isDark)),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      backgroundColor: context.cardBg,
                      title: Text(
                        'Clear All Cards',
                        style: GoogleFonts.inter(
                          color: context.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      content: Text(
                        'Are you sure you want to remove all saved cards?',
                        style: GoogleFonts.inter(color: context.textSecondary),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: Text('Cancel', style: GoogleFonts.inter(color: context.textMuted)),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: Text('Clear', style: GoogleFonts.inter(color: Colors.redAccent)),
                        ),
                      ],
                    ),
                  );
                  if (confirmed == true) {
                    await ref.read(paymentCardsProvider.notifier).clearAll();
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      'Clear All Cards',
                      style: GoogleFonts.inter(
                        color: Colors.redAccent,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
            if (_showAddForm)
              _buildAddCardSection(isDark)
            else
              _buildAddCardButton(isDark),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildCardItem(PaymentCard card, bool isDark) {
    return Dismissible(
      key: Key(card.id),
      direction: card.isDefault ? DismissDirection.none : DismissDirection.endToStart,
      onDismissed: (_) async {
        await ref.read(paymentCardsProvider.notifier).removeCard(card.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Card removed', style: GoogleFonts.inter()),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(Icons.delete_rounded, color: Colors.white, size: 24),
      ),
      child: GestureDetector(
        onTap: card.isDefault ? null : () {
          ref.read(paymentCardsProvider.notifier).setDefault(card.id);
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surface : AppColors.surfaceLightBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: card.isDefault
                  ? AppColors.purplePrimary
                  : isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.black.withValues(alpha: 0.1),
              width: card.isDefault ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              _getCardIcon(card.cardType, size: 24),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      card.maskedNumber,
                      style: GoogleFonts.inter(
                        color: isDark ? Colors.white : Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          card.cardHolderName,
                          style: GoogleFonts.inter(
                            color: context.textMuted,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '•',
                          style: TextStyle(color: context.textMuted),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${card.expiryMonth}/${card.expiryYear}',
                          style: GoogleFonts.inter(
                            color: context.textMuted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (card.isDefault)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.purplePrimary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'DEFAULT',
                    style: GoogleFonts.inter(
                      color: AppColors.purplePrimary,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )
              else
                Icon(
                  Icons.check_circle_outline,
                  color: context.textMuted,
                  size: 22,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddCardButton(bool isDark) {
    return GestureDetector(
      onTap: () => setState(() => _showAddForm = true),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.03)
              : Colors.black.withValues(alpha: 0.02),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.black.withValues(alpha: 0.1),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_rounded,
              color: AppColors.purplePrimary,
              size: 22,
            ),
            const SizedBox(width: 8),
            Text(
              'Add New Card',
              style: GoogleFonts.inter(
                color: AppColors.purplePrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddCardSection(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surface : AppColors.surfaceLightBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.black.withValues(alpha: 0.1),
        ),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.credit_card_rounded, color: AppColors.purplePrimary, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Add Card',
                  style: GoogleFonts.inter(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showAddForm = false;
                      _formKey.currentState?.reset();
                      _cardNumberController.clear();
                      _cardHolderController.clear();
                      _expiryController.clear();
                      _cvvController.clear();
                    });
                  },
                  child: Icon(
                    Icons.close_rounded,
                    color: context.textMuted,
                    size: 22,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildField(
              controller: _cardNumberController,
              label: 'Card Number',
              hint: '1234 5678 9012 3456',
              isDark: isDark,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(16),
                _CardNumberFormatter(),
              ],
              validator: (v) {
                final clean = v?.replaceAll(RegExp(r'\s'), '') ?? '';
                if (clean.length < 13) return 'Enter valid card number';
                return null;
              },
            ),
            const SizedBox(height: 14),
            _buildField(
              controller: _cardHolderController,
              label: 'Cardholder Name',
              hint: 'John Doe',
              isDark: isDark,
              textCapitalization: TextCapitalization.words,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Enter name';
                return null;
              },
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _buildField(
                    controller: _expiryController,
                    label: 'Expiry',
                    hint: 'MM/YY',
                    isDark: isDark,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),
                      _ExpiryFormatter(),
                    ],
                    validator: (v) {
                      if (v == null || v.length < 5) return 'MM/YY';
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildField(
                    controller: _cvvController,
                    label: 'CVV',
                    hint: '123',
                    isDark: isDark,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),
                    ],
                    validator: (v) {
                      if (v == null || v.length < 3) return 'CVV';
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _saveCard,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.purplePrimary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Save Card',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool isDark,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          validator: validator,
          textCapitalization: textCapitalization,
          style: GoogleFonts.inter(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.inter(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.3)
                  : Colors.black.withValues(alpha: 0.3),
            ),
            filled: true,
            fillColor: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.black.withValues(alpha: 0.03),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.black.withValues(alpha: 0.1),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.black.withValues(alpha: 0.1),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.purplePrimary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.redAccent),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      ],
    );
  }

  void _saveCard() {
    if (!_formKey.currentState!.validate()) return;

    final card = PaymentCard(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      cardNumber: _cardNumberController.text.replaceAll(RegExp(r'\s'), ''),
      cardHolderName: _cardHolderController.text.trim(),
      expiryMonth: _expiryController.text.split('/')[0],
      expiryYear: _expiryController.text.split('/')[1],
      cardType: _detectCardType(_cardNumberController.text),
      isDefault: ref.read(paymentCardsProvider).isEmpty,
      addedAt: DateTime.now(),
    );

    ref.read(paymentCardsProvider.notifier).addCard(card);

    _cardNumberController.clear();
    _cardHolderController.clear();
    _expiryController.clear();
    _cvvController.clear();

    setState(() => _showAddForm = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Card saved!', style: GoogleFonts.inter()),
        backgroundColor: Colors.green,
      ),
    );
  }
}

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(RegExp(r'\s'), '');
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(text[i]);
    }
    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

class _ExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(RegExp(r'[/]'), '');
    if (text.length >= 2) {
      final formatted = '${text.substring(0, 2)}/${text.substring(2)}';
      return TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
    return newValue;
  }
}
