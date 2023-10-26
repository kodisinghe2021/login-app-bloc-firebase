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
        Logger().i("ForgotClickedEvent is Triggered");
        emit(LinkSendingState());
        Logger().i("LinkSendState Triggered");
        bool isSuccess =
            await authenticationFirebase.forgotPassword(event.email);
        Logger().i("Inside forgot bloc -- $isSuccess");
        //---- if failed and error ocured
        if (isSuccess) {
          UserToken().clearCredintial();
          Logger().i("User Credintial cleared --${UserToken().getUserID}");
          emit(LinkSentSuccessState(isSucces: true));
          authenticationBloc.add(AuthenticationCheckingEvent());
        } else {
          emit(LinkSendingFailedState(
              errormessage: ExceptionsKeeper().getErrorMessage));
        }
      }
    });
  }
}
