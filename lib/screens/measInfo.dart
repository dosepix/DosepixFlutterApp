// Packages
import 'dart:math';
import 'package:dosepix/models/mode.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:tuple/tuple.dart';

// Models
import 'package:dosepix/models/measurement.dart';
import 'package:dosepix/models/user.dart';

// Database
import 'package:dosepix/database/databaseHandler.dart'
    if (dart.library.html) 'package:dosepix/databaseServer/databaseHandler.dart';

Tuple2<double, String> reformatDose(double dose) {
  if (dose < 1) {
    return Tuple2(dose * 1.0e3, 'nSv');
  } else if (dose >= 1.0e6) {
    return Tuple2(dose / 1.0e6, 'Sv');
  } else if (dose >= 1000) {
    return Tuple2(dose / 1.0e3, 'mSv');
  } else {
    return Tuple2(dose, 'µSv');
  }
}

// Functions for dose units
String getDoseString(double dose) {
  Tuple2 doseRe = reformatDose(dose);
  return doseRe.item1.toStringAsFixed(1) + ' ' + doseRe.item2;
}

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
            child: measurementArgs.arg == MODE_MEASUREMENT
                ? getLineChart2(
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
                      return getLineChart2(databaseMeasurement, timeCut: false);
                    }),
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

String getTitles(double value, double minVal, double maxVal,
    {int spacingNum = 10}) {
  // Calculate spacing
  // TODO: spacing should also depend on number of active plots
  int spacing = (maxVal - minVal).abs() ~/ spacingNum;
  if (spacing == 0) {
    spacing = 1;
  }

  if (value.ceil() == value && ((value - minVal) % spacing) == 0) {
    return value.roundToDouble().toInt().toString();
  }
  return '';
}

LineChart getLineChart2(MeasurementType measurement, {bool timeCut = false}) {
  List<MeasurementDataPoint> plotData = measurement.doseData.isNotEmpty
      ? measurement.doseData.reversed.toList()
      : [MeasurementDataPoint(measurement.startTime, 0)];
  if (timeCut) {
    plotData = measurement.selectTimeRange(60.0);
  }

  double doseInterval = plotData.isEmpty
      ? 1
      : ((plotData.first.dose - plotData.last.dose) > 0
          ? (plotData.first.dose - plotData.last.dose) / 5.0
          : 1);

  List<Color> gradientColors = [Colors.blue.withOpacity(0), Colors.blue];
  Gradient gradient = LinearGradient(
    colors: gradientColors,
    stops: [0.1, 1.0],
  );
  LineChartBarData lineData = LineChartBarData(
    spots: plotData.map((dp) => FlSpot(dp.time.toDouble(), dp.dose)).toList(),
    dotData: FlDotData(show: false),
    belowBarData: BarAreaData(
      show: true,
      color: Colors.blue,
      gradient: gradient,
    ),
    barWidth: 3,
    isCurved: false,
    isStrokeCapRound: true,
    color: Colors.blue,
    gradient: gradient,
  );

  return LineChart(
    LineChartData(
      borderData: FlBorderData(
        show: true,
        border: Border(
            left: BorderSide(
              color: Colors.black.withOpacity(0.6),
            ),
            bottom: BorderSide(
              color: Colors.black.withOpacity(0.6),
            )),
      ),
      titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 22,
              interval: 10,
              getTitlesWidget: (double value, TitleMeta meta) {
                TextStyle textStyle = const TextStyle(
                  color: Color(0xff373d42),
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                );
                // Don't show first and last values
                if ((value == meta.min) || (value == meta.max)) {
                  return Text(
                    "",
                    style: textStyle,
                  );
                }

                String title = (value ~/ 60).toString() +
                    ':' +
                    (value.toInt() % 60).toString();

                return Text(
                  title,
                  style: textStyle,
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: doseInterval,
              getTitlesWidget: (double value, TitleMeta meta) {
                TextStyle textStyle = const TextStyle(
                  color: Color(0xff373d42),
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                );
                // Don't show first and last values
                if ((value == meta.min) || (value == meta.max)) {
                  return Text(
                    "",
                    style: textStyle,
                  );
                }

                Tuple2 d = reformatDose(value);
                double dDose = d.item1;
                String title = dDose.toStringAsFixed(1);
                return Text(
                  title,
                  style: textStyle,
                );
              },
              reservedSize: 50,
            ),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
            ),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
            ),
          )),
      minY: plotData.isEmpty
          ? 0
          : 0.98 *
              plotData.map((value) => value.dose).reduce(min).roundToDouble(),
      maxY: plotData.isEmpty
          ? 0
          : 1.02 *
              plotData.map((value) => value.dose).reduce(max).roundToDouble(),
      minX: plotData.isEmpty ? 0 : plotData.last.time.roundToDouble(),
      maxX:
          plotData.isEmpty ? 0 : plotData.first.time.roundToDouble(), // + 60.0,
      lineTouchData: LineTouchData(enabled: false),
      clipData: FlClipData.all(),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: doseInterval,
        verticalInterval: 5,
      ),
      lineBarsData: [lineData],
    ),
    // Disable animations
    swapAnimationDuration: Duration.zero,
    swapAnimationCurve: Curves.easeOut,
  );
}

