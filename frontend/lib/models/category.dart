import 'package:hive/hive.dart';

part 'category.g.dart';

@HiveType(typeId: 2)
class Category extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String icon;

  @HiveField(4)
  final int toolCount;

  @HiveField(5)
  final DateTime createdAt;

  Category({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    this.toolCount = 0,
    required this.createdAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
      toolCount: json['toolCount'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'toolCount': toolCount,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Category copyWith({
    String? id,
    String? name,
    String? description,
    String? icon,
    int? toolCount,
    DateTime? createdAt,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      toolCount: toolCount ?? this.toolCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
