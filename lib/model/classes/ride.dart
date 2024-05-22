import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:milestoneone/model/classes/ride_location.dart';
import 'package:milestoneone/model/classes/user.dart';

class Ride {
  late String id;
  String type;
  String status;
  String driverName;
  String driverId;
  String driverStudentCode;
  String driverPhotoUrl;
  String car;
  int carCapacity;
  int reservedSeats;
  RideLocation from;
  RideLocation to;
  DateTime departureTime;
  int price;
  List<AppUser> passengers;
  List<AppUser> requestedPassengers;
  List<AppUser> rejectedPassengers;

  Ride({
    this.id = '',
    required this.status,
    required this.driverName,
    required this.driverId,
    required this.driverPhotoUrl,
    required this.driverStudentCode,
    required this.car,
    required this.carCapacity,
    required this.reservedSeats,
    required this.from,
    required this.to,
    required this.departureTime,
    required this.passengers,
    required this.requestedPassengers,
    required this.rejectedPassengers,
    required this.type,
    required this.price,
  });

  factory Ride.fromJson(Map<String, dynamic> json) {
    return Ride(
      id: json['id'],
      status: json['status'],
      driverName: json['driverName'],
      driverId: json['driverId'],
      driverStudentCode: json['driverStudentCode'],
      driverPhotoUrl: json['driverPhotoUrl'],
      car: json['car'],
      carCapacity: json['carCapacity'],
      reservedSeats: json['reservedSeats'],
      from: RideLocation(
        name: json['fromName'],
        latitude: json['fromLatitude'],
        longitude: json['fromLongitude'],
      ),
      to: RideLocation(
        name: json['toName'],
        latitude: json['toLatitude'],
        longitude: json['toLongitude'],
      ),
      departureTime: (json['departureTime'] as Timestamp).toDate(),
      passengers: [], // Created after object is created
      requestedPassengers: [], // Created after object is created
      rejectedPassengers: [], // Created after object is created
      type: json['type'],
      price: json['price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'driverName': driverName,
      'status': status,
      'driverId': driverId,
      'type': type,
      'driverPhotoUrl': driverPhotoUrl,
      'driverStudentCode': driverStudentCode,
      'car': car,
      'carCapacity': carCapacity,
      'reservedSeats': reservedSeats,
      'fromLatitude': from.latitude,
      'fromLongitude': from.longitude,
      'fromName': from.name,
      'toLatitude': to.latitude,
      'toLongitude': to.longitude,
      'toName': to.name,
      'departureTime': departureTime,
      'passengerIds': passengers.map((e) => e.id).toList(),
      'requestedPassengerIds': requestedPassengers.map((e) => e.id).toList(),
      'rejectedPassengerIds': rejectedPassengers.map((e) => e.id).toList(),
      'price': price,
    };
  }

  void setPassengers(List<AppUser> passengers) {
    this.passengers.clear();
    this.passengers.addAll(passengers);
  }

  void setRequestedPassengers(List<AppUser> requestedPassengers) {
    this.requestedPassengers.clear();
    this.requestedPassengers.addAll(requestedPassengers);
  }

  void setRejectedPassengers(List<AppUser> rejectedPassengers) {
    this.rejectedPassengers.clear();
    this.rejectedPassengers.addAll(rejectedPassengers);
  }

  bool hasFreeSeats() => reservedSeats < carCapacity;

  static List<Ride> getSampleRides() => [];
}

class RideStatus {
  static const String pending = 'pending';
  static const String active = 'active';
  static const String completed = 'completed';

  static const List<String> values = [pending, active, completed];
}
