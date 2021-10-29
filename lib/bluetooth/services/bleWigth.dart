
import 'package:bclose/modules/objects/oximeter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import 'bluetooth_serveces.dart';

// class ScanResultTile extends StatelessWidget {
//
//   ScanResultTile({required this.result,required this.onTap}) ;
//
//   final ScanResult result;
//   final VoidCallback onTap;
//
//   Widget _buildTitle(BuildContext context) {
//     if (result.device.name.length > 0) {
//       return Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Text(
//             result.device.name,
//             overflow: TextOverflow.ellipsis,
//           ),
//           Text(
//             result.device.id.toString(),
//             style: Theme.of(context).textTheme.caption,
//           )
//         ],
//       );
//     } else {
//       return Text(result.device.id.toString());
//     }
//   }
//
//   Widget _buildAdvRow(BuildContext context, String title, String value) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Text(title, style: Theme.of(context).textTheme.caption),
//           SizedBox(
//             width: 12.0,
//           ),
//           Expanded(
//             child: Text(
//               value,
//               style: Theme.of(context)
//                   .textTheme
//                   .caption!
//                   .apply(color: Colors.black),
//               softWrap: true,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   String getNiceHexArray(List<int> bytes) {
//     return '[${bytes.map((i) => i.toRadixString(16).padLeft(2, '0')).join(', ')}]'
//         .toUpperCase();
//   }
//
//   String getNiceManufacturerData(Map<int, List<int>> data) {
//     if (data.isEmpty) {
//       return "";
//     }
//     List<String> res = [];
//     data.forEach((id, bytes) {
//       res.add(
//           '${id.toRadixString(16).toUpperCase()}: ${getNiceHexArray(bytes)}');
//     });
//     return res.join(', ');
//   }
//
//   String getNiceServiceData(Map<String, List<int>> data) {
//     if (data.isEmpty) {
//       return "";
//     }
//     List<String> res = [];
//     data.forEach((id, bytes) {
//       res.add('${id.toUpperCase()}: ${getNiceHexArray(bytes)}');
//     });
//     return res.join(', ');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ExpansionTile(
//       title: _buildTitle(context),
//       leading: Text(result.rssi.toString()),
//       trailing: RaisedButton(
//         child: Text('CONNECT'),
//         color: Colors.black,
//         textColor: Colors.white,
//         onPressed: (result.advertisementData.connectable) ? onTap : null,
//       ),
//       children: <Widget>[
//         _buildAdvRow(
//             context, 'Complete Local Name', result.advertisementData.localName),
//         _buildAdvRow(context, 'Tx Power Level',
//             '${result.advertisementData.txPowerLevel ?? 'N/A'}'),
//         _buildAdvRow(
//             context,
//             'Manufacturer Data',
//             getNiceManufacturerData(
//                 result.advertisementData.manufacturerData) ??
//                 'N/A'),
//         _buildAdvRow(
//             context,
//             'Service UUIDs',
//             (result.advertisementData.serviceUuids.isNotEmpty)
//                 ? result.advertisementData.serviceUuids.join(', ').toUpperCase()
//                 : 'N/A'),
//         _buildAdvRow(context, 'Service Data',
//             getNiceServiceData(result.advertisementData.serviceData) ?? 'N/A'),
//       ],
//     );
//   }
// }
//
// class ServiceTile extends StatelessWidget {
//   final BluetoothService service;
//   final List<CharacteristicTile> characteristicTiles;
//
//   const ServiceTile({required this.service, required this.characteristicTiles})
//       ;
//
//   @override
//   Widget build(BuildContext context) {
//     if (characteristicTiles.length > 0) {
//       return ExpansionTile(
//         title: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Text('Service'),
//             Text('0x${service.uuid.toString().toUpperCase().substring(4, 8)}',
//                 style: Theme.of(context)
//                     .textTheme
//                     .body1!
//                     .copyWith(color: Theme.of(context).textTheme.caption!.color))
//           ],
//         ),
//         children: characteristicTiles,
//       );
//     } else {
//       return ListTile(
//         title: Text('Service'),
//         subtitle:
//         Text('0x${service.uuid.toString().toUpperCase().substring(4, 8)}'),
//       );
//     }
//   }
// }
//
// class CharacteristicTile extends StatelessWidget {
//   final BluetoothCharacteristic characteristic;
//   final List<DescriptorTile> descriptorTiles;
//   final VoidCallback onReadPressed;
//   final VoidCallback onWritePressed;
//   final VoidCallback onNotificationPressed;
//   BluetoothServices bluetoothServices =  Get.put(BluetoothServices());
//
//   CharacteristicTile(
//       {
//         required this.characteristic,
//         required this.descriptorTiles,
//         required this.onReadPressed,
//         required this.onWritePressed,
//         required this.onNotificationPressed})
//       ;
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<List<int>>(
//       stream: characteristic.value,
//       initialData: characteristic.lastValue,
//       builder: (c, snapshot) {
//         final value = snapshot.data;
//         bluetoothServices.getValueStream(characteristic)
//             .doOnData((event) => print("bloc_oximeter event : $event"))
//             .where((value) => value.isNotEmpty)
//             .bufferTest((value) => value.length < 20)
//             .doOnData((value) => print("bloc_oximeter - buffered value: $value"))
//             .where((value) => value[0][2] == 0x41 )
//             .map((value) => OximeterReadingBlt(value, "BLT_M70C"))
//             .where((reading) => reading.measurement.pulseRate! >= 20 && reading.measurement.saturation! >= 20)
//             .doOnData((reading) => print("bloc_oximeter - $reading"))
//             .timeout(Duration(seconds: 40), onTimeout: (sink) => sink.addError("timeout waiting for parsed reading from device", StackTrace.current))
//             .doOnData((currentReading) {
//           if (currentReading.isComplete) {
//             // if (firstFullReading == null) blocLoading.loading = false;
//             // firstFullReading = DateTime.now();
//             print("currentReading.isComplete");
//           }
//
//         })
//             .listen((update) {
//           print(update.measurement.pulseRate);
//           print(update.measurement.perfusion);
//           print(update.measurement.timestamp);
//           print(update.measurement.saturation);
//           // currentMeasurement = update.measurement;
//           // OXIMETRO_READING.value = [update.measurement];
//           print("currentReading.isComplete ${update.measurement}");
//
//           // if (firstFullReading == false){
//           //   firstFullReading = true;
//           //
//           //   Timer(Duration(seconds: 3), onSaveData);
//           //
//           //
//           // }
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
//         return ExpansionTile(
//           title: ListTile(
//             title: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Text('Characteristic'),
//                 Text(
//                     '0x${characteristic.uuid.toString().toUpperCase().substring(4, 8)}',
//                     style: Theme.of(context).textTheme.body1!.copyWith(
//                         color: Theme.of(context).textTheme.caption!.color))
//               ],
//             ),
//             subtitle: Text( value.toString()),
//             contentPadding: EdgeInsets.all(0.0),
//           ),
//           trailing: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               IconButton(
//                 icon: Icon(
//                   Icons.file_download,
//                   color: Theme.of(context).iconTheme.color!.withOpacity(0.5),
//                 ),
//                 onPressed: onReadPressed,
//               ),
//               IconButton(
//                 icon: Icon(Icons.file_upload,
//                     color: Theme.of(context).iconTheme.color!.withOpacity(0.5)),
//                 onPressed: onWritePressed,
//               ),
//               IconButton(
//                 icon: Icon(
//                     characteristic.isNotifying
//                         ? Icons.sync_disabled
//                         : Icons.sync,
//                     color: Theme.of(context).iconTheme.color!.withOpacity(0.5)),
//                 onPressed: onNotificationPressed,
//               )
//             ],
//           ),
//           children: descriptorTiles,
//         );
//       },
//     );
//   }
// }
//
// class DescriptorTile extends StatelessWidget {
//   final BluetoothDescriptor descriptor;
//   final VoidCallback onReadPressed;
//   final VoidCallback onWritePressed;
//
//   const DescriptorTile(
//       {required this.descriptor,required this.onReadPressed,required this.onWritePressed})
//     ;
//
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       title: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Text('Descriptor'),
//           Text('0x${descriptor.uuid.toString().toUpperCase().substring(4, 8)}',
//               style: Theme.of(context)
//                   .textTheme
//                   .body1!
//                   .copyWith(color: Theme.of(context).textTheme.caption!.color))
//         ],
//       ),
//       subtitle: StreamBuilder<List<int>>(
//         stream: descriptor.value,
//         initialData: descriptor.lastValue,
//         builder: (c, snapshot) => Text(snapshot.data.toString()),
//       ),
//       trailing: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           IconButton(
//             icon: Icon(
//               Icons.file_download,
//               color: Theme.of(context).iconTheme.color!.withOpacity(0.5),
//             ),
//             onPressed: onReadPressed,
//           ),
//           IconButton(
//             icon: Icon(
//               Icons.file_upload,
//               color: Theme.of(context).iconTheme.color!.withOpacity(0.5),
//             ),
//             onPressed: onWritePressed,
//           )
//         ],
//       ),
//     );
//   }
// }
//
// class AdapterStateTile extends StatelessWidget {
//   const AdapterStateTile({required this.state}) ;
//
//   final BluetoothState state;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.redAccent,
//       child: ListTile(
//         title: Text(
//           'Bluetooth adapter is ${state.toString().substring(15)}',
//           style: Theme.of(context).primaryTextTheme.subhead,
//         ),
//         trailing: Icon(
//           Icons.error,
//           color: Theme.of(context).primaryTextTheme.subhead!.color,
//         ),
//       ),
//     );
//   }
// }