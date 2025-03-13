import 'package:flutter/material.dart';
import 'package:notificationapp/services/notification_service_co.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: directives_ordering
import 'dart:convert';
import '../model/reminder_checkout.dart';

class CheckInReminder extends StatefulWidget {
  @override
  _CheckInReminderState createState() => _CheckInReminderState();
}

class _CheckInReminderState extends State<CheckInReminder> {
  final NotificationServiceCheckout _notificationServiceCheckout = NotificationServiceCheckout();
  List<ReminderCheckout> reminders = [];
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    _loadReminders();
    _notificationServiceCheckout.initialize();

    NotificationServiceCheckout.dailyReminderCo();
  }

  Future<void> _loadReminders() async {
    final prefs = await SharedPreferences.getInstance();
    final savedReminders = prefs.getStringList('reminders checkout') ?? [];
    setState(() {
      reminders =
          savedReminders.map((e) => ReminderCheckout.fromJson(jsonDecode(e))).toList();
    });
  }

  Future<void> _saveReminders() async {
    final prefs = await SharedPreferences.getInstance();
    final remindersJson = reminders.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList('reminders checkout', remindersJson);
  }

  Future<void> _addReminder() async {
    final reminder = ReminderCheckout(
        dateTime: DateTime(selectedDate.year, selectedDate.month,
            selectedDate.day, selectedTime.hour, selectedTime.minute),
        isActive: true);
    setState(() {
      reminders.add(reminder);
    });
    _saveReminders();
    _notificationServiceCheckout.scheduleDailyNotif(reminder.dateTime);
  }

  Future<void> _toggleReminder(int index, bool value) async {
    setState(() {
      reminders[index].isActive = value;
    });
    _saveReminders();
    if (value) {
      _notificationServiceCheckout.scheduleDailyNotif(reminders[index].dateTime);
    } else {
      _notificationServiceCheckout.cancelNotification(index);
    }
  }

  Future<void> _selectedDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectedTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'CheckOut Reminder',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: _notificationServiceCheckout.showInstantNotif,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 95),
              ),
              child: const Text('Notification Instant'),
            ),
            const SizedBox(height: 18),
            const Text(
              "Scheduled Notification",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 18),
            OutlinedButton.icon(
              onPressed: () => _selectedDate(context),
              icon: const Icon(Icons.calendar_today),
              label: Text('Date: ${selectedDate.toLocal().toString().split(' ')[0]}'),
            ),
            const SizedBox(height: 18),
            OutlinedButton.icon(
              onPressed: () => _selectedTime(context),
              icon: const Icon(Icons.access_time),
              label: Text('Time: ${selectedTime.format(context)}'),
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: _addReminder,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 115),
              ),
              child: const Text('Add Reminder'),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: ListView.builder(
                itemCount: reminders.length,
                itemBuilder: (context, index) {
                  final reminder = reminders[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title:
                          Text('Reminder set for ${reminder.formattedTime()}'),
                      subtitle: Text(reminder.isActive ? 'Active' : 'Inactive'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Switch(
                            value: reminder.isActive,
                            onChanged: (value) {
                              _toggleReminder(index, value);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                reminders.removeAt(index);
                              });
                              _saveReminders();
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
