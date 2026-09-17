import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();
    // Gunakan icon default aplikasi Flutter
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );
    await _notificationsPlugin.initialize(settings: settings);
  }

  static Future<void> scheduleFollowUp(
    int id,
    String title,
    String body,
    DateTime selectedDate,
  ) async {
    // Set waktu spesifik ke jam 09:00 pagi
    final tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      9, // Jam 9 pagi
      0, // Menit 00
    );

    // UNTUK TESTING (muncul 1 menit setelah diklik)
    //
    //    // final tz.TZDateTime scheduledDate = tz.TZDateTime.now(tz.local).add(const Duration(minutes: 1));
    //
    // UNTUK TESTING (muncul 1 menit setelah diklik)

    // 🛠️ PERBAIKAN: Gunakan named parameters (id:, title:, dll) dan hapus uiLocalNotificationDateInterpretation
    await _notificationsPlugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'jadwal_channel',
          'Jadwal Follow-up',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  static Future<void> testNotification() async {
    // Set waktu ke 5 detik dari sekarang
    final tz.TZDateTime scheduledDate = tz.TZDateTime.now(
      tz.local,
    ).add(const Duration(seconds: 5));

    await _notificationsPlugin.zonedSchedule(
      id: 999, // ID bebas
      title: 'Test Notifikasi 🚀',
      body: 'Jika kamu melihat ini, sistem notifikasi berjalan lancar!',
      scheduledDate: scheduledDate,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'jadwal_channel',
          'Jadwal Follow-up',
          importance: Importance.max,
          priority: Priority.high,
          fullScreenIntent:
              true, // 👈 Memaksa notif muncul walau layar terkunci
          visibility:
              NotificationVisibility.public, // 👈 Terlihat di lock screen
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  static Future<void> testSchedule({
    required int id,
    required String title,
    required String body,
  }) async {
    final tz.TZDateTime scheduledDate = tz.TZDateTime.now(
      tz.local,
    ).add(const Duration(seconds: 5));

    await _notificationsPlugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'jadwal_channel',
          'Jadwal Follow-up',
          importance: Importance.max,
          priority: Priority.high,
          fullScreenIntent: true,
          visibility: NotificationVisibility.public,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.alarmClock,
    );
  }

  // 🚀 Test Instan 0 Detik (Langsung Muncul Saat Diklik)
  static Future<void> showInstantNotification() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'instant_channel_id',
          'Notifikasi Instan',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
        );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

    await _notificationsPlugin.show(
      id: 0,
      title: 'Notifikasi Instan Berhasil! 🚀',
      body: 'Sistem notifikasi dasar berjalan dengan baik.',
      payload: 'instant',
      notificationDetails: platformDetails,
    );
  }
}
