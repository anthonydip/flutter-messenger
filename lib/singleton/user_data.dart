import 'package:flutter/material.dart';
import 'package:simple_messenger/models/friend.dart';

class UserData with ChangeNotifier {
  static final UserData _userData = UserData._internal();

  String id = "";
  String email = "";
  String token = "";
  List<Friend> friends = [];

  factory UserData() {
    return _userData;
  }

  UserData._internal();

  void addFriend(Friend friend) {
    friends.add(friend);
    notifyListeners();
  }

  void clear() {
    id = "";
    email = "";
    token = "";
    friends.clear();
    notifyListeners();
  }
}

final userData = UserData();