import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:simple_login_app/app.dart';
import 'package:simple_login_app/bloc/authentication_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (context) => AuthenticationBloc()
            ..add(
              AuthenticationCheckingEvent(),
            ),
        ),
      ],
      child: const AppView(),
    ),
  );
}
