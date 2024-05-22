import 'package:flutter/material.dart';
import 'package:milestoneone/model/classes/ride_request.dart';
import 'package:milestoneone/services/request_services.dart';
import 'package:milestoneone/tools/response_wrapper.dart';

import '../../../../main.dart';

class PassengerRequestsProvider extends ChangeNotifier {
  Future<FirebaseResponseWrapper<List<RideRequest>>> requestsFuture = RequestServices.getRideRequests(userId: auth.currentUser!.uid);

  void refresh() {
    requestsFuture = RequestServices.getRideRequests(userId: auth.currentUser!.uid);
    notifyListeners();
  }
}
