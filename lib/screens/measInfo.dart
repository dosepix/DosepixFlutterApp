// Packages
import 'package:dosepix/models/mode.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Models
import 'package:dosepix/models/measurement.dart';
import 'package:dosepix/models/user.dart';
import 'package:dosepix/models/linechart.dart';

// Database
import 'package:dosepix/database/databaseHandler.dart'
    if (dart.library.html) 'package:dosepix/databaseServer/databaseHandler.dart';

class MeasurementInfoArguments extends ModeArguments {
  final int measurementId;
  final int userId;
  MeasurementInfoArguments(args, next, this.measurementId, this.userId)
      : super(args, next);
}

class MeasInfo extends StatelessWidget {
  const MeasInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var measurements = context.watch<MeasurementModel>();
    var users = context.watch<ActiveUserModel>();

    // Get database
    DoseDatabase doseDatabase = Provider.of<DoseDatabase>(context);

    // Get measurementId from push
    final measurementArgs =
        ModalRoute.of(context)!.settings.arguments as MeasurementInfoArguments;

    return Scaffold(
      appBar: AppBar(
        title: measurementArgs.arg == MODE_MEASUREMENT
            ? Text(users.getUserFromId(measurementArgs.userId).userName)
            : FutureBuilder(
                future:
                    doseDatabase.usersDao.getUserById(measurementArgs.userId),
                builder: (c, AsyncSnapshot<User> snapshot) {
                  if (snapshot.data == null) {
                    return Text('');
                  } else {
                    return Text(snapshot.data!.userName);
                  }
                }),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.only(
                top: 5,
                bottom: 5,
                left: 30,
                right: 30,
              ),
              child: measurementArgs.arg == MODE_MEASUREMENT
                  ? getLineChart(
                      measurements
                          .getMeasurementFromId(measurementArgs.measurementId),
                      timeCut: true)
                  : StreamBuilder(
                      stream: doseDatabase.pointsDao
                          .loadDataPointsOfMeasurementId(
                              measurementArgs.measurementId),
                      builder: (c,
                          AsyncSnapshot<List<MeasurementDataPoint>> snapshot) {
                        if (snapshot.data == null) {
                          return Container();
                        }
                        MeasurementType databaseMeasurement = MeasurementType(
                            id: measurementArgs.measurementId,
                            name: 'None',
                            userId: measurementArgs.userId,
                            dosimeterId: -1,
                            deviceId: -1,
                            startTime: snapshot.data!.first.time,
                            doseData: snapshot.data!,
                            totalDose: -1);
                        return getLineChart(databaseMeasurement, timeCut: false);
                      }
                    ),
            ),
            flex: 5,
          ),
          Expanded(
              child: Row(
            children: [
              // Total dose
              Expanded(
                child: Container(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Column(
                      // Top label, bottom value
                      children: <Widget>[
                        Text(
                          "Total dose:",
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 30.0),
                        ),
                        measurementArgs.arg == MODE_MEASUREMENT
                            ? Text(
                                getDoseString(measurements
                                    .getMeasurementFromId(
                                        measurementArgs.measurementId)
                                    .totalDose),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 60.0),
                              )
                            : FutureBuilder(
                                future: doseDatabase.measurementsDao
                                    .getMeasurementsOfId(
                                        measurementArgs.measurementId),
                                builder:
                                    (c, AsyncSnapshot<Measurement> snapshot) {
                                  if (snapshot.data == null) {
                                    return Text('');
                                  }
                                  return Text(
                                    getDoseString(snapshot.data!.totalDose),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 60.0),
                                  );
                                }),
                      ],
                    ),
                  ),
                ),
              ),
              // Total dose
              Expanded(
                child: Container(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Column(
                      // Top label, bottom value
                      children: <Widget>[
                        Text(
                          "Total dose:",
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 30.0),
                        ),
                        Text(''),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }
}
