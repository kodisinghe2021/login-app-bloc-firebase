part of 'login_bloc.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}

final class LoginCheckingState extends LoginState {}

final class LoginSuccessState extends LoginState {}

final class LoginFailedState extends LoginState {}