LineChart getLineChartCombined(MeasurementModel measurements) {
  List<List<FlSpot>> plotData = measurements.measurements.map((measurement) {
    List<MeasurementDataPoint> dps = measurement.doseData.isNotEmpty
        ? measurement.selectTimeRange(60.0)
        : [MeasurementDataPoint(measurement.startTime, 0)];
    return dps.map((dp) => FlSpot(dp.time.toDouble(), dp.dose)).toList();
  }).toList();

  List<Color> gradientColors = [Colors.blue.withOpacity(0), Colors.blue];
  List<LineChartBarData> lineData = plotData.map((pd) {
    return LineChartBarData(
      spots: pd,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors:
              gradientColors.map((color) => color.withOpacity(0.5)).toList(),
          stops: [0.1, 1.0],
        ),
      ),
      barWidth: 3,
      isCurved: true,
      isStrokeCapRound: true,
    );
  }).toList();

  return LineChart(
    LineChartData(
      borderData: FlBorderData(
        show: true,
        border: Border(
            left: BorderSide(
              color: Colors.black.withOpacity(0.8),
            ),
            bottom: BorderSide(
              color: Colors.black.withOpacity(0.8),
            )),
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 22,
            getTitlesWidget: (double value, TitleMeta meta) {
              if (value.ceil() == value && (value % 5) == 0) {
                return Text(
                  value.roundToDouble().toInt().toString(),
                  style: const TextStyle(
                    color: Color(0xff68737d),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                );
              }
              return Text('');
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (double value, TitleMeta meta) {
              return Text(
                value.toString(),
                style: const TextStyle(
                  color: Color(0xff67727d),
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              );
              /*
              // Calculate spacing
              // TODO: spacing should also depend on number of active plots
              double minVal = plotData.map((value) => value.dose).reduce(min);
              double maxVal = plotData.map((value) => value.dose).reduce(max);
              const int spacingNum = 10;
              int spacing = (maxVal - minVal).abs() ~/ spacingNum;
              if (spacing == 0) {
                spacing = 1;
              }

              if (value.ceil() == value && ((value - minVal) % spacing) == 0) {
                return value.roundToDouble().toInt().toString();
              }
              return '';
               */
            },
            reservedSize: 28,
          ),
        ),
      ),
      // minY: plotData.map((value) => value.dose).reduce(min).roundToDouble(),
      // maxY: plotData.map((value) => value.dose).reduce(max).roundToDouble(),
      // minX: plotData.last.time.roundToDouble(),
      // maxX: plotData.last.time.roundToDouble() + 60.0,
      lineTouchData: LineTouchData(
        enabled: false,
        handleBuiltInTouches: false,
      ),
      clipData: FlClipData.all(),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 10,
        verticalInterval: 10,
      ),
      lineBarsData: lineData,
    ),
    // Disable animations
    swapAnimationDuration: Duration.zero,
    swapAnimationCurve: Curves.easeOut,
  );
}
