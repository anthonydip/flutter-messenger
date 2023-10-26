class UserData {
  static final UserData _userData = UserData._internal();

  String email = "";
  String token = "";

  factory UserData() {
    return _userData;
  }

  UserData._internal();
}

final userData = UserData();