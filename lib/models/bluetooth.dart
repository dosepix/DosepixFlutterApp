import 'dart:async';

import 'package:dosepix/models/measurement.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'dart:math';

const int NO_DEVICE = -1;

// UUIDs for a dosimeter
const String DOSE_SERVICE = 'f000ba55-0451-4000-b000-000000000000';
const String DOSE_CHARACTERISTIC = 'f0002bad-0451-4000-b000-000000000000';

class DeviceType {
  final BluetoothDevice device;
  final int id;
  int userId;
  int dosimeterId;
  final Stream<List<int>> stream;

  DeviceType({
    required this.device,
    required this.id,
    required this.userId,
    required this.dosimeterId,
    required this.stream,
  });
}

class DeviceArguments {
  final int deviceId;
  final int dosimeterId;

  DeviceArguments(this.deviceId, this.dosimeterId);
}

void connectDevice(BluetoothDevice device) async {
 await device.connect();
}

Future<List<BluetoothService>> getServices(BluetoothDevice device) async {
  List<BluetoothService> services = await device.discoverServices();
  return services;
}

class BluetoothModel extends  ChangeNotifier {
  final FlutterBlue _flutterBlue = FlutterBlue.instance;
  bool _bluetoothOn = false;
  final List<DeviceType> _devices = [];
  List<StreamSubscription> _subscriptions = [];

  List<DeviceType> get devices => _devices;
  List<int> get ids => _devices.map((device) => device.id).toList();
  List<String> get names => _devices.map((device) => device.device.name).toList();

  Future<bool> isBluetoothOn() async {
    _bluetoothOn = await _flutterBlue.isOn;
    notifyListeners();
    return _bluetoothOn;
  }

  void add(DeviceType device) {
    _devices.add(device);
    notifyListeners();
  }

  void scanDevices(int seconds) {
    _flutterBlue.startScan(timeout: Duration(seconds: seconds));
  }

  Future<int> connectAndSubscribe(BluetoothDevice device) async {
    // Initialize new device id
    int newId = -1;

    // Do not subscribe if device is already added
    // if(names.contains(device.name)) {
    //   return newId;
    // }
    await device.connect();

    List<BluetoothService> services = await device.discoverServices();
    services.forEach((service) {
     if(service.uuid.toString() == DOSE_SERVICE) {
       service.characteristics.forEach((characteristic) {
         if(characteristic.uuid.toString() == DOSE_CHARACTERISTIC) {
           characteristic.setNotifyValue(true);
           Stream<List<int>> stream = characteristic.value;

           newId = ids.isEmpty ? 1 : ids.reduce(max) + 1;
           _devices.add(
             // Add unassigned device
               DeviceType(
                   device: device,
                   id: newId,
                   userId: -1,
                   dosimeterId: -1,
                   stream: stream,)
           );

           // DEBUG: listen to data stream
           // characteristic.value.listen((event) {print(event);});
         }
       });
     }
    });

    notifyListeners();
    return newId;
  }

  DeviceType getDeviceById(int id) {
    return _devices[ids.indexOf(id)];
  }

  void disconnectAndRemove(DeviceType device) {
    // TODO: Remove debug
    if(device.id < 100) {
      device.device.disconnect();
    }
    _subscriptions[ids.indexOf(device.id)].cancel();
    _subscriptions.removeAt(ids.indexOf(device.id));
    print(_subscriptions);
    if(device.id < 100) {
      _devices.remove(device);
    }
  }

  void addSubscription(int deviceId, Function call) {
    StreamSubscription subscription = getDeviceById(deviceId)
        .stream.listen((List<int> value) {
      print(value);
      // value is list of four integers; convert to double
      // int newVal = value[0] + value[1] << 8 + value[2] << 16 + value[3] << 32;
      call(
        MeasurementDataPoint(
            DateTime
                .now()
                .toUtc()
                .millisecondsSinceEpoch / 1000.0,
            value[0].toDouble()
        )
      );
    });
   _subscriptions.add(subscription);
  }
}
