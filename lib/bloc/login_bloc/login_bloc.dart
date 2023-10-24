import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  static final _instance = LoginBloc._internal();
  factory LoginBloc() => _instance;

  LoginBloc._internal() : super(LoginInitial()) {
    on<LoginEvent>((event, emit) {
      Logger().i("in LoginBloc");
      if (event is LoginDetailsEnterEvent) {
        Logger().i("LoginDetailsEnterEvent Triggered");
        emit(LoginCheckingState());
      }

      if (event is LoginDetailsAddedEvent) {
        Logger().i(
            "LoginDetailsEnterEvent Triggered ++++++ LoginInitial state added to the bloc");
        emit(LoginInitial());
      }
    });
  }
}
