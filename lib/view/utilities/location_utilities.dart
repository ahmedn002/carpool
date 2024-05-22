import 'package:milestoneone/model/classes/ride_location.dart';
import 'package:milestoneone/view/global/constants.dart';

class LocationUtilities {
  static RideLocation getGateRideLocation(double latitude, double longitude) {
    if (latitude == Constants.gateTwoLatitude && longitude == Constants.gateTwoLongitude) {
      return const RideLocation(
        latitude: Constants.gateTwoLatitude,
        longitude: Constants.gateTwoLongitude,
        name: 'ASUFE - Gate 2',
      );
    } else {
      return const RideLocation(
        latitude: Constants.gateThreeLatitude,
        longitude: Constants.gateThreeLongitude,
        name: 'ASUFE - Gate 3',
      );
    }
  }
}
