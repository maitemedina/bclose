import 'dart:async';


import 'package:bclose/modules/objects/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:location/location.dart';
import 'package:rxdart/rxdart.dart';

class BlocBluetooth {
//  static const String OXIMETER_SERVICE_ID = "CDEACB80-5235-4C07-8846-93A37EE6B86D";
//  static const String OXIMETER_CHARACTERISTIC_ID = "CDEACB81-5235-4C07-8846-93A37EE6B86D";
//
//  static const String THERMOMETER_SERVICE_ID = "0000FFF0-0000-1000-8000-00805F9B34FB";
//  static const String THERMOMETER_CHARACTERISTIC_ID = "0000FFF3-0000-1000-8000-00805F9B34FB";

  FlutterBlue flutterBlue = FlutterBlue.instance;


  BehaviorSubject<List<Product>> _visibleDevicesSubject =
  BehaviorSubject.seeded([]);
  Stream<List<Product>> get visibleDevicesStream =>
      _visibleDevicesSubject.stream;
  Stream<List<Product>> visibleDevicesFromListStream(List<Product> devices) {
    return _visibleDevicesSubject.stream.map((list) => list
        .where((device) => devices.contains(device))
        .toList(growable: false));
  }

  List<Product>? get visibleDevices => _visibleDevicesSubject.value;

  BehaviorSubject<List<Product>> _connectedDevicesSubject =
  BehaviorSubject.seeded([]);
  Stream<List<Product>> get connectedDevicesStream =>
      _connectedDevicesSubject.stream;
  List<Product>? get connectedDevices => _visibleDevicesSubject.value;
  void set connectedDevice(Product device) {
    List<Product> connected = connectedDevices!;
    if (!connected.contains(device)) {
      connected.add(device);
      _connectedDevicesSubject.add(connected);
    }
  }

  void set disconnectedDevice(Product device) {
    List<Product> connected = connectedDevices!;
    if (connected.contains(device)) {
      connected.remove(device);
      _connectedDevicesSubject.add(connected);
    }
  }

  BehaviorSubject<List<Product>> _combinedVisibleDevicesSubject =
  BehaviorSubject.seeded([]);
  Stream<List<Product>> get combinedVisibleDevicesStream =>
      _combinedVisibleDevicesSubject.stream;
  List<Product>? get combinedVisibleDevices =>
      _combinedVisibleDevicesSubject.value;

  Stream<List<Product>> get _combineVisibleDevices =>
      Rx.combineLatest2(connectedDevicesStream, visibleDevicesStream,
              (List<Product> connected, List<Product> visible) {
            List<Product> combinedVisible = connected;
            visible.forEach((device) {
              if (!combinedVisible.contains(device)) {
                combinedVisible.add(device);
              }
            });
            return combinedVisible;
          });

  BehaviorSubject<bool> _isScanningSubject = BehaviorSubject();
  Stream<bool> get isScanningStream => _isScanningSubject.stream;
  bool? get isScanning => _isScanningSubject.value;

  // BlocBluetooth("this.log") {
  //   log.debugLogLine = "bloc_bluetooth - starting";
  //   flutterBlue.isScanning
  //       .listen((scanning) => _isScanningSubject.add(scanning));
  //   _combineVisibleDevices
  //       .listen((deviceList) => _combinedVisibleDevicesSubject.add(deviceList));
  // }

  Stream<bool> init(BuildContext context) {
    // log.debugLogLine = "bloc_bluetooth - initing";
    BehaviorSubject<bool> _proceedSubject = BehaviorSubject();
    StreamSubscription? subscription;
    subscription = _ensureLocationPermission(context)
        .timeout(Duration(seconds: 20),
        onTimeout: (sink) =>
            sink.addError("timeout waiting for location permission"))
        .switchMap((_) => _ensureLocationOn(context))
        .timeout(Duration(seconds: 20),
        onTimeout: (sink) => sink.addError("timeout waiting for location"))
        .switchMap((_) => _ensureBluetoothOn(context))
        .timeout(Duration(seconds: 20),
        onTimeout: (sink) => sink.addError("timeout waiting for bluetooth"))
        .listen((ok) {
      // log.debugLogLine = "bloc_bluetooth - conditions met!";
      _proceedSubject.add(true);
      _proceedSubject.close();
      subscription!.cancel();
    }, onError: (e) {
      // log.debugLogLine = "bloc_bluetooth - conditions error!";
      _proceedSubject.addError(e);
      _proceedSubject.close();
      subscription!.cancel();
    });
    return _proceedSubject.stream;
  }

