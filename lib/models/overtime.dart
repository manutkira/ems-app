// class Overtime extends Attendance {
//   Overtime({
//     this.overtime,
//     userId,
//     date,
//     code,
//     id,
//     type,
//     note,
//     createdAt,
//     updatedAt,
//     users,
//   }) : super(
//             userId: userId,
//             date: date,
//             code: code,
//             id: id,
//             type: type,
//             note: note,
//             createdAt: createdAt,
//             updatedAt: updatedAt,
//             users: users);

//   String? overtime;

//   Overtime copyWith({
//     int? id,
//     int? userId,
//     DateTime? date,
//     String? type,
//     String? note,
//     String? code,
//     DateTime? createdAt,
//     DateTime? updatedAt,
//     User? users,
//   }) =>
//       Overtime(
//         id: id ?? this.id,
//         userId: userId ?? this.userId,
//         date: date ?? this.date,
//         type: type ?? this.type,
//         note: note ?? this.note,
//         code: code ?? this.code,
//         createdAt: createdAt ?? this.createdAt,
//         updatedAt: updatedAt ?? this.updatedAt,
//         users: users == null ? this.users : users.copyWith(),
//       );

//   factory Overtime.fromRawJson(String str) =>
//       Overtime.fromJson(json.decode(str));

//   String toRawJson() => json.encode(toJson());

import 'package:ems/models/user.dart';
import 'package:ems/utils/utils.dart';
import 'package:flutter/material.dart';

List<OvertimeAttendance> overtimesFromJson(dynamic list) {
  List<OvertimeAttendance> _overtimeWithoutUser = [];

  list.forEach((key, value) {
    _overtimeWithoutUser.add(OvertimeAttendance(
      checkin: OvertimeCheckin.fromMap(value[0]),
      checkout: OvertimeCheckout.fromMap(
        value.length == 2 ? value[1] : value[0],
      ),
    ));
  });

  return _overtimeWithoutUser;
}

List<OvertimeRecord> overtimeRecordsFromJson(Map<String, dynamic> list) {
  return [
    ...list.keys.map((key) {
      var record = list[key][0];
      return OvertimeRecord.fromMap(record);
    })
  ];
}

// List<OvertimeByDay> overtimesByDayFromJson(dynamic list) {
//   List<OvertimeByDay> _overtimeWithoutUser = [];
//
//   list.forEach((key, value){
//     print(value);
//     // _overtimeWithoutUser.add(value);
//   });
//
//   return _overtimeWithoutUser;
// }

List<OvertimeRecordsByDays> overtimesByDayFromJson(Map<String, dynamic> list) {
  List<OvertimeByDay> lists = [];
  // print(list);
  // list.forEach((key, value) {
  //   // print('hihih $key');
  //   // OvertimeByDay.fromMap(value);
  // });
  var listOfDays = [];
  // OvertimeRecordsByDays.fromMap({list.keys.first: list.values.first});

  // print(list.map((key, value) => print("$key")));
  // return List<OvertimeRecordsByDays>.from(list.map((key, value) => null));

  return [
    ...list.keys.map((key) => OvertimeRecordsByDays.fromMap({key: list[key]})),
  ];
  // print(endlist);
  // return [];
  list.keys.toList().map((date) {
    // print(date);
    // return OvertimeRecordsByDays.fromMap({list.keys.first: list.values.first});
    // print(date);
    // listOfDays.add(OvertimeByDay.fromMap(date, list[date]));
    // lists[date.key] = list[date.value];
    // return lists.add(OvertimeByDay.fromMap(date, list[date]));
    // return print(date);
  }).toList();
  // print(listOfDays.length);
  // list.keys.toList().forEach((key) {
  //   print(list[key]);
  //   listOfDays.ins
  //   // listOfDays.add(key);
  //
  //   // print('$key ${list[key]}');
  //   // lists.add(OvertimeByDay.fromMap(key, list[key]));
  // });

  // list.keys.toList().map((key) {
  //   lists.add(OvertimeByDay.fromMap(key, list[key]));
  //   print('lists');
  // }).toList();
  // list.forEach((key, value) {
  //   // print(value);
  //   var over = OvertimeByDay.fromMap(key, value);
  //   lists.add(
  //     over,
  //   );
  // });

  /// lists here to send back to service.
  // print(lists);
  // return lists;
  // return List<OvertimeByDay>.from(
  //   list.map(
  //     (x) => OvertimeByDay.fromMap(x),
  //   ),
  // );
}

