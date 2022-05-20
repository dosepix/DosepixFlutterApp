import 'dart:async';

import 'package:dosepix/navigationDrawer/navigationDrawer.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:charts_flutter/flutter.dart' as charts;

class MeasurePage extends StatefulWidget {
  static const String routeName = '/measurePage';
  const MeasurePage({Key? key}) : super(key: key);

  @override
  _MeasurePageState createState() => _MeasurePageState();
}

class _MeasurePageState extends State<MeasurePage> {
  int roll = 0;
  int bins = 100;
  var hist = List<int>.generate(6, (index) => 0);
  final histTemp = List<int>.generate(6, (index) => 0);
  bool timerRunning = false;

  void _increment(int index) {
    histTemp[index]++;
  }

  void _updateHist() {
    print("Updating hist");
    setState(() {
      hist = List.from(histTemp);
      timerRunning = false;
    });
  }

  void _startTimer() {
    Timer(
        Duration(seconds: 3), _updateHist
    );
    timerRunning = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Measure"),
      ),
      drawer: NavigationDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(child: ToTHist(bins: bins)),
            /*
            Expanded(child: DiceRoll(
              callback: (int r) {
                setState(() => roll = r);
                _increment(roll - 1);
                if (!timerRunning) {
                  _startTimer();
                }
              },
            )),*/
            Expanded(child: ToTHistFill(
              callback: () {
              },
            ))
          ],
        )
      )
    );
  }
}

int randomNum(min, max) {
  var rn = new Random();
  return min + rn.nextInt(max - min);
}

int randomRejection() {
  var rn = new Random();

  double f(x) {
    return (x - 100)^2;
  }

  var y = 1;
  var x = 0;
  while (f(x) > y) {
    x = rn.nextInt(300);
  }

  return x;
}

class DiceRoll extends StatelessWidget {
  final Function(int) callback;
  final hist = List<int>.generate(6, (index) => 0);
  DiceRoll({Key? key, required this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          children: [
            OutlinedButton(onPressed: () {
              int lastRoll = randomNum(1, 6 + 1);
              callback(lastRoll);
              // _increment(rolled - 1);
              print(lastRoll.toString());
              },
                child: const Text("Roll dice")),
            OutlinedButton(onPressed: () {
              print(hist);
            }, child: const Text("Reset"))
          ],
        ),
      ),
    );
  }
}

class DiceStats {
  final String eyes;
  final int rolls;
  final charts.Color color;

  DiceStats(this.eyes, this.rolls, Color color)
    : this.color = new charts.Color(
    r: color.red, g: color.green, b: color.blue, a: color.alpha);
}

class HistChart extends StatelessWidget {
  final hist;
  const HistChart({Key? key, required this.hist}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var data = [
      DiceStats(1.toString(), hist[0], Colors.blue),
      DiceStats(2.toString(), hist[1], Colors.blue),
      DiceStats(3.toString(), hist[2], Colors.blue),
      DiceStats(4.toString(), hist[3], Colors.blue),
      DiceStats(5.toString(), hist[4], Colors.blue),
      DiceStats(6.toString(), hist[5], Colors.blue),
    ];

    var series = [
      charts.Series(
        domainFn: (DiceStats data, _) => data.eyes,
        measureFn: (DiceStats data, _) => data.rolls,
        colorFn: (DiceStats data, _) => data.color,
        id: "Dice rolls",
        data: data,
      )
    ];

    var chart = charts.BarChart(
      series,
      animate: true,
    );

    return chart;
  }
}

// === ToT SPECTRUM ===
class ToTStats {
  final String ToT;
  final int events;
  final charts.Color color;

  ToTStats(this.ToT, this.events, Color color)
      : this.color = new charts.Color(
      r: color.red, g: color.green, b: color.blue, a: color.alpha);
}

class ToTHist extends StatelessWidget {
  var bins;
  ToTHist({Key? key, required this.bins}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var spectrum = initData(bins, Colors.blue);

    var series = [
      charts.Series(
        domainFn: (ToTStats data, _) => data.ToT,
        measureFn: (ToTStats data, _) => data.events,
        colorFn: (ToTStats data, _) => data.color,
        id: "ToT spectrum",
        data: spectrum,
      )
    ];

    var chart = charts.BarChart(
      series,
      animate: true,
    );

    return chart;
  }

  List<ToTStats> initData(int bins, Color color) {
    List<ToTStats> data = [];
    for(int idx = 0; idx < bins; idx++) {
      data.add(ToTStats((idx + 1).toString(), 0, color));
    }
    return data;
  }
}

class ToTHistFill extends StatefulWidget {
  final Function() callback;
  final binsController = TextEditingController(text: 100.toString());
  ToTHistFill({Key? key, required this.callback}) : super(key: key);

  @override
  _ToTHistFillState createState() => _ToTHistFillState();
}

class _ToTHistFillState extends State<ToTHistFill> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Row(
          children: [
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Bins',
                hintText: 'Insert number of bins here',
              ),
              keyboardType: TextInputType.number,
              autofocus: false,
              controller: widget.binsController,
            ),
            OutlinedButton(onPressed: () {

            }, child: const Text("Start")),
          ],
        ),
      ),
    );
  }
}
