import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:math';

const int NO_DOSIMETER = -1;

@immutable
class DosimeterType {
  final int id;
  final String name;
  final MaterialColor color;
  final int activeUser;
  final List<double> doseData;
  final List<double> timeData;

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'color': this.color,
      'activeUser': this.activeUser,
    };
  }

  DosimeterType({
    required this.id,
    required this.name,
    required this.color,
    required this.activeUser,
    required this.doseData,
    required this.timeData,
  });
}

class DosimeterArguments {
  final int dosimeterId;
  DosimeterArguments(this.dosimeterId);
}

class DosimeterModel extends ChangeNotifier {
  List<DosimeterType> _dosimeters = [];

  List<DosimeterType> get dosimeters => _dosimeters;
  List<int> get ids => _dosimeters.map((dosimeter) => dosimeter.id).toList();
  List<String> get names => _dosimeters.map((dosimeter) => dosimeter.name).toList();
  List get info => _dosimeters.map((dosimeter) => dosimeter.toMap()).toList();

  void add(DosimeterType dosimeter) {
    _dosimeters.add( dosimeter );
    notifyListeners();
  }

  int addNew({required String name, required MaterialColor color}) {
    int newId = ids.isEmpty ? 1 : ids.reduce(max) + 1;
    _dosimeters.add(
      DosimeterType(id: newId,
          name: name, color: color,
          activeUser: -1, doseData: [], timeData: [])
    );
    return newId;
  }

  bool checkExisting(String name) {
    return names.contains(name);
  }

  int getIdByName(String name) {
   return ids[names.indexOf(name)];
  }

  int addNewCheckExisting({required String name, required MaterialColor color}) {
    if (!checkExisting(name)) {
      return addNew(
        name: name,
        color: color,
      );
    } else {
      return getIdByName(name);
    }
  }

  void remove(DosimeterType dosimeter) {
    _dosimeters.remove( dosimeter );
    notifyListeners();
  }
}

class ActiveDosimeterModel extends DosimeterModel {
}
