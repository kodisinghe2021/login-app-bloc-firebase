import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:simple_login_app/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:simple_login_app/exception.dart';
import 'package:simple_login_app/repository/firebase.dart';
import 'package:simple_login_app/token/user_token.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc() : super(ForgotPasswordInitial()) {
    on<ForgotPasswordEvent>((event, emit) async {
      AuthenticationBloc authenticationBloc = AuthenticationBloc();
      AuthenticationFirebase authenticationFirebase = AuthenticationFirebase();
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      if (event is ForgotClickedEvent) {
        emit(ShowPopupState());
      }
      if (event is LinkSending) {
        Logger().i("LinkSending  event is triggered");
        emit(LinkSendingState());
        //!!!!!!!
        await Future.delayed(const Duration(milliseconds: 2000));
        //!!!!!!

        bool isSuccess =
            await authenticationFirebase.forgotPassword(event.email);

        //---- if failed and error ocured
        if (isSuccess) {
          UserToken().clearCredintial();
          emit(LinkSentSuccessState(isSucces: true));
          authenticationBloc.add(AuthenticationCheckingEvent());
          // _isLoadingCubit.isLoading();
          // showMessage('Email link sent successfully');
        } else {
          ExceptionsKeeper().setMessage("Somthing went wrong");
          emit(LinkSendingFailedState());
        }
      }
    });
  }
}
