import 'package:flutter/foundation.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class OneSignalService {
  OneSignalService._();

  static const String appId = 'b2085106-716f-4e8e-89ab-ca0bb6829d82';
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized || appId.isEmpty) {
      if (appId.isEmpty) {
        debugPrint(
          'OneSignal skipped: missing OneSignal App ID in one_signal_service.dart.',
        );
      }
      return;
    }

    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    OneSignal.initialize(appId);

    OneSignal.Notifications.addPermissionObserver((granted) {
      debugPrint('OneSignal permission changed: $granted');
    });

    OneSignal.Notifications.addClickListener((event) {
      final payload = event.notification.additionalData;
      debugPrint('OneSignal notification clicked: $payload');
    });

    await OneSignal.Notifications.requestPermission(false);
    _initialized = true;
  }
}
