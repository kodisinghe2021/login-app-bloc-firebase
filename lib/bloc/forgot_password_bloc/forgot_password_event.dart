part of 'forgot_password_bloc.dart';

@immutable
sealed class ForgotPasswordEvent {}

final class LinkSending extends ForgotPasswordEvent {
  String email;
  LinkSending({required this.email});
}

final class ForgotClickedEvent extends ForgotPasswordEvent {}
