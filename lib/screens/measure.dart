import 'package:dosepix/models/dosimeter.dart';
import 'package:dosepix/models/mode.dart';
import 'package:dosepix/screens/measInfo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:fl_chart/fl_chart.dart';

// Models
import 'package:dosepix/models/user.dart';
import 'package:dosepix/models/measurement.dart';
import 'package:dosepix/models/bluetooth.dart';

// Screens
import 'package:dosepix/screens/bluetoothOff.dart';

// Database
import 'package:dosepix/database/databaseHandler.dart' if (dart.library.html) 'package:dosepix/databaseServer/databaseHandler.dart';

// TODO
// - Once a single measurement is started, add button in AppBar
//   to stop all measurements

class Measure extends StatefulWidget {
  Measure({Key? key}) : super(key: key);
  final bool bluetoothOn = true;
  bool singlePlot = false;

  @override
  _MeasureState createState() => _MeasureState();
}

class _MeasureState extends State<Measure> {
  @override
  Widget build(BuildContext context) {
    // Watched variables
    var activeUsers = context.watch<ActiveUserModel>();
    var measurements = context.watch<MeasurementModel>();
    var bluetooth = context.watch<BluetoothModel>();
    var measurementCurrent = context.watch<MeasurementCurrent>();

    // Get database
    DoseDatabase doseDatabase = Provider.of<DoseDatabase>(context);

    // Is executed when measurementCurrent is changed
    if (measurementCurrent.userId != NO_USER &&
        measurementCurrent.dosimeterId != NO_DOSIMETER &&
        measurementCurrent.deviceId != NO_DEVICE) {

      // Create new measurement
      // Internal representation to handle connection
      int measurementId = measurements.addNew(
        name: "",
        userId: measurementCurrent.userId,
        dosimeterId: measurementCurrent.dosimeterId,
        deviceId: measurementCurrent.deviceId,
      );

      // SQL to store acquired data
      MeasurementsCompanion measSQL = MeasurementsCompanion.insert(
        name: "",
        userId: measurementCurrent.userId,
        dosimeterId: measurementCurrent.dosimeterId,
        totalDose: 0,
      );

      doseDatabase.measurementsDao.insertReturningMeasurement(measSQL).then((measQuery)
      {
        // Listen to stream
        Function call = (MeasurementDataPoint dp) {
          // Update SQL points
          doseDatabase.pointsDao.insertPoint(
              PointsCompanion.insert(
                measurementId: measQuery.id,
                time: dp.time,
                dose: dp.dose,
              )
          );

          // Update totalDose of SQL measurement
          doseDatabase.measurementsDao.updateMeasurement(
              measQuery.copyWith(
                  totalDose: measurements.getMeasurementFromId(measurementId).totalDose));

          // Use for plots
          measurements.addDataPoint(measurementId, dp);
        };

        // Subscribe measurement to device
        bluetooth.addSubscription(
            measurements.getMeasurementFromId(measurementId).deviceId,
            call);
      });

      // Reset, so next measurement can be started
      measurementCurrent.userId = NO_USER;
      measurementCurrent.dosimeterId = NO_DOSIMETER;
      measurementCurrent.deviceId = NO_DEVICE;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Measure Dose"),
        actions: [
          IconButton(
            onPressed: () {showDialog(
                context: context,
                builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Stop all measurement?"),
                  content: Text("Do you really want to stop all measurements?"),
                actions: [
                  // Stop measurement and clear
                  TextButton(onPressed: () {
                    for(MeasurementType measurement in measurements.measurements) {
                      // Disconnect device
                      bluetooth.disconnectAndRemove(
                          bluetooth.getDeviceById(measurement.deviceId));
                      // Remove measurement
                      measurements.remove(measurement);
                      Navigator.pop(context);
                    }
                      },
                    child: Text("OK")),
                  TextButton(onPressed: () {
                    Navigator.pop(context);
                  }, child: Text("CANCEL")),
                ]);
              });
            },
            icon: const Icon(Icons.delete)),
          IconButton(
            onPressed: () {setState(() {
              widget.singlePlot = !widget.singlePlot;
            });
            },
            icon: const Icon(Icons.expand)
          ),
        ],
      ),
      body: Center(
      child: Column(
      children: widget.singlePlot ?
        getUserButtonsSingle(context, measurements, activeUsers, bluetooth) :
        getUserButtons(context, doseDatabase, measurements, activeUsers, bluetooth),
        ),
      ),
    );
  }

  // Box decoration for buttons
  BoxDecoration getBoxDeco(List<Color> menuColors) {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: menuColors,
        begin: FractionalOffset.centerLeft,
        end: FractionalOffset.centerRight,
      ),
      borderRadius: BorderRadius.circular(18.0),
    );
  }

  List<Expanded> getUserButtonsSingle(BuildContext context,
      MeasurementModel measurements, ActiveUserModel activeUsers,
      BluetoothModel bluetooth) {

    LineChart plot = getLineChartCombined(measurements);

    List<Expanded> containers = [];
    containers.add(
      Expanded(
        flex: 8,
        child: Container(
          child: plot,
        ),
      ),
    );

    containers.add(
      getAddUserButton(context, bluetooth),
    );

    return containers;
  }

  // Create containers containing buttons of active users;
  List<Expanded> getUserButtons(BuildContext context,
      DoseDatabase doseDatabase,
      MeasurementModel measurements, ActiveUserModel activeUsers,
      BluetoothModel bluetooth) {
    List<Expanded> containers = [];

    // Loop over measurements
    if (measurements.measurements.isNotEmpty) {
      for (MeasurementType measurement in measurements.measurements) {
        // Scale units
        String unit = measurement.totalDose < 1000 ? ' uSv' : ' mSv';
        double totalDoseUnit = measurement.totalDose < 1000 ? measurement
            .totalDose : measurement.totalDose / 1000.0;

        LineChart plot = getLineChart2(measurement, timeCut: true);
        // charts.LineChart plot = getLineChart(measurement);
        containers.add(
          Expanded(
            flex: 3,
            child: GestureDetector(
              onTap: () {
                // Show details about measurement
                Navigator.pushNamed(
                  context,
                  '/screen/measInfo',
                  arguments: MeasurementInfoArguments(
                      MODE_MEASUREMENT, 'POP', measurement.id, measurement.userId));
              },
              onLongPress: () {
                // Open dialog and ask to stop measurement
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Stop measurement?"),
                      content: Text("Do you want to stop the measurement for user " +
                          activeUsers.getUserFromId(measurement.userId).userName.toString()
                      ),
                      actions: [
                        // Stop measurement and clear
                        TextButton(onPressed: () {
                          // Disconnect device
                          bluetooth.disconnectAndRemove(
                              bluetooth.getDeviceById(measurement.deviceId));
                          // Remove active user
                          // activeUsers.remove(activeUsers.getUserFromId(
                          //     measurement.userId));
                          // Remove measurement
                          measurements.remove(measurement);

                          Navigator.pop(context);
                          }, child: Text("OK")),
                        TextButton(onPressed: () {
                          Navigator.pop(context);
                        }, child: Text("CANCEL")),
                      ],
                    );
                  }
                );
              },
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.blue,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    )
                ),
                child: Stack(
                  children: [
                    plot,
                    // Show Username in top right corner
                    Container(
                      alignment: Alignment.topRight,
                      child: Text(
                          activeUsers.users[activeUsers.ids.indexOf(
                          measurement.userId)].userName),
                    ),
                    Container(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        totalDoseUnit.toStringAsFixed(2) + unit,
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }
    }

    containers.add(
      getAddUserButton(context, bluetooth),
    );
    return containers;
  }

  Expanded getAddUserButton(context, BluetoothModel bluetooth) {
    // Add Add-new button
    return Expanded(
        flex: 1,
        child:
        Container(
          margin: EdgeInsets.all(10),
          width: double.infinity,
          child: OutlinedButton.icon(
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(0.0),
              backgroundColor: MaterialStateProperty.all(Colors.transparent),
              side: MaterialStateProperty.all(
                BorderSide(
                  color: Colors.blue,
                  width: 3,
                  style: BorderStyle.solid,
                ),
              ),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
            ),
            label: Text("Add measurement", style: TextStyle(
              fontSize: 20.0,
            )),
            icon: const Icon(
                Icons.add_circle_outline,
              size: 30.0,
            ),
            // Add new active user
            onPressed: () {
              bluetooth.isBluetoothOn().then((result) {
                // if(!bluetooth.isBluetoothOn()) {
                if (!result) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return BluetoothOff();
                      });
                  print('BT is off!');
                } else {
                  Navigator.pushNamed(
                    context,
                    '/screen/userSelect',
                    arguments: ModeArguments(MODE_MEASUREMENT, '/screen/dosimeterSelect'),
                  );
                }
              });
            },
          ),
        ),
    );
  }
}
