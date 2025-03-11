import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    AndroidInitializationSettings initializationSettingsAndroid = const AndroidInitializationSettings('@mipmap/ic_launcher');

    DarwinInitializationSettings initializationSettingsIOS = const DarwinInitializationSettings(requestAlertPermission: true, requestBadgePermission: true, requestSoundPermission: true);

    InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: _onNotificationTap);
  }

  void _onNotificationTap(NotificationResponse response) {
    // print("Notification Clicked: ${response.payload}");
  }

  Future<void> showInstantNotification() async {
    print('Sound File: sound.mp3');
    AndroidNotificationDetails androidPlatformChannelSpecifies = const AndroidNotificationDetails(
      'instant_channel',
      'Instant Notification',
      channelDescription: 'Channel for instant notification',
      importance: Importance.max,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound('sound'),
    );

    NotificationDetails platformChannelSpecifies = NotificationDetails(android: androidPlatformChannelSpecifies);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Reminder to Check-in',
      'Don`t Forget to Check-in!',
      platformChannelSpecifies,
      payload: 'instant',
    );
  }

  Future<void> scheduleDailyNotification(DateTime scheduledDateTime) async {
    print('Scheduled Notification Time: $scheduledDateTime');
    AndroidNotificationDetails androidPlatformChannelSpecifies = const AndroidNotificationDetails(
      'daily_channel',
      'Daily Reminder',
      channelDescription: 'Channel for daily reminders',
      importance: Importance.max,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound('sound'),
    );

    NotificationDetails platformChannelSpecifies = NotificationDetails(android: androidPlatformChannelSpecifies);

    tz.TZDateTime scheduledTime = tz.TZDateTime.from(scheduledDateTime, tz.local);
    print('Scheduled TZDateTime: $scheduledTime');

    await flutterLocalNotificationsPlugin.zonedSchedule(
      1,
      'Reminder to Check-in',
      'Don`t Forget to Check-in!',
      scheduledTime,
      platformChannelSpecifies,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      payload: 'reminder',
      matchDateTimeComponents: DateTimeComponents.time, // Ensure it repeats daily
    );
  }

  Future<void> cancelNotification(int notificationId) async {
    await flutterLocalNotificationsPlugin.cancel(notificationId);
  }

  static Future<void> dailyReminder() async {
    final NotificationService _notificationService = NotificationService();
    DateTime now = DateTime.now();

    DateTime scheduledTime = DateTime(now.year, now.month, now.day, 9, 0);

    print('Now: $now');
    print('Scheduled Time: $scheduledTime');

    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
      print('Scheduled Time after today: $scheduledTime');
    }

    await _notificationService.scheduleDailyNotification(scheduledTime);
  }
}
