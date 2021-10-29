

import 'package:bclose/util/helpers/helpers.dart';

import 'oximeter.dart';

class EnumThermometerMeasurementType {
  static const EnumThermometerMeasurementType CONTROL =
  const EnumThermometerMeasurementType._internal(0x11, "Control");
  static const EnumThermometerMeasurementType EAR =
  const EnumThermometerMeasurementType._internal(0x22, "Ear");
  static const EnumThermometerMeasurementType FOREHEAD =
  const EnumThermometerMeasurementType._internal(0x33, "Forehead");
  static const EnumThermometerMeasurementType OBJECT =
  const EnumThermometerMeasurementType._internal(0x55, "Object");
  static const EnumThermometerMeasurementType BODY =
  const EnumThermometerMeasurementType._internal(2, "Body");
  static const EnumThermometerMeasurementType UNKNOWN =
  const EnumThermometerMeasurementType._internal(0, "Unknown");

  static List<EnumThermometerMeasurementType> values() {
    List values = <EnumThermometerMeasurementType>[];
    values.add(CONTROL);
    values.add(EAR);
    values.add(FOREHEAD);
    values.add(OBJECT);
    values.add(BODY);
    values.add(UNKNOWN);
    return values.first;
  }

  final int dataType;
  final String name;

  static EnumThermometerMeasurementType parse(List<int> data) {
    switch (data != null ? data.length : 0) {
      case 5:
        switch (data[1]) {
          case 0x11:
            return CONTROL;
          case 0x22:
            return EAR;
          case 0x33:
            return FOREHEAD;
          case 0x55:
            return OBJECT;
          default:
            return UNKNOWN;
        }
        break;
      case 6:
        switch (data[5]) {
          case 0x2:
            return BODY;
          default:
            return UNKNOWN;
        }
        break;
      case 0:
      default:
        return UNKNOWN;
    }
  }

  const EnumThermometerMeasurementType._internal(this.dataType, this.name);

  @override
  String toString() {
    return name;
  }
}

class EnumThermometerMeasurementUnit {
  static const EnumThermometerMeasurementUnit CELSIUS =
  const EnumThermometerMeasurementUnit._internal("Celsius", "ºC");
  static const EnumThermometerMeasurementUnit FAHRENHEIT =
  const EnumThermometerMeasurementUnit._internal("Fahrenheit", "ºF");
  static const EnumThermometerMeasurementUnit UNKNOWN =
  const EnumThermometerMeasurementUnit._internal("Unknown", "");

  static List<EnumThermometerMeasurementUnit> values() {
    List values = <EnumThermometerMeasurementUnit>[];
    values.add(CELSIUS);
    values.add(FAHRENHEIT);
    values.add(UNKNOWN);
    return values[0];
  }

  final String name;
  final String unit;

  static EnumThermometerMeasurementUnit parse(List<int> data) {
    switch (data != null ? data.length : 0) {
      case 5:
        switch (data[2] & 0x80) {
          case 0x00: // 0b00000000
            return CELSIUS;
          case 0x80: // 0b10000000
            return FAHRENHEIT;
          case 0xFF:
          default:
            return UNKNOWN;
        }
        break;
      case 6:
        switch (data[5] & 0x1) {
          case 0x0: // 0b00000000
            return CELSIUS;
          case 0x1: // 0b00000001
            return FAHRENHEIT;
          default:
            return UNKNOWN;
        }
        break;
      case 0:
      default:
        return UNKNOWN;
    }
  }

  static EnumThermometerMeasurementUnit fromJson(String data) {
    switch (data) {
      case "ºC":
        return CELSIUS;
      case "ºF":
        return FAHRENHEIT;
      case "":
      default:
        return UNKNOWN;
    }
  }

  const EnumThermometerMeasurementUnit._internal(this.name, this.unit);

  @override
  String toString() {
    return name;
  }
}

class ThermometerMeasurement implements Measurement {
  static const String PRODUCT_CATEGORY = "thermometer";
  static const String LABEL = "Temperature";
  final EnumThermometerMeasurementUnit unit;

  /// range: 0-, unit: ºC or ºF
  final double temperature;
  @override
  final DateTime timestamp;

  final String device;

  @override
  bool get isComplete => temperature != null && temperature > 34;

  @override
  bool get isSafe => temperature < 37.5;



  ThermometerMeasurement(List<int> reading, this.device)
      : unit = EnumThermometerMeasurementUnit.parse(reading),
        temperature = decodeTemperature(reading),
        timestamp = DateTime.now();

  static double decodeTemperature(List<int> reading) {
    switch (reading != null ? reading.length : 0) {
      case 5:
        int high = reading[2] & 0x7F; //Filter first bit
        int low = reading[3];
        return ((high << 8) | low) * 0.01;
      case 6:
        int high = reading[2];
        int low = reading[1];
        return ((high << 8) | low) * 0.01;
      default:
        return 0;
    }
  }

  factory ThermometerMeasurement.parse(List<int> reading, String product) {
    if (reading != null && reading.length >= 5) {
      return ThermometerMeasurement(reading, product);
    } else {
      return ThermometerMeasurement(reading, product);
    }
  }

  @override
  ThermometerMeasurement.fromJson(Map<String, dynamic> json)
      : unit = EnumThermometerMeasurementUnit.CELSIUS,
        temperature = double.parse(json['value']['temperature'].toString()),
        timestamp = Util.getTimestampToData(json['timestamp']),
        device = json['mac_address'];

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'product_category': PRODUCT_CATEGORY,
      'product_mac': this.device,
      'values': {
        'unit': this.unit.toString(),
        'temperature': this.temperature,
        'timestamp': this.timestamp.toIso8601String(),
      },
    };

    print("toJson - ${json.toString()}");
    return json;
  }

  @override
  String toString() {
    return 'ThermometerMeasurement{${toJson().toString()}}';
  }
}

class ThermometerReading {
  final EnumThermometerMeasurementType dataType;
  final ThermometerMeasurement measurement;
  final int checksum;

  final String product;

  bool get isComplete => measurement.isComplete;

  ThermometerReading(List<int> reading, this.product)
      : dataType = EnumThermometerMeasurementType.parse(reading),
        measurement = ThermometerMeasurement.parse(reading, product),
        checksum = reading != null && reading.length == 5 ? reading[4] : 0;

  @override
  String toString() {
    return 'ThermometerReading{dataType: $dataType, measurement: $measurement, checksum: $checksum, product; $product}';
  }
}
