import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:simple_login_app/bloc/authentication_bloc.dart';

class Login extends StatelessWidget {
  bool isTapped = false;

  Login({super.key});
  @override
  Widget build(BuildContext context) {
    final Size sSize = MediaQuery.of(context).size;

    Logger().i("5. Inside Login build");
    return Scaffold(
      body: SizedBox(
        width: sSize.width,
        child: Column(
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
            // BlocBuilder(builder: (context, state) {
            //   if (state is LoadingStartState) {
            //     return const CircularProgressIndicator();
            //   }

            _ActiveloginButton(context, sSize),
          ],
        ),
      ),
    );
  }

  Widget _ActiveloginButton(BuildContext context, Size sSize) =>
      GestureDetector(
        onTap: () async {
          //await Future.delayed(const Duration(milliseconds: 300));
          // context.read<LoaderBloc>().add(LoadingEvent());
          context.read<AuthenticationBloc>().add(LogInEvent());
        },
        child: Container(
          width: sSize.width * .18,
          height: sSize.width * .18,
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
    final Size sSize = MediaQuery.of(context).size;
    return SizedBox(
      width: sSize.width * .9,
      height: sSize.height * .1,
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
