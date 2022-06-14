import 'package:dosepix/models/mode.dart';
import 'package:dosepix/screens/measInfo.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:dosepix/models/linechart.dart';

// Database
import 'package:dosepix/database/databaseHandler.dart' if (dart.library.html) 'package:dosepix/databaseServer/databaseHandler.dart';

class MeasurementSelectArguments extends ModeArguments {
  final int userId;
  MeasurementSelectArguments(arg, next, this.userId) : super(arg, next);
}

class MeasurementSelect extends StatefulWidget {
  const MeasurementSelect({Key? key}) : super(key: key);

  @override
  _MeasurementSelectState createState() => _MeasurementSelectState();
}

class _MeasurementSelectState extends State<MeasurementSelect> {
  @override
  Widget build(BuildContext context) {
    // Get database
    DoseDatabase doseDatabase = Provider.of<DoseDatabase>(context);

    // Get arguments from call
    final args = ModalRoute.of(context)!.settings.arguments as MeasurementSelectArguments;

    return WillPopScope(
      onWillPop: () {return Future.value(true);},
      child: Scaffold(
        appBar: AppBar(
          title: Text('Select measurement'),
          actions: [
            IconButton(onPressed: () {
              Navigator.pushNamed(context, '/screen/userSummary',
                  arguments: args);
            }, icon: const Icon(Icons.bar_chart))
          ],
        ),
        body: StreamBuilder(
          stream: doseDatabase.pointsDao.measurementsWithImportantPoints(fromUser: args.userId),
          builder: (c, AsyncSnapshot<List<MeasurementWithImportantPoints>> snapshot) {
            if(snapshot.connectionState == ConnectionState.active &&
                snapshot.hasData && snapshot.data != null) {
              return _buildListViewOfMeasurements(
                  doseDatabase, snapshot.data!);
            }
            // TODO: Show that no measurements are found
            return Container();
          },
        ),
      ),
    );
  }

  ListView _buildListViewOfMeasurements(
      DoseDatabase doseDatabase,
      List<MeasurementWithImportantPoints> mps,) {
    List<ListTile> tiles = <ListTile>[];
    for (MeasurementWithImportantPoints m in mps) {
      DateTime startDate = DateTime.fromMillisecondsSinceEpoch(m.points.first.time * 1000);
      if (m.points.first.id != BAD_DATA) {
        tiles.add(
          ListTile(
            title: Text('Measurement ' + m.measurement.id.toString()),
            subtitle: Text('Date: ' +  DateFormat('yyyy-MM-dd (HH:mm)').format(startDate)
              + ', Duration: ' + ((m.points.last.time - m.points.first.time) / 60.0).toStringAsFixed(2) + ' mins'
              + ', Total dose: ' + getDoseString(m.measurement.totalDose)),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/screen/measInfo',
                arguments: MeasurementInfoArguments(
                  MODE_ANALYZE, 'POP', m.measurement.id, m.measurement.userId));
            },
          )
        );
      }
    }

    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        ...tiles,
      ],
    );
  }
}
