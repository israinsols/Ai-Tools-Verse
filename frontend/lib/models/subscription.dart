import 'package:hive/hive.dart';

part 'subscription.g.dart';

@HiveType(typeId: 6)
enum SubscriptionTier {
  @HiveField(0)
  free,

  @HiveField(1)
  plus,

  @HiveField(2)
  pro,
}

@HiveType(typeId: 7)
class Subscription extends HiveObject {
  @HiveField(0)
  final SubscriptionTier tier;

  @HiveField(1)
  final bool trialActive;

  @HiveField(2)
  final DateTime? trialEndsAt;

  @HiveField(3)
  final DateTime? subscribedAt;

  @HiveField(4)
  final List<String> claimedDiscounts;

  Subscription({
    required this.tier,
    this.trialActive = false,
    this.trialEndsAt,
    this.subscribedAt,
    this.claimedDiscounts = const [],
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      tier: SubscriptionTier.values.firstWhere(
        (e) => e.name == json['tier'],
        orElse: () => SubscriptionTier.free,
      ),
      trialActive: json['trialActive'] as bool? ?? false,
      trialEndsAt: json['trialEndsAt'] != null
          ? DateTime.parse(json['trialEndsAt'] as String)
          : null,
      subscribedAt: json['subscribedAt'] != null
          ? DateTime.parse(json['subscribedAt'] as String)
          : null,
      claimedDiscounts: List<String>.from(json['claimedDiscounts'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tier': tier.name,
      'trialActive': trialActive,
      'trialEndsAt': trialEndsAt?.toIso8601String(),
      'subscribedAt': subscribedAt?.toIso8601String(),
      'claimedDiscounts': claimedDiscounts,
    };
  }

  Subscription copyWith({
    SubscriptionTier? tier,
    bool? trialActive,
    DateTime? trialEndsAt,
    DateTime? subscribedAt,
    List<String>? claimedDiscounts,
  }) {
    return Subscription(
      tier: tier ?? this.tier,
      trialActive: trialActive ?? this.trialActive,
      trialEndsAt: trialEndsAt ?? this.trialEndsAt,
      subscribedAt: subscribedAt ?? this.subscribedAt,
      claimedDiscounts: claimedDiscounts ?? this.claimedDiscounts,
    );
  }
}
