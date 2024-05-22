import 'package:milestoneone/main.dart';
import 'package:milestoneone/model/classes/user.dart';
import 'package:milestoneone/tools/response_wrapper.dart';

class UserServices {
  static Future<FirebaseResponseWrapper<bool>> writeUserData(AppUser user, String uid) async {
    bool hasError = false;
    firestore.collection('users').doc(uid).set(user.toJson()).catchError((error) => hasError = true);
    return FirebaseResponseWrapper(data: !hasError, hasError: hasError);
  }

  static Future<FirebaseResponseWrapper<List<AppUser>>> getAppUsersFromIds(List<String> ids) async {
    bool hasError = false;
    List<AppUser> users = [];
    await firestore.collection('users').get().then((value) {
      for (var doc in value.docs) {
        if (ids.contains(doc.id)) {
          users.add(AppUser.fromJson({
            'id': doc.id,
            ...doc.data(),
          }));
        }
      }
    }).catchError((error) => hasError = true);
    return FirebaseResponseWrapper(data: users, hasError: hasError);
  }
}
