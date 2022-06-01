import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'package:dosepix/navigationDrawer/navigationDrawer.dart';

class PairPage extends StatefulWidget {
  final FlutterBlue flutterBlue = FlutterBlue.instance;

  final List<BluetoothDevice> devicesList = <BluetoothDevice>[];
  final List<bool> isConnectedList = <bool>[];
  PairPage({Key? key}) : super(key: key);

  @override
  _PairPageState createState() => _PairPageState();
}

class _PairPageState extends State<PairPage> {
  _addDeviceToList(final BluetoothDevice device) {
    if (!widget.devicesList.contains(device)) {
      setState(() {
        widget.devicesList.add(device);
        widget.isConnectedList.add(false);
      });
    }
  }

  @override
  void initState() {
    print('Init');
    super.initState();

    // Already connected devices
    widget.flutterBlue.connectedDevices
        .asStream()
        .listen((List<BluetoothDevice> devices) {
      print(devices);
      for (BluetoothDevice device in devices) {
        _addDeviceToList(device);
      }
    });

    // Scan for devices
    widget.flutterBlue.startScan(timeout: Duration(seconds: 4));
    widget.flutterBlue.scanResults.listen((List<ScanResult> results) {
      for (ScanResult result in results) {
        _addDeviceToList(result.device);
      }
    });
    widget.flutterBlue.stopScan();
  }

  ListView _buildListViewOfDevices() {
    List<Container> containers = <Container>[];
    for (BluetoothDevice device in widget.devicesList) {
      int index = widget.devicesList.indexOf(device);
      containers.add(Container(
        height: 50,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  Text(device.name == "" ? '(unknown device)' : device.name),
                  Text(device.id.toString()),
                ],
              ),
            ),
            TextButton(
                onPressed: () {
                  print(widget.isConnectedList[index]);
                  setState(() {
                    if (!widget.isConnectedList[index]) {
                      device.connect();
                      widget.isConnectedList[index] = true;
                    } else {
                      device.disconnect();
                      widget.isConnectedList[index] = false;
                    }
                  });
                },
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: Colors.lightBlue,
                  onSurface: Colors.grey,
                ),
                child: widget.isConnectedList[index]
                    ? Text('Disconnect')
                    : Text('Connect')),
          ],
        ),
      ));
    }

    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        ...containers,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pair devices'),
      ),
      drawer: NavigationDrawer(),
      body: Center(
          child: StreamBuilder<BluetoothState>(
        stream: widget.flutterBlue.state,
        initialData: BluetoothState.unknown,
        builder: (c, snapshot) {
          final state = snapshot.data;
          print(state);
          if (state == BluetoothState.on) {
            print('Bluetooth on');
            return _buildListViewOfDevices();
          } else {
            print('Bluetooth off');
            return BluetoothOffScreen(state: state);
          }
        },
      )),
    );
  }
}

class BluetoothOffScreen extends StatelessWidget {
  final BluetoothState? state;
  const BluetoothOffScreen({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.bluetooth_disabled,
              size: 200.0,
              color: Colors.white54,
            ),
            Text(
              'Bluetooth Adapter is ${state != null ? state.toString().substring(15) : 'not available'}.',
            )
          ],
        ),
      ),
    );
  }
}
