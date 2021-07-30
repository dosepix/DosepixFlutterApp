import 'package:flutter/material.dart';

class BluetoothOff extends StatelessWidget {
  BluetoothOff({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Bluetooth status"),
      content: Text("Please turn on bluetooth and try again"),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      actions: [
        TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text("OK"))
      ]
    );
  }
}

