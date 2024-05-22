import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:milestoneone/main.dart';
import 'package:milestoneone/services/user_services.dart';
import 'package:milestoneone/tools/response_wrapper.dart';
import 'package:milestoneone/view/utilities/general_utilities.dart';

import '../model/classes/user.dart';
import 'firebase_storage_manager.dart';

class AuthenticationServices {
  static Future<FirebaseResponseWrapper<bool>> signInWithEmailAndPassword(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      return FirebaseResponseWrapper(data: true, hasError: false);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return FirebaseResponseWrapper(data: false, hasError: true, message: 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        return FirebaseResponseWrapper(data: false, hasError: true, message: 'Wrong password provided for that user.');
      }
    } catch (e) {
      return FirebaseResponseWrapper(data: false, hasError: true, message: 'An unknown error occurred.');
    }
    return FirebaseResponseWrapper(data: false, hasError: true, message: 'An unknown error occurred.');
  }

  static Future<FirebaseResponseWrapper<bool>> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required File profilePicture,
    required num balance,
  }) async {
    try {
      final UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: email, password: password);
      await userCredential.user!.updateDisplayName('$firstName $lastName');
      final String profilePictureUrl = await FirebaseStorageManager.uploadProfilePicture(profilePicture);
      await userCredential.user!.updatePhotoURL(profilePictureUrl);

      final FirebaseResponseWrapper<bool> writtenToFirestore = await UserServices.writeUserData(
        AppUser(
          firstName: firstName,
          lastName: lastName,
          email: GeneralUtilities.parseEmail(email),
          profilePictureUrl: profilePictureUrl,
          balance: balance,
        ),
        userCredential.user!.uid,
      );

      if (writtenToFirestore.hasError) {
        return FirebaseResponseWrapper(data: false, hasError: true, message: 'An unknown error occurred.');
      }

      return FirebaseResponseWrapper(data: true, hasError: false);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return FirebaseResponseWrapper(data: false, hasError: true, message: 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        return FirebaseResponseWrapper(data: false, hasError: true, message: 'Email already in use.');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return FirebaseResponseWrapper(data: false, hasError: true, message: 'An unknown error occurred.');
  }

  static Future<void> signOut() async {
    await auth.signOut();
  }
}
