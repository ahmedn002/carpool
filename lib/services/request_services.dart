import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:milestoneone/services/user_services.dart';
import 'package:milestoneone/tools/response_wrapper.dart';

import '../main.dart';
import '../model/classes/ride_request.dart';
import '../model/classes/user.dart';

class RequestServices {
  static Future<FirebaseResponseWrapper<bool>> addRideRequest(RideRequest rideRequest) async {
    bool hasError = false;
    String? errorMessage;

    try {
      await firestore
          .collection(
            'requests',
          )
          .add(rideRequest.toJson());
    } catch (e) {
      hasError = true;
      errorMessage = e.toString();
    }

    if (hasError) {
      return FirebaseResponseWrapper<bool>(
        data: false,
        message: errorMessage,
        hasError: true,
      );
    }

    // Add user id to ride's requestedPassengerIds
    await firestore
        .collection(
          'rides',
        )
        .doc(rideRequest.rideId)
        .update({
      'requestedPassengerIds': FieldValue.arrayUnion([rideRequest.user.id]),
    }).catchError((error) {
      hasError = true;
      errorMessage = error.toString();
    });

    return FirebaseResponseWrapper<bool>(
      data: !hasError,
      message: errorMessage,
      hasError: hasError,
    );
  }

  static Future<FirebaseResponseWrapper<List<RideRequest>>> getRideRequests({bool forDriver = false, String? userId}) async {
    bool hasError = false;
    String? errorMessage;
    List<Map> rideRequestsJsons = [];

    try {
      final rideRequestsSnapshot = await firestore
          .collection(
            'requests',
          )
          .get();

      for (var element in rideRequestsSnapshot.docs) {
        if (forDriver && element.data()['driverId'] != auth.currentUser!.uid) {
          continue;
        }
        if (userId != null && element.data()['userId'] != userId) {
          continue;
        }
        rideRequestsJsons.add({
          ...element.data(),
          'id': element.id,
        });
      }
    } catch (e) {
      hasError = true;
      errorMessage = e.toString();
    }

    if (hasError) {
      return FirebaseResponseWrapper<List<RideRequest>>(
        data: [],
        message: errorMessage,
        hasError: true,
      );
    }

    List<RideRequest> rideRequests = [];
    List<AppUser> users = (await UserServices.getAppUsersFromIds(rideRequestsJsons.map((e) => e['userId'] as String).toList())).data;
    for (var element in rideRequestsJsons) {
      final AppUser user = users.firstWhere((user) => user.id == element['userId']);
      final Map<String, dynamic> json = {
        ...element,
        'user': {
          'id': user.id,
          ...user.toJson(),
        },
      };
      rideRequests.add(RideRequest.fromJson(json));
    }

    return FirebaseResponseWrapper<List<RideRequest>>(
      data: rideRequests,
      message: errorMessage,
      hasError: hasError,
    );
  }

  static Future<FirebaseResponseWrapper<bool>> acceptRideRequest(RideRequest rideRequest, num price) async {
    bool hasError = false;
    String? errorMessage;

    try {
      await firestore
          .collection(
            'requests',
          )
          .doc(rideRequest.id)
          .set(
        {'status': RideRequest.accepted},
        SetOptions(merge: true),
      );
    } catch (e) {
      hasError = true;
      errorMessage = e.toString();
    }

    if (hasError) {
      return FirebaseResponseWrapper<bool>(
        data: false,
        message: errorMessage,
        hasError: true,
      );
    }

    // subtract price from user balance and add it in driver balance
    await firestore
        .collection(
          'users',
        )
        .doc(rideRequest.user.id)
        .update({
      'balance': FieldValue.increment(-price),
    }).catchError((error) {
      hasError = true;
      errorMessage = error.toString();
    });

    if (hasError) {
      return FirebaseResponseWrapper<bool>(
        data: false,
        message: errorMessage,
        hasError: true,
      );
    }

    await firestore
        .collection(
          'users',
        )
        .doc(rideRequest.driverId)
        .update({
      'balance': FieldValue.increment(price),
    }).catchError((error) {
      hasError = true;
      errorMessage = error.toString();
    });

    if (hasError) {
      return FirebaseResponseWrapper<bool>(
        data: false,
        message: errorMessage,
        hasError: true,
      );
    }

    // Add user id to ride's requestedPassengerIds
    await firestore
        .collection(
          'rides',
        )
        .doc(rideRequest.rideId)
        .update({
      'passengerIds': FieldValue.arrayUnion([rideRequest.user.id]),
      'requestedPassengerIds': FieldValue.arrayRemove([rideRequest.user.id]),
      'reservedSeats': FieldValue.increment(1),
    }).catchError((error) {
      hasError = true;
      errorMessage = error.toString();
    });

    return FirebaseResponseWrapper<bool>(
      data: !hasError,
      message: errorMessage,
      hasError: hasError,
    );
  }

  static Future<FirebaseResponseWrapper<bool>> declineRideRequest(RideRequest rideRequest) async {
    bool hasError = false;
    String? errorMessage;

    try {
      await firestore
          .collection(
            'requests',
          )
          .doc(rideRequest.id)
          .set(
        {'status': RideRequest.rejected},
        SetOptions(merge: true),
      );
    } catch (e) {
      hasError = true;
      errorMessage = e.toString();
    }

    if (hasError) {
      return FirebaseResponseWrapper<bool>(
        data: false,
        message: errorMessage,
        hasError: true,
      );
    }

    // Remove from ride's requestedPassengerIds
    await firestore
        .collection(
          'rides',
        )
        .doc(rideRequest.rideId)
        .update({
      'requestedPassengerIds': FieldValue.arrayRemove([rideRequest.user.id]),
      'rejectedPassengerIds': FieldValue.arrayUnion([rideRequest.user.id]),
    }).catchError((error) {
      hasError = true;
      errorMessage = error.toString();
    });

    return FirebaseResponseWrapper<bool>(
      data: !hasError,
      message: errorMessage,
      hasError: hasError,
    );
  }
}
