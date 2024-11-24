import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import './login/login_page.dart';
import './menu/medicine_reminder/notification_service.dart'; // Adjust based on your structure

void main() {
  // WidgetsFlutterBinding.ensureInitialized();  // Ensures that the binding is initialized
  NotificationService().initNotifications();  // Initialize notifications here
  tz_data.initializeTimeZones();  // Initialize timezone data
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(), // Set LoginPage as the home screen
    );
  }
}
