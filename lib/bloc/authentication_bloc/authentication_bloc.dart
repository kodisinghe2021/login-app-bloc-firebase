import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:simple_login_app/bloc/login_bloc/login_bloc.dart';
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
  final LoginBloc _loginBloc = LoginBloc();
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

      // -------this event is checking initially
      if (event is AuthenticationCheckingEvent) {
        if (AuthenticationBloc().getisFirstLoad) {
          await Future.delayed(const Duration(seconds: 3));
          AuthenticationBloc().setisFirstLoad(false);
        }
        //--- execute Firebase function
        bool isUserLogged = getStorage
            .hasData('userID'); //authenticationFirebase.isUserLogged();
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

      if (event is LogoutEvent) {
        Logger().i("Logout button clicked");
        await authenticationFirebase.logout();
        Logger().i(
            "password cleared---> ${UserToken().getEmail} -- ${UserToken().getUserID}");
        Fluttertoast.showToast(
            msg: "Successfully log out",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        AuthenticationBloc().add(AuthenticationCheckingEvent());
      }

      if (event is LogInEvent) {
        Logger().i("inside AuthenticationBloc -- LogInEvent");
        _loginBloc.add(LoginDetailsEnterEvent());

        if (username.text.isEmpty || password.text.isEmpty) {
          Logger().i("Empty fields");
          Fluttertoast.showToast(
              msg: "Empty fiels",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          await Future.delayed(const Duration(seconds: 1));
          _loginBloc.add(LoginDetailsAddedEvent());
          return;
        }

        //! __________+++++_______________
        bool isLoginSuccess =
            await authenticationFirebase.login(username.text, password.text);

        if (!isLoginSuccess) {
          Fluttertoast.showToast(
              msg: ExceptionsKeeper().getErrorMessage.toString(),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          username.clear();
          password.clear();
          Fluttertoast.showToast(
              msg: "Login Success",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.blue,
              textColor: Colors.white,
              fontSize: 16.0);
        }
        //! __________+++++_______________
        Logger().i(
            "login success token created --  ${UserToken().getEmail} -- ${UserToken().getUserID}");
        _loginBloc.add(LoginDetailsAddedEvent());
        AuthenticationBloc().add(AuthenticationCheckingEvent());
      }
      if (event is LoginCheckingEvent) {
        Logger().i("LoginCheckingEvent is emit AuthenticationCheckingState");
        emit(const AuthenticationCheckingState());
      }

      if (event is ForgotPasswordEvent) {
        if (username.text.isEmpty) {
          Fluttertoast.showToast(
              msg: "Please Enter your email",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.blue,
              textColor: Colors.white,
              fontSize: 16.0);
          return;
        }
      }
    });
  }
}
