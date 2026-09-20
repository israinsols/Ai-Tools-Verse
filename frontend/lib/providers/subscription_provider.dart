import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/subscription.dart';

final subscriptionProvider =
    StateNotifierProvider<SubscriptionNotifier, Subscription>((ref) {
  return SubscriptionNotifier();
});

class SubscriptionNotifier extends StateNotifier<Subscription> {
  Box<Subscription>? _subscriptionBox;

  SubscriptionNotifier()
      : super(Subscription(tier: SubscriptionTier.free)) {
    _init();
  }

  Future<void> _init() async {
    _subscriptionBox = await Hive.openBox<Subscription>('subscription');
    if (_subscriptionBox!.isNotEmpty) {
      state = _subscriptionBox!.get('current')!;
    }
  }

  Future<void> updateTier(SubscriptionTier tier) async {
    state = state.copyWith(
      tier: tier,
      subscribedAt: DateTime.now(),
    );
    await _saveState();
  }

  Future<void> startTrial(SubscriptionTier tier) async {
    state = state.copyWith(
      tier: tier,
      trialActive: true,
      trialEndsAt: DateTime.now().add(const Duration(days: 7)),
      subscribedAt: DateTime.now(),
    );
    await _saveState();
  }

  Future<void> endTrial() async {
    state = state.copyWith(trialActive: false);
    await _saveState();
  }

  void checkTrialExpiry() {
    if (state.trialActive && state.trialEndsAt != null) {
      if (DateTime.now().isAfter(state.trialEndsAt!)) {
        endTrial();
      }
    }
  }

  Future<void> cancelSubscription() async {
    state = Subscription(tier: SubscriptionTier.free);
    await _saveState();
  }

  Future<void> claimDiscount(String toolId) async {
    if (!state.claimedDiscounts.contains(toolId)) {
      state = state.copyWith(
        claimedDiscounts: [...state.claimedDiscounts, toolId],
      );
      await _saveState();
    }
  }

  Future<void> _saveState() async {
    await _subscriptionBox?.put('current', state);
  }
}
