

import 'dart:async';
import 'dart:io';
import 'package:bclose/core/settings/system_settings.dart';
import 'package:bclose/modules/objects/bpm.dart';
import 'package:bclose/modules/objects/product.dart';
import 'package:bclose/modules/objects/thermometer.dart';
import 'package:bclose/util/handler/request_handler.dart';
import 'package:bclose/util/helpers/helpers.dart';
import 'package:bclose/util/mixins/services.dart';
import 'package:bclose/widgets/alert/info_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:bclose/modules/enum/enums.dart';
import 'package:bclose/modules/objects/oximeter.dart';
import 'package:bclose/modules/screens/reusables/devices/preview_device.dart';
import 'package:get/get.dart';
import 'package:bclose/core/shared_preference/interface_shared_preference.dart';
import 'package:bclose/core/shared_preference/shared_preference_service.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'bleWigth.dart';

class BluetoothServices {

  static ILocalStorage localStorage = new PrefsLocalStorageService();


  FlutterBlue flutterBlue = FlutterBlue.instance;
  late StreamSubscription<ScanResult>? scanSubScription;
  late BluetoothDevice? targetDevice;
  late BluetoothCharacteristic? targetCharacteristic;

  var loading = false.obs;
  var loadingScanning = false.obs;
  var finishSave = false.obs;
  var reading = false.obs;
  var readingInt = false.obs;
  var devicesConnect = DevicesConnect.NULL.obs ;
  var OXIMETRO_READING =  <OximeterMeasurement>[].obs;
  var OXIMETRO_SAVE =  <OximeterMeasurement>[].obs;
  var THERMOMETER_SAVE =  <ThermometerMeasurement>[].obs;
  var THERMOMETER_READING =  <ThermometerMeasurement>[].obs;
  var BPM_SAVE =  <BpmeterMeasurement>[].obs;
  var BPM_READING =  <BpmeterMeasurement>[].obs;

  bool firstFullReading  = false;
  BehaviorSubject<OximeterMeasurement> _currentMeasurementSubject = BehaviorSubject();
  Stream<OximeterMeasurement> get currentMeasurementStream => _currentMeasurementSubject.stream;
  OximeterMeasurement? get currentMeasurement2 => _currentMeasurementSubject.value;
  set currentMeasurement(OximeterMeasurement measurement) => _currentMeasurementSubject.add(measurement);




