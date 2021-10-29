// import 'package:json_annotation/json_annotation.dart';
//
//
// @JsonSerializable(nullable: false)
class Documents {
  var id;
  var data;
  var name;
  var image;
  var type;


  Documents({this.id,
    this.data,
    this.name,
    this.image,
    this.type
  });

  Documents.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    data = json['username'];
    name = json['entity'];
    image = json['link'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.data;
    data['email'] = this.name;
    data['image'] = this.image;
    return data;
  }


}
