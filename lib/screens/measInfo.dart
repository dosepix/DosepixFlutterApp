// Packages
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:fl_chart/fl_chart.dart';

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
            child: getLineChart2(measurement),
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

LineChart getLineChart2(MeasurementType measurement) {
  List<MeasurementDataPoint> plotData = measurement.doseData.isNotEmpty ?
  measurement.selectTimeRange(60.0) : [
    MeasurementDataPoint(measurement.startTime, 0)
  ];
  List<Color> gradientColors = [Colors.blue.withOpacity(0), Colors.blue];
  LineChartBarData lineData = LineChartBarData(
    spots: plotData.map((dp) =>
      FlSpot(dp.time, dp.dose)
    ).toList(),
    dotData: FlDotData(show: false),
    belowBarData: BarAreaData(
      show: true,
      colors: gradientColors.map(
          (color) => color.withOpacity(0.5)
      ).toList(),
      gradientColorStops: [0.1, 1.0],
    ),
    barWidth: 3,
    isCurved: true,
    isStrokeCapRound: true,
    colors: gradientColors,
    colorStops: [0.1, 1.0],
  );

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
        )
        ),
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) =>
          const TextStyle(color: Color(0xff68737d), fontWeight: FontWeight.bold, fontSize: 15),
          getTitles: (value) {
            if (value.ceil() == value && (value % 5) == 0) {
              return value.roundToDouble().toInt().toString();
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(color: Color(0xff67727d), fontWeight: FontWeight.bold, fontSize: 15),
          getTitles: (value) {
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
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      minY: plotData.map((value) => value.dose).reduce(min).roundToDouble(),
      maxY: plotData.map((value) => value.dose).reduce(max).roundToDouble(),
      minX: plotData.last.time.roundToDouble(),
      maxX: plotData.last.time.roundToDouble() + 60.0,
      lineTouchData: LineTouchData(enabled: false),
      clipData: FlClipData.all(),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 10,
        verticalInterval: 10,
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
    List<MeasurementDataPoint> dps = measurement.doseData.isNotEmpty ?
    measurement.selectTimeRange(60.0) : [MeasurementDataPoint(measurement.startTime, 0)];
    return dps.map((dp) => FlSpot(dp.time, dp.dose)).toList();
  }).toList();

  List<Color> gradientColors = [Colors.blue.withOpacity(0), Colors.blue];
  List<LineChartBarData> lineData = plotData.map((pd) {
    return LineChartBarData(
      spots: pd,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        colors: gradientColors.map(
                (color) => color.withOpacity(0.5)
        ).toList(),
        gradientColorStops: [0.1, 1.0],
      ),
      barWidth: 3,
      isCurved: true,
      isStrokeCapRound: true,
      colors: gradientColors,
      colorStops: [0.1, 1.0],
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
            )
        ),
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) =>
          const TextStyle(color: Color(0xff68737d), fontWeight: FontWeight.bold, fontSize: 15),
          getTitles: (value) {
            if (value.ceil() == value && (value % 5) == 0) {
              return value.roundToDouble().toInt().toString();
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(color: Color(0xff67727d), fontWeight: FontWeight.bold, fontSize: 15),
          getTitles: (value) {
            return value.toString();
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
          margin: 12,
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
