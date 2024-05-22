import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:milestoneone/view/global/constants.dart';
import 'package:milestoneone/view/utilities/general_utilities.dart';

class AuthenticationProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late User _user;
  User get user => _user;
  set user(User user) {
    _user = user;
    notifyListeners();
  }

  bool _isDriver = false;
  bool get isDriver => _isDriver;

  bool _isLoggedIn = false;
  bool get isLogin => _isLoggedIn;
  set isLogin(bool isLoggedIn) {
    _isLoggedIn = isLoggedIn;
    notifyListeners();
  }

  Future<UserCredential?> login(String email, String password, String userType) async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: '${userType}_$email@eng.asu.edu.eg', password: password);
      _user = userCredential.user!;
      _isDriver = userType == Constants.driver;
      return userCredential;
    } on Exception catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<UserCredential?> register(String email, String password, String userType) async {
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: '${userType}_$email@eng.asu.edu.eg', password: password);
      _user = userCredential.user!;
      _isDriver = userType == Constants.driver;
      return userCredential;
    } on Exception catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  void rememberUser(User user) {
    _user = user;
    _isLoggedIn = true;
    _isDriver = GeneralUtilities.isDriver(user.email!);
    notifyListeners();
  }
}
