import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'navigationDrawer/navigationDrawer.dart';

// Models
import 'package:dosepix/models/user.dart';
import 'package:dosepix/models/dosimeter.dart';
import 'package:dosepix/models/measurement.dart';

// Screens
import 'screens/home.dart';
import 'screens/measure.dart';

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
  final UserModel userModel = UserModel();

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override void initState() {
    super.initState();

    // TODO: Load data from a database
    widget.userModel.addNew(fullName: "Flori Beißer", userName: "DerAlteKrierger", email: "test.mail");
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
      ],
      child: MaterialApp(
        title: widget.appTitle,
        home: MainPage(title: "Title"),
        routes: {
          '/screen/dosimeterSelect': (context) => DosimeterSelect(),
          '/screen/userSelect': (context) => UserSelect(),
          '/screen/userCreate': (context) => UserCreate(),
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
