import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    Logger().i("6. inside splash init stage");
    //context.read<AuthenticationBloc>().add(AuthenticationCheckingEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Logger().i("7. Inside Splash build");
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
