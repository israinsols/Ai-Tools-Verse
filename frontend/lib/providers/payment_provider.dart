import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/payment_card.dart';

final paymentCardsProvider =
    StateNotifierProvider<PaymentCardsNotifier, List<PaymentCard>>((ref) {
  return PaymentCardsNotifier();
});

class PaymentCardsNotifier extends StateNotifier<List<PaymentCard>> {
  Box<PaymentCard>? _box;

  PaymentCardsNotifier() : super([]) {
    _init();
  }

  Future<void> _init() async {
    _box = await Hive.openBox<PaymentCard>('payment_cards');
    if (_box!.isNotEmpty) {
      final seen = <String>{};
      final unique = <PaymentCard>[];
      for (final card in _box!.values) {
        if (seen.add(card.id)) {
          unique.add(card);
        }
      }
      if (unique.length < _box!.length) {
        await _box!.clear();
        for (final card in unique) {
          await _box!.put(card.id, card);
        }
      }
      state = unique;
    }
  }

  Future<void> addCard(PaymentCard card) async {
    state = [...state, card];
    await _box?.put(card.id, card);
  }

  Future<void> removeCard(String id) async {
    state = state.where((c) => c.id != id).toList();
    await _box?.delete(id);
  }

  Future<void> setDefault(String id) async {
    state = state.map((c) {
      final updated = PaymentCard(
        id: c.id,
        cardNumber: c.cardNumber,
        cardHolderName: c.cardHolderName,
        expiryMonth: c.expiryMonth,
        expiryYear: c.expiryYear,
        cardType: c.cardType,
        isDefault: c.id == id,
        addedAt: c.addedAt,
      );
      _box?.put(id, updated);
      return updated;
    }).toList();
  }

  PaymentCard? getDefaultCard() {
    try {
      return state.firstWhere((c) => c.isDefault);
    } catch (_) {
      return state.isNotEmpty ? state.first : null;
    }
  }

  Future<void> clearAll() async {
    state = [];
    await _box?.clear();
  }
}
