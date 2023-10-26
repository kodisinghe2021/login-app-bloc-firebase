class ExceptionsKeeper {
  ExceptionsKeeper._internal();
  static final _instance = ExceptionsKeeper._internal();
  factory ExceptionsKeeper() => _instance;

  String _errorMessage = "";

  void setMessage(String message) {
    switch (message) {
      case 'invalid-email':
        _errorMessage = "This email is Not valid";
      case 'INVALID_LOGIN_CREDENTIALS':
        _errorMessage = "email or password is not valid";
        break;
      case '':
        _errorMessage = "Somthing went wrong";
      default:
        _errorMessage = message;
    }
  }

  String get getErrorMessage => _errorMessage;
}
