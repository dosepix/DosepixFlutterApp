import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  final List<String> menuOptions = ["Measure", "Analyze"];
  final menuColors = [[Colors.red, Colors.blue], [Colors.green, Colors.blue]];
  final textColors = [Colors.white, Colors.white];

  @override
  Widget build(BuildContext context) {
    List<Container> containers = [];
    for(String option in menuOptions) {
      containers.add(
        Container(
        margin: EdgeInsets.all(10),
        width: 200,
        height: 50,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: menuColors[menuOptions.indexOf(option)],
            begin: FractionalOffset.centerLeft,
            end: FractionalOffset.centerRight,
          ),
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(18.0),
        ),
        child: TextButton(
          child: Text(option,
              style: TextStyle(color: textColors[menuOptions.indexOf(option)])),
          onPressed: () {},
        ),
      ),
      );
    }

    return Scaffold(
      body: Center(
        child: Column(
          children: containers,
        ),
      ),
    );
  }
}
