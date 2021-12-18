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

//   factory Overtime.fromJson(Map<String, dynamic> json) => Overtime(
//         overtime: json["overtime"],
//         userId: json["user_id"],
//         date: json["date"],
//         code: json["code"],
//         id: json["id"],
//         type: json["type"],
//         note: json["note"],
//         createdAt: json["created_at"] == null
//             ? null
//             : DateTime.parse(json["created_at"]),
//         updatedAt: json["updated_at"] == null
//             ? null
//             : DateTime.parse(json["updated_at"]),
//         users: json["users"] == null ? null : User.fromJson(json["users"]),
//       );

//   Map<String, dynamic> toJson() {
//     return {
//       "overtime": overtime,
//       "user_id": userId,
//       "date": date?.toIso8601String(),
//       "code": code,
//       "id": id,
//       "type": type,
//       "note": note,
//       "createdAt": createdAt?.toIso8601String(),
//       "updatedAt": updatedAt?.toIso8601String(),
//       "users": users,
//     };
//   }
// }
//
// class OvertimeUser {
//   int? id;
//   String? name;
//   String? phone;
//   String? email;
//   DateTime? emailVerifiedAt;
//   String? address;
//   String? password;
//   String? position;
//   String? skill;
//   String? salary;
//   String? role;
//   String? background;
//   String? status;
//   String? rate;
//   DateTime? createdAt;
//   DateTime? updatedAt;
//   String? image;
//   String? imageId;
//
//   OvertimeUser({
//     this.id,
//     this.name,
//     this.phone,
//     this.email,
//     this.emailVerifiedAt,
//     this.address,
//     this.password,
//     this.position,
//     this.skill,
//     this.salary,
//     this.role,
//     this.background,
//     this.status,
//     this.rate,
//     this.image,
//     this.imageId,
//     this.createdAt,
//     this.updatedAt,
//   });
//
//   factory OvertimeUser.fromMap(Map<String, dynamic> jsonData) {
//     return OvertimeUser(
//       name: jsonData['name'],
//       phone: jsonData['phone'],
//       email: jsonData['email'],
//       emailVerifiedAt: jsonData['emailVerifiedAt'],
//       address: jsonData['address'],
//       password: jsonData['password'],
//       position: jsonData['position'],
//       skill: jsonData['skill'],
//       salary: jsonData['salary'],
//       role: jsonData['role'],
//       background: jsonData['background'],
//       status: jsonData['status'],
//       rate: jsonData['rate'],
//       createdAt: jsonData['createdAt'],
//       updatedAt: jsonData['updatedAt'],
//       image: jsonData['updatedAt'],
//       imageId: jsonData['imageId'],
//     );
//   }
// }

import 'package:ems/models/user.dart';

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

List<OvertimeByDay> overtimesByDayFromJson(Map<String, dynamic> list) {
  List<OvertimeByDay> lists = [];

  // list.forEach((key, value) {
  //   // print('hihih $key');
  //   // OvertimeByDay.fromMap(value);
  // });
  list.forEach((key, value) {
    // print(value);
    // print(lists);
    var over = OvertimeByDay.fromMap(key, value);
    // print(over);
    lists.add(
      over,
    );
  });

  /// lists here to send back to service.
  // print(lists);
  return lists;
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
    // print('hi from map $value');
    List<OvertimeAttendance> otAttendances = [];
    value.forEach((key, value) {
      print('key ${value}');
      // if () {
      otAttendances.add(
        OvertimeAttendance(
          user: User.fromJson(value[0]['users']),
          checkin: OvertimeCheckin.fromMap(value[0]),
          checkout: OvertimeCheckout.fromMap(
            value.length == 2 ? value[1] : value[0],
          ),
        ),
      );
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

class OvertimeListWithTotal {
  String total;
  List<OvertimeAttendance> listOfOvertime;

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
