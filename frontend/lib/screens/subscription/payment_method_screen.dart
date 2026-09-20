import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../constants/app_colors.dart';
import '../../constants/theme_helper.dart';
import '../../models/payment_card.dart';
import '../../models/subscription.dart';
import '../../providers/payment_provider.dart';
import '../../providers/subscription_provider.dart';

class PaymentMethodScreen extends ConsumerStatefulWidget {
  final SubscriptionTier selectedTier;

  const PaymentMethodScreen({
    super.key,
    required this.selectedTier,
  });

  @override
  ConsumerState<PaymentMethodScreen> createState() =>
      _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends ConsumerState<PaymentMethodScreen> {
  bool _isProcessing = false;
  String? _selectedCardId;

  static const String _backendUrl = 'http://192.168.18.14:3000';

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final existingCards = ref.watch(paymentCardsProvider);
    final tierName =
        widget.selectedTier == SubscriptionTier.plus ? 'Plus' : 'Pro';
    final price =
        widget.selectedTier == SubscriptionTier.plus ? '\$4.99' : '\$9.99';

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
          'Payment Method',
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
            _buildOrderSummary(isDark, tierName, price),
            const SizedBox(height: 20),
            if (existingCards.isNotEmpty) ...[
              Text(
                'SAVED CARDS',
                style: GoogleFonts.inter(
                  color: context.textMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              ...existingCards.map(
                (card) => _buildSavedCard(card, isDark),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.1)
                          : Colors.black.withValues(alpha: 0.1),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'OR ADD NEW CARD',
                      style: GoogleFonts.inter(
                        color: context.textMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.1)
                          : Colors.black.withValues(alpha: 0.1),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
            _buildPayButton(isDark, tierName),
            const SizedBox(height: 16),
            // _buildTestInfo(isDark),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary(bool isDark, String tierName, String price) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surface : AppColors.surfaceLightBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.black.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.purplePrimary,
                  AppColors.purplePrimary.withValues(alpha: 0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.diamond_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AIVerse $tierName',
                  style: GoogleFonts.inter(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Monthly subscription • 7-day free trial',
                  style: GoogleFonts.inter(
                    color: context.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '$price/mo',
            style: GoogleFonts.inter(
              color: isDark ? Colors.white : Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavedCard(PaymentCard card, bool isDark) {
    final isSelected = _selectedCardId == card.id;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedCardId = card.id);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surface : AppColors.surfaceLightBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.purplePrimary
                : card.isDefault
                    ? AppColors.purplePrimary.withValues(alpha: 0.4)
                    : isDark
                        ? Colors.white.withValues(alpha: 0.1)
                        : Colors.black.withValues(alpha: 0.1),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            _getCardIcon(card.cardType),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    card.maskedNumber,
                    style: GoogleFonts.inter(
                      color: isDark ? Colors.white : Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${card.expiryMonth}/${card.expiryYear}',
                    style: GoogleFonts.inter(
                      color: context.textMuted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppColors.purplePrimary,
                size: 22,
              )
            else if (card.isDefault)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
              ),
          ],
        ),
      ),
    );
  }

  Widget _getCardIcon(String type) {
    switch (type) {
      case 'Visa':
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1F71),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            'VISA',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        );
      case 'Mastercard':
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.8),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 2),
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.8),
                shape: BoxShape.circle,
              ),
            ),
          ],
        );
      default:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey.shade700,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            type.toUpperCase(),
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.w700,
            ),
          ),
        );
    }
  }

  Widget _buildPayButton(bool isDark, String tierName) {
    final price = widget.selectedTier == SubscriptionTier.plus ? 499 : 999;

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: _isProcessing
                ? null
                : () => _handlePayment(price, tierName),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.purplePrimary,
              foregroundColor: Colors.white,
              disabledBackgroundColor:
                  AppColors.purplePrimary.withValues(alpha: 0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: _isProcessing
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    'Pay & Subscribe to $tierName',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: Text(
            'Your card will not be charged during the 7-day free trial.',
            style: GoogleFonts.inter(
              color: context.textMuted,
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildTestInfo(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline, color: Colors.blue, size: 16),
              const SizedBox(width: 6),
              Text(
                'Test Mode — Use these details',
                style: GoogleFonts.inter(
                  color: Colors.blue,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildTestDetail('Card:', '4242 4242 4242 4242'),
          _buildTestDetail('Expiry:', '12/30'),
          _buildTestDetail('CVC:', '123'),
          _buildTestDetail('Name:', 'Any name'),
        ],
      ),
    );
  }

  Widget _buildTestDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              color: Colors.blue.withValues(alpha: 0.7),
              fontSize: 11,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            value,
            style: GoogleFonts.inter(
              color: Colors.blue,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handlePayment(int amountInCents, String tierName) async {
    if (_selectedCardId != null) {
      await _payWithSavedCard(tierName);
      return;
    }

    if (!kIsWeb) {
      await _payWithStripe(amountInCents, tierName);
    } else {
      await _paySimulated(tierName);
    }
  }

  Future<void> _payWithSavedCard(String tierName) async {
    setState(() => _isProcessing = true);

    await Future.delayed(const Duration(seconds: 2));

    await ref.read(subscriptionProvider.notifier).startTrial(widget.selectedTier);

    if (mounted) {
      setState(() => _isProcessing = false);

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => _SubscriptionSuccessDialog(
          tier: widget.selectedTier,
        ),
      );
    }
  }

  Future<void> _payWithStripe(int amountInCents, String tierName) async {
    setState(() => _isProcessing = true);

    try {
      final data = await _createPaymentIntent(amountInCents, 'usd');

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: data['clientSecret'],
          merchantDisplayName: 'AIVerse',
          style: ThemeMode.dark,
          billingDetails: const BillingDetails(
            name: 'AIVerse User',
          ),
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      if (mounted) {
        setState(() => _isProcessing = false);
        await ref.read(subscriptionProvider.notifier).startTrial(widget.selectedTier);

        if (_selectedCardId == null) {
          await ref.read(paymentCardsProvider.notifier).addCard(
            PaymentCard(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              cardNumber: '••••••••••••4242',
              cardHolderName: 'Stripe User',
              expiryMonth: '12',
              expiryYear: '28',
              cardType: 'Visa',
              isDefault: ref.read(paymentCardsProvider).isEmpty,
              addedAt: DateTime.now(),
            ),
          );
        }

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => _SubscriptionSuccessDialog(
            tier: widget.selectedTier,
          ),
        );
      }
    } on StripeException catch (e) {
      if (mounted) {
        setState(() => _isProcessing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Payment cancelled: ${e.error.localizedMessage ?? "User cancelled"}',
              style: GoogleFonts.inter(),
            ),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isProcessing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Payment failed: ${e.toString()}',
              style: GoogleFonts.inter(),
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  Future<void> _paySimulated(String tierName) async {
    setState(() => _isProcessing = true);

    await Future.delayed(const Duration(seconds: 2));

    await ref.read(subscriptionProvider.notifier).startTrial(widget.selectedTier);

    if (mounted) {
      setState(() => _isProcessing = false);

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => _SubscriptionSuccessDialog(
          tier: widget.selectedTier,
        ),
      );
    }
  }

  Future<Map<String, dynamic>> _createPaymentIntent(
      int amount, String currency) async {
    final response = await http.post(
      Uri.parse('$_backendUrl/v1/payments/create-intent'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'amount': amount,
        'currency': currency,
        'tier': widget.selectedTier.name,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create payment intent: ${response.body}');
    }

    return jsonDecode(response.body);
  }
}

class _SubscriptionSuccessDialog extends StatelessWidget {
  final SubscriptionTier tier;

  const _SubscriptionSuccessDialog({required this.tier});

  @override
  Widget build(BuildContext context) {
    final tierName = tier == SubscriptionTier.plus ? 'Plus' : 'Pro';

    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFC084FC), Color(0xFF9333EA)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.purplePrimary.withValues(alpha: 0.4),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 36,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Welcome to $tierName!',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your 7-day free trial has started. You can cancel anytime before the trial ends.',
              style: GoogleFonts.inter(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 13,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.purplePrimary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Start Exploring',
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
}
