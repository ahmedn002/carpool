import 'package:flutter/material.dart';
import 'package:milestoneone/model/classes/ride.dart';
import 'package:milestoneone/model/classes/ride_request.dart';

class Constants {
  static const String googleMapsApiKey = 'YOUR_API_KEY';
  static const String driver = 'driver';
  static const String passenger = 'passenger';

  static const double gateTwoLatitude = 30.06462142924943;
  static const double gateTwoLongitude = 31.277284271389608;
  static const double gateThreeLatitude = 30.063897166311666;
  static const double gateThreeLongitude = 31.277600772052953;

  static const Map<String, Widget> rideStatuses = {
    RideStatus.pending: Icon(Icons.pending_actions_rounded),
    RideStatus.active: Icon(Icons.directions_car_rounded),
    RideStatus.completed: Icon(Icons.check_circle_rounded),
  };

  static const Map<String, Widget> requestStatuses = {
    RideRequest.accepted: Icon(Icons.check_circle_rounded),
    RideRequest.rejected: Icon(Icons.cancel_rounded),
  };

  static bool bybassTimeConstraints = false;
}
