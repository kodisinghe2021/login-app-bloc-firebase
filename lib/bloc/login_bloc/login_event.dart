part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {
  LoginEvent({
    required this.email,
    required this.password,
  });

  String email;
  String password;
}

final class LoginDetailsAddedEvent extends LoginEvent {
  // Private constructor to prevent external instantiation
  LoginDetailsAddedEvent({
    required this.email,
    required this.password,
  }) : super(
          email: email,
          password: password,
        );

  // // Static and final instance variable to hold the single instance of the class
  // static final _instance = LoginDetailsAddedEvent._internal();

  // // Factory constructor to provide access to the single instance
  // factory LoginDetailsAddedEvent() => _instance;

  // properties
  @override
  String email;
  @override
  String password;

  // //setter
  // void setData(String email, String password) {
  //   _email = email;
  //   _password = password;
  // }

  // //getters
  // String get getEmail => _email;
  // String get getPassword => _password;
}
