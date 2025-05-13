import 'package:flutter/material.dart';

class ReservationScreen extends StatefulWidget {
  final String restaurantId;
  final String restaurantName;

  const ReservationScreen({
    Key? key,
    this.restaurantId = 'my-reservations',
    this.restaurantName = 'My Reservations',
  }) : super(key: key);

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  final _guestsController = TextEditingController(text: '2');
  final _specialRequestsController = TextEditingController();
  bool _isLoading = false;
  
  // Available time slots
  final List<TimeOfDay> _availableTimeSlots = [
    const TimeOfDay(hour: 6, minute: 0),
    const TimeOfDay(hour: 7, minute: 0),
    const TimeOfDay(hour: 8, minute: 0),
    const TimeOfDay(hour: 9, minute: 0),
    const TimeOfDay(hour: 10, minute: 0),
    const TimeOfDay(hour: 11, minute: 0),
    const TimeOfDay(hour: 12, minute: 0),
    const TimeOfDay(hour: 13, minute: 0),
    const TimeOfDay(hour: 14, minute: 0),
    const TimeOfDay(hour: 15, minute: 0),
    const TimeOfDay(hour: 16, minute: 0),
    const TimeOfDay(hour: 17, minute: 0),
    const TimeOfDay(hour: 18, minute: 0),
  ];
  
  // List of reservations (would normally be fetched from a database)
  final List<Reservation> _reservations = [];

  @override
  void initState() {
    super.initState();
    _selectedTime = _availableTimeSlots[0];
  }

