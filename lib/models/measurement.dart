import 'package:flutter/foundation.dart';
import 'dart:math';

class MeasurementType {
  final int id;
  final String name;
  final int userId;
  final int dosimeterId;
  final int deviceId;
  final int startTime;
  final List<MeasurementDataPoint> doseData;
  double totalDose;

  // Constructor
  MeasurementType({
    required this.id,
    required this.name,
    required this.userId,
    required this.dosimeterId,
    required this.deviceId,
    required this.startTime,
    required this.doseData,
    required this.totalDose,
  });

  // Info to map
  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'userId': this.userId,
      'dosimeterId': this.dosimeterId,
      'deviceId': this.deviceId,
      'startTime': this.startTime,
      'doseData': this.doseData,
      // 'timeData': this.timeData,
      'totalDose': this.totalDose,
    };
  }

  // Add a data point
  void addDataPoint(MeasurementDataPoint dp) {
    // timeData.add(dp.time);
    this.doseData.add(MeasurementDataPoint(dp.time - this.startTime, dp.dose));
    this.totalDose += dp.dose;
  }

  List<MeasurementDataPoint> selectTimeRange(double time) {
    List<MeasurementDataPoint> filteredData = [];
    for (MeasurementDataPoint dp in this.doseData.reversed) {
      if(dp.time < doseData.last.time - time) {
        break;
      }
      filteredData.add(dp);
    }
    return filteredData;
  }
}

class MeasurementArguments {
  final int userId;
  final int dosimeterId;
  MeasurementArguments(this.userId, this.dosimeterId);
}

// Important ids for the current measurement
class MeasurementCurrent extends ChangeNotifier {
  int userId;
  int dosimeterId;
  int deviceId;
  MeasurementCurrent({
    required this.userId,
    required this.dosimeterId,
    required this.deviceId,
  });

  void update() {
    notifyListeners();
  }
}

// Description of a single data point
class MeasurementDataPoint {
  final int time;
  final double dose;
  MeasurementDataPoint(this.time, this.dose);
}

class MeasurementModel extends ChangeNotifier {
  final List<MeasurementType> _measurements = [];

  // Get a list of currently running measurements
  List<MeasurementType> get measurements => _measurements;
  // Get measurement ids
  List<int> get ids => _measurements.map((measurement) => measurement.id).toList();
  // Get a map of all measurement info
  List get info => _measurements.map((measurement) => measurement.toMap()).toList();

  void addDataPoint(int id, MeasurementDataPoint dp) {
    _measurements[this.ids.indexOf(id)].addDataPoint(dp);
    notifyListeners();
  }
  
  void notify() {
    notifyListeners();
  }

  // Add a measurement
  void add(MeasurementType measurement) {
    _measurements.add(measurement);
    notifyListeners();
  }

  // Adds a new measurement
  int addNew(
      {required String name,
        required int userId,
        required int dosimeterId,
        required int deviceId}) {
    int measurementId = ids.isEmpty ? 1 : ids.reduce(max) + 1;
    _measurements.add(MeasurementType(
      id: measurementId,
      name: name,
      userId: userId,
      dosimeterId: dosimeterId,
      deviceId: deviceId,
      startTime: DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000.0,
      doseData: <MeasurementDataPoint>[],
      // timeData: <double>[],
      totalDose: 0.0),
    );
    return measurementId;
  }

  // Remove measurement
  void remove(MeasurementType measurement) {
    _measurements.remove(measurement);
    notifyListeners();
  }

  MeasurementType getMeasurementFromId(int id) {
   return _measurements[ids.indexOf(id)];
  }

  void update() {
    notifyListeners();
  }
}
