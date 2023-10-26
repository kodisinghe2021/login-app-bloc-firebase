import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:simple_login_app/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:simple_login_app/token/user_token.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isClicked = false;
  bool isResetPasswordIsClicked = false;
  double cW = 70;
  double cH = 40;
  @override
  Widget build(BuildContext context) {
    Logger().i("Inside Home build");
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: const Text("Home"),
          centerTitle: true,
          actions: [
            IconButton.outlined(
              onPressed: () async {
                setState(() {
                  isClicked = true;
                });
                Future.delayed(const Duration(milliseconds: 1000));
                context.read<AuthenticationBloc>().add(LogoutEvent());
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: Center(
          child: Text(UserToken().getEmail),
        ),
        floatingActionButton: InkWell(
          onTap: isResetPasswordIsClicked
              ? () {}
              : () {
                  setState(() {
                    cW = 300;
                    cH = 260;
                    isResetPasswordIsClicked = true;
                    Logger().i(isResetPasswordIsClicked);
                  });
                },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeIn,
            width: cW,
            height: cH,
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(5, 5),
                  color: Colors.black.withOpacity(.3),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
              borderRadius: BorderRadius.circular(10),
            ),
            child: isResetPasswordIsClicked
                ? Form(
                    child: SizedBox(
                      width: cW,
                      height: cH,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            const Spacer(),
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                controller: context
                                    .read<AuthenticationBloc>()
                                    .currentPassword,
                                decoration: InputDecoration(
                                  hintText: 'Enter Exicting Password',
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: const BorderSide(
                                      width: 3,
                                      color: Colors.white,
                                    ),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                      width: 3,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(),
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                controller: context
                                    .read<AuthenticationBloc>()
                                    .newPassword,
                                decoration: InputDecoration(
                                  hintText: 'Enter New Password',
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: const BorderSide(
                                      width: 3,
                                      color: Colors.white,
                                    ),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                      width: 3,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
//------------------------ trigger the forgot password function
                                  if (context
                                          .read<AuthenticationBloc>()
                                          .newPassword
                                          .text
                                          .isEmpty ||
                                      context
                                          .read<AuthenticationBloc>()
                                          .currentPassword
                                          .text
                                          .isEmpty) {
                                    showMessage("Empty fields");
                                  } else {
                                    context
                                        .read<AuthenticationBloc>()
                                        .add(ResetPasswordEvent());
                                    setState(() {
                                      isResetPasswordIsClicked = false;
                                      cW = 70;
                                      cH = 40;
                                    });
                                  }
                                },
                                child: const Text("Reset"),
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
