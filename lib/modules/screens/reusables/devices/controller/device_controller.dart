
import 'dart:async';
import 'dart:developer';

import 'package:bclose/bluetooth/services/blueTest.dart';
import 'package:bclose/bluetooth/services/bluetooth_serveces.dart';
import 'package:bclose/core/shared_preference/interface_shared_preference.dart';
import 'package:bclose/core/shared_preference/shared_preference_service.dart';
import 'package:bclose/modules/enum/enums.dart';
import 'package:bclose/modules/objects/oximeter.dart';
import 'package:bclose/modules/objects/product.dart';
import 'package:bclose/modules/objects/thermometer.dart';
import 'package:bclose/util/handler/request_handler.dart';
import 'package:bclose/util/helpers/helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

import '../preview_device.dart';

class DeviceController extends GetxController{
  static ILocalStorage localStorage = new PrefsLocalStorageService();
  BluetoothServices bluetoothServices =  Get.find();

  var loading = false.obs;
  var devicesConnect = DevicesConnect.NULL.obs;
  var OXIMETRO_READING =  <OximeterMeasurement>[].obs;
  var OXIMETRO_SAVE =  <OximeterMeasurement>[].obs;
  var THERMOMETER_READING =  <ThermometerMeasurement>[].obs;
  bool firstFullReading  = false;
  // late BlocBluetooth bluetooth;

startScan(String deviceName, BuildContext context) async {
   // bluetoothServices.init(context);
  print("startDevice");
   bluetoothServices.startScan(deviceName);

  // bluetoothServices.startScan(deviceName);
  // blocOximeter.s
  // _blocOximeter.startReading(context);



}

discoverServices() async {

  Get.to(Preview_device_Page());
  devicesConnect.value = DevicesConnect.OXIMETRO;
  // var serv = bluetoothServices.targetDevice!.services.map((event) => event);
  //
  // serv.forEach((element) {
  //
  //   element.forEach((element) {
  //
  //     print(element.uuid);
  //
  //     element.characteristics.forEach((c) {
  //       c.setNotifyValue(!c.isNotifying);
  //       c.read();
  //       // targetCharacteristic = c;
  //       bluetoothServices.getValueStream(c)
  //           .doOnData((event) => print("bloc_oximeter event : $event"))
  //           .where((value) => value.isNotEmpty)
  //           .bufferTest((value) => value.length < 20)
  //           .doOnData((value) => print("bloc_oximeter - buffered value: $value"))
  //           .where((value) => value[0][2] == 0x41 )
  //           .map((value) => OximeterReadingBlt(value, "BLT_M70C"))
  //           .where((reading) => reading.measurement.pulseRate! >= 20 && reading.measurement.saturation! >= 20)
  //           .doOnData((reading) => print("bloc_oximeter - $reading"))
  //           .timeout(Duration(seconds: 40), onTimeout: (sink) => sink.addError("timeout waiting for parsed reading from device", StackTrace.current))
  //           .doOnData((currentReading) {
  //         if (currentReading.isComplete) {
  //           // if (firstFullReading == null) blocLoading.loading = false;
  //           // firstFullReading = DateTime.now();
  //           print("currentReading.isComplete");
  //         }
  //
  //       })
  //           .listen((update) {
  //         print(update.measurement.pulseRate);
  //         print(update.measurement.perfusion);
  //         print(update.measurement.timestamp);
  //         print(update.measurement.saturation);
  //         // currentMeasurement = update.measurement;
  //         // OXIMETRO_READING.value = [update.measurement];
  //         print("currentReading.isComplete ${update.measurement}");
  //
  //         // if (firstFullReading == false){
  //         //   firstFullReading = true;
  //         //
  //         //   Timer(Duration(seconds: 3), onSaveData);
  //         //
  //         //
  //         // }
  //         // plethysmograph = update.plethysmograph.;
  //       },
  //         onError: (e, st) {
  //           // log.debugLogLine = "bloc_oximeter - error reading: $e - $st";
  //           // blocLoading.loading = false;
  //           // device?.bluetoothCharacteristic?.setNotifyValue(false);
  //           // readingSubscription?.cancel();
  //           // readingSubscription = null;
  //           // measuring = false;
  //           // Util.presentDialog(context: context, message: "failed to read from oximeter, please try again making sure you have the finger properly introduced!", log: log);
  //         },
  //       );
  //     });
  //   });
  // });
}

