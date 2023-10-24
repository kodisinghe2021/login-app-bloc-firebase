part of 'authentication_bloc.dart';

@immutable
sealed class AuthenticationState {
  const AuthenticationState();
}

final class AuthenticationInitialState extends AuthenticationState {
  const AuthenticationInitialState() : super();
}

final class AuthenticationSuccessState extends AuthenticationState {
  const AuthenticationSuccessState() : super();
}

final class AuthenticationFailedState extends AuthenticationState {
  const AuthenticationFailedState() : super();
}
