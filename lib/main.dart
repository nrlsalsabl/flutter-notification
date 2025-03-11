import 'package:flutter/material.dart';
import 'package:notificationapp/reminder/checkin_reminder.dart';
import 'package:notificationapp/services/notification_service.dart';
import 'package:timezone/data/latest.dart' as tz;

Future<void> main() async {
  runApp(const MyApp());

  tz.initializeTimeZones();

  await NotificationService().initialize();
  
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Push Local Notification',
      home: const MyHomePage(title: 'Flutter Notification'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Check-in Reminder'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context, MaterialPageRoute(builder: (context) => CheckInReminder()),
                );
            },
          ),
          const Divider(), 

          ListTile(
            title: const Text('Check-out Reminder'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Navigator.push(
              //   context, MaterialPageRoute(builder: (context) => const CheckOutReminder()),
              // );
            },
          ),
          const Divider(),
        ],
      ),
    );
  }
}