  // bool setCharacteristicNotification (BluetoothGattCharacteristic characteristic,
  //     boolean enable);

  startReadingJmp() async {
    Get.to(Preview_device_Page());
    devicesConnect.value = DevicesConnect.OXIMETRO;

    if (bluetoothServices.targetDevice == null) return;


    List<BluetoothService> services = await bluetoothServices.targetDevice!.discoverServices();



    services.forEach((service) {
      print("characteristic. cont ${service.uuid}");

      if (service.uuid.toString() == "00001801-0000-1000-8000-00805f9b34fb") {

        service.characteristics.forEach((characteristic) async {

          print("characteristic. cont ${characteristic.uuid}");
          bluetoothServices.getValueStream(characteristic)
              .doOnData((value) => print("object"))
              .where((value) => value.isNotEmpty)
              .map((value) => OximeterReading(value, "BLT_M70C"))
              .where((reading) => reading.measurement.pulseRate! >= 20 && reading.measurement.saturation! >= 20)
              .doOnData((reading) { if (reading.dataType == EnumOximeterDataType.MEASUREMENT) print("bloc_oximeter - $reading");})
              .timeout(Duration(seconds: 40), onTimeout: (sink) => sink.addError("timeout waiting for parsed reading from device", StackTrace.current))
              .doOnData((currentReading) {
            if (currentReading.isComplete) {
              // if (firstFullReading == null) blocLoading.loading = false;
              // firstFullReading ??= DateTime.now();
              // log.debugLogLine = "bloc_oximeter - first full reading - ${firstFullReading.toIso8601String()}";
            }
            // if (firstFullReading != null && DateTime.now().isAfter(firstFullReading.add(Duration(seconds: 30)))) {
            //   log.debugLogLine = "bloc_oximeter - finalized reading";
            //   device?.bluetoothCharacteristic?.setNotifyValue(false);
            //   firstFullReading = null;
            //   database.addReading(currentMeasurement);
            //   measuring = false;
            //   readingSubscription?.cancel();
            //   readingSubscription = null;
            // }
          })
              .listen((update) {
            switch (update.dataType) {
              case EnumOximeterDataType.MEASUREMENT:
                // currentMeasurement = update.measurement;
                OXIMETRO_READING.value = [update.measurement];
                break;
              case EnumOximeterDataType.PLETHYSMOGRAPH:
                // plethysmograph = update.plethysmograph;
              print(update.plethysmograph);
                break;
              default:
                break;
            }
          },
            onError: (e, st) {
              // log.debugLogLine = "bloc_oximeter - error reading: $e - $st";
              // blocLoading.loading = false;
              // device?.bluetoothCharacteristic?.setNotifyValue(false);
              // readingSubscription?.cancel();
              // readingSubscription = null;
              // measuring = false;
              // Util.presentDialog(context: context, message: e.toString(), log: log);
            },
          );


        });

      }


    });




  }

  discoverTEMPServices() async {

    Get.to(Preview_device_Page());
    devicesConnect.value = DevicesConnect.THERMOMETER;

    if (bluetoothServices.targetDevice == null) return;

    List<BluetoothService> services = await bluetoothServices.targetDevice!.discoverServices();



    services.forEach((service) {

      print("service.uuid.toString()");
      print(service.uuid.toString());

       if (service.uuid.toString() == "0000ffe1-0000-1000-8000-00805f9b34fb") {
         print("characteristic. cont ${service.characteristics.length}");
         service.characteristics.forEach((characteristic) async {


           bluetoothServices.getValueStream(characteristic)
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
               print(update.measurement);
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

         });
       }


    });
  }

