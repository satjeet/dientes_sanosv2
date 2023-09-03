import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationManager {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> requestPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("Permission granted");
      _getFCMToken();
    } else {
      print("Permission denied");
    }
  }

  Future<void> _getFCMToken() async {
    String? token = await _firebaseMessaging.getToken();
    print("FCM Token: $token");
    // Aquí podrías guardar el token en Firestore o en algún lugar seguro.
  }
}
