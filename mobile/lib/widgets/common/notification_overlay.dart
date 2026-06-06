import 'package:flutter/material.dart';
import 'package:mobile/widgets/common/notification_banner.dart';

class NotificationOverlay {
  static OverlayEntry? _currentEntry;

  static void show(BuildContext context, String title, String body) {
    _currentEntry?.remove();
    _currentEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top,
        left: 0,
        right: 0,
        child: NotificationBanner(
          title: title,
          body: body,
          onDismiss: () {
            _currentEntry?.remove();
            _currentEntry = null;
          },
        ),
      ),
    );
    Overlay.of(context).insert(_currentEntry!);
  }
}
