import 'dart:ui';

import 'package:syncfusion_flutter_calendar/calendar.dart';

class AppointmentDataSource extends CalendarDataSource {
  AppointmentDataSource(List<AppointmentUser> source){
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

class AppointmentUser {

  AppointmentUser(this.id,this.eventName, this.from, this.to, this.background, this.isAllDay,this.concluded,this.type,this.extra);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
  int concluded;
  String type;
  int id;
  String extra;
}