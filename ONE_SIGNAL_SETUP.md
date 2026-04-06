# OneSignal Setup

## 1. Add the OneSignal App ID

Add your OneSignal App ID directly in:

`lib/services/notifications/one_signal_service.dart`

Replace:

```dart
static const String appId = 'YOUR_ONESIGNAL_APP_ID';
```

with your real App ID from the OneSignal dashboard.

## 2. Android platform credentials

For Android, the important delivery credential is not added in `AndroidManifest.xml`.

You need to:

1. Open the OneSignal dashboard.
2. Go to your app's Android platform setup.
3. Connect Firebase Cloud Messaging (FCM) credentials there.

Typical Android pieces:

- `google-services.json`: downloaded from your Firebase project and placed in `android/app/` if your Firebase setup requires it.
- FCM service account / sender credentials: added in the OneSignal dashboard.
- OneSignal App ID: stored directly in `lib/services/notifications/one_signal_service.dart`.

## 3. Current app integration point

The app initializes OneSignal from:

- `lib/services/notifications/one_signal_service.dart`
- `lib/main.dart`

If the App ID is empty, the app skips OneSignal initialization safely.