  @override
  void dispose() {
    _guestsController.dispose();
    _specialRequestsController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return '${days[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        
        // If selected date is today, filter out past time slots
        if (picked.year == DateTime.now().year && 
            picked.month == DateTime.now().month && 
            picked.day == DateTime.now().day) {
          _validateSelectedTime();
        }
      });
    }
  }
  
  void _validateSelectedTime() {
    final now = TimeOfDay.now();
    
    // If selected date is today and selected time is in the past, select the next available time
    if (_selectedDate.year == DateTime.now().year && 
        _selectedDate.month == DateTime.now().month && 
        _selectedDate.day == DateTime.now().day) {
      
      // Check if selected time is in the past
      if (_selectedTime.hour < now.hour || 
          (_selectedTime.hour == now.hour && _selectedTime.minute < now.minute)) {
        
        // Find the next available time slot
        TimeOfDay? nextAvailable;
        for (var timeSlot in _availableTimeSlots) {
          if (timeSlot.hour > now.hour || 
              (timeSlot.hour == now.hour && timeSlot.minute > now.minute)) {
            nextAvailable = timeSlot;
            break;
          }
        }
        
        if (nextAvailable != null) {
          setState(() {
            _selectedTime = nextAvailable!;
          });
        }
      }
    }
  }

  void _makeReservation() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      final newReservation = Reservation(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        restaurantName: widget.restaurantName,
        date: _selectedDate,
        time: _selectedTime,
        guestCount: int.parse(_guestsController.text),
        specialRequests: _specialRequestsController.text,
        status: 'Confirmed',
      );

      setState(() {
        _reservations.add(newReservation);
        _isLoading = false;
      });

      // Show success dialog
      if (mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Reservation Confirmed'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Restaurant: ${widget.restaurantName}'),
                    const SizedBox(height: 8),
                    Text('Date: ${_formatDate(_selectedDate)}'),
                    const SizedBox(height: 4),
                    Text('Time: ${_selectedTime.format(context)}'),
                    const SizedBox(height: 4),
                    Text('Party size: ${_guestsController.text} guests'),
                    if (_specialRequestsController.text.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text('Special requests: ${_specialRequestsController.text}'),
                    ],
                    const SizedBox(height: 16),
                    const Text(
                      'Your reservation has been confirmed. You will receive a notification with the details.',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Reset form or navigate back
                    _formKey.currentState!.reset();
                    _guestsController.text = '2';
                    _specialRequestsController.clear();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reserve - ${widget.restaurantName}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              // Navigate to reservation history
              _showReservationHistory();
            },
            tooltip: 'Reservation History',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Restaurant info card
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.restaurantName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Hours: 6:00 AM - 6:00 PM',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Phone: (555) 123-4567',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              const Text(
                'Reservation Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Date selection
              ListTile(
                leading: const Icon(Icons.calendar_month),
                title: const Text('Date'),
                subtitle: Text(
                  _formatDate(_selectedDate),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: const Icon(Icons.arrow_drop_down),
                onTap: () => _selectDate(context),
                tileColor: Colors.grey[200],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Time selection
              const Text('Time'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _availableTimeSlots.map((time) {
                  final isSelected = _selectedTime.hour == time.hour &&
                      _selectedTime.minute == time.minute;
                  return ChoiceChip(
                    label: Text(time.format(context)),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedTime = time;
                        });
                      }
                    },
                    backgroundColor: Colors.grey[200],
                    selectedColor: Theme.of(context).primaryColor,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  );
                }).toList(),
              ),
              
              const SizedBox(height: 16),
              
              // Guest count
              TextFormField(
                controller: _guestsController,
                decoration: const InputDecoration(
                  labelText: 'Number of Guests',
                  hintText: 'Enter number of guests',
                  prefixIcon: Icon(Icons.people),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter number of guests';
                  }
                  final guestCount = int.tryParse(value);
                  if (guestCount == null || guestCount < 1) {
                    return 'Please enter a valid number';
                  }
                  if (guestCount > 20) {
                    return 'For large parties, please call us directly';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Special requests
              TextFormField(
                controller: _specialRequestsController,
                decoration: const InputDecoration(
                  labelText: 'Special Requests (Optional)',
                  hintText: 'Any dietary restrictions or special occasions?',
                  prefixIcon: Icon(Icons.notes),
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              
              const SizedBox(height: 24),
              
              // Submit button
              ElevatedButton(
                onPressed: _isLoading ? null : _makeReservation,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Make Reservation',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
              
              const SizedBox(height: 8),
              const Text(
                'Note: Cancellations must be made at least 2 hours in advance.',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showReservationHistory() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Text(
                        'Reservation History',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                _reservations.isEmpty
                    ? const Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 64,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'No reservations yet',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Expanded(
                        child: ListView.separated(
                          controller: scrollController,
                          itemCount: _reservations.length,
                          separatorBuilder: (context, index) => const Divider(),
                          itemBuilder: (context, index) {
                            final reservation = _reservations[index];
                            return ListTile(
                              leading: const CircleAvatar(
                                child: Icon(Icons.restaurant),
                              ),
                              title: Text(reservation.restaurantName),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${_formatDate(reservation.date)} at ${reservation.time.format(context)}',
                                  ),
                                  Text('${reservation.guestCount} guests'),
                                ],
                              ),
                              trailing: Chip(
                                label: Text(
                                  reservation.status,
                                  style: TextStyle(
                                    color: reservation.status == 'Confirmed'
                                        ? Colors.green[700]
                                        : Colors.red[700],
                                  ),
                                ),
                                backgroundColor: reservation.status == 'Confirmed'
                                    ? Colors.green[100]
                                    : Colors.red[100],
                              ),
                              onTap: () {
                                // Show reservation details
                              },
                            );
                          },
                        ),
                      ),
              ],
            );
          },
        );
      },
    );
  }
}

class Reservation {
  final String id;
  final String restaurantName;
  final DateTime date;
  final TimeOfDay time;
  final int guestCount;
  final String specialRequests;
  final String status; // Confirmed, Cancelled, Completed

  Reservation({
    required this.id,
    required this.restaurantName,
    required this.date,
    required this.time,
    required this.guestCount,
    required this.specialRequests,
    required this.status,
  });
} 