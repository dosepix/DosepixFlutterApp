import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:dosepix/colors.dart';
import 'package:dosepix/models/mode.dart';
import 'package:dosepix/screens/measurementSelect.dart';
import 'package:dosepix/screens/userCreate/userCreate.dart';

// Models
import 'package:dosepix/models/user.dart';
import 'package:dosepix/models/measurement.dart';
import 'package:dosepix/models/listLayout.dart';

// Database
import 'package:dosepix/database/databaseHandler.dart'
    if (dart.library.html) 'package:dosepix/databaseServer/databaseHandler.dart';

class UserSelect extends StatefulWidget {
  const UserSelect({Key? key}) : super(key: key);

  @override
  _UserSelectState createState() => _UserSelectState();
}

class _UserSelectState extends State<UserSelect> {
  @override
  Widget build(BuildContext context) {
    var activeUsers = context.watch<ActiveUserModel>();
    var measurementCurrent = context.watch<MeasurementCurrent>();

    // Get database
    DoseDatabase doseDatabase = Provider.of<DoseDatabase>(context);

    // Get arguments from call
    final args = ModalRoute.of(context)!.settings.arguments as ModeArguments;

    Widget floatingActionButton = FloatingActionButton.extended(
      label: Text(
        'Add user',
        style: GoogleFonts.nunito(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      icon: Icon(Icons.add),
      tooltip: 'Add new user',
      elevation: 0.0,
      backgroundColor: dosepixColor40,
      extendedPadding: EdgeInsets.all(40),
      onPressed: () {
        // Navigator.pushNamed(context, '/screen/userCreate');
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return UserCreate();
              }
            );
      },
    );

    Widget body = StreamBuilder(
      stream: doseDatabase.usersDao.watchUsers(),
      builder: (c, AsyncSnapshot<List<User>> snapshot) {
        // print(snapshot.data);
        // print(snapshot.connectionState);
        if (snapshot.connectionState == ConnectionState.active &&
            snapshot.hasData &&
            snapshot.data != null) {
          return _buildListViewOfUsers(context, snapshot.data!,
              activeUsers, measurementCurrent, args);
        }
        return Container();
      }
    );

    return WillPopScope(
      // If selection is aborted, reset user for current measurement
      onWillPop: () {
        measurementCurrent.userId = NO_USER;
        return Future.value(true);
      },
      child: getListLayout(
        context,
        "Select",
        " User",
        Icons.account_circle,
        floatingActionButton,
        body
      ),
    );
  }

  ListView _buildListViewOfUsers(
      BuildContext context,
      List<User> users,
      ActiveUserModel activeUsers,
      MeasurementCurrent current,
      ModeArguments args) {
    List<Widget> tiles = <Widget>[];

    // Existing users
    for (User user in users) {
      tiles.add(ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: EdgeInsets.only(
          left: 30,
          right: 30,
          top: 10,
          bottom: 10,
        ),
        tileColor: dosepixColor10,
        textColor: Color.fromRGBO(88, 88, 88, 1.0),
        title: Text(
          user.userName,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 20.0,
          ),
        ),
        subtitle: Text(user.fullName),
        trailing: Icon(Icons.keyboard_arrow_right),
        onTap: () {
          // TODO: Check if already added!
          activeUsers.add(user);
          current.userId = user.id;

          if (args.arg == MODE_ANALYZE) {
            MeasurementSelectArguments arguments = MeasurementSelectArguments(
              MODE_ANALYZE,
              '/screen/measInfo',
              user.id,
              user.userName,
            );
            Navigator.pushNamed(
              context,
              '/screen/userSummary',
              arguments: arguments,
            );
          } else {
            // Measure mode
            ModeArguments arguments = ModeArguments(MODE_MEASUREMENT, 'POP');
            Navigator.pushNamed(
              context,
              '/screen/dosimeterSelect',
              arguments: arguments,
            );
          }
        },
      ),
      );
      tiles.add(
        const SizedBox(
          height: 15,
        ),
      );
    }

    // Combine to ListView
    return ListView(
      padding: const EdgeInsets.only(
        left: 50,
        right: 50,
        top: 10,
        bottom: 10,
      ),
      children: <Widget>[
        ...tiles,
      ],
    );
  }
}
