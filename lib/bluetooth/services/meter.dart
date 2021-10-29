import 'dart:async';

import 'package:bclose/constants/app_colors.dart';
import 'package:bclose/modules/objects/product.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'blueTest.dart';

class BlocMeter {

  late BlocBluetooth bluetooth;


  late StreamSubscription scanningSubscription;


  BehaviorSubject<bool> _isScanningSubject = BehaviorSubject.seeded(false);

  Stream<bool> get isScanningStream => _isScanningSubject.stream;

  bool? get scanning2 => _isScanningSubject.value;

  set scanning(bool measuring) => _isScanningSubject.add(measuring);

  EnumProductCategory deviceCategory = EnumProductCategory.UNKNOWN;

  BehaviorSubject<Product> _deviceSubject = BehaviorSubject();

  Stream<Product> get deviceStream => _deviceSubject.stream;

  Product? get device2 => _deviceSubject.value;

  set device(Product device) => _deviceSubject.add(device);

  late DateTime firstFullReading;

   BlocMeter(this.bluetooth);

  Stream<List<Product>> scanningStream(
      BuildContext context,
      Stream<List<Product>> knownDevices,
      EnumProductCategory deviceCategory,
      Function(Product) action) {

    this.deviceCategory = deviceCategory;
    showDialogKnownDevicesInRange(context, action);
    return bluetooth
        .init(context)
        .doOnData((success) => print( "bloc_meter - proceeding"))
        .switchMap((_) => knownDevices)
        .take(1)
        .doOnData((devices) =>
    print("bloc_meter - known devices list - $devices"))
        .switchMap((devices) =>
        bluetooth.startScanning(context: context, devices: devices))
        .where((devices) => devices?.isNotEmpty ?? false);
  }

  void showDialogKnownDevicesInRange(
      BuildContext context, Function(Product) action) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return StreamBuilder<List<Product>>(
            stream: bluetooth.combinedVisibleDevicesStream
                .map((devices) => devices
                .where((device) => device.category == deviceCategory)
                .toList(growable: false))
                .timeout(Duration(seconds: 15),
                onTimeout: (sink) => sink.addError(
                    "timeout waiting for recognized device",
                    StackTrace.current)),
            initialData: bluetooth.combinedVisibleDevices,
            builder: (context, snapshot) {
              String title = "";
              Widget content = Container();
              List<Widget>? actions;
              if (snapshot?.hasError ?? false) {
                // blocLoading.loading = false;
                title = "No known devices found!";
                content = Container(
                    width: 150,
                    height: 150,
                    child: Center(
                        child: Text(
                            "Please try again, making sure you are using the correct device, that it's in range, and that it's turned on!")));
                actions = <Widget>[
                  FlatButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Ok"))
                ];
              } else if (snapshot == null ||
                  !snapshot.hasData ||
                  snapshot.data!.isEmpty) {
                title = "Searching...";
                content = Container(
                    width: 150,
                    height: 150,
                    child: Center(
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.GREEN))));
              } else {
                // blocLoading.loading = false;
                title = "Select your device from the list:";
                content = Container(
                  width: 200,
                  height: 200,
                  child: ListView.builder(
                    itemCount: snapshot?.data?.length ?? 0,
                    itemBuilder: (context, index) => snapshot != null &&
                        snapshot.data != null &&
                        snapshot.data!.isNotEmpty
                        ? ListTile(
                      title:
                      Text(snapshot.data![index].bluetoothDevice!.name),
                      subtitle: Text(
                          "id: ${snapshot.data![index].bluetoothDevice!.id}"),
                      onTap: () {
                        // blocLoading.loading = true;
                        // blocLoading.readytoread = true;
                        device = snapshot.data![index];

                        bluetooth.stopScan();
                        Navigator.pop(context);
                        action(device2!);
                      },
                    )
                        : Container(),
                  ),
                );
              }
              return WillPopScope(
                onWillPop: () {
                  if (snapshot?.hasError ?? false) {
                    // blocLoading.loading = false;
                    return Future.value(false);
                  } else {
                    // blocLoading.loading = false;
                    bluetooth.stopScan();
                    return Future.value(true);
                  }
                },
                child: AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  title: Text(title),
                  content: content,
                  actions: actions,
                ),
              );
            });
      },
    );
  }

  Stream<bool> startScanning(
      BuildContext context,
      Stream<List<Product>> knownDevices,
      EnumProductCategory deviceCategory,
      Function(Product) action) {
    // this.blocLoading = blocLoading;
    BehaviorSubject<bool> _finding = BehaviorSubject();
    // blocLoading.loading = true;
    // log.debugLogLine = "bloc_meter - start scanning";
    scanningSubscription?.cancel();
    scanningSubscription =
        scanningStream(context, knownDevices, deviceCategory, action)
            .doOnEach((_) => "")
            .listen(
              (connected) {
            print("bloc_meter - started finding known meters");
            _finding.add(true);
            _finding.close();
            scanningSubscription?.cancel();
            // scanningSubscription = null;
          },
          onError: (e, st) {
            // log.debugLogLine = "bloc_meter - error scanning - $e - $st";
            _finding.add(false);
            _finding.close();
            // Util.presentDialog(
            //     context: context, message: "No known meters found!", log: log);
            scanningSubscription?.cancel();
            // scanningSubscription = null;
          },
        );
    return _finding.stream;
  }

  dispose() {
    scanningSubscription?.cancel();
    // scanningSubscription = null;
  }
}
