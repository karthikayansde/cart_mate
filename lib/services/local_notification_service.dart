import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final LocalNotificationService _instance = LocalNotificationService._internal();
  factory LocalNotificationService() => _instance;
  LocalNotificationService._internal();

  static final FlutterLocalNotificationsPlugin _plugin =
  FlutterLocalNotificationsPlugin();

  /// INITIALIZE
  Future<void> init() async {
    const androidSettings = AndroidInitializationSettings('@drawable/ic_launcher');
    const settings = InitializationSettings(android: androidSettings);
    await _plugin.initialize(settings);
    // Request permissions (for Android 12+ exact alarms, iOS if needed)
    // await _requestPermissions();
  }
  /// REQUEST PERMISSIONS
  Future<void> _requestPermissions() async {
    final androidImpl = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    final granted = await androidImpl?.requestExactAlarmsPermission();
    debugPrint("Exact alarm permission: $granted");
  }

  /// SHOW INSTANT NOTIFICATION
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'channel_id',
      'General Notifications',
      channelDescription: 'Channel for local notifications',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@drawable/ic_launcher',
      largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
    );

    const platformDetails = NotificationDetails(android: androidDetails);

    await _plugin.show(
      id,
      title,
      body,
      platformDetails,
    );
  }
}