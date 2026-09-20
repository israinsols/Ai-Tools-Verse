import 'package:hive/hive.dart';

part 'review.g.dart';

@HiveType(typeId: 4)
class Review extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String toolId;

  @HiveField(2)
  final String userId;

  @HiveField(3)
  final String userName;

  @HiveField(4)
  final int rating;

  @HiveField(5)
  final String title;

  @HiveField(6)
  final String comment;

  @HiveField(7)
  final int helpful;

  @HiveField(8)
  final DateTime createdAt;

  @HiveField(9)
  final DateTime updatedAt;

  Review({
    required this.id,
    required this.toolId,
    required this.userId,
    required this.userName,
    required this.rating,
    required this.title,
    required this.comment,
    this.helpful = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] ?? '',
      toolId: json['toolId'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      rating: json['rating'] ?? 0,
      title: json['title'] ?? '',
      comment: json['comment'] ?? '',
      helpful: json['helpful'] ?? 0,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'toolId': toolId,
      'userId': userId,
      'userName': userName,
      'rating': rating,
      'title': title,
      'comment': comment,
      'helpful': helpful,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  String get initials {
    final parts = userName.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return userName.substring(0, 2).toUpperCase();
  }

  String get timeAgo {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inDays > 365) return '${(diff.inDays / 365).floor()}y ago';
    if (diff.inDays > 30) return '${(diff.inDays / 30).floor()}mo ago';
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'Just now';
  }
}
