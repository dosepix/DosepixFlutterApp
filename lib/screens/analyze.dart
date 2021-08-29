import 'package:flutter/material.dart';

class Analyze extends StatefulWidget {
  const Analyze({Key? key}) : super(key: key);

  @override
  _AnalyzeState createState() => _AnalyzeState();
}

class _AnalyzeState extends State<Analyze> {
  @override
  Widget build(BuildContext context) {

    // TODO: Menu for user and measurement analysis
    return Scaffold(
     appBar: AppBar(
       title: Text('Analyze'),
     ),
    );
  }
}