  Stream<bool> _checkLocationPermission() {
    // log.debugLogLine = "bloc_bluetooth - checking location permission";
    return Location().requestPermission().asStream().map(
            (status) => status == PermissionStatus.granted ? true : throw "denied");
  }

  Stream<bool> _ensureLocationPermission(BuildContext context) {
    // log.debugLogLine = "bloc_bluetooth - ensuring location permission";
    BehaviorSubject<bool> _grantedSubject = BehaviorSubject();
    StreamSubscription? subscription;
    subscription = _checkLocationPermission().listen((status) {
      // log.debugLogLine = "bloc_bluetooth - location permission granted";
      _grantedSubject.add(true);
      _grantedSubject.close();
      subscription!.cancel();
    }, onError: (e, st) {
      // log.debugLogLine = "bloc_bluetooth - location permission - $e - $st";
//       Util.presentDialog(
//           context: context,
//           message: "App needs location permissions to find device",
//           actions: <Widget>[
//             FlatButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                   log.debugLogLine =
//                   "bloc_bluetooth - requesting location permission";
//                   _ensureLocationPermission(context).listen((granted) {
//                     log.debugLogLine =
//                     "bloc_bluetooth - location permission granted";
//                     _grantedSubject.add(true);
//                     _grantedSubject.close();
//                   }, onError: (e, st) {
//                     log.debugLogLine =
//                     "bloc_bluetooth - location permission error";
// //                    _grantedSubject.addError(e, st);    //commented due to Recursiveness
// //                    _grantedSubject.close();
//                   });
//                 },
//                 child: Text("Try again"))
//           ],
//           log: log);
      subscription!.cancel();
    });
    return _grantedSubject.stream;
  }

  Stream<bool> _checkLocationOn() {
    // log.debugLogLine = "bloc_bluetooth - checking location on";
    return Location().serviceEnabled().asStream();
  }

  Stream<bool> _ensureLocationOn(BuildContext context) {
    // log.debugLogLine = "bloc_bluetooth - ensuring location on";
    BehaviorSubject<bool> _locationOnSubject = BehaviorSubject();
    StreamSubscription? subscription;
    subscription = _checkLocationOn().listen((enabled) {
      if (enabled) {
        // log.debugLogLine = "bloc_bluetooth - location is on";
        _locationOnSubject.add(true);
        _locationOnSubject.close();
        subscription!.cancel();
      } else {
        // log.debugLogLine = "bloc_bluetooth - location is off";
        // Util.presentDialog(
        //     context: context,
        //     message: "Please turn your device's location on!",
        //     actions: [
        //       FlatButton(
        //         onPressed: () {
        //           Navigator.pop(context);
        //           log.debugLogLine =
        //           "bloc_bluetooth - requesting location be turned on";
        //           Location().requestService().asStream().listen((enabled) {
        //             if (enabled) {
        //               log.debugLogLine = "bloc_bluetooth - location turned on";
        //               _locationOnSubject.add(enabled);
        //               _locationOnSubject.close();
        //               subscription.cancel();
        //             } else {
        //               log.debugLogLine = "bloc_bluetooth - location turned off";
        //               _locationOnSubject.addError(Exception("Location off"));
        //               _locationOnSubject.close();
        //               subscription.cancel();
        //             }
        //           }, onError: (e) {
        //             log.debugLogLine =
        //             "bloc_bluetooth - location request error";
        //             _locationOnSubject.addError(e);
        //             _locationOnSubject.close();
        //             subscription.cancel();
        //           });
        //         },
        //         child: Text("Settings"),
        //       )
        //     ],
        //     log: log);
      }
    }, onError: (e) {
      // log.debugLogLine = "bloc_bluetooth - location check error";
      _locationOnSubject.addError(e);
      _locationOnSubject.close();
      subscription!.cancel();
    });
    return _locationOnSubject.stream;
  }

