import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Screens
import 'package:dosepix/screens/measurementSelect.dart';

// Database
import 'package:dosepix/database/databaseHandler.dart' if (dart.library.html) 'package:dosepix/databaseServer/databaseHandler.dart';

class UserSummary extends StatefulWidget {
  const UserSummary({Key? key}) : super(key: key);

  @override
  _UserSummaryState createState() => _UserSummaryState();
}

class _UserSummaryState extends State<UserSummary> {
  @override
  Widget build(BuildContext context) {
    // Get database
    DoseDatabase doseDatabase = Provider.of<DoseDatabase>(context);
    // Get arguments from call
    final args = ModalRoute.of(context)!.settings.arguments as MeasurementSelectArguments;

    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder(
          future: doseDatabase.usersDao.getUserById(args.userId),
          builder: (c, AsyncSnapshot<User> snapshot) {
            if (snapshot.data == null) return Text('');
            return Text('Summary of ' + snapshot.data!.userName);
          }
        )
      ),
    );
  }
}

