import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';

class UserToken {
  static final UserToken _instance = UserToken._internal();

  factory UserToken() => _instance;

  UserToken._internal();

  final GetStorage _localStore = GetStorage();
  String _userID = "";
  String _email = "";

  void setUserID(String userID) {
    _userID = userID;
  }

  void setEmail(String email) {
    _email = email;
  }

  String get getUserID => _userID;
  String get getEmail => _email;

  Future<void> clearCredintial() async {
    await _localStore.erase();
    setEmail("");
    setUserID("");
  }

  Future<void> setData(UserCredential userCredential) async {
    setEmail(userCredential.user!.email.toString());
    setUserID(userCredential.user!.uid);
    await _localStore.write('userID', userCredential.user!.uid);
    Logger().i("Successfullt created user data -- ${UserToken().getEmail}");
  }
}
