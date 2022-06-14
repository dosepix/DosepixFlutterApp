import 'dart:async';

import 'package:dosepix/models/measurement.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:math';

const int NO_DEVICE = -1;

// UUIDs for a dosimeter
const String DOSE_SERVICE = '00000000-cc7a-482a-984a-7f2ed5b3e58f';
const String DOSE_CHARACTERISTIC = '00000000-8e22-4541-9d4c-21edae82ed19';

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
  await device.connect(autoConnect: true);
}

Future<List<BluetoothService>> getServices(BluetoothDevice device) async {
  List<BluetoothService> services = await device.discoverServices();
  return services;
}

class BluetoothModel extends ChangeNotifier {
  final FlutterBluePlus _flutterBlue = FlutterBluePlus.instance;
  bool _bluetoothOn = false;
  final List<DeviceType> _devices = [];
  List<StreamSubscription> _subscriptions = [];
  List<StreamSubscription> _deviceStateSubscriptions = [];

  List<DeviceType> get devices => _devices;
  List<int> get ids => _devices.map((device) => device.id).toList();
  List<String> get names =>
      _devices.map((device) => device.device.name).toList();

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
    await device.connect(autoConnect: true);

    List<BluetoothService> services = await device.discoverServices();
    services.forEach((service) {
      print("Service UUID " + service.uuid.toString());
      if (service.uuid.toString() == DOSE_SERVICE) {
        service.characteristics.forEach((characteristic) {
          print("Char UUID " + characteristic.uuid.toString());
          if (characteristic.uuid.toString() == DOSE_CHARACTERISTIC) {
            characteristic.setNotifyValue(true);
            Stream<List<int>> stream = characteristic.value.asBroadcastStream();

            newId = ids.isEmpty ? 1 : ids.reduce(max) + 1;
            _devices.add(
              // Add unassigned device
              DeviceType(
                device: device,
                id: newId,
                userId: -1,
                dosimeterId: -1,
                stream: stream,
              )
            );
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

  void disconnectAndRemove (DeviceType device, [bool removeDevice = true]) async {
    // TODO: Remove debug
    if (device.id < 100) {
      await device.device.disconnect();
    }

    int deviceIndex = ids.indexOf(device.id);

    // Cancel subscriptions
    _subscriptions[deviceIndex].cancel();
    _deviceStateSubscriptions[deviceIndex].cancel();

    _subscriptions.removeAt(deviceIndex);
    _deviceStateSubscriptions.removeAt(deviceIndex);
    print(_subscriptions);
    if (device.id < 100 && removeDevice) {
      _devices.remove(device);
    }
  }

  void addSubscription(
    int deviceId,
    Function call,
  ) {
    StreamSubscription deviceStateSubscription;
    StreamSubscription subscription;
    Stream<List<int>> stream;

    stream = getDeviceById(deviceId).stream.timeout(
        Duration(seconds: 10),
        onTimeout: (timeout) async {
          print('timeout');
          print(deviceId);
          // disconnectAndRemove(getDeviceById(deviceId), false);
          // addSubscription(deviceId, call);

          disconnectAndRemove(getDeviceById(deviceId), false);
          await connectAndSubscribe(getDeviceById(deviceId).device);
      });

    subscription =
      stream.listen((List<int> value) {
        return onDoseReceive(call, value);
      },
      onDone: () {
        print("done");
      },
      onError: (error) {
        print("error");
      });

    deviceStateSubscription =
      getDeviceById(deviceId).device.state.listen((BluetoothDeviceState state) {
      print(state);
      if ((state == BluetoothDeviceState.connected)) {
        // _subscriptions[0].cancel();
        /* _subscriptions[0] = devices[0].stream.listen((List<int> value) {
          return onDoseReceive(call, value);
        });
        */
      }
    });

    _subscriptions.add(subscription);
    _deviceStateSubscriptions.add(deviceStateSubscription);
  }
}

void onDoseReceive(Function call, List<int> value) {
  if (value.isNotEmpty) {
    print(value);
    // value is list of six integers, representing the characters of the
    // number as well as the unit

    var valueString = String.fromCharCodes(value.sublist(0, 5));
    var valueFloat = double.parse(valueString);

    var unit = value[5];
    switch (unit) {
      case 0x89:
        // In case of micro, do nothing
        break;
      case 0x88:
        // nano
        valueFloat /= 1.0e6;
        break;
      case 0x8a:
        // milli
        valueFloat *= 1.0e3;
        break;
      default:
        // no unit
        valueFloat *= 1.0e6;
    }

    call(MeasurementDataPoint(
      DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000,
      valueFloat,
    ));
  }
}
