import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/utils/traffic_prediction.dart';
import '../models/app_notification.dart';

class NotificationsNotifier extends StateNotifier<List<AppNotification>> {
  NotificationsNotifier() : super(_seed());

  static List<AppNotification> _seed() {
    final now = DateTime.now();
    return [
      AppNotification(
        id: 'n1',
        type: NotificationType.traffic,
        title: 'Traffic Alert',
        message: getTrafficPrediction(now),
        timestamp: now.subtract(const Duration(minutes: 2)),
      ),
      AppNotification(
        id: 'n2',
        type: NotificationType.checkpoint,
        title: 'Checkpoint Detected',
        message: 'New checkpoint reported on Hebron-Bethlehem road with 8 votes.',
        timestamp: now.subtract(const Duration(minutes: 10)),
      ),
      AppNotification(
        id: 'n3',
        type: NotificationType.routeSuggestion,
        title: 'Route Suggestion',
        message: 'Main Road is affected by a closure. Northern Bypass is recommended.',
        timestamp: now.subtract(const Duration(minutes: 18)),
      ),
      AppNotification(
        id: 'n4',
        type: NotificationType.tripUpdate,
        title: 'Trip Almost Full',
        message: 'Hebron Mall → Bethlehem trip only has 2 seats left. Book now!',
        timestamp: now.subtract(const Duration(minutes: 30)),
      ),
      AppNotification(
        id: 'n5',
        type: NotificationType.traffic,
        title: 'Road Closed',
        message: 'Old City entrance is closed. Use southern detour.',
        timestamp: now.subtract(const Duration(hours: 1)),
      ),
    ];
  }

  void markAsRead(String id) {
    state = [
      for (final n in state)
        if (n.id == id) n.copyWith(isRead: true) else n,
    ];
  }

  void markAllRead() {
    state = state.map((n) => n.copyWith(isRead: true)).toList();
  }

  void addNotification(AppNotification notification) {
    state = [notification, ...state];
  }

  int get unreadCount => state.where((n) => !n.isRead).length;
}

final notificationsProvider =
    StateNotifierProvider<NotificationsNotifier, List<AppNotification>>(
  (_) => NotificationsNotifier(),
);

final unreadCountProvider = Provider<int>((ref) {
  return ref.watch(notificationsProvider).where((n) => !n.isRead).length;
});
