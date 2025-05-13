import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReservationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> createReservation(DateTime reservationTime) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');
<<<<<<< HEAD
    
    // Check if reservation time is within allowed hours (6:00 AM - 6:00 PM)
    if (reservationTime.hour < 6 || reservationTime.hour >= 18) {
      throw Exception('Reservations can only be made between 6:00 AM and 6:00 PM');
    }
    
    // Check if reservation time is in the past
    if (reservationTime.isBefore(DateTime.now())) {
      throw Exception('Cannot make reservations for past times');
    }
=======
>>>>>>> 8de4c38708317529c31694d7f9ab862e0bb61141

    await _firestore.collection('reservations').add({
      'userId': user.uid,
      'reservationTime': Timestamp.fromDate(reservationTime),
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
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
<<<<<<< HEAD
    // Check if reservation time is within allowed hours (6:00 AM - 6:00 PM)
    if (reservationTime.hour < 6 || reservationTime.hour >= 18) {
      return false;
    }
    
    // Check if reservation time is in the past
    if (reservationTime.isBefore(DateTime.now())) {
      return false;
    }
  
=======
>>>>>>> 8de4c38708317529c31694d7f9ab862e0bb61141
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
    // You can adjust this number based on your restaurant's capacity
    const maxReservationsPerTimeSlot = 5;
    final timeSlotReservations = reservations.docs.where((doc) {
      final time = (doc.data()['reservationTime'] as Timestamp).toDate();
      return time.hour == reservationTime.hour &&
          time.minute == reservationTime.minute;
    }).length;

    return timeSlotReservations < maxReservationsPerTimeSlot;
  }
} 