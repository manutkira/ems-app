import 'package:ems/models/user.dart';

List<AttendanceById> attendanceByIdFromJson(Map<String, dynamic> list) {
  // print('$list');

  List<AttendanceById> _overtimeWithoutUser = [];
  list.forEach((key, value) {
    for (int i = 0; i < value.length; i += 2) {
      var checkIn;
      var checkOut;
      if (value[i]['type'] == 'checkin' ||
          value[i]['type'] == 'absent' ||
          value[i]['type'] == 'permission') {
        checkIn = value[i];
      }
      if (i + 1 > value.length) {
        checkOut = value[i + 1];
      }
      if (i + 1 < value.length && value[i + 1]['type'] == 'checkout') {
        if (value[i + 1]['type'] == 'checkout') {
          checkOut = value[i + 1];
        }
      }

      _overtimeWithoutUser.add(AttendanceById(
        checkin1: OvertimeCheckin1.fromMap(checkIn),
        checkout1: OvertimeCheckout1.fromMap(checkOut ?? checkIn),
      ));
    }
  });

  return _overtimeWithoutUser;
}

class AttendanceById {
  OvertimeCheckin1? checkin1;
  OvertimeCheckin2? checkin2;
  // OvertimeCheckin3? checkin3;
  OvertimeCheckout1? checkout1;
  OvertimeCheckout2? checkout2;
  // OvertimeCheckout3? checkout3;
  User? user;

  AttendanceById({
    this.user,
    this.checkin1,
    this.checkin2,
    // this.checkin3,
    this.checkout1,
    this.checkout2,
    // this.checkout3,
  });

  AttendanceById copyWith({
    OvertimeCheckin1? checkin1,
    OvertimeCheckin2? checkin2,
    OvertimeCheckin3? checkin3,
    OvertimeCheckout1? checkout1,
    OvertimeCheckout2? checkout2,
    OvertimeCheckout3? checkout3,
    User? user,
  }) =>
      AttendanceById(
        checkin1: checkin1 ?? this.checkin1,
        checkin2: checkin2 ?? this.checkin2,
        // checkin3: checkin3 ?? this.checkin3,
        checkout1: checkout1 ?? this.checkout1,
        checkout2: checkout2 ?? this.checkout2,
        // checkout3: checkout3 ?? this.checkout3,
        user: user ?? this.user,
      );
}

class OvertimeCheckin1 {
  int? id;
  int? userId;
  DateTime? date;
  String? type;
  String? code;
  String? overtime;

  OvertimeCheckin1({
    this.id,
    this.userId,
    this.date,
    this.type,
    this.code,
    this.overtime,
  });

  factory OvertimeCheckin1.fromMap(Map<String, dynamic> jsonData) =>
      OvertimeCheckin1(
        id: jsonData["id"],
        userId: jsonData["user_id"],
        date:
            jsonData["date"] == null ? null : DateTime.parse(jsonData["date"]),
        type: jsonData["type"] ?? '',
        code: jsonData["code"] ?? '',
        overtime: jsonData["overtime"] ?? '',
      );
}

class OvertimeCheckin2 {
  int? id;
  int? userId;
  DateTime? date;
  String? type;
  String? code;
  String? overtime;

  OvertimeCheckin2({
    this.id,
    this.userId,
    this.date,
    this.type,
    this.code,
    this.overtime,
  });

  factory OvertimeCheckin2.fromMap(Map<String, dynamic> jsonData) =>
      OvertimeCheckin2(
        id: jsonData["id"],
        userId: jsonData["user_id"],
        date:
            jsonData["date"] == null ? null : DateTime.parse(jsonData["date"]),
        type: jsonData["type"] ?? '',
        code: jsonData["code"] ?? '',
        overtime: jsonData["overtime"] ?? '',
      );
}

class OvertimeCheckin3 {
  int? id;
  int? userId;
  DateTime? date;
  String? type;
  String? code;
  String? overtime;

  OvertimeCheckin3({
    this.id,
    this.userId,
    this.date,
    this.type,
    this.code,
    this.overtime,
  });

  factory OvertimeCheckin3.fromMap(Map<String, dynamic> jsonData) =>
      OvertimeCheckin3(
        id: jsonData["id"],
        userId: jsonData["user_id"],
        date:
            jsonData["date"] == null ? null : DateTime.parse(jsonData["date"]),
        type: jsonData["type"] ?? '',
        code: jsonData["code"] ?? '',
        overtime: jsonData["overtime"] ?? '',
      );
}

class OvertimeCheckout1 {
  int? id;
  int? userId;
  DateTime? date;
  String? type;
  String? code;
  String? overtime;

  OvertimeCheckout1({
    this.id,
    this.userId,
    this.date,
    this.type,
    this.code,
    this.overtime,
  });

  factory OvertimeCheckout1.fromMap(Map<String, dynamic> jsonData) =>
      OvertimeCheckout1(
        id: jsonData["id"],
        userId: jsonData["user_id"],
        date:
            jsonData["date"] == null ? null : DateTime.parse(jsonData["date"]),
        type: jsonData["type"] ?? '',
        code: jsonData["code"] ?? '',
        overtime: jsonData["overtime"] ?? '',
      );
}

class OvertimeCheckout2 {
  int? id;
  int? userId;
  DateTime? date;
  String? type;
  String? code;
  String? overtime;

  OvertimeCheckout2({
    this.id,
    this.userId,
    this.date,
    this.type,
    this.code,
    this.overtime,
  });

  factory OvertimeCheckout2.fromMap(Map<String, dynamic> jsonData) =>
      OvertimeCheckout2(
        id: jsonData["id"],
        userId: jsonData["user_id"],
        date:
            jsonData["date"] == null ? null : DateTime.parse(jsonData["date"]),
        type: jsonData["type"] ?? '',
        code: jsonData["code"] ?? '',
        overtime: jsonData["overtime"] ?? '',
      );
}

class OvertimeCheckout3 {
  int? id;
  int? userId;
  DateTime? date;
  String? type;
  String? code;
  String? overtime;

  OvertimeCheckout3({
    this.id,
    this.userId,
    this.date,
    this.type,
    this.code,
    this.overtime,
  });

  factory OvertimeCheckout3.fromMap(Map<String, dynamic> jsonData) =>
      OvertimeCheckout3(
        id: jsonData["id"],
        userId: jsonData["user_id"],
        date:
            jsonData["date"] == null ? null : DateTime.parse(jsonData["date"]),
        type: jsonData["type"] ?? '',
        code: jsonData["code"] ?? '',
        overtime: jsonData["overtime"] ?? '',
      );
}
