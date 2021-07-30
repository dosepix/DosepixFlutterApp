import 'package:flutter/foundation.dart';
import 'dart:math';

@immutable
class UserType {
  final int id;
  final String fullName;
  final String userName;
  final String email;
  final int numberInterventions;
  final double totalDose;
  final String password;

  Map<String, dynamic> toMap() {
    return {
      'userName': this.userName,
      'email': this.email,
      'numberInterventions': this.numberInterventions,
      'totalDose': this.totalDose,
      'password': this.password,
    };
  }

  UserType({
    required this.id,
    required this.fullName,
    required this.userName,
    required this.email,
    required this.numberInterventions,
    required this.totalDose,
    required this.password
  });
}

class UserModel extends ChangeNotifier {
  final List<UserType> _users = [];

  // Get a list of currently registered users
  List<UserType> get users => _users;
  List<int> get ids => _users.map((user) => user.id).toList();
  List get info => _users.map((user) => user.toMap()).toList();

  // Add a new user and notify
  void add(UserType user) {
    _users.add(user);
    notifyListeners();
  }

  void addNew(
      {required String fullName,
        required String userName,
        required String email}) {
    add(UserType(
        id: ids.isEmpty ? 1 : ids.reduce(max) + 1,
        fullName: fullName,
        userName: userName,
        email: email,
        numberInterventions: 0,
        totalDose: 0,
        password: ""));
}

  // Remove user and notify
  void remove(UserType user) {
    _users.remove(user);
    notifyListeners();
  }
}

class ActiveUserModel extends UserModel {
}