  Stream<bool> _ensureBluetoothOn(BuildContext context) {
    // log.debugLogLine = "bloc_bluetooth - ensuring bluetooth is on";
    BehaviorSubject<bool> _bluetoothOnSubject = BehaviorSubject();
    StreamSubscription? subscription;
    subscription = flutterBlue.state.listen((state) {
      // log.debugLogLine = "bloc_bluetooth - bluetooth state $state";
      switch (state) {
        case BluetoothState.unavailable:
          _bluetoothOnSubject
              .addError("Your device does not support bluetooth!");
          _bluetoothOnSubject.close();
          subscription!.cancel();
          break;
        case BluetoothState.unauthorized:
          _bluetoothOnSubject.addError("Bluetooth usage unauthorized!");
          _bluetoothOnSubject.close();
          subscription!.cancel();
          break;
        case BluetoothState.turningOn:
        // Nothing to do but wait
          break;
        case BluetoothState.on:
          _bluetoothOnSubject.add(true);
          _bluetoothOnSubject.close();
          subscription!.cancel();
          break;
        case BluetoothState.turningOff:
        case BluetoothState.off:
        case BluetoothState.unknown:
        default:
          // Util.presentDialog(
          //     context: context,
          //     message: "Please turn your device's bluetooth on!",
          //     actions: [
          //       FlatButton(
          //         onPressed: () {
          //           Navigator.pop(context);
          //           log.debugLogLine =
          //           "bloc_bluetooth - requesting bluetooth be turned on";
          //           SystemSetting.goto(SettingTarget.BLUETOOTH);
          //         },
          //         child: Text("Settings"),
          //       )
          //     ],
          //     log: log);
          break;
      }
    });
    return _bluetoothOnSubject.stream;
  }

  Stream<String> quickCheckConditions() {
    return Rx.zip3(
        _checkLocationPermission(),
        _checkLocationOn(),
        flutterBlue.state.map((state) => state == BluetoothState.on),
            (locationPermission, location, bluetooth) =>
        locationPermission)
        .timeout(Duration(seconds: 20), onTimeout: (sink) {
      sink.add(false);
      sink.close();
    }).map((ok) => ok != null
        ? "bloc_bluetooth - conditions met"
        : throw 'conditions failed');
  }

  Stream<List<Product>> _filterScan(
      {required BuildContext context,
        required List<Product> devices,
        required Stream<ScanResult> scanResultsStream}) {
    // List<DeviceIdentifier> deviceIds = devices.map((device) => DeviceIdentifier(device.mac)).toList(growable: false);
    StreamSubscription? subscription;
    subscription = scanResultsStream
        .doOnData((result) => print("bloc_bluetooth - device: ${result.device.name}, rssi: ${result.rssi}, id: ${result.device.id}")
    )
        .map((result) => result.device)
    // .where((bluetoothDevice) => deviceIds.contains(bluetoothDevice.id))
        .where((bluetoothDevice) =>
        devices.any((device) => device.bleName == bluetoothDevice.name))
        .listen(
          (bluetoothDevice) {

        print("bloc_bluetooth - found recognized device - $bluetoothDevice")
        ;
        List<Product>? visibleDevices = _visibleDevicesSubject.value;
        Product device = devices
            .firstWhere((device) => device.bleName == bluetoothDevice.name);
        device.bluetoothDevice = bluetoothDevice;
        if (!visibleDevices!.contains(device)) {
          visibleDevices.add(device);
          print("bloc_bluetooth - ${visibleDevices.length} recognized devices found");

          _visibleDevicesSubject.add(visibleDevices.toList());
        }
      },
      onError: (e, st) {
        // log.debugLogLine = "bloc_bluetooth - scanning error: $e - $st";
        _visibleDevicesSubject.addError(e, st);
        // Util.presentDialog(context: context, message: e.toString(), log: log);
        stopScan();
        subscription!.cancel();
      },
      onDone: () => subscription!.cancel(),
    );
    return visibleDevicesStream;
  }

//  Stream<List<Device>> startScanning({@required BuildContext context, @required List<Device> devices}) {
//    log.debugLogLine = "bloc_bluetooth - start scan called, looking for devices: $devices";
//    _visibleDevicesSubject.add([]);
//    log.debugLogLine = "bloc_bluetooth - initiating scan!";
//    return _filterScan(
//        context: context,
//        devices: devices,
//        scanResultsStream: quickCheckConditions()
//          .switchMap((_) => Stream.fromFuture(flutterBlue.startScan(timeout: Duration(seconds: 10))).expand((typeless) => typeless as List<ScanResult>))
//    );
//  }

