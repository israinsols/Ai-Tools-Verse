import 'package:hive/hive.dart';

part 'payment_card.g.dart';

@HiveType(typeId: 8)
class PaymentCard extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String cardNumber;

  @HiveField(2)
  final String cardHolderName;

  @HiveField(3)
  final String expiryMonth;

  @HiveField(4)
  final String expiryYear;

  @HiveField(6)
  final String cardType;

  @HiveField(7)
  final bool isDefault;

  @HiveField(8)
  final DateTime addedAt;

  PaymentCard({
    required this.id,
    required this.cardNumber,
    required this.cardHolderName,
    required this.expiryMonth,
    required this.expiryYear,
    this.cardType = 'Visa',
    this.isDefault = false,
    required this.addedAt,
  });

  String get maskedNumber {
    if (cardNumber.length >= 4) {
      return '•••• •••• •••• ${cardNumber.substring(cardNumber.length - 4)}';
    }
    return cardNumber;
  }

  factory PaymentCard.fromJson(Map<String, dynamic> json) {
    return PaymentCard(
      id: json['id'] as String,
      cardNumber: json['cardNumber'] as String,
      cardHolderName: json['cardHolderName'] as String,
      expiryMonth: json['expiryMonth'] as String,
      expiryYear: json['expiryYear'] as String,
      cardType: json['cardType'] as String? ?? 'Visa',
      isDefault: json['isDefault'] as bool? ?? false,
      addedAt: DateTime.parse(json['addedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cardNumber': cardNumber,
      'cardHolderName': cardHolderName,
      'expiryMonth': expiryMonth,
      'expiryYear': expiryYear,
      'cardType': cardType,
      'isDefault': isDefault,
      'addedAt': addedAt.toIso8601String(),
    };
  }
}
