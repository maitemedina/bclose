// import 'package:json_annotation/json_annotation.dart';
//
//
// @JsonSerializable(nullable: false)
class User {
  var id;
  var username;
  var email;
  var token;
  var code;
  var image;
  var status;
  var gender;
  var born_date;
  var sos_name;
  var sos_number;
  var sos_image;
  var weight;
  var height;
  var unitW;
  var unitH;
  var uinT;
  UserPatient? userpatient;


  User({this.id,
    this.username,
    this.email,
    this.token,
    this.code,
    this.image,
    this.status,
    this.userpatient,
    this.gender,
    this.born_date,
    this.sos_name,
    this.sos_number,
    this.sos_image,
    this.weight,
    this.height,
    this.unitW,
    this.unitH,
    this.uinT,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['entity'];
    token = json['serie'];
    code = json['publication_date'];
    image = json['link'];
    status = json['created_at'];
    userpatient = json['userpatient'];
    born_date  = json['born_date'];
    sos_image  = json['sos_image'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['email'] = this.email;
    data['token'] = this.token;
    data['code'] = this.code;
    data['image'] = this.image;
    data['status'] = this.status;
    data['userpatient'] = this.status;
    data['born_date'] = this.born_date;
    data['sos_image'] = this.sos_image;
    return data;
  }


}


class UserPatient {
  var id;
  var weight;
  var height;
  var userId;
  var createdAt;
  var updatedAt;
  var status;
  var responsableId;
  var cuidadorId;
  var cuidadorPin;

  UserPatient(
      {this.id,
        this.weight,
        this.height,
        this.userId,
        this.createdAt,
        this.updatedAt,
        this.status,
        this.responsableId,
        this.cuidadorId,
        this.cuidadorPin});

  UserPatient.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    weight = json['weight'];
    height = json['height'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
    responsableId = json['responsable_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['weight'] = this.weight;
    data['height'] = this.height;
    data['user_id'] = this.userId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['status'] = this.status;
    data['responsable_id'] = this.responsableId;
    return data;
  }
}

class Conversation {
  var id;
  var message;
  var annex;
  var patientId;
  var userId;
  var status;
  var createdAt;
  var updatedAt;
  var sendByPatient;
  var type;
  var sender;
  var seen;

  Conversation(
      {this.id,
        this.message,
        this.annex,
        this.patientId,
        this.userId,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.sendByPatient,
        this.type,
        this.sender,
        this.seen});

  Conversation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    message = json['message'];
    annex = json['annex'];
    patientId = json['patient_id'];
    userId = json['user_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    sendByPatient = json['sendByPatient'];
    type = json['type'];
    sender = json['sender'];
    seen = json['seen'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['message'] = this.message;
    data['annex'] = this.annex;
    data['patient_id'] = this.patientId;
    data['user_id'] = this.userId;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['sendByPatient'] = this.sendByPatient;
    data['type'] = this.type;
    data['sender'] = this.sender;
    data['seen'] = this.seen;
    return data;
  }
}