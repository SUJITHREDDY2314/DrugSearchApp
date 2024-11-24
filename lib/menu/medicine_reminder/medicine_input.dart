import 'package:flutter/material.dart';
import 'notification_service.dart';  // Import notification service

class MedicineForm extends StatefulWidget {
  @override
  _MedicineFormState createState() => _MedicineFormState();
}

class _MedicineFormState extends State<MedicineForm> {
  final TextEditingController _medicineController = TextEditingController();
  final TextEditingController _doseController = TextEditingController();
  TimeOfDay? _selectedTime;
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _notificationService.initNotifications();
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _saveMedicine() {
    if (_medicineController.text.isEmpty || _doseController.text.isEmpty || _selectedTime == null) {
      return; // Add proper validation or feedback here
    }

    // Schedule the reminder notification
    final now = DateTime.now();
    final scheduledTime = DateTime(now.year, now.month, now.day, _selectedTime!.hour, _selectedTime!.minute);

    // Show the notification
    _notificationService.scheduleNotification(
      0,
      'Time to Take Medicine',
      'Take ${_doseController.text}g of ${_medicineController.text}',
      scheduledTime,
    );

    // Provide feedback to the user
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Reminder set for ${_medicineController.text}')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Medicine'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _medicineController,
              decoration: InputDecoration(labelText: 'Medicine Name'),
            ),
            TextField(
              controller: _doseController,
              decoration: InputDecoration(labelText: 'Dose(gms)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text(_selectedTime == null
                    ? 'Select Time'
                    : 'Time: ${_selectedTime!.format(context)}'),
                IconButton(
                  icon: Icon(Icons.access_time),
                  onPressed: () => _selectTime(context),
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveMedicine,
              child: Text('Set Reminder'),
            ),
          ],
        ),
      ),
    );
  }
}
