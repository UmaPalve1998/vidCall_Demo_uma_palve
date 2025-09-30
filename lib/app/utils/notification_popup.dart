import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'difenece_colors.dart';
import 'difenece_text_style.dart';

class NotificationPopup extends StatefulWidget {
  final RemoteMessage message;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;

  const NotificationPopup({
    Key? key,
    required this.message,
    this.onTap,
    this.onDismiss,
  }) : super(key: key);

  @override
  State<NotificationPopup> createState() => _NotificationPopupState();
}

class _NotificationPopupState extends State<NotificationPopup>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  Timer? _autoDismissTimer;
  bool _isDismissing = false;

  @override
  void initState() {
    super.initState();

    // Initialize animations
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    ));

    // Start animations
    _fadeController.forward();
    _slideController.forward();

    // Auto dismiss after 5 seconds
    _autoDismissTimer = Timer(const Duration(seconds: 5), () {
      _dismiss();
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    _autoDismissTimer?.cancel();
    super.dispose();
  }

  void _dismiss() {
    if (_isDismissing) return; // Prevent multiple dismissals
    _isDismissing = true;

    _autoDismissTimer?.cancel();

    _fadeController.reverse();
    _slideController.reverse().then((_) {
      widget.onDismiss?.call();
      if (mounted && Navigator.of(context).canPop()) {
        try {
          Navigator.of(context).pop();
        } catch (e) {
          debugPrint("Error dismissing popup: $e");
        }
      }
    });
  }

  void _onTap() {
    _autoDismissTimer?.cancel();
    widget.onTap?.call();
    _dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          margin: const EdgeInsets.only(top: 50, left: 16, right: 16),
          child: Material(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: _getBackgroundColor(),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: InkWell(
                onTap: _onTap,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // Icon
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _getIconBackgroundColor(),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          _getIcon(),
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.message.notification?.title ??
                                  'Notification',
                              style: DifeneceTextStyle.KH_2_NORMAL.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              widget.message.notification?.body ?? '',
                              style: DifeneceTextStyle.KH_3_BOLD.copyWith(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 12,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),

                      // Close button
                      IconButton(
                        onPressed: _dismiss,
                        icon: Icon(
                          Icons.close,
                          color: Colors.white.withOpacity(0.7),
                          size: 20,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 24,
                          minHeight: 24,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    final title = widget.message.notification?.title?.toLowerCase() ?? '';
    if (title.contains('sos') || title.contains('emergency')) {
      return Colors.red;
    } else if (title.contains('patrol') || title.contains('alert')) {
      return DifeneceColors.PBlueColor;
    } else {
      return Colors.green;
    }
  }

  Color _getIconBackgroundColor() {
    final title = widget.message.notification?.title?.toLowerCase() ?? '';
    if (title.contains('sos') || title.contains('emergency')) {
      return Colors.red.shade700;
    } else if (title.contains('patrol') || title.contains('alert')) {
      return DifeneceColors.PBlueColor.withOpacity(0.8);
    } else {
      return Colors.green.shade700;
    }
  }

  IconData _getIcon() {
    final title = widget.message.notification?.title?.toLowerCase() ?? '';
    if (title.contains('sos') || title.contains('emergency')) {
      return Icons.warning;
    } else if (title.contains('patrol')) {
      return Icons.security;
    } else if (title.contains('alert')) {
      return Icons.notifications_active;
    } else {
      return Icons.notifications;
    }
  }
}

class NotificationPopupService {
  static void showNotificationPopup(
    BuildContext context,
    RemoteMessage message, {
    VoidCallback? onTap,
  }) {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.transparent,
        builder: (context) => NotificationPopup(
          message: message,
          onTap: onTap,
          onDismiss: () {
            try {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            } catch (e) {
              debugPrint("Error dismissing popup: $e");
            }
          },
        ),
      );
    } catch (e) {
      debugPrint("Error showing notification popup: $e");
    }
  }

  static void showCustomNotificationPopup(
    BuildContext context, {
    required String title,
    required String body,
    Color? backgroundColor,
    IconData? icon,
    VoidCallback? onTap,
  }) {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.transparent,
        builder: (context) => CustomNotificationPopup(
          title: title,
          body: body,
          backgroundColor: backgroundColor,
          icon: icon,
          onTap: onTap,
          onDismiss: () {
            try {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            } catch (e) {
              debugPrint("Error dismissing custom popup: $e");
            }
          },
        ),
      );
    } catch (e) {
      debugPrint("Error showing custom notification popup: $e");
    }
  }
}

class CustomNotificationPopup extends StatefulWidget {
  final String title;
  final String body;
  final Color? backgroundColor;
  final IconData? icon;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;

  const CustomNotificationPopup({
    Key? key,
    required this.title,
    required this.body,
    this.backgroundColor,
    this.icon,
    this.onTap,
    this.onDismiss,
  }) : super(key: key);

  @override
  State<CustomNotificationPopup> createState() =>
      _CustomNotificationPopupState();
}

class _CustomNotificationPopupState extends State<CustomNotificationPopup>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  Timer? _autoDismissTimer;
  bool _isDismissing = false;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    ));

    _fadeController.forward();
    _slideController.forward();

    _autoDismissTimer = Timer(const Duration(seconds: 5), () {
      _dismiss();
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    _autoDismissTimer?.cancel();
    super.dispose();
  }

  void _dismiss() {
    if (_isDismissing) return; // Prevent multiple dismissals
    _isDismissing = true;

    _autoDismissTimer?.cancel();

    _fadeController.reverse();
    _slideController.reverse().then((_) {
      widget.onDismiss?.call();
      if (mounted && Navigator.of(context).canPop()) {
        try {
          Navigator.of(context).pop();
        } catch (e) {
          debugPrint("Error dismissing custom popup: $e");
        }
      }
    });
  }

  void _onTap() {
    _autoDismissTimer?.cancel();
    widget.onTap?.call();
    _dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          margin: const EdgeInsets.only(top: 50, left: 16, right: 16),
          child: Material(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: widget.backgroundColor ?? DifeneceColors.PBlueColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: InkWell(
                onTap: _onTap,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: (widget.backgroundColor ??
                                  DifeneceColors.PBlueColor)
                              .withOpacity(0.8),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          widget.icon ?? Icons.notifications,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.title,
                              style: DifeneceTextStyle.KH_2_NORMAL.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              widget.body,
                              style: DifeneceTextStyle.KH_3_BOLD.copyWith(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 12,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: _dismiss,
                        icon: Icon(
                          Icons.close,
                          color: Colors.white.withOpacity(0.7),
                          size: 20,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 24,
                          minHeight: 24,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
