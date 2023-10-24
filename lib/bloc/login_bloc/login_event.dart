part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

final class LoginDetailsEnterEvent extends LoginEvent {}

final class LoginDetailsAddedEvent extends LoginEvent {}
