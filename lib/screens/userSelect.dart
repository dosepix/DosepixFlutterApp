import 'package:dosepix/models/mode.dart';
import 'package:dosepix/screens/measurementSelect.dart';
import 'package:dosepix/screens/userCreate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Models
import 'package:dosepix/models/user.dart';
import 'package:dosepix/models/measurement.dart';

// Database
import 'package:dosepix/database/databaseHandler.dart' if (dart.library.html) 'package:dosepix/databaseServer/databaseHandler.dart';

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

    return WillPopScope(
      // If selection is aborted, reset user for current measurement
      onWillPop: () {
        measurementCurrent.userId = NO_USER;
        return Future.value(true);
      },
      child: Scaffold(
      appBar: AppBar(
        title: Text('Select user'),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(height: 50.0),
        color: Colors.transparent,
        elevation: 0.0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Add user'),
        icon: Icon(Icons.add),
        tooltip: 'Add new user',
        elevation: 0.0,
        onPressed: () {
          // Navigator.pushNamed(context, '/screen/userCreate');
          showDialog(context: context,
              builder: (BuildContext context) {
                return UserCreate();
              });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: StreamBuilder(
        stream: doseDatabase.usersDao.watchUsers(),
        builder: (c, AsyncSnapshot<List<User>> snapshot) {
          print(snapshot.data);
          print(snapshot.connectionState);
          if(snapshot.connectionState == ConnectionState.active &&
              snapshot.hasData && snapshot.data != null) {
            return _buildListViewOfUsers(context,
              snapshot.data!,
              activeUsers,
              measurementCurrent,
              args);
          }
          return Container();
        }),
      ),
    );
  }

  ListView _buildListViewOfUsers(
      BuildContext context,
      List<User> users,
      ActiveUserModel activeUsers,
      MeasurementCurrent current,
      ModeArguments args) {
    List<ListTile> tiles = <ListTile>[];

    // Existing users
    for (User user in users) {
      tiles.add(
        ListTile(
          title: Text(user.userName),
          subtitle: Text(user.fullName),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () {
            // TODO: Check if already added!
            activeUsers.add(user);
            current.userId = user.id;

            if (args.arg == MODE_ANALYZE) {
              MeasurementSelectArguments arguments = MeasurementSelectArguments(
                  MODE_ANALYZE, '/screen/measInfo', user.id);
              Navigator.pushNamed(
                context,
                '/screen/measurementSelect',
                arguments: arguments,
              );
            } else {
              // Measure mode
              ModeArguments arguments = ModeArguments(
                  MODE_MEASUREMENT, 'POP');
              Navigator.pushNamed(
                context,
                '/screen/dosimeterSelect',
                arguments: arguments,
              );
            }
          },
        )
      );
    }

    // Combine to ListView
    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        ...tiles,
      ],
    );
  }
}
