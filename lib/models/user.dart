import 'package:flutter/foundation.dart';
import 'dart:math';
import 'package:dosepix/database/databaseHandler.dart' if (dart.library.html) 'package:dosepix/databaseServer/databaseHandler.dart';

const int NO_USER = -1;

class UserArguments {
  final int userId;
  UserArguments(this.userId);
}

class UserModel extends ChangeNotifier {
  final List<User> _users = [];

  // Get a list of currently registered users
  List<User> get users => _users;
  List<int> get ids => _users.map((user) => user.id).toList();
  // List get info => _users.map((user) => user.toMap()).toList();

  // Add a new user and notify
  void add(User user) {
    _users.add(user);
    notifyListeners();
  }

  // Remove user and notify
  void remove(User user) {
    _users.remove(user);
    notifyListeners();
  }

  User getUserFromId(int id) {
    return _users[ids.indexOf(id)];
  }
}

class ActiveUserModel extends UserModel {
}
