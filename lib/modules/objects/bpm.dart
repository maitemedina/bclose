

import 'oximeter.dart';

class EnumBpmeterDataType {
  static const EnumBpmeterDataType MEASURING = const EnumBpmeterDataType._internal(32, "Measuring");
  static const EnumBpmeterDataType FINAL = const EnumBpmeterDataType._internal(30, "Final");
  static const EnumBpmeterDataType UNKNOWN = const EnumBpmeterDataType._internal(0, "Unknown");

  static List<EnumBpmeterDataType> values() {
    List values = <EnumBpmeterDataType>[];
    values.add(MEASURING);
    values.add(FINAL);
    values.add(UNKNOWN);
    return values[0];
  }

  final int dataType;
  final String name;

  static EnumBpmeterDataType parse(List<int> data) {
    if(data != null && data.isNotEmpty) {
      if (data.length == 2) {
        return MEASURING;
      } else {
        return FINAL;
      }
    } else {
      return UNKNOWN;
    }

    // switch (data != null && data.isNotEmpty ? (data.first ?? 0) : 0) {
    //   case 32:
    //     return MEASURING;
    //   case 30:
    //     return FINAL;
    //   case 0:
    //   default:
    //     return UNKNOWN;
    // }
  }

  const EnumBpmeterDataType._internal(this.dataType, this.name);

  @override
  String toString() {
    return name;
  }
}

class BpmeterMeasurement implements Measurement {
  static const String PRODUCT_CATEGORY = "bpmeter";
  static const String UNIT = "mmHg";
  static const String UNIT_PULSE = "Bpm";
  static const String LABEL = "Tensão";
  static const String LABEL_SYSTOLIC = "Sys";
  static const String LABEL_DIASTOLIC = "Dia";
  static const String LABEL_PULSE = "Pulso";

  /// range: 25-250, unit: BPM
  final int? pulseRate;
  /// range: 0-200, Sys mmHg
  final int? systolic;
  /// range: 0-200, Dia mmHg
  final int? diastolic;
  @override
  final DateTime timestamp;

  final String? device;

  @override
  bool get isComplete => systolic != null;

  @override
  bool get isSafe => systolic! > 90 && diastolic! < 100;

  BpmeterMeasurement({this.diastolic, this.systolic, this.pulseRate, this.device}):
        timestamp = DateTime.now()
  ;

  BpmeterMeasurement.fromMeasuringBytes(List<int> reading, this.device):
        pulseRate = 0,
        systolic = reading[1],
        diastolic = 0,
        timestamp = DateTime.now()
  ;

  BpmeterMeasurement.fromFinalBytes(List<int> reading, this.device):
        pulseRate = reading[8],
        systolic = reading[2],
        diastolic = reading[4],
        timestamp = DateTime.now()
  ;

  factory BpmeterMeasurement.parse(List<int> reading, String product) {
    switch(EnumBpmeterDataType.parse(reading)) {
      case EnumBpmeterDataType.MEASURING:
        return BpmeterMeasurement.fromMeasuringBytes(reading, product);
      case EnumBpmeterDataType.FINAL:
        return BpmeterMeasurement.fromFinalBytes(reading, product);
      case EnumBpmeterDataType.UNKNOWN:
      default:
        return BpmeterMeasurement.fromFinalBytes(reading, product);
    }
  }

  @override
  BpmeterMeasurement.fromJson(Map<String, dynamic> json):
        pulseRate = int.parse(json?['value']?["pulseRate"] ?? "0"),
        systolic = int.parse(json?['value']?["systolic"]  ?? "0"),
        diastolic = int.parse(json?['value']?["diastolic"]  ?? "0"),
        timestamp = DateTime.now(),
        device = json['mac_address']
  ;

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'product_category': PRODUCT_CATEGORY,
      'product_mac': this.device,
      'values': {
        "pulseRate": this.pulseRate,
        "systolic": this.systolic,
        "diastolic": this.diastolic,
        "timestamp": this.timestamp.toIso8601String(),
      },
    };

    print("toJson - ${json.toString()}");
    return json;
  }

  @override
  String toString() {
    return 'BpmeterMeasurement{${toJson().toString()}}';
  }


}

class BpmeterReading {
  final EnumBpmeterDataType dataType;
  final BpmeterMeasurement measurement;
  String productMac;

  bool get isComplete => measurement?.isComplete ?? false;

  BpmeterReading(List<int> reading, this.productMac):
        dataType = EnumBpmeterDataType.parse(reading),

        measurement = BpmeterMeasurement.parse(reading, productMac)
  ;

  @override
  String toString() {
    return 'BpmeterReading{dataType: $dataType, measurement: $measurement, productMac: $productMac}';
  }

}
