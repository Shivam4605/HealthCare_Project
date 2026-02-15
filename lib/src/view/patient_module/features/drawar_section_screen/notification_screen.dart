import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with TickerProviderStateMixin {
  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;

  bool _isLoading = true;
  String _selectedFilter = 'All';
  bool _notificationsEnabled = true;

  final List<NotificationModel> _notifications = [
    NotificationModel(
      id: '1',
      title: 'Appointment Reminder',
      message:
          'You have an appointment with Dr. Sarah Johnson tomorrow at 10:30 AM',
      type: NotificationType.appointment,
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
      actionLink: '/appointment/123',
      icon: Icons.calendar_month_rounded,
    ),
    NotificationModel(
      id: '2',
      title: 'Prescription Ready',
      message:
          'Your prescription has been refilled and is ready for pickup at City Pharmacy',
      type: NotificationType.medical,
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      isRead: false,
      actionLink: '/prescription/456',
      icon: Icons.medication_rounded,
    ),
    NotificationModel(
      id: '3',
      title: 'Health Tips',
      message:
          'Stay hydrated! Drink at least 8 glasses of water today for optimal health',
      type: NotificationType.promotion,
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
      icon: Icons.tips_and_updates_rounded,
    ),
    NotificationModel(
      id: '4',
      title: 'Lab Results Available',
      message:
          'Your blood test results are now available. View them in the app.',
      type: NotificationType.medical,
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
      actionLink: '/lab-results/789',
      icon: Icons.science_rounded,
    ),
    NotificationModel(
      id: '5',
      title: 'Special Offer',
      message:
          'Get 20% off on your next health checkup package. Limited time offer!',
      type: NotificationType.promotion,
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
      isRead: true,
      icon: Icons.local_offer_rounded,
    ),
    NotificationModel(
      id: '6',
      title: 'Medication Reminder',
      message: 'Time to take your evening medication: Metformin 500mg',
      type: NotificationType.reminder,
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      isRead: false,
      icon: Icons.alarm_rounded,
    ),
    NotificationModel(
      id: '7',
      title: 'Appointment Cancelled',
      message:
          'Your appointment with Dr. Michael Chen on Friday has been cancelled due to emergency',
      type: NotificationType.appointment,
      timestamp: DateTime.now().subtract(const Duration(hours: 8)),
      isRead: false,
      icon: Icons.cancel_rounded,
    ),
  ];

  List<NotificationModel> get _filteredNotifications {
    switch (_selectedFilter) {
      case 'Unread':
        return _notifications.where((n) => !n.isRead).toList();
      case 'Appointments':
        return _notifications
            .where((n) => n.type == NotificationType.appointment)
            .toList();
      case 'Medical':
        return _notifications
            .where(
              (n) =>
                  n.type == NotificationType.medical ||
                  n.type == NotificationType.reminder,
            )
            .toList();
      case 'Promotions':
        return _notifications
            .where((n) => n.type == NotificationType.promotion)
            .toList();
      default:
        return _notifications;
    }
  }

  int get _unreadCount => _notifications.where((n) => !n.isRead).length;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadData();
  }

  void _initializeAnimations() {
    _fabAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fabAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fabAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    _fabAnimationController.forward();
  }

  Future<void> _loadData() async {
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() => _isLoading = false);
  }

  void _markAsRead(String id) {
    setState(() {
      final index = _notifications.indexWhere((n) => n.id == id);
      if (index != -1) {
        _notifications[index].isRead = true;
      }
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification.isRead = true;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('All notifications marked as read'),
        backgroundColor: const Color(0xFF13BDAC),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _deleteNotification(String id) {
    setState(() {
      _notifications.removeWhere((n) => n.id == id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Notification removed'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Undo',
          textColor: Colors.white,
          onPressed: () {
            // Undo logic would go here
          },
        ),
      ),
    );
  }

  void _clearAll() {
    if (_notifications.isEmpty) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Notifications'),
        content: const Text(
          'Are you sure you want to clear all notifications?',
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => _notifications.clear());
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  void _toggleNotifications() {
    setState(() {
      _notificationsEnabled = !_notificationsEnabled;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _notificationsEnabled
              ? 'Notifications enabled'
              : 'Notifications disabled',
        ),
        backgroundColor: const Color(0xFF13BDAC),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: _buildAppBar(),
      body: _isLoading ? _buildLoadingScreen() : _buildMainContent(),
      floatingActionButton: _buildFAB(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF13BDAC).withOpacity(0.1),
                blurRadius: 8,
              ),
            ],
          ),
          child: const Icon(
            Icons.arrow_back,
            color: Color(0xFF2E3E5C),
            size: 20,
          ),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'Notifications',
        style: TextStyle(
          color: Color(0xFF2E3E5C),
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        if (_unreadCount > 0)
          IconButton(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.done_all_rounded, color: Color(0xFF2E3E5C)),
                Positioned(
                  top: -2,
                  right: -2,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xFF13BDAC),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$_unreadCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            onPressed: _markAllAsRead,
          ),
        IconButton(
          icon: const Icon(
            Icons.delete_sweep_rounded,
            color: Color(0xFF2E3E5C),
          ),
          onPressed: _clearAll,
        ),
      ],
    );
  }

  Widget _buildLoadingScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.8, end: 1.0),
            duration: const Duration(milliseconds: 800),
            curve: Curves.elasticOut,
            builder: (context, scale, child) {
              return Transform.scale(
                scale: scale,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: const RadialGradient(
                      colors: [Color(0xFF13BDAC), Color(0xFF0FA394)],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF13BDAC).withOpacity(0.3),
                        blurRadius: 30,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.notifications_rounded,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 30),
          const Text(
            'Loading Notifications...',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2E3E5C),
            ),
          ),
          const SizedBox(height: 20),
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF13BDAC)),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Column(
      children: [
        _buildFilterChips(),
        Expanded(
          child: _filteredNotifications.isEmpty
              ? _buildEmptyState()
              : _buildNotificationList(),
        ),
      ],
    );
  }

  Widget _buildFilterChips() {
    final filters = ['All', 'Unread', 'Appointments', 'Medical', 'Promotions'];

    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = _selectedFilter == filter;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (selected) {
                setState(() => _selectedFilter = filter);
              },
              backgroundColor: Colors.white,
              selectedColor: const Color(0xFF13BDAC),
              checkmarkColor: Colors.white,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF2E3E5C),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected
                      ? const Color(0xFF13BDAC)
                      : const Color(0xFF13BDAC).withOpacity(0.3),
                ),
              ),
              elevation: isSelected ? 2 : 0,
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_rounded,
            size: 100,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 20),
          Text(
            'No notifications',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You\'re all caught up!',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredNotifications.length,
      itemBuilder: (context, index) {
        final notification = _filteredNotifications[index];
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 400 + (index * 50)),
          curve: Curves.easeOut,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: child,
              ),
            );
          },
          child: _buildNotificationCard(notification),
        );
      },
    );
  }

  Widget _buildNotificationCard(NotificationModel notification) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_rounded, color: Colors.white),
      ),
      onDismissed: (direction) => _deleteNotification(notification.id),
      child: GestureDetector(
        onTap: () {
          _markAsRead(notification.id);
          if (notification.actionLink != null) {
            // Navigate to relevant screen
          }
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: notification.isRead ? Colors.white : const Color(0xFFE8F6F3),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: notification.isRead
                  ? Colors.grey.shade200
                  : const Color(0xFF13BDAC).withOpacity(0.3),
              width: notification.isRead ? 1 : 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon with gradient background
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: _getGradientForType(notification.type),
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: _getColorForType(
                        notification.type,
                      ).withOpacity(0.3),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Icon(notification.icon, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: notification.isRead
                                  ? FontWeight.w600
                                  : FontWeight.bold,
                              color: notification.isRead
                                  ? const Color(0xFF2E3E5C)
                                  : const Color(0xFF13BDAC),
                            ),
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: Color(0xFF13BDAC),
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.message,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 14,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatTime(notification.timestamp),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _getColorForType(
                              notification.type,
                            ).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _getTypeString(notification.type),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: _getColorForType(notification.type),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFAB() {
    return ScaleTransition(
      scale: _fabAnimation,
      child: FloatingActionButton.extended(
        onPressed: _toggleNotifications,
        backgroundColor: _notificationsEnabled
            ? const Color(0xFF13BDAC)
            : Colors.grey,
        icon: Icon(
          _notificationsEnabled
              ? Icons.notifications_active_rounded
              : Icons.notifications_off_rounded,
          color: Colors.white,
        ),
        label: Text(
          _notificationsEnabled ? 'ON' : 'OFF',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }

  // Helper methods
  List<Color> _getGradientForType(NotificationType type) {
    switch (type) {
      case NotificationType.appointment:
        return const [Color(0xFF13BDAC), Color(0xFF0FA394)];
      case NotificationType.medical:
        return const [Color(0xFF6B5CE7), Color(0xFF8B7BFF)];
      case NotificationType.reminder:
        return const [Color(0xFFFFA07A), Color(0xFFFF8E8E)];
      case NotificationType.promotion:
        return const [Color(0xFFFF6B6B), Color(0xFFEE5A6F)];
    }
  }

  Color _getColorForType(NotificationType type) {
    switch (type) {
      case NotificationType.appointment:
        return const Color(0xFF13BDAC);
      case NotificationType.medical:
        return const Color(0xFF6B5CE7);
      case NotificationType.reminder:
        return const Color(0xFFFFA07A);
      case NotificationType.promotion:
        return const Color(0xFFFF6B6B);
    }
  }

  String _getTypeString(NotificationType type) {
    switch (type) {
      case NotificationType.appointment:
        return 'APPOINTMENT';
      case NotificationType.medical:
        return 'MEDICAL';
      case NotificationType.reminder:
        return 'REMINDER';
      case NotificationType.promotion:
        return 'OFFER';
    }
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hr ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return DateFormat('MMM d').format(timestamp);
    }
  }
}

enum NotificationType { appointment, medical, reminder, promotion }

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime timestamp;
  bool isRead;
  final String? actionLink;
  final IconData icon;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    required this.isRead,
    this.actionLink,
    required this.icon,
  });
}
