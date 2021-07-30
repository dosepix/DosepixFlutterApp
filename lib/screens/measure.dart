import 'package:dosepix/screens/dosimeterSelect.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_blue/flutter_blue.dart';

// Models
import 'package:dosepix/models/user.dart';
import 'package:dosepix/models/dosimeter.dart';

// Screens
import 'package:dosepix/screens/bluetoothOff.dart';

// TODO
// - Once a single measurement is started, add button in AppBar
//   to stop all measurements

class Measure extends StatelessWidget {
  const Measure({Key? key}) : super(key: key);
  final bool bluetoothOn = true;

  @override
  Widget build(BuildContext context) {
    // Currently active users
    var activeUsers = context.watch<ActiveUserModel>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Measure Dose"),
      ),
      body: Center(
        child: Column(
          children: getUserButtons(context, activeUsers),
        ),
      ),
    );
  }

  // Box decoration for buttons
  BoxDecoration getBoxDeco(List<Color> menuColors) {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: menuColors,
        begin: FractionalOffset.centerLeft,
        end: FractionalOffset.centerRight,
      ),
      borderRadius: BorderRadius.circular(18.0),
    );
  }

  // Create containers containing buttons of active users;
  List<Expanded> getUserButtons(BuildContext context, ActiveUserModel activeUsers) {
    List<Expanded> containers = [];
    if (activeUsers.users.isNotEmpty) {
      for (UserType user in activeUsers.users) {
        containers.add(
           Expanded(
             child: Container(
               padding: EdgeInsets.all(8),
               decoration: BoxDecoration(
                 border: Border.all(
                   color: Colors.blue,
                 ),
                 borderRadius: BorderRadius.all(
                   Radius.circular(10.0),
                 )
               ),
               child: GestureDetector(
                 onTap: () {},
                 onLongPress: () {},
                 child: SfCartesianChart(),
               ),
             ),
           ),
          /*
          Expanded(
            child:
          Container(
            margin: EdgeInsets.all(10),
            width: 200,
            height: 50,
            decoration: getBoxDeco([Colors.red, Colors.blue]),
            child: TextButton(
              child: Text(user.userName,
                  style: TextStyle(
                      color: Colors.white)),
              // Short tap: show detailed information for user
              onPressed: () {

              },
              // Long tap: show dialog to stop measurement
              onLongPress: () {

              },
            ),
          ),
        ),
           */
        );
      }
    }

    // Add Add-new button
    containers.add(
      Expanded(
        child:
        Container(
          margin: EdgeInsets.all(10),
          width: double.infinity,
          child: OutlinedButton.icon(
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(0.0),
              backgroundColor: MaterialStateProperty.all(Colors.transparent),
              side: MaterialStateProperty.all(
                BorderSide(
                  color: Colors.blue,
                  width: 3,
                  style: BorderStyle.solid,
                ),
              ),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
            ),
            label: Text("Add user", style: TextStyle(
              fontSize: 20.0,
            )),
            icon: const Icon(
                Icons.add_circle_outline,
              size: 30.0,
            ),
            // Add new active user
            onPressed: () {
              if(!this.bluetoothOn) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return BluetoothOff();
                    });
              } else {
                Navigator.pushNamed(
                    context,
                    '/screen/dosimeterSelect'
                );
              }
            }
          ),
        ),
          ),
    );
    return containers;
  }
}
