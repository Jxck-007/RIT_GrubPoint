import 'package:flutter/material.dart';

class Reservation {
  final String id;
  final String userId;
  final String restaurantName;
  final DateTime date;
  final TimeOfDay time;
  final int guestCount;
  final String specialRequests;
  final String status;

  Reservation({
    required this.id,
    required this.userId,
    required this.restaurantName,
    required this.date,
    required this.time,
    required this.guestCount,
    required this.specialRequests,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'restaurantName': restaurantName,
      'date': date.toIso8601String(),
      'time': '${time.hour}:${time.minute}',
      'guestCount': guestCount,
      'specialRequests': specialRequests,
      'status': status,
    };
  }

  factory Reservation.fromMap(Map<String, dynamic> map) {
    final timeParts = (map['time'] as String).split(':');
    return Reservation(
      id: map['id'] as String,
      userId: map['userId'] as String,
      restaurantName: map['restaurantName'] as String,
      date: DateTime.parse(map['date'] as String),
      time: TimeOfDay(
        hour: int.parse(timeParts[0]),
        minute: int.parse(timeParts[1]),
      ),
      guestCount: map['guestCount'] as int,
      specialRequests: map['specialRequests'] as String,
      status: map['status'] as String,
    );
  }
} 