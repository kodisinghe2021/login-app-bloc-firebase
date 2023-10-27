import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:simple_login_app/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:simple_login_app/screens/home/home_page.dart';
import 'package:simple_login_app/screens/login/login_page.dart';
import 'package:simple_login_app/screens/splash/splash_screen.dart';

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    Logger().i("Inside AppView");
    return const MaterialApp(
      home: BlocBuilderView(),
    );
  }
}

class BlocBuilderView extends StatelessWidget {
  const BlocBuilderView({super.key});

  @override
  Widget build(BuildContext context) {
    Logger().i("inside builder");
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {},
      builder: (context, state) {
        Logger().i("5. Inside BlocBuilder");
        if (state is AuthenticationFailedState) {
          Logger().i("Inside BlocBuilder -- AuthenticationFailedState");
          return Login();
        }
        if (state is AuthenticationSuccessState) {
          Logger().i("Inside BlocBuilder -- AuthenticationSuccessState");
          return const Home();
        }
        return const Splash();
      },
    );
  }
}