  Stream<bool> init(BuildContext context) {

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

      _proceedSubject.add(true);
      _proceedSubject.close();
       subscription!.cancel();
    }, onError: (e) {

      _proceedSubject.addError(e);
      _proceedSubject.close();
       subscription!.cancel();
    });
    return _proceedSubject.stream;
  }

  Stream<bool> _ensureLocationPermission(BuildContext context) {

    BehaviorSubject<bool> _grantedSubject = BehaviorSubject();
    StreamSubscription? subscription;
    subscription = checkLocationPermission().listen((status) {

      _grantedSubject.add(true);
      _grantedSubject.close();
       subscription!.cancel();
    }, onError: (e, st) {
      Services().alertDialog(context, UIInfoAlert(cb: (f){

        Navigator.pop(context);
        // log.debugLogLine =
        // "bloc_bluetooth - requesting location be turned on";
        _ensureLocationPermission(context).listen((granted) {

                    _grantedSubject.add(true);
                    _grantedSubject.close();
                  }, onError: (e, st) {

                   _grantedSubject.addError(e, st);    //commented due to Recursiveness
                   _grantedSubject.close();
                  });

      }, title: "LOCATION", sub_title: "App needs location permissions to find device"));

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

  Stream<bool> _ensureLocationOn(BuildContext context) {

    BehaviorSubject<bool> _locationOnSubject = BehaviorSubject();
    StreamSubscription? subscription;
    subscription = _checkLocationOn().listen((enabled) {
      if (enabled) {

        _locationOnSubject.add(true);
        _locationOnSubject.close();
        subscription!.cancel();
      } else {

        Services().alertDialog(context, UIInfoAlert(cb: (f){

            Navigator.pop(context);
            // log.debugLogLine =
            // "bloc_bluetooth - requesting location be turned on";
            Location().requestService().asStream().listen((enabled) {
              if (enabled) {
                // log.debugLogLine = "bloc_bluetooth - location turned on";
                _locationOnSubject.add(enabled);
                _locationOnSubject.close();
                // subscription.cancel();
              } else {
                // log.debugLogLine = "bloc_bluetooth - location turned off";
                _locationOnSubject.addError(Exception("Location off"));
                _locationOnSubject.close();
                // subscription.cancel();
              }
            }, onError: (e) {
              // log.debugLogLine =
              // "bloc_bluetooth - location request error";
              _locationOnSubject.addError(e);
              _locationOnSubject.close();
              // subscription.cancel();
            });

        }, title: "LOCATION", sub_title: "Please turn your device's location on!"));


      }
    }, onError: (e) {

      _locationOnSubject.addError(e);
      _locationOnSubject.close();
       subscription!.cancel();
    });
    return _locationOnSubject.stream;
  }

  Stream<bool> _ensureBluetoothOn(BuildContext context) {

    BehaviorSubject<bool> _bluetoothOnSubject = BehaviorSubject();
    StreamSubscription? subscription;
    subscription = flutterBlue.state.listen((state) {

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

        Services().alertDialog(context, UIInfoAlert(cb: (f){

                   Navigator.pop(context);

                    SystemSetting.goto(SettingTarget.BLUETOOTH);

        }, title: "BLUETOOTH", sub_title: "Please turn your device's bluetooth on!"));

          break;
      }
    });
    return _bluetoothOnSubject.stream;
  }

  Stream<bool> _checkLocationOn() {
    return Location().serviceEnabled().asStream();
  }

  Stream<bool> checkLocationPermission() {

    return Location().requestPermission().asStream().map(
            (status) => status == PermissionStatus.granted ? true : throw "denied");
  }







   startScan(String deviceName) async {
     print("Start Scanning");


     loadingScanning.value = true;
     finishSave.value = false;
     readingInt.value = true;
     firstFullReading = false;

     await flutterBlue.startScan(timeout: Duration(seconds: 4));


     print("Start Scanning.......");

     getDevices().listen((element) {
       // stopScan();
       // loadingScanning.value = false;
       print("Start Scanning $element");

       element.forEach((element) async {
         print("Start Scanning Opem");

         if (element.name == deviceName) {
           print("Start Scanning Opem ${FlutterBlue.instance.isScanning}");
           FlutterBlue.instance.stopScan();
           element.connect();
           element.discoverServices();

           loadingScanning.value = false;
           if(readingInt.value){
             readingInt.value = false;
             reading.value = true;
           }

           var serv = element.services.map((event) => event);

           serv.forEach((element) {

             element.forEach((element) {



               element.characteristics.forEach((c) {
                 c.setNotifyValue(!c.isNotifying);
                 c.read();
                 targetCharacteristic = c;
                 print("Bpmresd ${FlutterBlue.instance.isScanning}");
                 if(deviceName == "BLT_M70C")
                    setOximetreDate(c);
                 if(deviceName == "TEMP")
                   setThermometer(c);
                 if(deviceName == "BPM_01")
                   setBpm(c);

               });
             });
           });

           // targetDevice = element;



           // Navigator.of(context)
           //              .push(MaterialPageRoute(builder: (context) {
           //            r.device.connect();
           //            return DeviceScreen(device: r.device);
           //          })),

         }
       }
       );
     });



     var device = getScanResult().map((r) => r
                  );

    print("Start Scanning ${device.length}");
     device.forEach((element) {
       element.forEach((deve) async {
           if (deve.device.name == deviceName) {

             //stopScan();

             var serv = deve.device.services.map((event) => event);

             serv.forEach((element) {

               element.forEach((element) {
                  print(element.uuid);
                 element.characteristics.forEach((c) {
                   c.setNotifyValue(!c.isNotifying);
                   c.read();
                   if(deviceName == "BLT_M70C")
                     setOximetreDate(c);
                   if(deviceName == "TEMP")
                     setThermometer(c);
                   if(deviceName == "BPM_01")
                     setBpm(c);

                 });
               });
             });

             targetDevice = deve.device;


             await deve.device.connect();
             // connectToDevice();
             loading.value = false;
             FlutterBlue.instance.stopScan();
             // Navigator.of(context)
             //              .push(MaterialPageRoute(builder: (context) {
             //            r.device.connect();
             //            return DeviceScreen(device: r.device);
             //          })),

           }
         print(deve.device.name);
         print(deve.device.id);
           deve.device.state.listen((event) { print(event.index);});

       });
       print(element.length);
     });
    // loading.value = true;
    // scanSubScription = flutterBlue.scan(timeout: Duration(seconds: 30))
    //     .listen((oneResult) {
    //   if (oneResult.device.name == deviceName) {
    //
    //     //stopScan();
    //     flutterBlue.stopScan();
    //     targetDevice = oneResult.device;
    //     connectToDevice();
    //     loading.value = false;
    //
    //   }
    // }, onDone: () {
    //   stopScan();
    // });

     // Start scanning

    //
    // scanSubScription = flutterBlue.scan().listen((scanResult) async {
    //
    //   print(scanResult.device.name);
    //   print("scanResult.device.name");
    //
    //     if (scanResult.device.name == deviceName) {
    //
    //       //stopScan();
    //       flutterBlue.stopScan();
    //       targetDevice = scanResult.device;
    //       connectToDevice();
    //       loading.value = false;
    //
    //     }
    //
    //
    //
    //
    //  }, onDone: () => stopScan()
    // );



  }


  setOximetreDate(BluetoothCharacteristic c){

    getValueStream(c)
        .doOnData((event) => print("bloc_oximeter event : $event"))
        .where((value) => value.isNotEmpty)
        .bufferTest((value) => value.length < 20)
        .doOnData((value) => print("bloc_oximeter - buffered value: $value"))
        .where((value) => value[0][2] == 0x41 )
        .map((value) => OximeterReadingBlt(value, "BLT_M70C"))
        .where((reading) => reading.measurement.pulseRate! >= 20 && reading.measurement.saturation! >= 20)
        .doOnData((reading) => print("bloc_oximeter - $reading"))
        .timeout(Duration(seconds: 40), onTimeout: (sink) => sink.addError("timeout waiting for parsed reading from device", StackTrace.current))
        .doOnData((currentReading) {
      if (currentReading.isComplete) {
        // if (firstFullReading == null) blocLoading.loading = false;
        // firstFullReading = DateTime.now();
        print("currentReading.isComplete");
      }

    })
        .listen((update) {

      OXIMETRO_READING.value = [update.measurement];

      if (firstFullReading == false){
        firstFullReading = true;

        Timer(Duration(seconds: 3), onSaveOximetroData);



      }
      // plethysmograph = update.plethysmograph.;
    },
      onError: (e, st) {
        // log.debugLogLine = "bloc_oximeter - error reading: $e - $st";
        // blocLoading.loading = false;
        // device?.bluetoothCharacteristic?.setNotifyValue(false);
        // readingSubscription?.cancel();
        // readingSubscription = null;
        // measuring = false;
        // Util.presentDialog(context: context, message: "failed to read from oximeter, please try again making sure you have the finger properly introduced!", log: log);
      },
    );
  }
  setThermometer(BluetoothCharacteristic c){

    getValueStream(c)
        .doOnData((value) => print(value))
        .where((value) => (value.length) >= 5)
        .map((value) => ThermometerReading(value, "TEMP"))
        .where((reading) =>
    reading.measurement.temperature >= 30 &&
        reading.measurement.temperature <= 50)
        .doOnData((reading) =>  print(reading))
        .timeout(Duration(seconds: 40),
        onTimeout: (sink) => sink.addError(
            "timeout waiting for parsed reading from device",
            StackTrace.current))
        .doOnEach((_) {

    }).listen(
          (update) {
        // log.debugLogLine = "bloc_thermometer - finalized reading";
        // device?.bluetoothCharacteristic?.setNotifyValue(false);
        // currentMeasurement = update.measurement;
        // database.addReading(currentMeasurement);
        // readingSubscription.cancel();
        // readingSubscription = null;
        print("update.measurement");
        THERMOMETER_READING.value = [update.measurement];
        if (firstFullReading == false){
          firstFullReading = true;
          Timer(Duration(seconds: 3), onSaveThermometerData);



        }
      },
      onError: (e, st) {
        // log.debugLogLine = "bloc_thermometer - error reading: $e - $st";
        // device?.bluetoothCharacteristic?.setNotifyValue(false);
        // readingSubscription.cancel();
        // readingSubscription = null;
        // blocLoading.loading = false;
        // //     blocLoading.readytoread = false;
        // Util.presentDialog(
        //     context: context,
        //     message:
        //     "failed to read from thermometer, please try again making sure you're pointing at the forehead and that you're close enough to it!",
        //     log: log);
      },
    );
  }
  setBpm(BluetoothCharacteristic c) {
    print("pulseRate ");
    getValueStream(c)
        .doOnData((value) => value)
        .where((value) => (value?.length ?? 0) >= 2)
    // .map((value) => BpmeterReading(value, device.mac))
        .map((value) => BpmeterReading(value, "BPM_01"))
        .where((reading) =>  reading.measurement.systolic! >= 40 && reading.measurement.diastolic! <= 200)
        .doOnData((reading) => print("bloc_bpmeter - $reading"))
        .timeout(Duration(seconds: 40), onTimeout: (sink) => sink.addError("timeout waiting for parsed reading from device", StackTrace.current))
        .listen((update) {

      print("pulseRate ${update.measurement.pulseRate}");

      switch(update.dataType) {
        case EnumBpmeterDataType.FINAL:
        // blocLoading.loading = false;
        // measuring = false;
        //
        // log.debugLogLine = "bloc_bpmeter - finalized reading";
          c.setNotifyValue(false);
          print("pulseRate ${update.measurement.pulseRate}");
          print(update.measurement.diastolic);
          print(update.measurement.systolic);
          BPM_READING.value = [update.measurement];
          if (firstFullReading == false){
            firstFullReading = true;
            Timer(Duration(seconds: 3), onSaveBpm);

          }
          // currentMeasurement = update.measurement;
          // database.addReading(currentMeasurement);
          // readingSubscription?.cancel();
          // readingSubscription = null;
          break;
        case EnumBpmeterDataType.MEASURING:
          print("pulseRate ${update.measurement.pulseRate}");
          // BPM_READING.value = [update.measurement];
          // if (firstFullReading == false){
          //   firstFullReading = true;
          //   Timer(Duration(seconds: 3), onSaveBpm);
          //
          // }
          break;
        case EnumBpmeterDataType.UNKNOWN:
        default:
          break;
      }
    },
      onError: (e, st) {
        print("pulseRate $e - $st");
        // blocLoading.loading = false;
        // measuring = false;
        //
        // log.debugLogLine = "bloc_bpmeter - error reading: $e - $st";
        // c.setNotifyValue(false);
        //   readingSubscription?.cancel();
        //   readingSubscription = null;
        //   Util.presentDialog(context: context, message: "failed to read from bpmeter, please try again making sure you have the armband properly, secured on the upper arm, and connected to the device!", log: log);
      },
    );
  }






  stopScan() {
    // scanSubScription?.cancel();
    // scanSubScription = null;
    // loading.value = false;
  }

  connectToDevice() async {
     if (targetDevice == null) return;
     await targetDevice!.connect();
     targetDevice!.discoverServices();



    print('DEVICE CONNECTED');
  }

  disconnectFromDevice() {
    if (targetDevice == null) return;

    targetDevice!.disconnect();
    print('Device Disconnected');

  }

  Stream<List<BluetoothDevice>> getDevices(){
    return Stream.periodic(Duration(seconds: 2))
      .asyncMap((_) => FlutterBlue.instance.connectedDevices);
}
  Stream<List<ScanResult>> getScanResult(){
    return FlutterBlue.instance.scanResults;
  }



  Stream<List<int>> getValueStream(BluetoothCharacteristic characteristic) {

    return characteristic
        .setNotifyValue(true)
        .asStream()
        .doOnData((listening) => "")
        .switchMap((listening) => characteristic.value);
  }




  dispose() {
    //
    // _visibleDevicesSubject?.close();
    // _connectedDevicesSubject?.close();
    // _combinedVisibleDevicesSubject?.close();
    // _isScanningSubject?.close();
  }

  void onSaveOximetroData() async {
    var idPatiente =   await localStorage.get("idPatiente").then((value) => value.toString());
    var body = {
      "patient_id" :"${idPatiente}",
      "device_id": "1",
      "device_category_id": "1",
      "mac_address": "123456789",
      "type":"oximetro",
      "value":{
        "saturation": OXIMETRO_READING[0].saturation.toString(),
        "perfusion": OXIMETRO_READING[0].perfusion.toString(),
        "pulseRate": OXIMETRO_READING[0].pulseRate.toString(),
      }
    };
    onSaveData(body );

  }
  void onSaveThermometerData() async {

    var idPatiente =   await localStorage.get("idPatiente").then((value) => value.toString());
    var body = {
      "patient_id" :"${idPatiente}",
      "device_id": "1",
      "device_category_id": "1",
      "mac_address": "123456789",
      "type":"temperature",
      "value":{
        "temperature":THERMOMETER_READING[0].temperature
      }
    };
    onSaveData(body );

  }
  void onSaveBpm() async {

    var idPatiente =   await localStorage.get("idPatiente").then((value) => value.toString());
    var body = {
      "patient_id" :"${idPatiente}",
      "device_id": "1",
      "device_category_id": "1",
      "mac_address": "123456789",
      "type":"bpm",
      "value":{
        "pulseRate":BPM_READING[0].pulseRate,
        "systolic":BPM_READING[0].systolic,
        "diastolic":BPM_READING[0].diastolic,
      }
    };
    onSaveData(body );

  }

  void onSaveData(Map<String,dynamic> body ,) async {
    loading.value = true;



    var value = await RequestHandler.servicesPost(body,"reading/create");
    reading.value = false;
    finishSave.value = true;
    loading.value = false;
    if (value.runtimeType == ErrorRequest){
      // _requestAlertError(context, value);
      //setUser()
    }else{
      FlutterBlue.instance.stopScan();
      targetCharacteristic?.setNotifyValue(false);

      onLoadData();
      // loadingUser(context);
      // Get.back();
    }
  }

  void onLoadData() async {
    // loading.value = true;
    print("OXIMETRO_READING");
    print("OXIMETRO_READING onloadData");

    var idPatiente =   await localStorage.get("idPatiente").then((value) => value.toString());

    print("OXIMETRO_READING");
    print("OXIMETRO_READING ${idPatiente}");

    var body = {

      "patient_id": idPatiente.toString(),
      "device_id": 1,
      "startDate": "",
      "lastDate": ""

    };

    var value = await RequestHandler.servicesPost(body,"reading/list");

    // loading.value = false;
    if (value.runtimeType == ErrorRequest){
      // _requestAlertError(context, value);
      //setUser()
    }else{
      print(value);

      OXIMETRO_SAVE.value = [];
      THERMOMETER_SAVE.value = [];
      BPM_SAVE.value = [];

      for(var item in value){

        if(item["type"]=="oximetro")
        OXIMETRO_SAVE.add(OximeterMeasurement(perfusion: item["value"]["perfusion"],saturation: int.parse(item["value"]["saturation"]), pulseRate: int.parse(item["value"]["pulseRate"]),timestampRegister: Util.getTimestampToData(item["timestamp"])));
        if(item["type"]=="temperature")
          THERMOMETER_SAVE.add(ThermometerMeasurement.fromJson(item));
        if(item["type"]=="bpm")
          print(item);
           BPM_SAVE.add(BpmeterMeasurement.fromJson(item));

      }

      if(OXIMETRO_SAVE.length>0){
        OXIMETRO_READING.value = [OXIMETRO_SAVE.last];
      }
      if(THERMOMETER_SAVE.length>0){
        THERMOMETER_READING.value = [THERMOMETER_SAVE.last];
      }
      if(BPM_SAVE.length>0){
        BPM_READING.value = [BPM_SAVE.last];
      }



    }
  }


}


