class UserToken {
  static final UserToken _instance = UserToken._internal();

  factory UserToken() => _instance;

  UserToken._internal();

  String _userID = "";
  String _email = "";

  void setUserID(String userID) {
    _userID = userID;
  }

  void setEmail(String email) {
    _email = email;
  }

  String get getUserID => _userID;
  String get getEmail => _email;
}
