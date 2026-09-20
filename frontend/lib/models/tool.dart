import 'package:hive/hive.dart';

part 'tool.g.dart';

@HiveType(typeId: 0)
class Tool extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String websiteUrl;

  @HiveField(4)
  final String? logoUrl;

  @HiveField(5)
  final String categoryId;

  @HiveField(6)
  final List<String> tags;

  @HiveField(7)
  final PricingType pricingType;

  @HiveField(8)
  final double rating;

  @HiveField(9)
  final int viewCount;

  @HiveField(10)
  final bool isVerified;

  @HiveField(11)
  final bool isFeatured;

  @HiveField(12)
  final bool isTrending;

  @HiveField(13)
  final bool isNew;

  @HiveField(14)
  final DateTime createdAt;

  @HiveField(15)
  final DateTime updatedAt;

  @HiveField(16)
  final String status;

  @HiveField(17)
  final String? submittedBy;

  @HiveField(18)
  final List<String> keyFeatures;

  @HiveField(19)
  final List<String> pros;

  @HiveField(20)
  final List<String> cons;

  @HiveField(21)
  final String? freeTierInfo;

  @HiveField(22)
  final List<PricingPlan> pricingPlans;

  @HiveField(23)
  final String? trialInfo;

  @HiveField(24)
  final List<String> membershipBenefits;

  @HiveField(25)
  final int? plusDiscountPercent;

  @HiveField(26)
  final int? proDiscountPercent;

  @HiveField(27)
  final String? discountCodePlus;

  @HiveField(28)
  final String? discountCodePro;

  Tool({
    required this.id,
    required this.name,
    required this.description,
    required this.websiteUrl,
    this.logoUrl,
    required this.categoryId,
    this.tags = const [],
    required this.pricingType,
    this.rating = 0.0,
    this.viewCount = 0,
    this.isVerified = false,
    this.isFeatured = false,
    this.isTrending = false,
    this.isNew = false,
    this.status = 'approved',
    this.submittedBy,
    this.keyFeatures = const [],
    this.pros = const [],
    this.cons = const [],
    this.freeTierInfo,
    this.pricingPlans = const [],
    this.trialInfo,
    this.membershipBenefits = const [],
    this.plusDiscountPercent,
    this.proDiscountPercent,
    this.discountCodePlus,
    this.discountCodePro,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Tool.fromJson(Map<String, dynamic> json) {
    return Tool(
      id: (json['id'] as String?) ?? '',
      name: (json['name'] as String?) ?? 'Unknown Tool',
      description: (json['description'] as String?) ?? '',
      websiteUrl: (json['websiteUrl'] as String?) ?? '',
      logoUrl: json['logoUrl'] as String?,
      categoryId: (json['categoryId'] as String?) ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      pricingType: PricingType.values.firstWhere(
        (e) => e.name == json['pricingType'],
        orElse: () => PricingType.free,
      ),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      viewCount: json['viewCount'] as int? ?? 0,
      isVerified: json['isVerified'] as bool? ?? false,
      isFeatured: json['isFeatured'] as bool? ?? false,
      isTrending: json['isTrending'] as bool? ?? false,
      isNew: json['isNew'] as bool? ?? false,
      status: json['status'] as String? ?? 'approved',
      submittedBy: json['submittedBy'] as String?,
      keyFeatures: List<String>.from(json['keyFeatures'] ?? []),
      pros: List<String>.from(json['pros'] ?? []),
      cons: List<String>.from(json['cons'] ?? []),
      freeTierInfo: json['freeTierInfo'] as String?,
      pricingPlans: (json['pricingPlans'] as List<dynamic>?)
              ?.map((e) => PricingPlan.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      trialInfo: json['trialInfo'] as String?,
      membershipBenefits: List<String>.from(json['membershipBenefits'] ?? []),
      plusDiscountPercent: json['plusDiscountPercent'] as int?,
      proDiscountPercent: json['proDiscountPercent'] as int?,
      discountCodePlus: json['discountCodePlus'] as String?,
      discountCodePro: json['discountCodePro'] as String?,
      createdAt: _parseDateTime(json['createdAt']),
      updatedAt: _parseDateTime(json['updatedAt']),
    );
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is DateTime) return value;
    try {
      return DateTime.parse(value as String);
    } catch (_) {
      return DateTime.now();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'websiteUrl': websiteUrl,
      'logoUrl': logoUrl,
      'categoryId': categoryId,
      'tags': tags,
      'pricingType': pricingType.name,
      'rating': rating,
      'viewCount': viewCount,
      'isVerified': isVerified,
      'isFeatured': isFeatured,
      'isTrending': isTrending,
      'isNew': isNew,
      'status': status,
      'submittedBy': submittedBy,
      'keyFeatures': keyFeatures,
      'pros': pros,
      'cons': cons,
      'freeTierInfo': freeTierInfo,
      'pricingPlans': pricingPlans.map((e) => e.toJson()).toList(),
      'trialInfo': trialInfo,
      'membershipBenefits': membershipBenefits,
      'plusDiscountPercent': plusDiscountPercent,
      'proDiscountPercent': proDiscountPercent,
      'discountCodePlus': discountCodePlus,
      'discountCodePro': discountCodePro,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Tool copyWith({
    String? id,
    String? name,
    String? description,
    String? websiteUrl,
    String? logoUrl,
    String? categoryId,
    List<String>? tags,
    PricingType? pricingType,
    double? rating,
    int? viewCount,
    bool? isVerified,
    bool? isFeatured,
    bool? isTrending,
    bool? isNew,
    String? status,
    String? submittedBy,
    List<String>? keyFeatures,
    List<String>? pros,
    List<String>? cons,
    String? freeTierInfo,
    List<PricingPlan>? pricingPlans,
    String? trialInfo,
    List<String>? membershipBenefits,
    int? plusDiscountPercent,
    int? proDiscountPercent,
    String? discountCodePlus,
    String? discountCodePro,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Tool(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      websiteUrl: websiteUrl ?? this.websiteUrl,
      logoUrl: logoUrl ?? this.logoUrl,
      categoryId: categoryId ?? this.categoryId,
      tags: tags ?? this.tags,
      pricingType: pricingType ?? this.pricingType,
      rating: rating ?? this.rating,
      viewCount: viewCount ?? this.viewCount,
      isVerified: isVerified ?? this.isVerified,
      isFeatured: isFeatured ?? this.isFeatured,
      isTrending: isTrending ?? this.isTrending,
      isNew: isNew ?? this.isNew,
      status: status ?? this.status,
      submittedBy: submittedBy ?? this.submittedBy,
      keyFeatures: keyFeatures ?? this.keyFeatures,
      pros: pros ?? this.pros,
      cons: cons ?? this.cons,
      freeTierInfo: freeTierInfo ?? this.freeTierInfo,
      pricingPlans: pricingPlans ?? this.pricingPlans,
      trialInfo: trialInfo ?? this.trialInfo,
      membershipBenefits: membershipBenefits ?? this.membershipBenefits,
      plusDiscountPercent: plusDiscountPercent ?? this.plusDiscountPercent,
      proDiscountPercent: proDiscountPercent ?? this.proDiscountPercent,
      discountCodePlus: discountCodePlus ?? this.discountCodePlus,
      discountCodePro: discountCodePro ?? this.discountCodePro,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

@HiveType(typeId: 1)
enum PricingType {
  @HiveField(0)
  free,

  @HiveField(1)
  freemium,

  @HiveField(2)
  paid,
}

@HiveType(typeId: 5)
class PricingPlan extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String price;

  @HiveField(2)
  final String period;

  @HiveField(3)
  final String? description;

  PricingPlan({
    required this.name,
    required this.price,
    required this.period,
    this.description,
  });

  factory PricingPlan.fromJson(Map<String, dynamic> json) {
    return PricingPlan(
      name: json['name'] as String,
      price: json['price'] as String,
      period: json['period'] as String,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'period': period,
      'description': description,
    };
  }
}