  void onSaveData() async {
    loading.value = true;

    var idPatiente =   await localStorage.get("idPatiente").then((value) => value.toString());

    print("OXIMETRO_READING");
    print("OXIMETRO_READING ${idPatiente}");

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


    print("OXIMETRO_READING");
    print("OXIMETRO_READING");

    var value = await RequestHandler.servicesPost(body,"reading/create");
    print(" OXIMETRO_READING");
    print("OXIMETRO_READING $value");
    print(" OXIMETRO_READING");
    print(" OXIMETRO_READING");
    print(" OXIMETRO_READING");
    loading.value = false;
    if (value.runtimeType == ErrorRequest){
      // _requestAlertError(context, value);
      //setUser()
    }else{
      print(value);
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
    print("OXIMETRO_READING");
    print("OXIMETRO_READING $value");
    print("OXIMETRO_READING");
    print("OXIMETRO_READING");
    print("OXIMETRO_READING");
    // loading.value = false;
    if (value.runtimeType == ErrorRequest){
      // _requestAlertError(context, value);
      //setUser()
    }else{
      print(value);

      OXIMETRO_SAVE.value = [];

     for(var item in value){
       OXIMETRO_SAVE.add(OximeterMeasurement(perfusion: item["value"]["perfusion"],saturation: int.parse(item["value"]["saturation"]), pulseRate: int.parse(item["value"]["pulseRate"]),timestampRegister: Util.getTimestampToData(item["timestamp"])));
     }


    }
  }


  // startReadingJmp3(BuildContext context) {
  //   print("Starte scam");
  //   Get.to(Preview_device_Page());
  //   devicesConnect.value = DevicesConnect.OXIMETRO;
  //
  //   var device = bluetooth.startReading(Product(bleService: "00001801-0000-1000-8000-00805f9b34fb",bleName: "BLT_M70C",bleCharacteristic: "CDEACB81-5235-4C07-8846-93A37EE6B86D",isPaired: true,category: EnumProductCategory.OXIMETER,supplier: ""))
  //       .doOnData((value) => "value Straem : ${value}")
  //       .where((value) => value?.isNotEmpty ?? false)
  //       .map((value) => OximeterReading(value, "BLT_M70C"))
  //       .where((reading) => reading.measurement.pulseRate! >= 20 && reading.measurement.saturation! >= 20)
  //       .doOnData((reading) { if (reading.dataType == EnumOximeterDataType.MEASUREMENT) print("bloc_oximeter - $reading");})
  //       .timeout(Duration(seconds: 40), onTimeout: (sink) => sink.addError("timeout waiting for parsed reading from device", StackTrace.current))
  //       .doOnData((currentReading) {
  //         print(currentReading.measurement);
  //     // if (currentReading.isComplete) {
  //     //   if (firstFullReading == null) blocLoading.loading = false;
  //     //   firstFullReading;
  //     //   print("bloc_oximeter - first full reading - ${firstFullReading.toIso8601String()}");
  //     // }
  //     // if (firstFullReading != null && DateTime.now().isAfter(firstFullReading.add(Duration(seconds: 30)))) {
  //     //   log.debugLogLine = "bloc_oximeter - finalized reading";
  //     //   device?.bluetoothCharacteristic?.setNotifyValue(false);
  //     //   firstFullReading = null;
  //     //   database.addReading(currentMeasurement);
  //     //   measuring = false;
  //     //   readingSubscription?.cancel();
  //     //   readingSubscription = null;
  //     // }
  //   })
  //       .listen((update) {
  //     switch (update.dataType) {
  //       case EnumOximeterDataType.MEASUREMENT:
  //         print(update.measurement);
  //         break;
  //       case EnumOximeterDataType.PLETHYSMOGRAPH:
  //         print(update.plethysmograph);
  //         break;
  //       default:
  //         break;
  //     }
  //   },
  //     onError: (e, st) {
  //       // log.debugLogLine = "bloc_oximeter - error reading: $e - $st";
  //       // blocLoading.loading = false;
  //       // device?.bluetoothCharacteristic?.setNotifyValue(false);
  //       // readingSubscription?.cancel();
  //       // readingSubscription = null;
  //       // measuring = false;
  //       // Util.presentDialog(context: context, message: e.toString(), log: log);
  //     },
  //   );
  //   print("Starte device");
  //   device.onData((data) {print(data.measurement.pulseRate);});
  //   print("Starte device");
  //
  // }




}