import 'package:milestoneone/main.dart';

class AppUser {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String profilePictureUrl;
  final num balance;
  late final String studentId;

  AppUser({
    this.id = '',
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.balance,
    required this.profilePictureUrl,
  }) {
    studentId = email.split('@')[0];
  }

  factory AppUser.fromAuth() {
    return AppUser(
      id: auth.currentUser!.uid,
      firstName: auth.currentUser!.displayName!.split(' ')[0],
      lastName: auth.currentUser!.displayName!.split(' ')[1],
      email: auth.currentUser!.email!,
      balance: 0,
      profilePictureUrl: auth.currentUser!.photoURL!,
    );
  }

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      profilePictureUrl: json['profilePictureUrl'] as String,
      balance: json['balance'] as num,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'profilePictureUrl': profilePictureUrl,
      'balance': balance,
    };
  }
}
