

class EnumOximeterDataType {
  static const EnumOximeterDataType PLETHYSMOGRAPH = const EnumOximeterDataType._internal(0x80, "Plethysmograph");
  static const EnumOximeterDataType MEASUREMENT = const EnumOximeterDataType._internal(0x81, "Measurement");
  static const EnumOximeterDataType UNKNOWN = const EnumOximeterDataType._internal(0, "Unknown");

  static List<EnumOximeterDataType> values() {
    List values = <EnumOximeterDataType>[];
    values.add(PLETHYSMOGRAPH);
    values.add(MEASUREMENT);
    values.add(UNKNOWN);
    return values[0];
  }

  final int dataType;
  final String name;

  static EnumOximeterDataType parse(List<int> data) {
    switch (data.first) {
      case 0x80:
        return PLETHYSMOGRAPH;
      case 0x81:
        return MEASUREMENT;
      case 0:
      default:
        return UNKNOWN;
    }
  }

  const EnumOximeterDataType._internal(this.dataType, this.name);

  @override
  String toString() {
    return name;
  }
}

class OximeterPlethysmograph {
  final List<int> values;

  OximeterPlethysmograph._(List<int> reading):
        values = reading.sublist(1).asMap().map((index, input) => MapEntry(9-index, decode(input))).values.toList()
  ;

  OximeterPlethysmograph(List<int> reading) : this._(reading);

  static int decode(int input) => input != 0x7F ? input : 0/*null*/;

  factory OximeterPlethysmograph.parse(List<int> reading) {
    if (EnumOximeterDataType.parse(reading) == EnumOximeterDataType.PLETHYSMOGRAPH) {
      return OximeterPlethysmograph(reading);
    } else {
      return  OximeterPlethysmograph([0]);
    }
  }

  @override
  String toString() {
    return 'OximeterPlethysmograph{values: $values}';
  }

}

class OximeterMeasurement implements Measurement {
  static const String PRODUCT_CATEGORY = "oximeter";
  static const String UNIT_SATURATION = "%";
  static const String UNIT_PERFUSION = "%";
  static const String UNIT_PULSE = "BPM";
  static const String LABEL = "Oximetro";
  static const String LABEL_SATURATION = "SpO2";
  static const String LABEL_PERFUSION = "PI";
  static const String LABEL_PULSE = "Pulso";

  /// range: 25-250, unit: BPM
  final int? pulseRate;
  /// range: 35-100, SpO2%
  late final int? saturation;
  /// range: 0-200, PI%
  final String? perfusion;
  @override
  final DateTime timestamp;

  @override
  final DateTime timestampRegister;

  final String? device;

  @override
  bool get isComplete => pulseRate != null && saturation != null && perfusion != null;

  @override
  bool get isSafe => saturation! > 90;

  OximeterMeasurement({this.perfusion,  this.saturation,  this.pulseRate,  this.device,required this.timestampRegister}):
        timestamp = DateTime.now()
  ;

  OximeterMeasurement.fromBytes(List<int> reading, this.device):
        pulseRate = decodePulseRate(reading[1]),
        saturation = decodeSaturation(reading[2]),
        perfusion = decodePerfusion(reading[3]).toStringAsFixed(1),
        timestamp = DateTime.now(),
        timestampRegister = DateTime.now()
  ;

  static int decodePulseRate(int input) => input != 0xFF ? input : 0/*null*/;
  static int decodeSaturation(int input) => input != 0x7F ? input : 0/*null*/;
  static double decodePerfusion(int input) => input != 0x7F ? input*0.1 : 0/*null*/;

  factory OximeterMeasurement.parse(List<int> reading, String product) {
    if (EnumOximeterDataType.parse(reading) == EnumOximeterDataType.MEASUREMENT) {
      return OximeterMeasurement.fromBytes(reading, product);
    } else {
      return OximeterMeasurement.fromBytes(reading, product);
    }
  }

  factory OximeterMeasurement.parseBlt(List<int> reading, String product) {
    return OximeterMeasurement(
        perfusion: reading[15] != 255 ? (reading[15]*0.1).toStringAsFixed(1) : "0",
        saturation: reading[16] != 127 ? reading[16] : 0,
        pulseRate: reading[17] != 255 ? reading[17] : 0,
        device: product, timestampRegister: DateTime.now()
    );
  }

  @override
  OximeterMeasurement.fromJson(Map<String, dynamic> json,):
        pulseRate = json['values']["pulseRate"],
        saturation = json['values']["saturation"],
        perfusion = json['values']["perfusion"] is int ? (json['values']["perfusion"] as int).toDouble() : json['values']["perfusion"],
        timestamp = DateTime.parse(json['values']["timestamp"]),
        device = json['product_mac'],
        timestampRegister = json['values']["pulseRate"]
  ;

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'product_category': PRODUCT_CATEGORY,
      'product_mac': this.device,
      'values': {
        "pulseRate": this.pulseRate,
        "saturation": this.saturation,
        "perfusion": this.perfusion,
        "timestamp": this.timestamp.toIso8601String(),
      },
    };

    print("toJson - ${json.toString()}");
    return json;
  }

  @override
  String toString() {
    return 'OximeterMeasurement{${toJson().toString()}}';
  }


}

class OximeterReading {
  final EnumOximeterDataType dataType;
  final OximeterPlethysmograph plethysmograph;
  final OximeterMeasurement measurement;
  String productMac;

  bool get isComplete => measurement.isComplete;

  OximeterReading(List<int> reading, this.productMac):
        dataType = EnumOximeterDataType.parse(reading),
        plethysmograph = OximeterPlethysmograph.parse(reading),
        measurement = OximeterMeasurement.parse(reading, productMac)
  ;

  @override
  String toString() {
    return 'OximeterReading{dataType: $dataType, plethysmograph: $plethysmograph, measurement: $measurement, productMac: $productMac}';
  }

}

class OximeterReadingBlt {
  final OximeterPlethysmograph? plethysmograph;
  final OximeterMeasurement measurement;
  String productMac;

  bool get isComplete => measurement.isComplete;

  OximeterReadingBlt(List<List<int>> reading, this.productMac):
        plethysmograph = null,//OximeterPlethysmograph.parse(reading),
        measurement = OximeterMeasurement.parseBlt(reading[1], productMac)
  ;

  @override
  String toString() {
    return 'OximeterReadingBlt{plethysmograph: $plethysmograph, measurement: $measurement, productMac: $productMac}';
  }

}


abstract class Measurement {
  DateTime get timestamp;
  bool get isComplete;
  bool get isSafe;
  String toString();
  Measurement.fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();
}