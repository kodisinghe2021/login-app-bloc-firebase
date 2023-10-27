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
  Future<bool> login({required String email, required String password}) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (userCredential.user!.uid.isNotEmpty &&
          userCredential.user!.email.toString().isNotEmpty) {
        Logger().i("Login Success from Firebase");

        // make object with values
        await UserToken().setData(userCredential);

        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      Logger().e(e.code);
      ExceptionsKeeper().setMessage(e.code);
      return false;
    }
  }

//*-------------------------------logout---03
  Future<void> logout() async {
    try {
      await _auth.signOut();
      Logger().i("Singout Success from Firebase");
      // clear local storage
      await UserToken().clearCredintial();
    } on FirebaseAuthException catch (e) {
      Logger().e(e.code);
    }
  }

//*---------------------- forgot password -- 04
  Future<bool> forgotPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      Logger().i("Link sent successfully.....");
      return true;
    } on FirebaseAuthException catch (e) {
      Logger().e("failed to sent link--${e.code}");
      ExceptionsKeeper().setMessage(e.code);
      return false;
    }
  }

//*---------------------- update password -- 05
  Future<bool> updatePassword(
    String currentPassword,
    String newPassword,
  ) async {
    Logger().i("updatePassword function $currentPassword -- $newPassword");

    try {
      Logger().i(
          "Trying to login ${UserToken().getEmail.toString()}---- $currentPassword");
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: UserToken().getEmail.toString(),
        password: currentPassword,
      );

      Logger().i(
          "User Login Successfully ${userCredential.user!.email.toString()}");
      //_____________+++++_______________
      AuthCredential authCredential = userCredential.credential ??
          const AuthCredential(providerId: "", signInMethod: "");
      // const AuthCredential(providerId: "", signInMethod: "");
      //_____________+++++_______________
      Logger().i(
          "Condition success -- ${userCredential.credential != null} ---  ${userCredential.user!.email!.isNotEmpty}");
      if (userCredential.user!.email.toString().isNotEmpty) {
        Logger().i("Inside if ----+++++++++++++@@@@@@@@@@@@@@@@@@@@@@@@@@");
        // authCredential = userCredential.credential ??
        //     const AuthCredential(providerId: "", signInMethod: "");
        Logger().i("AuthCredintial Catched --- ${authCredential.accessToken}");
        try {
          // UserCredential newCredintial = await userCredential.user!
          //     .reauthenticateWithCredential(authCredential);
          // Logger().i(
          //     "Reauthentication success -- ${newCredintial.user!.email.toString()}");
          await userCredential.user!.updatePassword(newPassword);
          Logger().i("password Updated successfully.....");
          return true;
        } on FirebaseAuthException catch (e) {
          Logger().i("password Updated Failed -- ${e.code}");
          ExceptionsKeeper().setMessage('Update failed -- ${e.code}');
          return false;
        }
      } else {
        ExceptionsKeeper().setMessage('Current password is invalid');
        return false;
      }
    } on FirebaseAuthException catch (e) {
      ExceptionsKeeper().setMessage(e.code);
      return false;
    }
  }
}
