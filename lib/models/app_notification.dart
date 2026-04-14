enum NotificationType { traffic, routeSuggestion, tripUpdate, checkpoint }

extension NotificationTypeLabel on NotificationType {
  String get label {
    switch (this) {
      case NotificationType.traffic:
        return 'Traffic Alert';
      case NotificationType.routeSuggestion:
        return 'Route Suggestion';
      case NotificationType.tripUpdate:
        return 'Trip Update';
      case NotificationType.checkpoint:
        return 'Checkpoint Alert';
    }
  }

  String get icon {
    switch (this) {
      case NotificationType.traffic:
        return '🚗';
      case NotificationType.routeSuggestion:
        return '🗺️';
      case NotificationType.tripUpdate:
        return '🚌';
      case NotificationType.checkpoint:
        return '🚔';
    }
  }
}

class AppNotification {
  final String id;
  final NotificationType type;
  final String title;
  final String message;
  final DateTime timestamp;
  final bool isRead;

  const AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.timestamp,
    this.isRead = false,
  });

  AppNotification copyWith({
    String? id,
    NotificationType? type,
    String? title,
    String? message,
    DateTime? timestamp,
    bool? isRead,
  }) =>
      AppNotification(
        id: id ?? this.id,
        type: type ?? this.type,
        title: title ?? this.title,
        message: message ?? this.message,
        timestamp: timestamp ?? this.timestamp,
        isRead: isRead ?? this.isRead,
      );

  String get timeAgo {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
