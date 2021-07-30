import 'package:dosepix/models/dosimeter.dart';
import 'package:dosepix/screens/userCreate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Models
import 'package:dosepix/models/user.dart';
import 'package:dosepix/models/measurement.dart';
import 'package:dosepix/models/dataStream.dart';

class UserSelect extends StatelessWidget {
  const UserSelect({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var registeredUsers = context.watch<UserModel>();
    var activeUsers = context.watch<ActiveUserModel>();
    var measurements = context.watch<MeasurementModel>();
    final dosimeterArgs = ModalRoute.of(context)!.settings.arguments as DosimeterArguments;

    return Scaffold(
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
      body: _buildListViewOfUsers(context,
          registeredUsers, activeUsers, measurements, dosimeterArgs.dosimeterId),
    );
  }

  ListView _buildListViewOfUsers(
      BuildContext context,
      UserModel registeredUsers,
      ActiveUserModel activeUsers,
      MeasurementModel measurements,
      int dosimeterId) {
    List<ListTile> tiles = <ListTile>[];
    // Existing users
    if(registeredUsers.users.isNotEmpty) {
      for (UserType user in registeredUsers.users) {
        tiles.add(
          ListTile(
            title: Text(user.userName),
            subtitle: Text(user.fullName),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              // TODO: Check if already added!
              activeUsers.add(user);

              // Create a measurement
              measurements.addNew(
                name: "",
                userId: user.id,
                dosimeterId: dosimeterId,
              );

              // Back to dosimeter select page
              Navigator.pop(context);

              // TODO: Just for testing, exchange with real data
              // Listen to stream
              DataStream().randomDose(Duration(seconds: 1)).listen((value) {
                // activeUsers.users[registeredUsers.users.indexOf(user)].a
                measurements.measurements.last.doseData.add(value);
              }
              );

              // Back to measurement page
              Navigator.pop(context);
            },
          )
        );
      }
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
