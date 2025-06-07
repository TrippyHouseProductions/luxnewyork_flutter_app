import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:geolocator/geolocator.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class StoreProximityService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings =
        InitializationSettings(android: androidSettings);

    await _notificationsPlugin.initialize(initSettings);

    // NOTE Request iOS permissions
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    // NOTE Request Android 13+ notification permission
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }

    // NOTE Ensure Android notification channel exists for store alerts
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'store_channel',
      'Nearby Store Alerts',
      description: 'Notifications for nearby stores',
      importance: Importance.high,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> checkNearbyStores() async {
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permission denied');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print('Location permissions are permanently denied');
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      final stores = await _loadStoreData();
      final nearbyStore = _findNearestStore(position, stores);

      if (nearbyStore != null && nearbyStore['distance'] < 10.0) {
        print(
            'Nearest: ${nearbyStore['storeName']} (${nearbyStore['distance']} km)');
        await _sendNotification(
          title: 'Store Nearby!',
          body:
              'You are near ${nearbyStore['storeName']} in ${nearbyStore['city']}.',
        );
      } else {
        print('No store within range');
      }
    } catch (e) {
      print('Error checking nearby stores: $e');
    }
  }

  Future<List<Map<String, dynamic>>> _loadStoreData() async {
    final jsonString =
        await rootBundle.loadString('assets/data/store_locations.json');
    final List<dynamic> data = jsonDecode(jsonString);
    return data.cast<Map<String, dynamic>>();
  }

  Map<String, dynamic>? _findNearestStore(
    Position userPosition,
    List<Map<String, dynamic>> stores,
  ) {
    Map<String, dynamic>? nearestStore;
    double minDistance = double.infinity;

    for (var store in stores) {
      final storeLat = store['latitude'];
      final storeLon = store['longitude'];
      final distance = Geolocator.distanceBetween(
            userPosition.latitude,
            userPosition.longitude,
            storeLat,
            storeLon,
          ) /
          1000; // NOTE convert to kilometers

      if (distance < minDistance) {
        minDistance = distance;
        store['distance'] = distance;
        nearestStore = store;
      }
    }

    return nearestStore;
  }

  Future<void> _sendNotification({
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'store_channel',
      'Nearby Store Alerts',
      channelDescription: 'Notifications for nearby stores',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails details =
        NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(0, title, body, details);
  }

  Future<void> showTestNotification() async {
    await _sendNotification(
      title: 'Test Notification',
      body: 'If you see this, notifications are working.',
    );
  }
}
