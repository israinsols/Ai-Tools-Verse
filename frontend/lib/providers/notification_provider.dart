import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/app_notification.dart';
import '../services/api_service.dart';
import 'providers.dart';

final notificationsProvider =
    StateNotifierProvider<NotificationsNotifier, List<AppNotification>>((ref) {
  return NotificationsNotifier(ref.read(apiServiceProvider));
});

final unreadCountProvider = Provider<int>((ref) {
  final notifications = ref.watch(notificationsProvider);
  return notifications.where((n) => !n.isRead).length;
});

class NotificationsNotifier extends StateNotifier<List<AppNotification>> {
  final ApiService _api;

  NotificationsNotifier(this._api) : super([]) {
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    try {
      final notifications = await _api.getNotifications();
      state = notifications;
    } catch (e) {
      // silent fail
    }
  }

  Future<void> markAsRead(String id) async {
    try {
      await _api.markNotificationRead(id);
      state = state.map((n) {
        if (n.id == id) {
          n.isRead = true;
        }
        return n;
      }).toList();
    } catch (e) {
      // silent fail
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await _api.markAllNotificationsRead();
      state = state.map((n) {
        n.isRead = true;
        return n;
      }).toList();
    } catch (e) {
      // silent fail
    }
  }

  Future<void> deleteNotification(String id) async {
    try {
      await _api.deleteNotification(id);
      state = state.where((n) => n.id != id).toList();
    } catch (e) {
      // silent fail
    }
  }
}
