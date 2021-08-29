import 'package:flutter/foundation.dart';

@immutable
class DoseType {
  final int id;
  final int userId;
  final int idDosimeter;
  final List<double> doseData;
  final List<double> timeData;

  DoseType(
      this.id,
      this.userId,
      this.idDosimeter,
      this.doseData,
      this.timeData,
      );
}

class DoseModel extends ChangeNotifier {
  final List<DoseType> _doses = [];

  List<DoseType> get doses => _doses;

  double getTotalDose(DoseType dose) {
    return dose.doseData.fold(0, (p, c) => p + c);
  }

  double getDoseRate(dose) {
    var totalDose = dose.doseData.fold(0, (p, c) => p + c);
    var totalTime = dose.timeData.fold(0, (p, c) => p + c);
    return totalDose / totalTime;
  }

  void add(DoseType dose) {
    _doses.add(dose);
    notifyListeners();
  }

  void remove(DoseType dose) {
    _doses.remove(dose);
    notifyListeners();
  }
}
