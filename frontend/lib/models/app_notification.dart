import 'package:hive/hive.dart';

part 'app_notification.g.dart';

@HiveType(typeId: 9)
class AppNotification extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String message;

  @HiveField(3)
  final String type;

  @HiveField(4)
  final String? toolId;

  @HiveField(5)
  bool isRead;

  @HiveField(6)
  final DateTime createdAt;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    this.toolId,
    this.isRead = false,
    required this.createdAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: (json['id'] as String?) ?? '',
      title: (json['title'] as String?) ?? '',
      message: (json['message'] as String?) ?? '',
      type: (json['type'] as String?) ?? 'info',
      toolId: json['toolId'] as String?,
      isRead: json['isRead'] as bool? ?? false,
      createdAt: _parseDateTime(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type,
      'toolId': toolId,
      'isRead': isRead,
      'createdAt': createdAt.toIso8601String(),
    };
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
}
