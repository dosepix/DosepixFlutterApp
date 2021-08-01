// Packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;

// Models
import 'package:dosepix/models/measurement.dart';
import 'package:dosepix/models/user.dart';

class MeasurementInfoArguments {
  final int id;
  MeasurementInfoArguments(this.id);
}

class MeasInfo extends StatelessWidget {
  const MeasInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var measurements = context.watch<MeasurementModel>();
    var users = context.watch<UserModel>();

    // Get measurementId from push
    final measurementArgs = ModalRoute.of(context)!.settings.arguments as MeasurementInfoArguments;

    // Get measurement
    MeasurementType measurement = measurements.getMeasurementFromId(measurementArgs.id);

    // Get user
    UserType user = users.getUserFromId(measurement.userId);

    // Total dose
    String unit = measurement.totalDose < 1000 ? ' uSv' : ' mSv';
    double totalDoseUnit = measurement.totalDose < 1000 ? measurement
        .totalDose : measurement.totalDose / 1000.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(user.userName),
      ),
      body: Column(
        children: [
          Expanded(
            child: getLineChart(measurement),
            flex: 5,
          ),
          Expanded(child:
            Row(
              children: [
                // Total dose
                Expanded(child:
                  Container(child:
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Column(
                        // Top label, bottom value
                        children: <Widget>[
                          Text(
                            "Total dose:",
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 30.0),
                          ),
                          Text(
                            totalDoseUnit.toStringAsFixed(2) + unit,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 60.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Total dose
                Expanded(child:
                  Container(child:
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Column(
                        // Top label, bottom value
                        children: <Widget>[
                          Text(
                            "Total dose:",
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 30.0),
                          ),
                          Text(
                            totalDoseUnit.toStringAsFixed(2) + unit,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 60.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          ),
        ],
      ),
    );
  }
}

// Create a line chart from the data stored in measurement
charts.LineChart getLineChart(MeasurementType measurement) {
  // Construct plot
  List<MeasurementDataPoint> plotData = measurement.doseData.isNotEmpty ?
  measurement.selectTimeRange(60.0) : [
    MeasurementDataPoint(measurement.startTime, 0)
  ];

  return charts.LineChart(
    [charts.Series<MeasurementDataPoint, double>(
      id: measurement.id.toString(),
      domainFn: (MeasurementDataPoint dp, _) => dp.time,
      measureFn: (MeasurementDataPoint dp, _) => dp.dose,
      data: plotData,
    )
    ],
    animate: false,
    primaryMeasureAxis: charts.NumericAxisSpec(
      tickProviderSpec: charts.BasicNumericTickProviderSpec(
          desiredTickCount: 5,
          desiredMinTickCount: 5,
          desiredMaxTickCount: 5,
          zeroBound: false
      ),
    ),
    secondaryMeasureAxis: charts.NumericAxisSpec(
      tickProviderSpec: charts.BasicNumericTickProviderSpec(
          desiredTickCount: 10,
          desiredMinTickCount: 10,
          desiredMaxTickCount: 10,
          zeroBound: false
      ),
    ),
    domainAxis: charts.NumericAxisSpec(
      viewport: charts.NumericExtents(
          plotData.last.time, plotData.last.time + 60.0),
    ),
    defaultInteractions: false,
  );
}