class OvertimeByDay {
  DateTime date;
  List<OvertimeAttendance> overtimes;

  OvertimeByDay({required this.date, required this.overtimes});

  factory OvertimeByDay.fromMap(key, value) {
    // print('hi from map ${value[0]}');
    List<OvertimeAttendance> otAttendances = [];

    Map gg = value;
    print(gg.entries.toList());

    value.forEach((key, val) {
      // OvertimeRecord.fromMap(val['get_t5']);
      // if () {
      // otAttendances.add(
      //   OvertimeAttendance(
      //     user: User.fromJson(val['users']),
      //     checkin: OvertimeCheckin.fromMap(val['get_t5']),
      //     checkout: OvertimeCheckout.fromMap(
      //       val.length == 2 ? val[1] : val[0],
      //     ),
      //   ),
      // );

      // }
      // print(otAttendances);
      // print(ot.user?.name);
      //0 in 1 out
      // print(value[1]);
    });
    // print(jsonData);
    // jsonData.forEach((key, value) {
    //   print(key);
    // });
    return OvertimeByDay(
      date: DateTime.parse(key),
      overtimes: otAttendances,
    );
  }

  @override
  String toString() {
    return "${date.toIso8601String()} emp: ${overtimes[0].user?.name} overtime: ${overtimes[0].checkout?.overtime}";
  }
}

class OvertimeRecordsByDays {
  DateTime date;
  List<OvertimeRecord> records;

  OvertimeRecordsByDays({required this.date, required this.records});

  factory OvertimeRecordsByDays.fromMap(Map<String, dynamic> jsonData) {
    // print(jsonData);
    List<OvertimeRecord> recs = [
      ...jsonData.values.first.map((record) => OvertimeRecord.fromMap(record))
    ];

    OvertimeRecordsByDays rec = OvertimeRecordsByDays(
      date: DateTime.parse(jsonData.keys.first),
      records: recs,
    );
    return rec;
  }
}

class OvertimeRecord {
  int id;
  DateTime date;
  User? user;
  String duration;
  AttendanceRecord? checkIn;
  AttendanceRecord? checkOut;

  OvertimeRecord({
    required this.id,
    required this.date,
    this.user,
    required this.duration,
    this.checkIn,
    this.checkOut,
  });

  factory OvertimeRecord.fromMap(Map<String, dynamic> jsonData) {
    // print("HEY $jsonData");
    return OvertimeRecord(
      id: jsonData["id"],
      date: DateTime.parse(jsonData["date"]),
      user: jsonData['users'] == null ? null : User.fromJson(jsonData["users"]),
      duration: jsonData["overtime"],
      checkIn: jsonData["get_t5"] == null
          ? null
          : AttendanceRecord.fromMap(jsonData["get_t5"]),
      checkOut: jsonData["get_t6"] == null
          ? null
          : AttendanceRecord.fromMap(jsonData["get_t6"]),
    );
  }

  OvertimeRecord copyWith({
    int? id,
    DateTime? date,
    User? user,
    String? duration,
    AttendanceRecord? checkIn,
    AttendanceRecord? checkOut,
  }) =>
      OvertimeRecord(
        id: id ?? this.id,
        date: date ?? this.date,
        user: user ?? this.user,
        duration: duration ?? this.duration,
        checkIn: checkIn ?? this.checkIn,
        checkOut: checkOut ?? this.checkOut,
      );
}

