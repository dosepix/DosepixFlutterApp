import 'package:flutter/material.dart';
import 'dart:math';

class DataStream extends StatelessWidget {
  DataStream({Key? key}) : super(key: key);
  final Random _random = Random();
  final _stop = false;

  Stream<double> randomDose(Duration interval) async* {
    while(!_stop) {
      await Future.delayed(interval);
      yield _random.nextDouble() * 10.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