  Stream<List<Product>> startScanning(
      {required BuildContext context, required List<Product> devices}) {

    if (!isScanning!) {
      _visibleDevicesSubject.add([]);
      // log.debugLogLine = "bloc_bluetooth - initiating scan!";
      return _filterScan(
          context: context,
          devices: devices,
          scanResultsStream: quickCheckConditions().switchMap(
                  (_) => flutterBlue.scan(timeout: Duration(seconds: 10))));
    } else {
      // log.debugLogLine =
      // "bloc_bluetooth - already scanning, tagging along current scan!";
      return _filterScan(
          context: context,
          devices: devices,
          scanResultsStream:
          flutterBlue.scanResults.expand((scanResults) => scanResults));
    }
  }

  /// Do not use,it makes bluetooth module seemingly unusable
  Stream<bool> stopScan({listen = false}) {

    Stream<bool> stopped = Stream.fromFuture(flutterBlue.stopScan())
        .doOnData((_) =>  "bloc_bluetooth - stopped scanning")
        .mapTo(true);
    if (listen) {
      return stopped;
    } else {
      stopped.listen((_) {});
      return Stream.value(true);
    }
  }

  Stream<Product> connectDevice(Product device) {

    return quickCheckConditions()
        .switchMap((_) => _connectDevice(device.bluetoothDevice!))
        .switchMap((_) => device.bluetoothDevice!.state)
        .where((state) => state == BluetoothDeviceState.connected)
        .take(1)
        .timeout(Duration(seconds: 10),
        onTimeout: (sink) => sink.addError(
            "timeout connecting to device!", StackTrace.current))
        .map((_) => device)
        .doOnData((device) => (connectedDevice = device))
        .doOnData((device) => "bloc_bluetooth - connected to device: $device");
  }

  Stream<bool> disconnectDevice(Product device) {

    return device.bluetoothDevice!.state
        .where((state) => state == BluetoothDeviceState.connected)
        .doOnData((connected) => "device is connected")
        .map((_) {
      device.bluetoothCharacteristic?.setNotifyValue(false);
      // device.bluetoothDevice.disconnect();
    })
    // .switchMap((_) => device.bluetoothDevice.state)
    // .where((state) => state == BluetoothDeviceState.disconnected)
    // .doOnData((_) => (disconnectedDevice = device))
        .doOnData((connected) =>  "device is disconnected")
        .mapTo(true);
  }

  Stream<List<int>> startReading(Product device) {

    if (device.isVisible) {
      return connectDevice(device)/*.switchMap((value) {
        print("2PlayMore - " + value.bleCharacteristic.toString());
        print("2PlayMore - " + value.bleService.toString());
        value.bluetoothDevice.discoverServices().then((value) => print(value));
        //value.bluetoothDevice.discoverServices()
        /*value.bluetoothDevice.services.listen((event) {
          print("2PlayMore - " + event.toString());
        });*/
        //print("2PlayMore - " + ));
        return Stream.value([1, 2, 3, 4]);
      });*/
          .switchMap((_) => _getService(device.bluetoothDevice!, device.bleService ?? device.category!.serviceId))
          .map((service) => _getCharacteristic(service, device.bleCharacteristic ?? device.category!.characteristicId))
          .where((characteristic) => characteristic != null)
          .timeout(Duration(seconds: 30), onTimeout: (sink) => sink.addError("timeout waiting for reading from device!", StackTrace.current))
          .doOnData((characteristic) => device.bluetoothCharacteristic = characteristic)
          .switchMap(_getValueStream);

    } else {
      return Stream.error("bloc_bluetooth - device not visible - $device");
    }
  }