class AttendanceRecord {
  int? id;
  TimeOfDay? time;
  String? note;

  AttendanceRecord({
    this.id,
    this.time,
    this.note,
  });

  factory AttendanceRecord.fromMap(Map<String, dynamic> jsonData) {
    return AttendanceRecord(
      id: jsonData['id'],
      time: getTimeOfDayFromString(
        jsonData['time'],
      ),
      note: jsonData['note'],
    );
  }

  AttendanceRecord copyWith({
    int? id,
    TimeOfDay? time,
    String? note,
  }) =>
      AttendanceRecord(
        id: id ?? this.id,
        time: time ?? this.time,
        note: note ?? this.note,
      );
}

class OvertimeListWithTotal {
  String total;
  // List<OvertimeAttendance> listOfOvertime;
  List<OvertimeRecord> listOfOvertime;

  OvertimeListWithTotal({required this.total, required this.listOfOvertime});
}

class OvertimeAttendance {
  OvertimeCheckin? checkin;
  OvertimeCheckout? checkout;
  User? user;

  OvertimeAttendance({
    this.user,
    this.checkin,
    this.checkout,
  });

  OvertimeAttendance copyWith({
    OvertimeCheckin? checkin,
    OvertimeCheckout? checkout,
    User? user,
  }) =>
      OvertimeAttendance(
        checkin: checkin ?? this.checkin,
        checkout: checkout ?? this.checkout,
        user: user ?? this.user,
      );
}

class OvertimeCheckin {
  int? id;
  int? userId;
  DateTime? date;
  String? type;
  String? code;
  String? note;
  String? overtime;

  OvertimeCheckin({
    this.id,
    this.userId,
    this.date,
    this.type,
    this.code,
    this.note,
    this.overtime,
  });

  factory OvertimeCheckin.fromMap(Map<String, dynamic> jsonData) =>
      OvertimeCheckin(
        id: jsonData["id"],
        userId: jsonData["user_id"],
        date:
            jsonData["date"] == null ? null : DateTime.parse(jsonData["date"]),
        type: jsonData["type"] ?? '',
        code: jsonData["code"] ?? '',
        note: jsonData["note"] ?? '',
        overtime: jsonData["overtime"] ?? '',
      );
}

class OvertimeCheckout {
  int? id;
  int? userId;
  DateTime? date;
  String? type;
  String? code;
  String? note;
  String? overtime;

  OvertimeCheckout({
    this.id,
    this.userId,
    this.date,
    this.type,
    this.code,
    this.note,
    this.overtime,
  });

  factory OvertimeCheckout.fromMap(Map<String, dynamic> jsonData) =>
      OvertimeCheckout(
        id: jsonData["id"],
        userId: jsonData["user_id"],
        date:
            jsonData["date"] == null ? null : DateTime.parse(jsonData["date"]),
        type: jsonData["type"] ?? '',
        code: jsonData["code"] ?? '',
        note: jsonData["note"] ?? '',
        overtime: jsonData["overtime"] ?? '',
      );
}

// class OvertimeUser extends User {
//   OvertimeUser({
//     id,
//     name,
//     phone,
//     email,
//     emailVerifiedAt,
//     address,
//     password,
//     position,
//     skill,
//     salary,
//     role,
//     background,
//     status,
//     rate,
//     createdAt,
//     updatedAt,
//     image,
//     imageId,
//   }) : super(
// name: name,
// phone: phone,
// email: email,
// emailVerifiedAt: emailVerifiedAt,
// address: address,
// password: password,
// position: position,
// skill: skill,
// salary: salary,
// role: role,
// background: background,
// status: status,
// rate: rate,
// createdAt: createdAt,
// updatedAt: updatedAt,
// image: image,
// imageId: imageId,
//         );
// }
