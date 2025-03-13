class ReminderCheckout {
  DateTime dateTime;
  bool isActive;

  ReminderCheckout({
    required this.dateTime,
    this.isActive = true, 
  });

  Map<String, dynamic> toJson() {
    return {
      'dateTime': dateTime.toIso8601String(),
      'isActive': isActive,
    };
  }

  factory ReminderCheckout.fromJson(Map<String, dynamic> json) {
    return ReminderCheckout(
      dateTime: DateTime.parse(json['dateTime']),
      isActive: json['isActive'],
    );
  }

  String formattedTime() {
    return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
  }
}
