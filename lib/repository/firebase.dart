import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:simple_login_app/exception.dart';
import 'package:simple_login_app/token/user_token.dart';

class AuthenticationFirebase {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GetStorage _getStorage = GetStorage();
  //* check user Status -------------------------- 01

  Future<bool> requestForUserData(String userID) async {
    User? user = _auth.currentUser;
    await Future.delayed(const Duration(milliseconds: 500));
    if (user != null) {
      UserToken().setEmail(user.email.toString());
      UserToken().setUserID(user.uid);
      Logger().i(
          "User created -- ${UserToken().getEmail}  -- ${UserToken().getUserID}");
      return true;
    } else {
      return false;
    }
  }

  //* login with firebase -------------------------02
  Future<bool> login(String username, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: username, password: password);
      if (userCredential.user!.uid.isNotEmpty &&
          userCredential.user!.email.toString().isNotEmpty) {
        Logger().i("Login Success from Firebase");
        // set user ID for local storage
        _getStorage.write('userID', userCredential.user!.uid);

        // make object with values
        UserToken().setUserID(userCredential.user!.uid);
        UserToken().setEmail(userCredential.user!.email.toString());

        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      Logger().e(e.code);
      ExceptionsKeeper().setMessage(e.code);
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      Logger().i("Singout Success from Firebase");
      // clear local storage
      _getStorage.erase();
      UserToken().setUserID("");
      UserToken().setEmail("");
    } on FirebaseAuthException catch (e) {
      Logger().e(e.code);
    }
  }
}
