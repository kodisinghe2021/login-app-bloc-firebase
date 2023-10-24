import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:simple_login_app/bloc/authentication_bloc.dart';
import 'package:simple_login_app/token/user_token.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isClicked = false;
  @override
  Widget build(BuildContext context) {
    Logger().i("Inside Home build");
    return Scaffold(
      body: Center(
        child: Text(UserToken().getEmail),
      ),
      floatingActionButton: isClicked
          ? const CircularProgressIndicator()
          : FloatingActionButton(
              onPressed: () async {
                setState(() {
                  isClicked = true;
                });
                Future.delayed(const Duration(milliseconds: 1000));
                context.read<AuthenticationBloc>().add(LogoutEvent());
              },
              child: const Icon(Icons.logout),
            ),
    );
  }
}
