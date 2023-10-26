import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:simple_login_app/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:simple_login_app/bloc/login_bloc/login_bloc.dart';
import 'package:simple_login_app/widgets/popup_box.dart';

class Login extends StatelessWidget {
  bool isTapped = false;
  final TextEditingController _email = TextEditingController();
  Login({super.key});
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    Logger().i("5. Inside Login build");
    return Scaffold(
      body: SizedBox(
        width: screenSize.width,
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTextField(
                  hint: 'Enter Username',
                  iconData: Icons.security,
                  controller: context.read<AuthenticationBloc>().username,
                ),
                CustomTextField(
                  hint: 'Enter Password',
                  iconData: Icons.person,
                  controller: context.read<AuthenticationBloc>().password,
                ),

                PopUpBox(
                  enabledWidget: _forgotPassword(screenSize),
                  focusWidget: _showPopupInputBox(screenSize),
                ),
                const SizedBox(height: 20),
//--------------|||||------------------|||||--------------------------------|||||
                BlocConsumer<LoginBloc, LoginState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    Logger().i(
                        "Inside BlocConsumer -- LoginBloc state is --$state");
                    if (state is LoginCheckingState) {
                      Logger().i("State is LoginCheckingState");
                      return _DeactivatedLoginButton();
                    }
                    return _ActiveloginButton(context, screenSize);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

//*====================== Popup Input box
  Widget _forgotPassword(Size screenSize) => Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.only(left: 20),
          width: screenSize.width * .3,
          height: screenSize.height * .05,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: const FittedBox(
            child: Material(
              type: MaterialType.transparency,
              child: Text(
                'Forgot Password?',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.blueAccent,
                ),
              ),
            ),
          ),
        ),
      );
  Widget _showPopupInputBox(Size screenSize) => Material(
        borderRadius: BorderRadius.circular(20),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 50,
              horizontal: 20,
            ),
            width: screenSize.width * .9,
            height: screenSize.height * .35,
            decoration: BoxDecoration(
              // color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.blueAccent,
                width: 4,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Enter Your Email Here",
                  style: TextStyle(fontSize: 17),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        width: 2,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () {},
                  child: Container(
                    width: screenSize.width * .5,
                    height: screenSize.height * .06,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Center(
                      child: Text(
                        "Send",
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );

  Widget _ActiveloginButton(BuildContext context, Size screenSize) =>
      GestureDetector(
        onTap: () async {
          context.read<AuthenticationBloc>().add(LogInEvent());
          //  context.read<LoginBloc>().add(LoginDetailsEnterEvent());
        },
        child: Container(
          width: screenSize.width * .18,
          height: screenSize.width * .18,
          margin: const EdgeInsets.only(right: 30),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blueAccent,
          ),
          child: const Center(
              child: Icon(
            Icons.arrow_forward_ios,
            size: 40,
            color: Colors.white,
            weight: 40,
          )),
        ),
      );

  Widget _DeactivatedLoginButton() => const CircularProgressIndicator();
}

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.hint,
    required this.iconData,
    required this.controller,
  });

  final String hint;
  final IconData iconData;
  final TextEditingController controller;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    // bool isValidForm = context.read<AuthenticationBloc>().isValidForm;
    final Size screenSize = MediaQuery.of(context).size;
    return SizedBox(
      width: screenSize.width * .9,
      height: screenSize.height * .1,
      child: TextFormField(
        controller: widget.controller,
        decoration: InputDecoration(
          icon: Icon(widget.iconData),
          hintText: widget.hint,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: const BorderSide(
              width: 2,
              color: Colors.blueAccent,
            ),
          ),
          //  errorText: isValidForm ? null : 'empty field',
        ),
        // validator: (value) {
        //   if (value!.isEmpty) {
        //     return 'This Field requred';
        //   }
        //   return null;
        // },
      ),
    );
  }
}
