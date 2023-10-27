import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:simple_login_app/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:simple_login_app/repository/firebase.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  static final _instance = LoginBloc._internal();
  factory LoginBloc() => _instance;

  LoginBloc._internal() : super(LoginInitial()) {
    AuthenticationFirebase authentication = AuthenticationFirebase();
    AuthenticationBloc authenticationBloc = AuthenticationBloc();
    on<LoginEvent>((event, emit) async {
      Logger().i("in LoginBloc");
      if (event is LoginDetailsAddedEvent) {
        //   LoginDetailsAddedEvent loginDetails = LoginDetailsAddedEvent();
        Logger().i("LoginDetailsEnterEvent Triggered");
        emit(LoginCheckingState());

        //----  waiting for the login response from backend----
        //-----------------------------------//
        Logger().i("login credintial -- ${event.email}-${event.password}");

        if (event.email.isEmpty || event.password.isEmpty) {
          showMessage("EVENT IS EMPTY", color: Colors.red);
          return;
        }
        bool isLoginSuccess = await authentication.login(
          email: event.email,
          password: event.password,
        );
        //~~~~~/////////////////////////////////////////////////////

        await Future.delayed(const Duration(milliseconds: 2000));

        Logger().i("Login status -- $isLoginSuccess");

        if (isLoginSuccess) {
          emit(LoginSuccessState());
          authenticationBloc.add(AuthenticationCheckingEvent());
        } else {
          emit(LoginFailedState());
          authenticationBloc.add(AuthenticationCheckingEvent());
        }
      }

      if (event is LoginDetailsAddedEvent) {
        Logger().i(
            "LoginDetailsEnterEvent Triggered ++++++ LoginInitial state added to the bloc");
        emit(LoginInitial());
      }
    });
  }
}
