import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/auth/firebase_auth/auth_util.dart';
import '../../services/notifications_service.dart';
import '../../models/app_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'notifications_screen_model.dart';
export 'notifications_screen_model.dart';

class NotificationsScreenWidget extends StatefulWidget {
  const NotificationsScreenWidget({super.key});

  static String routeName = 'NotificationsScreen';
  static String routePath = '/notifications';

  @override
  State<NotificationsScreenWidget> createState() =>
      _NotificationsScreenWidgetState();
}

class _NotificationsScreenWidgetState extends State<NotificationsScreenWidget> {
  late NotificationsScreenModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  late NotificationsService _service;
  List<AppNotification> _notifications = [];
  bool _isLoading = true;
  String? _errorMessage;
  bool _showUnreadOnly = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NotificationsScreenModel());
    _service = NotificationsService(SupaFlow.client);
    _loadNotifications();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _loadNotifications() async {
    if (currentUserUid.isEmpty) {
      print('No user ID found');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final notifications = await _service.getUserNotifications(
        currentUserUid,
        unreadOnly: _showUnreadOnly,
      );

      setState(() {
        _notifications = notifications;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading notifications: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  Future<void> _markAsRead(AppNotification notification) async {
    if (notification.isRead) return;

    await _service.markAsRead(notification.id);
    setState(() {
      final index = _notifications.indexWhere((n) => n.id == notification.id);
      if (index != -1) {
        _notifications[index] =
            notification.copyWith(isRead: true, readAt: DateTime.now());
      }
    });
  }

  Future<void> _markAllAsRead() async {
    await _service.markAllAsRead(currentUserUid);
    setState(() {
      _notifications = _notifications
          .map((n) => n.copyWith(isRead: true, readAt: DateTime.now()))
          .toList();
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All notifications marked as read')),
      );
    }
  }

  Future<void> _deleteNotification(AppNotification notification) async {
    await _service.deleteNotification(notification.id);
    setState(() {
      _notifications.removeWhere((n) => n.id == notification.id);
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notification deleted')),
      );
    }
  }

  void _handleNotificationTap(AppNotification notification) {
    // Mark as read
    _markAsRead(notification);

    // Navigate based on notification type
    switch (notification.notificationType) {
      case NotificationType.chatMessage:
        context.pushNamed('chatsnew');
        break;
      case NotificationType.postGame:
      case NotificationType.gameReminder:
      case NotificationType.friendJoinedGame:
      case NotificationType.gameUpdate:
        if (notification.gameId != null) {
          context.pushNamed('playnew');
        }
        break;
      case NotificationType.bookingConfirmation:
        context.pushNamed('VenuesNew');
        break;
      case NotificationType.spotLeft:
        if (notification.gameId != null) {
          context.pushNamed('playnew');
        }
        break;
    }
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      // Original types
      case NotificationType.chatMessage:
        return Icons.message_rounded;
      case NotificationType.postGame:
        return Icons.rate_review_rounded;
      case NotificationType.gameReminder:
        return Icons.alarm_rounded;
      case NotificationType.friendJoinedGame:
        return Icons.person_add_rounded;
      case NotificationType.bookingConfirmation:
        return Icons.check_circle_rounded;
      case NotificationType.spotLeft:
        return Icons.warning_rounded;
      case NotificationType.gameUpdate:
        return Icons.info_rounded;
      case NotificationType.joinRequest:
        return Icons.group_add_rounded;
      case NotificationType.requestAccepted:
        return Icons.celebration_rounded;

      // PlayNow types
      case NotificationType.gameInviteReceived:
        return Icons.mail_rounded;
      case NotificationType.joinRequestReceived:
        return Icons.person_add_alt_rounded;
      case NotificationType.joinRequestApproved:
        return Icons.check_circle_outline_rounded;
      case NotificationType.joinRequestDeclined:
        return Icons.cancel_rounded;
      case NotificationType.playerTagged:
        return Icons.local_offer_rounded;
      case NotificationType.ratingReceived:
        return Icons.star_rounded;
      case NotificationType.gameResultsSubmitted:
        return Icons.emoji_events_rounded;
      case NotificationType.gameCancelled:
        return Icons.event_busy_rounded;
      case NotificationType.paymentReceived:
        return Icons.payments_rounded;
      case NotificationType.walletCreditEarned:
        return Icons.account_balance_wallet_rounded;
      case NotificationType.playPalAdded:
        return Icons.favorite_rounded;
      case NotificationType.referralRewardEarned:
        return Icons.card_giftcard_rounded;
      case NotificationType.offerActivated:
        return Icons.local_offer_rounded;

      // FindPlayers types
      case NotificationType.playerRequestResponse:
        return Icons.reply_rounded;
      case NotificationType.playerRequestFulfilled:
        return Icons.done_all_rounded;
      case NotificationType.matchFound:
        return Icons.group_rounded;
      case NotificationType.gameSessionInvite:
        return Icons.event_available_rounded;
      case NotificationType.sessionSpotFilled:
        return Icons.how_to_reg_rounded;
      case NotificationType.sessionJoinRequestAccepted:
        return Icons.thumb_up_rounded;
      case NotificationType.sessionJoinRequestRejected:
        return Icons.thumb_down_rounded;

      default:
        return Icons.notifications_rounded;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      // Original types
      case NotificationType.chatMessage:
        return const Color(0xFF6C63FF);
      case NotificationType.postGame:
        return const Color(0xFFFF6584);
      case NotificationType.gameReminder:
        return const Color(0xFFFFB74D);
      case NotificationType.friendJoinedGame:
        return const Color(0xFF4CAF50);
      case NotificationType.bookingConfirmation:
        return const Color(0xFF26C6DA);
      case NotificationType.spotLeft:
        return const Color(0xFFFFA726);
      case NotificationType.gameUpdate:
        return const Color(0xFF42A5F5);
      case NotificationType.joinRequest:
        return const Color(0xFF9C27B0);
      case NotificationType.requestAccepted:
        return const Color(0xFF66BB6A);

      // PlayNow types
      case NotificationType.gameInviteReceived:
        return const Color(0xFF7C4DFF);
      case NotificationType.joinRequestReceived:
        return const Color(0xFF9C27B0);
      case NotificationType.joinRequestApproved:
        return const Color(0xFF66BB6A);
      case NotificationType.joinRequestDeclined:
        return const Color(0xFFEF5350);
      case NotificationType.playerTagged:
        return const Color(0xFFFF7043);
      case NotificationType.ratingReceived:
        return const Color(0xFFFFD54F);
      case NotificationType.gameResultsSubmitted:
        return const Color(0xFF26A69A);
      case NotificationType.gameCancelled:
        return const Color(0xFFE57373);
      case NotificationType.paymentReceived:
        return const Color(0xFF66BB6A);
      case NotificationType.walletCreditEarned:
        return const Color(0xFF4DB6AC);
      case NotificationType.playPalAdded:
        return const Color(0xFFEC407A);
      case NotificationType.referralRewardEarned:
        return const Color(0xFFFFCA28);
      case NotificationType.offerActivated:
        return const Color(0xFFAB47BC);

      // FindPlayers types
      case NotificationType.playerRequestResponse:
        return const Color(0xFF5C6BC0);
      case NotificationType.playerRequestFulfilled:
        return const Color(0xFF66BB6A);
      case NotificationType.matchFound:
        return const Color(0xFF42A5F5);
      case NotificationType.gameSessionInvite:
        return const Color(0xFF7E57C2);
      case NotificationType.sessionSpotFilled:
        return const Color(0xFF26C6DA);
      case NotificationType.sessionJoinRequestAccepted:
        return const Color(0xFF66BB6A);
      case NotificationType.sessionJoinRequestRejected:
        return const Color(0xFFEF5350);

      default:
        return const Color(0xFF6C63FF);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: const Color(0xFF121212),
        body: Stack(
          children: [
            // Background pattern
            Positioned.fill(
              child: CustomPaint(
                painter: _BackgroundPainter(),
              ),
            ),
            // Main content
            SafeArea(
              child: Column(
                children: [
                  // Header
                  _buildHeader(),
                  // Filter tabs
                  _buildFilterTabs(),
                  // Notifications list
                  Expanded(
                    child: _buildNotificationsList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final unreadCount =
        _notifications.where((n) => !n.isRead).length;

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // Back button
          InkWell(
            onTap: () => context.safePop(),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
                size: 22.0,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Notifications',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (unreadCount > 0)
                  Text(
                    '$unreadCount unread',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 14,
                    ),
                  ),
              ],
            ),
          ),
          // Mark all as read button
          if (unreadCount > 0)
            InkWell(
              onTap: _markAllAsRead,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF6C63FF).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF6C63FF).withValues(alpha: 0.5),
                    width: 1,
                  ),
                ),
                child: const Text(
                  'Mark all read',
                  style: TextStyle(
                    color: Color(0xFF6C63FF),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          _buildFilterChip('All', !_showUnreadOnly),
          const SizedBox(width: 12),
          _buildFilterChip('Unread', _showUnreadOnly),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return InkWell(
      onTap: () {
        setState(() {
          _showUnreadOnly = label == 'Unread';
        });
        _loadNotifications();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFF6C63FF), Color(0xFF8B5CF6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF6C63FF)
                : Colors.white.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationsList() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6C63FF)),
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading notifications',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage!,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadNotifications,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C63FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_off_outlined,
              color: Colors.white.withValues(alpha: 0.3),
              size: 80,
            ),
            const SizedBox(height: 16),
            Text(
              _showUnreadOnly
                  ? 'No unread notifications'
                  : 'No notifications yet',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 18,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadNotifications,
      color: const Color(0xFF6C63FF),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          final notification = _notifications[index];
          return _buildNotificationCard(notification);
        },
      ),
    );
  }

  Widget _buildNotificationCard(AppNotification notification) {
    final icon = _getNotificationIcon(notification.notificationType);
    final color = _getNotificationColor(notification.notificationType);
    final timeAgo = timeago.format(notification.createdAt);

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => _deleteNotification(notification),
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(
          Icons.delete_rounded,
          color: Colors.white,
          size: 28,
        ),
      ),
      child: InkWell(
        onTap: () => _handleNotificationTap(notification),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: notification.isRead ? 0.05 : 0.1),
                Colors.white.withValues(alpha: notification.isRead ? 0.02 : 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: notification.isRead
                  ? Colors.white.withValues(alpha: 0.1)
                  : color.withValues(alpha: 0.3),
              width: notification.isRead ? 1 : 2,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      color.withValues(alpha: 0.8),
                      color.withValues(alpha: 0.6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
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
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.body,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      timeAgo,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 12,
                      ),
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
}

class _BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF6C63FF).withValues(alpha: 0.05)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height * 0.3);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.35,
      size.width * 0.5,
      size.height * 0.3,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.25,
      size.width,
      size.height * 0.3,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
