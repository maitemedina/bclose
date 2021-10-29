
import 'package:bclose/core/shared_preference/interface_shared_preference.dart';
import 'package:bclose/core/shared_preference/shared_preference_service.dart';
import 'package:bclose/modules/objects/oximeter.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get.dart';

class OximeterController extends GetxController{
  static ILocalStorage localStorage = new PrefsLocalStorageService();
  var OXIMETRO_READING =  <OximeterMeasurement>[].obs;

  // discoverServices() async {
  //
  //   if (targetDevice == null) return;
  //
  //   List<BluetoothService> services = await targetDevice!.discoverServices();
  //
  //
  //
  //   services.forEach((service) {
  //
  //     if (service.uuid.toString() == "0000ffe0-0000-1000-8000-00805f9b34fb") {
  //       print("characteristic. cont ${service.characteristics.length}");
  //       service.characteristics.forEach((characteristic) async {
  //
  //
  //         _getValueStream(characteristic)
  //             .doOnData((event) => print("bloc_oximeter : $event"))
  //             .where((event) => event?.isNotEmpty ?? false)
  //             .bufferTest((value) => value.length < 20)
  //             .doOnData((value) => print("bloc_oximeter - buffered value: $value"))
  //             .where((value) => value[0][2] == 0x41)
  //             .map((value) => OximeterReadingBlt(value, "BLT_M70C"))
  //             .where((reading) => reading.measurement.pulseRate! >= 20 && reading.measurement.saturation! >= 20)
  //             .doOnData((reading) => print("bloc_oximeter - $reading"))
  //             .timeout(Duration(seconds: 40), onTimeout: (sink) => sink.addError("timeout waiting for parsed reading from device", StackTrace.current))
  //             .doOnData((currentReading) {
  //           if (currentReading.isComplete) {
  //             print("currentReading.isComplete");
  //           }
  //           // if (firstFullReading != null && DateTime.now().isAfter(firstFullReading.add(Duration(seconds: 30)))) {
  //           // log.debugLogLine = "bloc_oximeter - finalized reading blt";
  //           // device?.bluetoothCharacteristic?.setNotifyValue(false);
  //           // firstFullReading = null;
  //           // database.addReading(currentMeasurement);
  //           // measuring = false;
  //           // readingSubscription?.cancel();
  //           // readingSubscription = null;
  //           // }
  //         })
  //             .listen((update) {
  //           // print(update.measurement.pulseRate);
  //           // print(update.measurement.perfusion);
  //           // print(update.measurement.timestamp);
  //           // print(update.measurement.saturation);
  //           // currentMeasurement = update.measurement;
  //           OXIMETRO_READING.value = [update.measurement];
  //           // plethysmograph = update.plethysmograph.;
  //         },
  //           onError: (e, st) {
  //             // log.debugLogLine = "bloc_oximeter - error reading: $e - $st";
  //             // blocLoading.loading = false;
  //             // device?.bluetoothCharacteristic?.setNotifyValue(false);
  //             // readingSubscription?.cancel();
  //             // readingSubscription = null;
  //             // measuring = false;
  //             // Util.presentDialog(context: context, message: "failed to read from oximeter, please try again making sure you have the finger properly introduced!", log: log);
  //           },
  //         );
  //
  //
  //       });
  //     }
  //   });
  // }



}