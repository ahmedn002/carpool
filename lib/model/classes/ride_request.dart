import 'package:milestoneone/model/classes/user.dart';

class RideRequest {
  String id;
  String driverId;
  AppUser user;
  String status;
  String rideId;

  static const String pending = 'pending';
  static const String accepted = 'accepted';
  static const String rejected = 'rejected';

  RideRequest({
    this.id = '',
    required this.driverId,
    required this.user,
    required this.status,
    required this.rideId,
  });

  factory RideRequest.fromJson(Map<String, dynamic> json) {
    return RideRequest(
      id: json['id'],
      driverId: json['driverId'],
      user: AppUser.fromJson(json['user']),
      status: json['status'],
      rideId: json['rideId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'driverId': driverId,
      'userId': user.id,
      'status': status,
      'rideId': rideId,
    };
  }
}
