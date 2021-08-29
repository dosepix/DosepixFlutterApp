import 'package:dosepix/models/mode.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  final List<String> menuOptions = ["Measure", "Analyze"];
  final menuColors = [[Colors.red, Colors.blue], [Colors.green, Colors.blue]];
  final textColors = [Colors.white, Colors.white];

  @override
  Widget build(BuildContext context) {
    List<Expanded> containers = [];
    for(String option in menuOptions) {
      containers.add(
        Expanded(child: Container(
          width: double.infinity,
          margin: EdgeInsets.all(10),
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
                style: TextStyle(
                  color: textColors[menuOptions.indexOf(option)],
                  fontSize: 40,
                )),
            onPressed: () {
              Navigator.pushNamed(
                context,
                // TODO: fix
                option == 'Analyze' ? '/screen/userSelect' : '/screen/' + option.toLowerCase(),
                arguments: ModeArguments(MODE_ANALYZE, '/screen/measurementSelect'),
              );
            },
          ),
        ),
      ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Select mode'),
      ),
      body: Center(
        child: Column(
          children: containers,
        ),
      ),
    );
  }
}
