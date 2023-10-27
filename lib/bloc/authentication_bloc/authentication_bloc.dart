import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:simple_login_app/exception.dart';
import 'package:simple_login_app/repository/firebase.dart';
import 'package:simple_login_app/token/user_token.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  //------------------------making Singleton
  static final AuthenticationBloc _instance = AuthenticationBloc._internal();
  factory AuthenticationBloc() => _instance;

  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController currentPassword = TextEditingController();
  final TextEditingController newPassword = TextEditingController();
  // final LoginBloc _loginBloc = LoginBloc();

  bool _isFirstLoad = true;

  void setisFirstLoad(bool val) {
    _isFirstLoad = val;
  }

  bool get getisFirstLoad => _isFirstLoad;

  // -----------------------------------------------Constructor calling
  AuthenticationBloc._internal() : super(const AuthenticationInitialState()) {
    on<AuthenticationEvent>((event, emit) async {
      AuthenticationFirebase authenticationFirebase = AuthenticationFirebase();
      // create local storage instance
      final GetStorage getStorage = GetStorage();

//&-----------------------------------------------AuthenticationCheckingEvent
      if (event is AuthenticationCheckingEvent) {
        Logger().i("authentication loggin");
        if (AuthenticationBloc().getisFirstLoad) {
          await Future.delayed(const Duration(seconds: 3));
          AuthenticationBloc().setisFirstLoad(false);
        }

        //--- execute Firebase function
        bool isUserLogged = getStorage.hasData('userID');

        Logger().i(
            "Local storage data -- $isUserLogged -- ${getStorage.read('userID')}");

        if (isUserLogged) {
          // 1. get user local id
          String userID = await getStorage.read('userID');
          // 2. get user data using local user ID
          await authenticationFirebase.requestForUserData(userID);
          emit(const AuthenticationSuccessState());
        } else {
          Logger().i("Login Failed");
          emit(const AuthenticationFailedState());
        }
      }
//&-----------------------------------------------LogoutEvent
      if (event is LogoutEvent) {
        Logger().i("Logout button clicked");
        await authenticationFirebase.logout();
        // Logger().i(
        //     "password cleared---> ${UserToken().getEmail} -- ${UserToken().getUserID}");
        showMessage("Successfully log out", color: Colors.red);
        AuthenticationBloc().add(AuthenticationCheckingEvent());
      }

//&-----------------------------------------------LogInEvent

      // if (event is LogInEvent) {
      //   Logger().i("inside AuthenticationBloc -- LogInEvent");
      //   _loginBloc.add(LoginDetailsEnterEvent());

      //   if (username.text.isEmpty || password.text.isEmpty) {
      //     Logger().i("Empty fields");
      //     showMessage("Empty fiels", color: Colors.red);
      //     await Future.delayed(const Duration(seconds: 1));

      //     _loginBloc.add(LoginDetailsAddedEvent());
      //     return;
      //   }
      //   Logger().i("get into false side");
      //   //! __________+++++_______________
      //   bool isLoginSuccess =
      //       await authenticationFirebase.login(username.text, password.text);

      //   if (!isLoginSuccess) {
      //     showMessage(ExceptionsKeeper().getErrorMessage.toString(),
      //         color: Colors.red);
      //   } else {
      //     username.clear();
      //     password.clear();
      //     showMessage("Login Success");
      //   }
      //   //! __________+++++_______________
      //   // Logger().i(
      //   //     "login success token created --  ${UserToken().getEmail} -- ${UserToken().getUserID}");

      //   _loginBloc.add(LoginDetailsAddedEvent());

      //   AuthenticationBloc().add(AuthenticationCheckingEvent());
      // }

//&-----------------------------------------------LoginCheckingEvent
      if (event is LoginCheckingEvent) {
        Logger().i("LoginCheckingEvent is emit AuthenticationCheckingState");
        emit(const AuthenticationCheckingState());
      }
// //&-----------------------------------------------ForgotPasswordEvent
//       if (event is ForgotPasswordEvent) {
//         Logger().i("forgot password event is triggered");
//         bool isSuccess =
//             await authenticationFirebase.forgotPassword(username.text);

//         //---- if failed and error ocured
//         if (!isSuccess) {
//           showMessage("Failed..! - e ${ExceptionsKeeper().getErrorMessage}",
//               color: Colors.red);
//         } else {
//           _isLoadingCubit.isLoading();
//           showMessage('Email link sent successfully');
//         }
//         //---if successfully link was sent..
//       }
//&-----------------------------------------------PasswordResetEvent
      if (event is ResetPasswordEvent) {
        Logger().i("Inside ResetPasswordEvent");
        bool isUpdatedSuccess = await authenticationFirebase.updatePassword(
          currentPassword.text,
          newPassword.text,
        );
        if (isUpdatedSuccess) {
          showMessage("Successfully Updated");
          await UserToken().clearCredintial();
          AuthenticationBloc().add(AuthenticationCheckingEvent());
        } else {
          showMessage(ExceptionsKeeper().getErrorMessage, color: Colors.red);
        }
      }
    });
  }
}

dynamic showMessage(
  String message, {
  Color? color,
}) =>
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: color ?? Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0);