//  startReading() {
//    if (!isScanning && !pairing) {
//      _checkLocationPermission()
//          .switchMap((status) => _scanDevice(OXIMETER_ID))
//          .switchMap((device) => _getService(device, OXIMETER_SERVICE_ID))
//          .map((service) => _getCharacteristic(service, OXIMETER_CHARACTERISTIC_ID))
//          .doOnData((characteristic) => this.characteristic = characteristic)
//          .switchMap(_getValueStream)
//          .map((value) => OximeterReading(value))
//          .doOnData((reading) {
//            /*if (reading.dataType == EnumOximeterDataType.MEASUREMENT) */log.debugLogLine = reading.toString();
//          })
//          .doOnData((currentReading) {
//            if (currentReading.isComplete) firstFullReading ??= DateTime.now();
//            if (firstFullReading != null && DateTime.now().isAfter(firstFullReading.add(Duration(seconds: 30)))) {
//              characteristic?.setNotifyValue(false);
//              firstFullReading = null;
//              blocFirebase.addReading(reading.measurement);
////              getLogs();
//            }
//          })
//          .listen((update) {
//            switch (update.dataType) {
//              case EnumOximeterDataType.MEASUREMENT:
//                reading = update;
//                break;
//              case EnumOximeterDataType.PLETHYSMOGRAPH:
//                plethysmograph = update.plethysmograph;
//                break;
//              default:
//                break;
//            }
//          });
//    } else if(characteristic != null) {
//      characteristic?.setNotifyValue(true);
////      getLogs();
//    }
//  }

//  Stream<BluetoothDevice> _scanDevice(String deviceId) {
//    log.debugLogLine = "bloc_bluetooth - starting bluetooth scan";
//    return flutterBlue.scan(timeout: Duration(seconds: 10))
//        .doOnData((result) => log.debugLogLine = "bloc_bluetooth - device: ${result.device.name}, rssi: ${result.rssi}, id: ${result.device.id}")
//        .where((result) => result.device.id == DeviceIdentifier(deviceId))
//        .doOnData((_) => flutterBlue.stopScan())
//        .map((result) => result.device)
//        .doOnData((device) => log.debugLogLine = "bloc_bluetooth - found $deviceId - device: $device")
//        .flatMap((device) => device.connect(autoConnect: true).asStream().map((_) => device))
//        .doOnData((device) => log.debugLogLine = "bloc_bluetooth - connected to device: $deviceId");
//  }

  Stream<BluetoothDevice> _connectDevice(BluetoothDevice device) {

    return device.state.take(1).switchMap((state) {

      return state == BluetoothDeviceState.disconnected
          ? /*device.disconnect().asStream().switchMap((_) => */ device
          .connect(autoConnect: true, timeout: Duration(seconds: 40))
          .asStream()
          .map((_) => device) /*)*/
          : Stream.value(device);
    });
  }

  Stream<BluetoothService> _getService(
      BluetoothDevice device, String serviceId) {

    return _connectDevice(device)
        .switchMap(
            (connectedDevice) => connectedDevice.discoverServices().asStream())
        .expand((services) => services)
        .doOnData((service) =>
    "bloc_bluetooth - bluetooth service: ${service.uuid}")
        .where((service) => service.uuid.toString().toUpperCase() == serviceId)
        .doOnData((service) =>
    "bloc_bluetooth - found $serviceId - service: $service");
  }

  BluetoothCharacteristic _getCharacteristic(
      BluetoothService service, String characteristicId) {

    service.characteristics.forEach((characteristic) =>
    "bloc_bluetooth - bluetooth characteristic: ${characteristic.uuid}");
    BluetoothCharacteristic characteristic = service.characteristics.firstWhere(
            (characteristic) =>
        characteristic.uuid.toString().toUpperCase() == characteristicId,
        );

    return characteristic;
  }

  Stream<List<int>> _getValueStream(BluetoothCharacteristic characteristic) {

    return characteristic
        .setNotifyValue(true)
        .asStream()
        .doOnData((listening) => listening
        ? "bloc_bluetooth - listening to characteristic"
        : "bloc_bluetooth - failed to listen to characteristic")
        .switchMap((listening) => characteristic.value);
  }

  dispose() {

    _visibleDevicesSubject.close();
    _connectedDevicesSubject.close();
    _combinedVisibleDevicesSubject.close();
    _isScanningSubject.close();
  }
}
