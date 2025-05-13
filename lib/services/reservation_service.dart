import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReservationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> createReservation(DateTime reservationTime) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    // Validate reservation time
    if (!await _isValidReservationTime(reservationTime)) {
      throw Exception('Invalid reservation time. Please select a future time between 6:00 AM and 6:00 PM.');
    }

    // Check if time slot is available
    if (!await isTimeSlotAvailable(reservationTime)) {
      throw Exception('This time slot is full. Please select another time.');
    }

    await _firestore.collection('reservations').add({
      'userId': user.uid,
      'reservationTime': Timestamp.fromDate(reservationTime),
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<bool> _isValidReservationTime(DateTime reservationTime) async {
    final now = DateTime.now();
    
    // Check if time is in the past
    if (reservationTime.isBefore(now)) {
      return false;
    }

    // Check if time is within allowed hours (6:00 AM - 6:00 PM)
    if (reservationTime.hour < 6 || reservationTime.hour >= 18) {
      return false;
    }

    // Check if time is at least 30 minutes in the future
    final minimumTime = now.add(const Duration(minutes: 30));
    if (reservationTime.isBefore(minimumTime)) {
      return false;
    }

    // Check if time is not more than 7 days in the future
    final maximumTime = now.add(const Duration(days: 7));
    if (reservationTime.isAfter(maximumTime)) {
      return false;
    }

    return true;
  }

  Stream<QuerySnapshot> getUserReservations() {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    return _firestore
        .collection('reservations')
        .where('userId', isEqualTo: user.uid)
        .orderBy('reservationTime', descending: false)
        .snapshots();
  }

  Future<void> cancelReservation(String reservationId) async {
    await _firestore
        .collection('reservations')
        .doc(reservationId)
        .update({'status': 'cancelled'});
  }

  Future<bool> isTimeSlotAvailable(DateTime reservationTime) async {
    if (!await _isValidReservationTime(reservationTime)) {
      return false;
    }

    final startOfDay = DateTime(
      reservationTime.year,
      reservationTime.month,
      reservationTime.day,
    );
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final reservations = await _firestore
        .collection('reservations')
        .where('reservationTime',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay),
            isLessThan: Timestamp.fromDate(endOfDay))
        .where('status', isEqualTo: 'pending')
        .get();

    // Check if there are too many reservations for the same time slot
    const maxReservationsPerTimeSlot = 5;
    final timeSlotReservations = reservations.docs.where((doc) {
      final time = (doc.data()['reservationTime'] as Timestamp).toDate();
      return time.hour == reservationTime.hour &&
          time.minute == reservationTime.minute;
    }).length;

    return timeSlotReservations < maxReservationsPerTimeSlot;
  }

  Future<List<DateTime>> getAvailableTimeSlots(DateTime date) async {
    final availableSlots = <DateTime>[];
    final startHour = 6; // 6 AM
    final endHour = 18; // 6 PM

    for (var hour = startHour; hour < endHour; hour++) {
      for (var minute = 0; minute < 60; minute += 30) {
        final timeSlot = DateTime(
          date.year,
          date.month,
          date.day,
          hour,
          minute,
        );

        if (await isTimeSlotAvailable(timeSlot)) {
          availableSlots.add(timeSlot);
        }
      }
    }

    return availableSlots;
  }
} 