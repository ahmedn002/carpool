import 'package:flutter/widgets.dart';
import 'package:milestoneone/model/classes/ride_request.dart';

import '../../model/classes/ride.dart';

class DriverDataProvider extends ChangeNotifier {
  List<Ride> driverRides = [];
  Ride? currentlyActiveRide;

  List<RideRequest> rideRequests = [];
  int pendingRequests = 0;

  void checkForActiveRide() {
    if (driverRides.isNotEmpty) {
      try {
        currentlyActiveRide = driverRides.firstWhere(
          (ride) => ride.departureTime.isAfter(DateTime.now()),
        );
      } catch (e) {
        currentlyActiveRide = null;
      }
    }
  }

  void updateRideRequests(List<RideRequest> rideRequests) {
    this.rideRequests = rideRequests;
    pendingRequests = rideRequests.where((request) => request.status == RideRequest.pending).length;
    notifyListeners();
  }
}
