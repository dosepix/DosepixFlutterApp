import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:math';

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
  List get info => _dosimeters.map((dosimeter) => dosimeter.toMap()).toList();

  void add(DosimeterType dosimeter) {
    _dosimeters.add( dosimeter );
    notifyListeners();
  }

  void addNew({required String name, required MaterialColor color}) {
    this.add(
      DosimeterType(id: ids.isEmpty ? 1 : ids.reduce(max) + 1,
          name: name, color: color,
          activeUser: -1, doseData: [], timeData: [])
    );
  }

  void remove(DosimeterType dosimeter) {
    _dosimeters.remove( dosimeter );
    notifyListeners();
  }
}

class ActiveDosimeterModel extends DosimeterModel {
}
