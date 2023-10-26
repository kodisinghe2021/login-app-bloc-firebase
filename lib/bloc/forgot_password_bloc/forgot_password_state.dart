part of 'forgot_password_bloc.dart';

@immutable
sealed class ForgotPasswordState {
  bool isSuccess;
  ForgotPasswordState({required this.isSuccess});
}

final class ForgotPasswordInitial extends ForgotPasswordState {
  ForgotPasswordInitial() : super(isSuccess: false);
}

final class ShowPopupState extends ForgotPasswordState {
  ShowPopupState() : super(isSuccess: false);
}

final class LinkSendingState extends ForgotPasswordState {
  LinkSendingState() : super(isSuccess: false);
}

final class LinkSentSuccessState extends ForgotPasswordState {
  bool isSucces;
  LinkSentSuccessState({required this.isSucces}) : super(isSuccess: isSucces);
}

final class LinkSendingFailedState extends ForgotPasswordState {
  LinkSendingFailedState() : super(isSuccess: false);
}
