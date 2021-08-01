import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:provider/provider.dart';
import 'navigationDrawer/navigationDrawer.dart';

// Models
import 'package:dosepix/models/user.dart';
import 'package:dosepix/models/dosimeter.dart';
import 'package:dosepix/models/measurement.dart';
import 'package:dosepix/models/bluetooth.dart';

// Screens
import 'screens/home.dart';
import 'screens/measure.dart';
import 'screens/measInfo.dart';

import 'package:dosepix/screens/dosimeterSelect.dart';
import 'package:dosepix/screens/userSelect.dart';
import 'package:dosepix/screens/userCreate.dart';

void main() => runApp(MyApp());

/* === FUNCTIONS === */
int randomNum(min, max) {
  var rn = new Random();
  return min + rn.nextInt(max - min);
}

/* === WIDGETS === */
class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);
  final appTitle = "Dosepix demo";

  // Instantiate models here to initialize them
  final UserModel userModel = UserModel();

  // Model to store current measurement data
  final MeasurementCurrent measurementCurrent =
    MeasurementCurrent(
      userId: NO_USER,
      dosimeterId: NO_DOSIMETER,
      deviceId: NO_DEVICE,
    );

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override void initState() {
    super.initState();

    // TODO: Load data from a database
    widget.userModel.addNew(fullName: "Flori Beißer", userName: "DerAlteKrieger", email: "test.mail");
    widget.userModel.addNew(fullName: "Flori Beißer", userName: "DerAlteKrieger2", email: "test.mail");

    // Disconnect already connected dosimeters
    FlutterBlue.instance.connectedDevices.then((devices) {
      for (BluetoothDevice device in devices) {
        device.disconnect();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserModel>(
          create: (context) => widget.userModel,
        ),
        ChangeNotifierProvider<ActiveUserModel>(
          create: (context) => ActiveUserModel(),
        ),
        ChangeNotifierProvider<ActiveDosimeterModel>(
          create: (context) => ActiveDosimeterModel(),
        ),
        ChangeNotifierProvider<MeasurementModel>(
          create: (context) => MeasurementModel(),
        ),
        ChangeNotifierProvider<BluetoothModel>(
          create: (context) => BluetoothModel(),
        ),
        ChangeNotifierProvider<DosimeterModel>(
          create: (context) => DosimeterModel(),
        ),
        ChangeNotifierProvider<MeasurementCurrent>(
          create: (context) => widget.measurementCurrent,
        ),
      ],
      child: MaterialApp(
        title: widget.appTitle,
        home: MainPage(title: "Title"),
        routes: {
          '/screen/measure': (context) => Measure(),
          '/screen/dosimeterSelect': (context) => DosimeterSelect(),
          '/screen/userSelect': (context) => UserSelect(),
          '/screen/userCreate': (context) => UserCreate(),
          '/screen/measInfo': (context) => MeasInfo(),
        },
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  final String title;
  const MainPage({Key? key, required this.title}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    // return Home();
    return Measure();

    /*
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: NavigationDrawer(title: "Drawer"),
      body: Center(child: Text("Body test")),
    );
     */
  }
}
