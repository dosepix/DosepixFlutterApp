import 'dart:math';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'navigationDrawer/navigationDrawer.dart';
import 'package:dosepix/colors.dart';
import 'package:dosepix/database/databaseHandler.dart'
    if (dart.library.html) 'package:dosepix/databaseServer/databaseHandler.dart';

// Models
import 'package:dosepix/models/user.dart';
import 'package:dosepix/models/dosimeter.dart';
import 'package:dosepix/models/measurement.dart';
import 'package:dosepix/models/bluetooth.dart';

// Screens
import 'package:dosepix/screens/home.dart';
import 'package:dosepix/screens/measure.dart';
import 'package:dosepix/screens/analyze.dart';
import 'package:dosepix/screens/measInfo.dart';
import 'package:dosepix/screens/userSummary.dart';
import 'package:dosepix/screens/dosimeterSelect.dart';
import 'package:dosepix/screens/measurementSelect.dart';
import 'package:dosepix/screens/userSelect.dart';
import 'package:dosepix/screens/userCreate/userCreate.dart';
import 'package:dosepix/screens/instructions.dart';

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

  // Model to store current measurement data
  final MeasurementCurrent measurementCurrent = MeasurementCurrent(
    userId: NO_USER,
    dosimeterId: NO_DOSIMETER,
    deviceId: NO_DEVICE,
  );

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

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
        Provider<DoseDatabase>(
          create: (context) => DoseDatabase(),
        ),
      ],
      child: MaterialApp(
        title: widget.appTitle,
        home: MainPage(title: "Title"),
        theme: _buildTheme(),
        routes: {
          '/screen/measure': (context) => Measure(),
          '/screen/analyze': (context) => Analyze(),
          '/screen/dosimeterSelect': (context) => DosimeterSelect(),
          '/screen/measurementSelect': (context) => MeasurementSelect(),
          '/screen/userSelect': (context) => UserSelect(),
          '/screen/userCreate': (context) => UserCreate(),
          '/screen/measInfo': (context) => MeasInfo(),
          '/screen/userSummary': (context) => UserSummary(),
          '/screen/instructions': (context) => Instructions(),
        },
      ),
    );
  }
}

ThemeData _buildTheme() {
  var baseTheme = ThemeData();
  return baseTheme.copyWith(
    textTheme: GoogleFonts.nunitoTextTheme(baseTheme.textTheme),
    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(
        color: dosepixColor50,
      ),
      titleTextStyle: TextStyle(
        color: dosepixColor50,
        fontSize: 20,
      ),
    ),
  );
}

class MainPage extends StatefulWidget {
  final String title;
  const MainPage({Key? key, required this.title}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Dummy read to load database
    if (!kIsWeb) {
      Provider.of<DoseDatabase>(context).usersDao.getUserById(0).then((t) {
        print(t);
      });
      Provider.of<DoseDatabase>(context).pointsDao.getPoints().then((t) {
        print(t);
      });
      Provider.of<DoseDatabase>(context)
          .measurementsDao
          .getMeasurements()
          .then((t) {
        print(t);
      });
    }

    return Home();
  }
}
