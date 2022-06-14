import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:tuple/tuple.dart';

// Models
import 'package:dosepix/models/measurement.dart';

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

double getDoseInterval(List<MeasurementDataPoint> plotData) {
  double doseInterval;
  if (plotData.isEmpty) {
    doseInterval = 1;
  } else {
    String unit = reformatDose(plotData.first.dose).item2;
    switch (unit) {
      case 'nSv':
        doseInterval = 1.0e-3;
        break;
      case 'mSv':
        doseInterval = 1.0e3;
        break;
      case 'Sv':
        doseInterval = 1.0e6;
        break;
      default:
        doseInterval = 1;
    }

    if ((plotData.first.dose - plotData.last.dose) > 0) {
      doseInterval = (plotData.first.dose - plotData.last.dose) / 5.0;
    }
  }
  return doseInterval;
}

LineChart generateLineChart(
  List<LineChartBarData> lineData,
  double doseInterval,
  double minY,
  double maxY,) {

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
                return SizedBox.shrink();
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
                return SizedBox.shrink();
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
        ),
      ),
      // minY: minY,
      // maxY: maxY,
      // minX: plotData.isEmpty ? 0 : plotData.last.time.roundToDouble(),
      // maxX:
      //     plotData.isEmpty ? 0 : plotData.first.time.roundToDouble(), // + 60.0,
      lineTouchData: LineTouchData(enabled: false),
      clipData: FlClipData.all(),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: doseInterval,
        verticalInterval: 5,
      ),
      lineBarsData: lineData,
    ),
    // Disable animations
    swapAnimationDuration: Duration.zero,
    swapAnimationCurve: Curves.easeOut,
  );
}

LineChart getLineChart(MeasurementType measurement, {bool timeCut = false}) {
  List<MeasurementDataPoint> plotData = measurement.doseData.isNotEmpty
      ? measurement.doseData.reversed.toList()
      : [MeasurementDataPoint(measurement.startTime, 0)];
  if (timeCut) {
    plotData = measurement.selectTimeRange(60.0);
  }

  double doseInterval = getDoseInterval(plotData);
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

  double minY = plotData.isEmpty
          ? 0
          : 0.99 *
              plotData.map((value) => value.dose).reduce(min).roundToDouble();

  double maxY = plotData.isEmpty
          ? 0
          : 1.01 *
              plotData.map((value) => value.dose).reduce(max).roundToDouble();

  return generateLineChart(
      [lineData],
      doseInterval,
      minY,
      maxY
    );
}

LineChart getLineChartCombined(MeasurementModel measurements) {
  List<List<MeasurementDataPoint>> plotData =
      measurements.measurements.map((measurement) {
    List<MeasurementDataPoint> dps = measurement.doseData.isNotEmpty
        ? measurement.selectTimeRange(60.0)
        : [MeasurementDataPoint(measurement.startTime, 0)];
    return dps.map((dp) => MeasurementDataPoint(dp.time, dp.dose)).toList();
  }).toList();

  double doseInterval =
      plotData.map((pd) => getDoseInterval(pd)).reduce(max).roundToDouble();
  List<Color> gradientColors = [Colors.blue.withOpacity(0), Colors.blue];
  List<LineChartBarData> lineData = plotData.map((pd) {
    return LineChartBarData(
      spots: pd.map((dp) => FlSpot(dp.time.toDouble(), dp.dose)).toList(),
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
      isCurved: false,
      isStrokeCapRound: true,
      color: Colors.blue,
    );
  }).toList();

  double minY = plotData.map((pd) => pd.isEmpty ? 1000 : 0.99 * pd.map((dp) => dp.dose).reduce(min).roundToDouble()).reduce(min).roundToDouble();
  double maxY = plotData.map((pd) => pd.isEmpty ? 0 : 1.01 * pd.map((dp) => dp.dose).reduce(max).roundToDouble()).reduce(max).roundToDouble();

  return generateLineChart(
      lineData,
      doseInterval,
      minY,
      maxY
  );
}
