class Reminder {
  DateTime dateTime;
  bool isActive;

  Reminder({
    required this.dateTime,
    this.isActive = true, 
  });

  Map<String, dynamic> toJson() {
    return {
      'dateTime': dateTime.toIso8601String(),
      'isActive': isActive,
    };
  }

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      dateTime: DateTime.parse(json['dateTime']),
      isActive: json['isActive'],
    );
  }

  String formattedTime() {
    return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
  }
}
