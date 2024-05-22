import 'package:flutter/material.dart';

import '../../../../model/classes/ride.dart';

class PassengerDataProvider extends ChangeNotifier {
  List<Ride> availableRides = [];

  void setAvailableRides(List<Ride> rides) {
    availableRides = rides;
    notifyListeners();
  }
}
