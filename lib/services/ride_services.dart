import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:milestoneone/main.dart';
import 'package:milestoneone/model/classes/ride.dart';
import 'package:milestoneone/model/classes/user.dart';
import 'package:milestoneone/services/user_services.dart';
import 'package:milestoneone/tools/response_wrapper.dart';

class RideServices {
  static Future<FirebaseResponseWrapper<bool>> addRide(Ride ride) async {
    bool hasError = false;
    String? errorMessage;
    await firestore
        .collection(
          'rides',
        )
        .add(ride.toJson())
        .catchError((error) {
      hasError = true;
      errorMessage = error.toString();
    });

    if (hasError) {
      return FirebaseResponseWrapper<bool>(
        data: false,
        message: errorMessage,
        hasError: true,
      );
    } else {
      return FirebaseResponseWrapper<bool>(
        data: true,
        message: null,
        hasError: false,
      );
    }
  }

  static Future<FirebaseResponseWrapper<List<Ride>>> getRides() async {
    bool hasError = false;
    String? errorMessage;
    List<Ride> rides = [];
    await firestore
        .collection(
          'rides',
        )
        .get()
        .then((QuerySnapshot querySnapshot) async {
      for (var doc in querySnapshot.docs) {
        final Map data = doc.data() as Map<String, dynamic>;
        final FirebaseResponseWrapper<List<AppUser>> passengers = await UserServices.getAppUsersFromIds(data['passengerIds'].cast<String>());
        data['passengerIds'] = [];
        final FirebaseResponseWrapper<List<AppUser>> requestedPassengers = await UserServices.getAppUsersFromIds(data['requestedPassengerIds'].cast<String>());
        data['requestedPassengerIds'] = [];
        final FirebaseResponseWrapper<List<AppUser>> rejectedPassengers = await UserServices.getAppUsersFromIds(data['rejectedPassengerIds'].cast<String>());
        data['rejectedPassengerIds'] = [];
        rides.add(
          Ride.fromJson({
            'id': doc.id,
            ...doc.data() as Map<String, dynamic>,
          })
            ..setPassengers(passengers.data)
            ..setRequestedPassengers(requestedPassengers.data)
            ..setRejectedPassengers(rejectedPassengers.data),
        );
      }
    }).catchError((error) {
      hasError = true;
      errorMessage = error.toString();
      throw error;
    });

    return FirebaseResponseWrapper<List<Ride>>(
      data: rides,
      message: errorMessage,
      hasError: hasError,
    );
  }

  static Future<FirebaseResponseWrapper<List<Ride>>> getRidesByDriverId(String driverId) async {
    bool hasError = false;
    String? errorMessage;
    List<Ride> rides = [];
    await firestore
        .collection(
          'rides',
        )
        .where('driverId', isEqualTo: driverId)
        .get()
        .then((QuerySnapshot querySnapshot) async {
      for (var doc in querySnapshot.docs) {
        final Map data = doc.data() as Map<String, dynamic>;
        final FirebaseResponseWrapper<List<AppUser>> passengers = await UserServices.getAppUsersFromIds(data['passengerIds'].cast<String>());
        data['passengerIds'] = [];
        rides.add(
          Ride.fromJson({
            'id': doc.id,
            ...doc.data() as Map<String, dynamic>,
          })
            ..setPassengers(passengers.data),
        );
      }
    }).catchError((error) {
      hasError = true;
      errorMessage = error.toString();
      throw error;
    });

    return FirebaseResponseWrapper<List<Ride>>(
      data: rides,
      message: errorMessage,
      hasError: hasError,
    );
  }

  static Future<FirebaseResponseWrapper<List<Ride>>> getRidesByPassengerId(String passengerId) async {
    bool hasError = false;
    String? errorMessage;
    List<Ride> rides = [];
    await firestore
        .collection(
          'rides',
        )
        .where('passengerIds', arrayContains: passengerId)
        .get()
        .then((QuerySnapshot querySnapshot) async {
      for (var doc in querySnapshot.docs) {
        final Map data = doc.data() as Map<String, dynamic>;
        final FirebaseResponseWrapper<List<AppUser>> passengers = await UserServices.getAppUsersFromIds(data['passengerIds'].cast<String>());
        data['passengerIds'] = [];
        rides.add(
          Ride.fromJson({
            'id': doc.id,
            ...doc.data() as Map<String, dynamic>,
          })
            ..setPassengers(passengers.data),
        );
      }
    }).catchError((error) {
      hasError = true;
      errorMessage = error.toString();
      throw error;
    });

    return FirebaseResponseWrapper<List<Ride>>(
      data: rides,
      message: errorMessage,
      hasError: hasError,
    );
  }

  static Future<FirebaseResponseWrapper<bool>> addPassengerToRide(String rideId, String passengerId) async {
    bool hasError = false;
    String? errorMessage;
    await firestore
        .collection(
          'rides',
        )
        .doc(rideId)
        .update({
      'passengerIds': FieldValue.arrayUnion([passengerId]),
      'reservedSeats': FieldValue.increment(1),
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
    } else {
      return FirebaseResponseWrapper<bool>(
        data: true,
        message: null,
        hasError: false,
      );
    }
  }

  static Future<FirebaseResponseWrapper<bool>> changeRideStatus(String rideId, String status) async {
    bool hasError = false;
    String? errorMessage;
    await firestore
        .collection(
          'rides',
        )
        .doc(rideId)
        .update({
      'status': status,
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
    } else {
      return FirebaseResponseWrapper<bool>(
        data: true,
        message: null,
        hasError: false,
      );
    }
  }
}
