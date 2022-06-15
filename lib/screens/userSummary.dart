import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Screens
import 'package:dosepix/screens/measurementSelect.dart';

// Models
import 'package:dosepix/widgets/calendar.dart';
import 'package:dosepix/models/listLayout.dart';
import 'package:dosepix/models/measurementTime.dart';

// Database
import 'package:dosepix/database/databaseHandler.dart' if (dart.library.html) 'package:dosepix/databaseServer/databaseHandler.dart';

class UserSummary extends StatefulWidget {
  const UserSummary({Key? key}) : super(key: key);

  @override
  _UserSummaryState createState() => _UserSummaryState();
}

class _UserSummaryState extends State<UserSummary> {
  Future<MeasurementTimeModel> getMeasuremenentTime(DoseDatabase doseDatabase, int measurementId, int userId) async {
    List<Point> points = await doseDatabase.pointsDao.getPointsOfMeasurementId(measurementId);
    DateTime startTime = DateTime.fromMillisecondsSinceEpoch(points.first.time * 1000);
    DateTime duration = DateTime.fromMillisecondsSinceEpoch((points.first.time - points.last.time) * 1000);
    double totalDose = (points.last.dose - points.first.dose).abs();

    return MeasurementTimeModel(
      measurementId,
      userId,
      startTime,
      duration,
      totalDose,
    );
  }

  Future<Map<DateTime, List<MeasurementTimeModel>>> getAllStartTimes(
    DoseDatabase doseDatabase,
    int userId
    ) async {
    Map<DateTime, List<MeasurementTimeModel>> output = new Map();

    List<Measurement> measurements = await doseDatabase.measurementsDao.getMeasurementsOfUser(userId);
    for (Measurement measurement in measurements) {
      print(measurement);
      MeasurementTimeModel measurementTime;
      try {
        measurementTime = await getMeasuremenentTime(doseDatabase, measurement.id, userId);
      } catch(error) {
        continue;
      }

      DateTime startTime = measurementTime.startTime;
      print(startTime);
      if (output.containsKey(DateUtils.dateOnly(startTime))) {
        output[DateUtils.dateOnly(startTime)]!.add(measurementTime);
      } else {
        output[DateUtils.dateOnly(startTime)] = [
          measurementTime,
        ];
      }
    }
    return output;
  }

  @override
  Widget build(BuildContext context) {
    // Get database
    DoseDatabase doseDatabase = Provider.of<DoseDatabase>(context);
    // Get arguments from call
    final args = ModalRoute.of(context)!.settings.arguments as MeasurementSelectArguments;

    Widget body = Container(
      child: FutureBuilder(
        future: getAllStartTimes(doseDatabase, args.userId),
        builder: (c, AsyncSnapshot<Map<DateTime, List<MeasurementTimeModel>>> snapshot) {
          print(snapshot);
          if (snapshot.hasData) {
            return Calendar(snapshot.data!);
          } else {
            return Container();
          }
        }
      ),
    );

    return getListLayout(
      context,
      'Summary of ' + args.userName,
      "",
      Icons.show_chart,
      SizedBox.shrink(),
      body,
      size: 120,
      iconSize: 50,
      fontSize: 30,
    );
  }
}
