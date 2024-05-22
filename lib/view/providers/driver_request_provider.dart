import 'package:flutter/cupertino.dart';
import 'package:milestoneone/main.dart';
import 'package:milestoneone/model/classes/ride.dart';
import 'package:milestoneone/model/classes/ride_request.dart';
import 'package:milestoneone/services/ride_services.dart';
import 'package:milestoneone/tools/response_wrapper.dart';
import 'package:milestoneone/view/providers/driver_data_provider.dart';

import '../../services/request_services.dart';

class DriverRequestProvider extends ChangeNotifier {
  late Future<FirebaseResponseWrapper<List<Ride>>> ridesRequest;
  bool rereadRides = false;
  late Future<FirebaseResponseWrapper<List<RideRequest>>> rideRequestsRequest;

  late DriverDataProvider _driverDataProvider;

  void initialize(DriverDataProvider driverDataProvider) {
    _driverDataProvider = driverDataProvider;

    ridesRequest = RideServices.getRidesByDriverId(auth.currentUser!.uid);
    rereadRides = true;

    rideRequestsRequest = RequestServices.getRideRequests(forDriver: true);
    _handleRideRequestsResponse();
  }

  void reloadRides() {
    ridesRequest = RideServices.getRidesByDriverId(auth.currentUser!.uid);
    rereadRides = true;
    notifyListeners();
  }

  void reloadRideRequests() {
    rideRequestsRequest = RequestServices.getRideRequests(forDriver: true);
    _handleRideRequestsResponse();
    notifyListeners();
  }

  void _handleRideRequestsResponse() async {
    final FirebaseResponseWrapper<List<RideRequest>> response = await rideRequestsRequest;
    if (!response.hasError) {
      _driverDataProvider.updateRideRequests(response.data);
    }
    notifyListeners();
  }
}
