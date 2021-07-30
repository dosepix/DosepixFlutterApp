import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Models
import 'package:dosepix/models/dosimeter.dart';

class DosimeterSelect extends StatefulWidget {
  const DosimeterSelect({Key? key}) : super(key: key);

  @override
  _DosimeterSelectState createState() => _DosimeterSelectState();
}

class _DosimeterSelectState extends State<DosimeterSelect> {
  @override
  Widget build(BuildContext context) {
    var activeDosimeters = context.watch<ActiveDosimeterModel>();

    // Scan for close dosimeters
    // scanDosimeters(activeDosimeters);
    print(activeDosimeters.info);

    return Scaffold(
      appBar: AppBar(
        title: Text("Select dosimeter"),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(height: 50.0),
        color: Colors.transparent,
        elevation: 0.0,
      ),
      floatingActionButton:
        FloatingActionButton.extended(
          label: Text("Scan"),
          icon: Icon(Icons.bluetooth),
          tooltip: 'Scan for dosimeters',
          elevation: 0.0,
          onPressed: () {
            scanDosimeters(activeDosimeters);
            print(activeDosimeters.info);
          },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Column(
        children: <Widget>[
          Expanded(child: _buildListViewOfDevices(activeDosimeters)),
        ],
      ),
    );
  }

  // Do some scanning and add found dosimeters to activeDosimeters
  void scanDosimeters(DosimeterModel activeDosimeters) {
    // Scan bluetooth for dosimeters, select suitable devices and add to activeDosimeters
    activeDosimeters.addNew(
      name: "Dosepix1",
      color: Colors.red,
    );
  }

  ListView _buildListViewOfDevices(DosimeterModel activeDosimeters) {
    List<ListTile> tiles = <ListTile>[];
    for (DosimeterType dosimeter in activeDosimeters.dosimeters) {
      tiles.add(
        ListTile(
          title: Text(dosimeter.name),
          subtitle: Text(dosimeter.id.toString()),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () {
            // Connect to dosimeter and select user
            Navigator.pushNamed(
                context,
                '/screen/userSelect',
                arguments: DosimeterArguments(dosimeter.id),
            );
          },
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        ...tiles,
      ],
    );
  }
}
