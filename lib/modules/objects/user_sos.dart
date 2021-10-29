// import 'package:json_annotation/json_annotation.dart';
//
//
// @JsonSerializable(nullable: false)
class UserSos {
  var status;
  var id;
  var userId;
  var name;
  var morada;
  var image;
  var number;


  UserSos({this.id,
    this.userId,
    this.name,
    this.morada,
    this.image,
    this.number,
    this.status
  });

  UserSos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name1'];
    morada = json['address1'];
    image = json['image1'];
    number = json['phone_number1'];
    status = json['status'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['address'] = this.morada;
    data['image'] = this.image;
    data['phone_number'] = this.number;
    return data;
  }


}
