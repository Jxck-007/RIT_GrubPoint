import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReservationWidget extends StatefulWidget {
  final Function(DateTime) onReservationConfirmed;

  const ReservationWidget({
    super.key,
    required this.onReservationConfirmed,
  });

  @override
  State<ReservationWidget> createState() => _ReservationWidgetState();
}

class _ReservationWidgetState extends State<ReservationWidget> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _isLoading = false;

  bool _isValidTime(TimeOfDay time) {
    final now = DateTime.now();
    final selectedDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      time.hour,
      time.minute,
    );

    // Check if the selected time is in the past
    if (selectedDateTime.isBefore(now)) {
      return false;
    }

    // Check if the time is between 4 AM and 11 PM
    final hour = time.hour;
    return hour >= 4 && hour < 23;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        // Reset time if the selected date is today
        if (picked.day == DateTime.now().day) {
          _selectedTime = TimeOfDay.now();
        }
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (picked != null && picked != _selectedTime) {
      if (_isValidTime(picked)) {
        setState(() {
          _selectedTime = picked;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a valid time between 4 AM and 11 PM'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _confirmReservation() {
    if (!_isValidTime(_selectedTime)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a valid time between 4 AM and 11 PM'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final reservationDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    setState(() => _isLoading = true);
    widget.onReservationConfirmed(reservationDateTime);
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Make a Reservation',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _selectDate(context),
                    icon: const Icon(Icons.calendar_today),
                    label: Text(
                      DateFormat('MMM dd, yyyy').format(_selectedDate),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _selectTime(context),
                    icon: const Icon(Icons.access_time),
                    label: Text(_selectedTime.format(context)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Available Hours: 4:00 AM - 11:00 PM',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _confirmReservation,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Confirm Reservation'),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 