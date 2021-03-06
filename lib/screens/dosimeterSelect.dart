import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dosepix/colors.dart';

// Models
import 'package:dosepix/models/dosimeter.dart';
import 'package:dosepix/models/bluetooth.dart';
import 'package:dosepix/models/measurement.dart';
import 'package:dosepix/models/user.dart';
import 'package:dosepix/models/listLayout.dart';

// Screens
import 'package:dosepix/screens/bluetoothOff.dart';
import 'package:dosepix/screens/dosimeterAlreadyUsed.dart';

// Database
import 'package:dosepix/database/databaseHandler.dart' if (dart.library.html) 'package:dosepix/databaseServer/databaseHandler.dart';

class DosimeterSelect extends StatefulWidget {
  const DosimeterSelect({Key? key}) : super(key: key);

  @override
  _DosimeterSelectState createState() => _DosimeterSelectState();
}

class _DosimeterSelectState extends State<DosimeterSelect> {
  @override
  Widget build(BuildContext context) {
    // All registered dosimeters
    var dosimeters = context.watch<DosimeterModel>();
    var bluetooth = context.watch<BluetoothModel>();
    var measurementCurrent = context.watch<MeasurementCurrent>();

    // Get database
    DoseDatabase doseDatabase = Provider.of<DoseDatabase>(context);

    // Scan for close dosimeters
    FlutterBluePlus.instance.startScan(timeout: Duration(seconds: 4));

    Widget floatingActionButton = StreamBuilder<bool>(
      stream: FlutterBluePlus.instance.isScanning,
      initialData: false,
      builder: (c, snapshot) {
        if (snapshot.data!) {
          return FloatingActionButton.extended(
            label: Text(
              "Scanning...",
              style: GoogleFonts.nunito(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            icon: Icon(Icons.search),
            elevation: 0.0,
            backgroundColor: dosepixColor40,
            extendedPadding: EdgeInsets.all(40),
            onPressed: () {
              FlutterBluePlus.instance.stopScan();
            },
          );
        } else {
          return FloatingActionButton.extended(
            label: Text(
              "Scan",
              style: GoogleFonts.nunito(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            icon: Icon(Icons.bluetooth),
            tooltip: 'Scan for dosimeters',
            elevation: 0.0,
            backgroundColor: dosepixColor40,
            extendedPadding: EdgeInsets.all(40),
            onPressed: () {
              FlutterBluePlus.instance.startScan(timeout: Duration(seconds: 4));
            },
          );
        }
      }
    );

    Widget body = StreamBuilder<BluetoothState> (
      stream: FlutterBluePlus.instance.state,
      initialData: BluetoothState.unknown,
      builder: (c, snapshot) {
        final state = snapshot.data;
        if (state == BluetoothState.on) {
          return Row(
            children: [
              // List scan results
              Expanded(child:
                StreamBuilder<List<ScanResult>>(
                  stream: FlutterBluePlus.instance.scanResults,
                  initialData: [],
                  builder: (c, snapshot) {
                    return _buildListViewOfDevices(snapshot.data, doseDatabase,
                      bluetooth, dosimeters, measurementCurrent);
                  },
                ),
              ),
              Expanded(child:
                StreamBuilder<List<BluetoothDevice>>(
                  stream: Stream.periodic(Duration(seconds: 2)).asyncMap(
                          (_) => FlutterBluePlus.instance.connectedDevices),
                  initialData: [],
                  builder: (c, snapshot) {
                    return _buildListViewOfConnectedDevices(
                        snapshot.data, bluetooth, measurementCurrent);
                  },
                ),
              ),
            ],
          );
        } else {
          measurementCurrent.deviceId = NO_DEVICE;
          return BluetoothOff();
        }
      }
    );

    return WillPopScope(
      onWillPop: () {
        measurementCurrent.dosimeterId = NO_DOSIMETER;
        return Future.value(true);
      },
      child: getListLayout(
        context,
        "Select",
        " Dosimeter",
        Icons.visibility,
        floatingActionButton,
        body
      ),
    );
  }

  ListView _buildListViewOfConnectedDevices(
      List<BluetoothDevice>? devices,
      BluetoothModel bluetooth,
      MeasurementCurrent measurementCurrent) {
    List<ListTile> tiles = [];

    for(BluetoothDevice device in devices!) {
     tiles.add(
       ListTile(
         title: Text(device.name),
         onTap: () {
           // DEBUG
           /*
           bluetooth.add(
             // Add unassigned device
             DeviceType(
               device: device,
               id: bluetooth.ids.last + 100,
               userId: 999,
               dosimeterId: 999,
               stream: DataStream().randomDose(Duration(seconds: 1))
             )
           );
           */

           measurementCurrent.deviceId = bluetooth.ids.last;
           measurementCurrent.dosimeterId = 999;
           measurementCurrent.update();

           // Back to measurement page
           Navigator.pop(context);
           Navigator.pop(context);
         },
       ),
     );
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

  ListView _buildListViewOfDevices(
      List<ScanResult>? results,
      DoseDatabase doseDatabase,
      BluetoothModel bluetooth,
      DosimeterModel dosimeters,
      MeasurementCurrent measurementCurrent) {
    List<StreamBuilder<BluetoothDeviceState>> tiles = <StreamBuilder<BluetoothDeviceState>>[];
    for (ScanResult result in results!) {
      // Do not list devices which are not dosimeters
      if(!(result.device.name.contains("DPX") || result.device.name.contains("Dosepix"))) {
        continue;
      }
      print(result);

      void Function() onTap = () {
        // Connect device and add to list of devices
        bluetooth.connectAndSubscribe(result.device).then((deviceId) {
          // Add device to database if not already included
          doseDatabase.dosimetersDao.insertDosimeter(
            DosimetersCompanion.insert(
              name: result.device.name,
              color: 'red',
              totalDose: 0.0,
            )
          ).catchError((error) {
            print('Device already added to database');
          });

          // device already paired
          if(deviceId > 0) {
            if(bluetooth.getDeviceById(deviceId).userId != NO_USER) {
              return DosimeterAlreadyUsed();
            }
          }

          // Check if dosimeter is in database;
          // create new entry if not
          // TODO: Color needs to be stored on device somehow
          int dosimeterId = dosimeters.addNewCheckExisting(
              name: result.device.name, color: Colors.red);

          // Add to active devices
          // Couple device with id
          // device.dosimeterId = dosimeterId;

          // Update current run with information
          measurementCurrent.deviceId = deviceId;
          measurementCurrent.dosimeterId = dosimeterId;
          measurementCurrent.update();

          // Back to measurement page
          Navigator.pop(context);
          Navigator.pop(context);
        });
      };

      tiles.add(
        StreamBuilder<BluetoothDeviceState>(
          stream: result.device.state,
          initialData: BluetoothDeviceState.disconnected,
          builder: (c, snapshot) {
            switch (snapshot.data) {
              case BluetoothDeviceState.disconnected:
                return getListTile(
                  result.device.name,
                  result.device.id.toString(),
                  onTap,
                );
              case BluetoothDeviceState.connected:
                return getListTile(
                  result.device.name,
                  result.device.id.toString(),
                  () {
                    // Function is called if an already connected device
                    // is selected
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return DosimeterAlreadyUsed();
                        }
                    );
                  },
                );
                default:
                  return ListTile();
            }
          },
        ),
      );
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
