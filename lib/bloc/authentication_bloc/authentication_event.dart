part of 'authentication_bloc.dart';

@immutable
sealed class AuthenticationEvent {}

final class AuthenticationCheckingEvent extends AuthenticationEvent {}

final class LogoutEvent extends AuthenticationEvent {}

final class LogInEvent extends AuthenticationEvent {}

final class LoginCheckingEvent extends AuthenticationEvent {}

final class ForgotPasswordEvent extends AuthenticationEvent {}
