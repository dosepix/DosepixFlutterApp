import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:dosepix/models/linechart.dart';
import 'package:dosepix/screens/measInfo.dart';

// Models
import 'package:dosepix/models/measurementTime.dart';
import 'package:dosepix/models/mode.dart';
import 'package:dosepix/models/listLayout.dart';

// Database
import 'package:dosepix/database/databaseHandler.dart'
    if (dart.library.html) 'package:dosepix/databaseServer/databaseHandler.dart';

class MeasurementSelectWidget extends StatelessWidget {
  final List<MeasurementTimeModel> measurementTimes;
  MeasurementSelectWidget(this.measurementTimes);

  Future<List<Measurement>> getMeasurementsFromIds(
    List<int> measurementIds,
    DoseDatabase doseDatabase,
  ) async {
    List<Measurement> measurements = [];

    for (int id in measurementIds) {
      Measurement measurement = await doseDatabase.measurementsDao.getMeasurementsOfId(id);
    }

    return measurements;
  }

  @override
  Widget build(BuildContext context) {
    // Get database
    DoseDatabase doseDatabase = Provider.of<DoseDatabase>(context);

    /*
    Widget body = FutureBuilder(
      future: 
        getMeasurementsFromIds(
          measurementIds,
          doseDatabase,
        ),
      builder:
          (c, AsyncSnapshot<List<Measurement>> snapshot) {
        if (snapshot.hasData) {
          for (Measurement measurement in snapshot.data!) {
            print(measurement);
          }
        }
        return Container();
      },
    );
    */

    List<Widget> _buildListView(
      List<MeasurementTimeModel> measurementTimes,
    ) {
      List<Widget> tiles = <Widget>[];

      for (MeasurementTimeModel measurementTime in measurementTimes) {
        tiles.add(
          getListTile(
            'Measurement ' + measurementTime.id.toString(),
            'Date: ' +
                DateFormat('yyyy-MM-dd (HH:mm)').format(measurementTime.startTime) +
                ', Duration: ' +
                (measurementTime.duration.second / 60.0)
                    .toStringAsFixed(2) +
                ' mins' +
                ', Total dose: ' +
                getDoseString(measurementTime.totalDose),
            () {
              Navigator.pushNamed(context, '/screen/measInfo',
                  arguments: MeasurementInfoArguments(
                    MODE_ANALYZE,
                    'POP',
                    measurementTime.id,
                    measurementTime.userId,
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
      return tiles;
    }

    return ListView(
      padding: const EdgeInsets.only(
        left: 50,
        right: 50,
        top: 10,
        bottom: 10,
      ),
      children: <Widget>[
        ..._buildListView(measurementTimes),
      ],
    );
  }
}
