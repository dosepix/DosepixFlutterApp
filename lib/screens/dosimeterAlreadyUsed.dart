/* Shows an alert that the currently selected dosimeter is already in use */
import 'package:flutter/material.dart';

class DosimeterAlreadyUsed extends StatelessWidget {
  const DosimeterAlreadyUsed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text("Warning!"),
        content: Text("Device is already connected to ..."),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        actions: [
          // Dismiss message
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Dismiss"))
        ]
    );
  }
}
