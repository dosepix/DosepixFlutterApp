import 'package:dosepix/models/mode.dart';
import 'package:dosepix/screens/measInfo.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:dosepix/models/linechart.dart';

// Models
import 'package:dosepix/models/listLayout.dart';

// Database
import 'package:dosepix/database/databaseHandler.dart'
    if (dart.library.html) 'package:dosepix/databaseServer/databaseHandler.dart';

class MeasurementSelectArguments extends ModeArguments {
  final int userId;
  final String userName;
  MeasurementSelectArguments(
    arg,
    next,
    this.userId,
    this.userName
  ) : super(arg, next);
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
    final args = ModalRoute.of(context)!.settings.arguments
        as MeasurementSelectArguments;

    Widget body = StreamBuilder(
      stream: doseDatabase.pointsDao
          .measurementsWithImportantPoints(fromUser: args.userId),
      builder:
          (c, AsyncSnapshot<List<MeasurementWithImportantPoints>> snapshot) {
        if (snapshot.connectionState == ConnectionState.active &&
            snapshot.hasData &&
            snapshot.data != null) {
          return _buildListViewOfMeasurements(
            doseDatabase,
            snapshot.data!,
          );
        }
        // TODO: Show that no measurements are found
        return Container();
      },
    );

    return WillPopScope(
      onWillPop: () {
        return Future.value(true);
      },
      child: getListLayout(
        context,
        "Select",
        " Measurement",
        Icons.show_chart,
        SizedBox.shrink(),
        body,
      ),
    );
  }

  ListView _buildListViewOfMeasurements(
    DoseDatabase doseDatabase,
    List<MeasurementWithImportantPoints> mps,
  ) {
    List<Widget> tiles = <Widget>[];
    for (MeasurementWithImportantPoints m in mps) {
      DateTime startDate =
          DateTime.fromMillisecondsSinceEpoch(m.points.first.time * 1000);
      if (m.points.first.id != BAD_DATA) {
        tiles.add(
          getListTile(
            'Measurement ' + m.measurement.id.toString(),
            'Date: ' +
                DateFormat('yyyy-MM-dd (HH:mm)').format(startDate) +
                ', Duration: ' +
                ((m.points.last.time - m.points.first.time) / 60.0)
                    .toStringAsFixed(2) +
                ' mins' +
                ', Total dose: ' +
                getDoseString(m.measurement.totalDose),
            () {
              Navigator.pushNamed(context, '/screen/measInfo',
                  arguments: MeasurementInfoArguments(
                    MODE_ANALYZE,
                    'POP',
                    m.measurement.id,
                    m.measurement.userId
                  ),
                );
            },
          ),
        );

        tiles.add(
          const SizedBox(
            height: 15,
          ),
        );
      }
    }

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
