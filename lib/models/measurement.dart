import 'package:flutter/foundation.dart';
import 'dart:math';

@immutable
class MeasurementType {
  final int id;
  final String name;
  final int userId;
  final int dosimeterId;
  final List<double> doseData;
  final List<double> timeData;

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'userId': this.userId,
      'dosimeterId': this.dosimeterId,
      'doseData': this.doseData,
      'timeData': this.timeData,
    };
  }

  MeasurementType({
    required this.id,
    required this.name,
    required this.userId,
    required this.dosimeterId,
    required this.doseData,
    required this.timeData
  });
}

class MeasurementModel extends ChangeNotifier {
  final List<MeasurementType> _measurements = [];

  // Get a list of currently registered users
  List<MeasurementType> get measurements => _measurements;
  List<int> get ids => _measurements.map((measurement) => measurement.id).toList();
  List get info => _measurements.map((measurement) => measurement.toMap()).toList();

  // Add a new user and notify
  void add(MeasurementType measurement) {
    _measurements.add(measurement);
    notifyListeners();
  }

  void addNew(
      {required String name,
        required int userId, required int dosimeterId}) {
    _measurements.add(MeasurementType(
        id: ids.isEmpty ? 1 : ids.reduce(max) + 1,
        name: name,
        userId: userId,
        dosimeterId: dosimeterId,
        doseData: <double>[],
        timeData: <double>[])
    );
  }

  // Remove user and notify
  void remove(MeasurementType measurement) {
    _measurements.remove(measurement);
    notifyListeners();
  }
}
