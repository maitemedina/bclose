
import 'package:flutter_blue/flutter_blue.dart';

import 'oximeter.dart';

class EnumProductCategory {
  static const EnumProductCategory OXIMETER = const EnumProductCategory._internal(
      OximeterMeasurement.PRODUCT_CATEGORY,
      "CDEACB80-5235-4C07-8846-93A37EE6B86D",
      "CDEACB81-5235-4C07-8846-93A37EE6B86D",
      true
  );
  // static const EnumProductCategory THERMOMETER = const EnumProductCategory._internal(
  //     // ThermometerMeasurement.PRODUCT_CATEGORY,
  //     "0000FFF0-0000-1000-8000-00805F9B34FB",
  //     "0000FFF3-0000-1000-8000-00805F9B34FB",
  //     true
  // );
  // static const EnumProductCategory BPMETER = const EnumProductCategory._internal(
  //     BpmeterMeasurement.PRODUCT_CATEGORY,
  //     "",
  //     "",
  //     true
  // );
  static const EnumProductCategory UNKNOWN = const EnumProductCategory._internal("Unknown", "", "", false);

  static List<EnumProductCategory> values() {
    List values = <EnumProductCategory>[];
    values.add(OXIMETER);
    // values.add(THERMOMETER);
    // values.add(BPMETER);
    values.add(UNKNOWN);
    return values[0];
  }

  final String name;
  final String serviceId;
  final String characteristicId;
  final bool isNotify;

  static EnumProductCategory parse(String category) {
    switch (category) {
      case OximeterMeasurement.PRODUCT_CATEGORY:
        return OXIMETER;
      // case ThermometerMeasurement.PRODUCT_CATEGORY:
      //   return THERMOMETER;
      // case BpmeterMeasurement.PRODUCT_CATEGORY:
      //   return BPMETER;
      case "":
      default:
        return UNKNOWN;
    }
  }

  const EnumProductCategory._internal(this.name, this.serviceId, this.characteristicId, this.isNotify);

  @override
  String toString() {
    return name;
  }

}

class Product {
  static const String SUPPLIER_BLT = "suppliers/blt";

  final EnumProductCategory? category;
  final String? name;
  final String? bleName;
  final String? bleService;
  final String? bleCharacteristic;
  final String? supplier;
  final bool? isPaired;
  BluetoothDevice? bluetoothDevice;
  BluetoothCharacteristic? bluetoothCharacteristic;

  bool get isVisible => bluetoothDevice != null;

  String get id => "${category}_$name";

  Product({ this.category,  this.bleName,  this.bleService,  this.bleCharacteristic,  this.name,  this.supplier,  this.isPaired});

  factory Product.fromJson(Map<String, dynamic> product, String userId) {
    return Product(
      category: EnumProductCategory.parse(product["category"]),
      bleName: product.containsKey('ble_name') ? product['ble_name'] : product['name'], //note the fallback name won't work for discovery
      bleService: product["ble_service"],
      bleCharacteristic: product["ble_characteristic"],
      name: product["name"],
      supplier: product["supplier"],
      isPaired: (product['users'] != null ? (product['users'].contains('/users/$userId') ?? false) : false),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "category": this.category.toString(),
      "ble_name": this.bleName,
      "ble_service": this.bleService,
      "ble_characteristic": this.bleCharacteristic,
      "supplier": this.supplier,
      "name": this.name,
    };
  }

  @override
  String toString() {
    return 'Product{${toJson().toString()}, isPaired: $isPaired}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Product &&
              runtimeType == other.runtimeType &&
              name == other.name;

  @override
  int get hashCode => name.hashCode;

}
