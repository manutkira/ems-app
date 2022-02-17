import 'dart:convert';

import 'package:ems/models/attendance.dart';
import 'package:ems/models/attendances.dart';
import 'package:ems/models/overtime.dart';
import 'package:ems/models/user.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

import 'base_service.dart';
import 'exceptions/attendance.dart';

class AttendanceService extends BaseService {
  static AttendanceService get instance => AttendanceService();
  int _code = 0;

  Future<Attendance> findOne(int id) async {
    try {
      Response response = await get(Uri.parse('$baseUrl/attendances/$id'));
      _code = response.statusCode;
      var jsondata = json.decode(response.body);
      var attendance = Attendance.fromJson(jsondata);
      return attendance;
    } catch (e) {
      throw AttendanceException(code: _code);
    }
  }

  String _formatDate(DateTime? date) {
    return date != null ? DateFormat('y-M-d').format(date) : '';
  }

  /// creates one attendance record.
  Future<void> createOneRecord({
    required int userId,
    required DateTime datetime,
    String? note,
  }) async {
    String uri = "$baseUrl/attendances";

    Map<String, dynamic> payload = {
      "user_id": userId,
      "date": datetime.toIso8601String(),
    };

    if (note != null && note != 'null') {
      payload['note'] = note;
    }

    try {
      Response response = await post(
        Uri.parse(uri),
        headers: headers(),
        body: jsonEncode(payload),
      );
      if (response.statusCode != 201) {
        _code = response.statusCode;
        throw AttendanceException(code: _code);
      }
      var decoded = jsonDecode(response.body);
    } catch (e) {
      throw AttendanceException(code: _code);
    }
  }

  Future<void> createManyRecords(List<dynamic> cache) async {
    if (cache.toString() == "[]" || cache.toString() == "null") {
      return;
    }

    String uri = "$baseUrl/attendances/mass";

    // removes unnecessary user object
    // decoding the encoded object to actually copy the object.
    // with other methods, the local cache got modified.
    var clean = json.decode(json.encode(cache)).map((att) {
      att.removeWhere((key, value) => key == 'user');
      return att;
    }).toList();

    try {
      Response res = await post(
        Uri.parse(uri),
        headers: headers(),
        body: jsonEncode(
          {
            "data": clean,
          },
        ),
      );

      if (res.statusCode != 200) {
        throw AttendanceException(code: 500, message: "mass upload failed");
      }
    } catch (err) {
      throw AttendanceException(code: 500, message: "mass upload failed");
    }
  }

  /// updates an attendance record
  Future<AttendanceRecord> updateOneRecord({
    required AttendanceRecord record,
  }) async {
    String uri = "$baseUrl/attendance_record/${record.id}";

    Map<String, String> payload = {};
    if (record.time != null) {
      payload['time'] = '${record.time?.hour}:${record.time?.minute}:00';
    }
    if (record.note != null) {
      payload['note'] = record.note.toString();
    }
    if (payload.isEmpty) return record;

    try {
      Response response = await put(
        Uri.parse(uri),
        headers: headers(),
        body: jsonEncode(payload),
      );
      _code = response.statusCode;
      var decoded = jsonDecode(response.body);
      return AttendanceRecord.fromMap(decoded);
    } catch (e) {
      throw AttendanceException(code: _code);
    }
  }

  /// deletes an attendance record
  Future<bool> deleteOneRecord(int id) async {
    try {
      Response response = await delete(
        Uri.parse('$baseUrl/attendance_record/$id'),
        headers: headers(),
      );

      if (response.statusCode == 200 || response.statusCode == 404) {
        return true;
      } else {
        _code = response.statusCode;
        throw AttendanceException(code: _code);
      }
    } catch (e) {
      throw AttendanceException(code: _code);
      //
    }
  }

  // Future<int> countLateByUserId({
  //   required int userId,
  //   DateTime? start,
  //   DateTime? end,
  // }) async {
  //   String startDate = _formatDate(start);
  //   String endDate = _formatDate(end);

  //   bool hasNoStartOrEndDate =
  //       start == null || end == null || startDate.isEmpty || endDate.isEmpty;

  //   try {
  //     String url =
  //         '$baseUrl/attendance_count?start=$startDate&end=$endDate&late_morning=$userId';
  //     Response response = await get(Uri.parse(url));
  //     _code = response.statusCode;
  //     return int.parse(response.body);
  //   } catch (e) {
  //     throw AttendanceException(code: _code);
  //   }
  // }
  Future<int> countLateAllByUserId({
    required int userId,
  }) async {
    try {
      String url = '$baseUrl/attendance_count?late=$userId';
      Response response = await get(Uri.parse(url));
      _code = response.statusCode;

      return int.parse(response.body);
    } catch (e) {
      throw AttendanceException(code: _code);
    }
  }

  Future<int> countPresentAllByUserId({
    required int userId,
  }) async {
    try {
      String url = '$baseUrl/attendance_count?present=$userId';
      Response response = await get(Uri.parse(url));
      _code = response.statusCode;

      return int.parse(response.body);
    } catch (e) {
      throw AttendanceException(code: _code);
    }
  }

  Future<int> countLateByUserId({
    required int userId,
    DateTime? start,
    DateTime? end,
  }) async {
    String startDate = _formatDate(start);
    String endDate = _formatDate(end);

    bool hasNoStartOrEndDate =
        start == null || end == null || startDate.isEmpty || endDate.isEmpty;

    try {
      String url =
          '$baseUrl/attendance_count?late-morning=$userId&start=$startDate&end=$endDate';
      Response response = await get(Uri.parse(url));
      _code = response.statusCode;
      return int.parse(response.body);
    } catch (e) {
      throw AttendanceException(code: _code);
    }
  }

  Future<int> countLateNoonByUserId({
    required int userId,
    DateTime? start,
    DateTime? end,
  }) async {
    String startDate = _formatDate(start);
    String endDate = _formatDate(end);

    bool hasNoStartOrEndDate =
        start == null || end == null || startDate.isEmpty || endDate.isEmpty;

    try {
      String url =
          '$baseUrl/attendance_count?late-afternoon=$userId&start=$startDate&end=$endDate';
      Response response = await get(Uri.parse(url));
      _code = response.statusCode;
      return int.parse(response.body);
    } catch (e) {
      throw AttendanceException(code: _code);
    }
  }

  Future<int> countPresentByUserId({
    required int userId,
    DateTime? start,
    DateTime? end,
  }) async {
    String startDate = _formatDate(start);
    String endDate = _formatDate(end);

    bool hasNoStartOrEndDate =
        start == null || end == null || startDate.isEmpty || endDate.isEmpty;

    try {
      String url =
          '$baseUrl/attendance_count?present-morning=$userId&start=$startDate&end=$endDate';
      Response response = await get(Uri.parse(url));
      _code = response.statusCode;
      return int.parse(response.body);
    } catch (e) {
      throw AttendanceException(code: _code);
    }
  }

  Future<int> countPresentNoonByUserId({
    required int userId,
    DateTime? start,
    DateTime? end,
  }) async {
    String startDate = _formatDate(start);
    String endDate = _formatDate(end);

    bool hasNoStartOrEndDate =
        start == null || end == null || startDate.isEmpty || endDate.isEmpty;

    try {
      String url =
          '$baseUrl/attendance_count?present-afternoon=$userId&start=$startDate&end=$endDate';
      Response response = await get(Uri.parse(url));
      _code = response.statusCode;
      return int.parse(response.body);
    } catch (e) {
      throw AttendanceException(code: _code);
    }
  }
  // Future<int> countLateNoonByUserId({
  //   required int userId,
  //   DateTime? start,
  //   DateTime? end,
  // }) async {
  //   String startDate = _formatDate(start);
  //   String endDate = _formatDate(end);

  //   bool hasNoStartOrEndDate =
  //       start == null || end == null || startDate.isEmpty || endDate.isEmpty;

  //   try {
  //     String url =
  //         '$baseUrl/attendance_count?start=$startDate&end=$endDate&late_afternoon=$userId';
  //     Response response = await get(Uri.parse(url));
  //     _code = response.statusCode;
  //     return int.parse(response.body);
  //   } catch (e) {
  //     throw AttendanceException(code: _code);
  //   }
  // }
  // Future<int> countLateNoonByUserId({
  //   required int userId,
  // }) async {
  //   try {
  //     String url = '$baseUrl/attendance_count?present-afternoon=$userId';
  //     Response response = await get(Uri.parse(url));
  //     _code = response.statusCode;
  //     return int.parse(response.body);
  //   } catch (e) {
  //     throw AttendanceException(code: _code);
  //   }
  // }

  Future<int> countAbsentByUserId({
    required int userId,
    DateTime? start,
    DateTime? end,
  }) async {
    String startDate = _formatDate(start);
    String endDate = _formatDate(end);

    bool hasNoStartOrEndDate =
        start == null || end == null || startDate.isEmpty || endDate.isEmpty;

    try {
      String url =
          '$baseUrl/attendance_count?start=$startDate&end=$endDate&absent_morning=$userId';
      Response response = await get(Uri.parse(url));
      _code = response.statusCode;
      return int.parse(response.body);
    } catch (e) {
      throw AttendanceException(code: _code);
    }
  }

  Future<int> countAbsentNoonByUserId({
    required int userId,
    DateTime? start,
    DateTime? end,
  }) async {
    String startDate = _formatDate(start);
    String endDate = _formatDate(end);

    bool hasNoStartOrEndDate =
        start == null || end == null || startDate.isEmpty || endDate.isEmpty;

    try {
      String url =
          '$baseUrl/attendance_count?start=$startDate&end=$endDate&absent_afternoon=$userId';
      Response response = await get(Uri.parse(url));
      _code = response.statusCode;
      return int.parse(response.body);
    } catch (e) {
      throw AttendanceException(code: _code);
    }
  }

  Future<int> countPermissionByUserId({
    required int userId,
    DateTime? start,
    DateTime? end,
  }) async {
    String startDate = _formatDate(start);
    String endDate = _formatDate(end);

    bool hasNoStartOrEndDate =
        start == null || end == null || startDate.isEmpty || endDate.isEmpty;

    try {
      String url =
          '$baseUrl/attendance_count?start=$startDate&end=$endDate&permission_morning=$userId';
      Response response = await get(Uri.parse(url));
      _code = response.statusCode;
      return int.parse(response.body);
    } catch (e) {
      throw AttendanceException(code: _code);
    }
  }

  Future<int> countPermissionNoonByUserId({
    required int userId,
    DateTime? start,
    DateTime? end,
  }) async {
    String startDate = _formatDate(start);
    String endDate = _formatDate(end);

    bool hasNoStartOrEndDate =
        start == null || end == null || startDate.isEmpty || endDate.isEmpty;

    try {
      String url =
          '$baseUrl/attendance_count?start=$startDate&end=$endDate&permission_afternoon=$userId';
      Response response = await get(Uri.parse(url));
      _code = response.statusCode;
      return int.parse(response.body);
    } catch (e) {
      throw AttendanceException(code: _code);
    }
  }

  Future<int> countLate(int id) async {
    try {
      Response response =
          await get(Uri.parse('$baseUrl/attendance_count?late_morning=$id'));

      if (response.statusCode != 200) {
        _code = response.statusCode;
        throw AttendanceException(code: _code);
      }

      return int.parse(response.body);
    } catch (e) {
      throw AttendanceException(code: _code);
    }
  }

  Future<int> countLateNoon(int id) async {
    try {
      Response response =
          await get(Uri.parse('$baseUrl/attendance_count?late_afternoon=$id'));

      if (response.statusCode != 200) {
        _code = response.statusCode;
        throw AttendanceException(code: _code);
      }

      return int.parse(response.body);
    } catch (e) {
      throw AttendanceException(code: _code);
    }
  }

  Future<int> countPresent(int id) async {
    try {
      Response response =
          await get(Uri.parse('$baseUrl/attendance_count?present_morning=$id'));

      if (response.statusCode != 200) {
        _code = response.statusCode;
        throw AttendanceException(code: _code);
      }

      return int.parse(response.body);
    } catch (e) {
      throw AttendanceException(code: _code);
    }
  }

  Future<int> countPresentNoon(int id) async {
    try {
      Response response = await get(
          Uri.parse('$baseUrl/attendance_count?present_afternoon=$id'));

      if (response.statusCode != 200) {
        _code = response.statusCode;
        throw AttendanceException(code: _code);
      }

      return int.parse(response.body);
    } catch (e) {
      throw AttendanceException(code: _code);
    }
  }

  Future<int> countAbsent(int id) async {
    try {
      Response response =
          await get(Uri.parse('$baseUrl/attendance_count?absent_morning=$id'));

      if (response.statusCode != 200) {
        _code = response.statusCode;
        throw AttendanceException(code: _code);
      }

      return int.parse(response.body);
    } catch (e) {
      throw AttendanceException(code: _code);
    }
  }

  Future<int> countAbsentNoon(int id) async {
    try {
      Response response = await get(
          Uri.parse('$baseUrl/attendance_count?absent_afternoon=$id'));

      if (response.statusCode != 200) {
        _code = response.statusCode;
        throw AttendanceException(code: _code);
      }

      return int.parse(response.body);
    } catch (e) {
      throw AttendanceException(code: _code);
    }
  }

  Future<int> countPermission(int id) async {
    try {
      Response response = await get(
          Uri.parse('$baseUrl/attendance_count?permission_morning=$id'));

      if (response.statusCode != 200) {
        _code = response.statusCode;
        throw AttendanceException(code: _code);
      }

      return int.parse(response.body);
    } catch (e) {
      throw AttendanceException(code: _code);
    }
  }

  Future<int> countPermissionNoon(int id) async {
    try {
      Response response = await get(
          Uri.parse('$baseUrl/attendance_count?permission_afternoon=$id'));

      if (response.statusCode != 200) {
        _code = response.statusCode;
        throw AttendanceException(code: _code);
      }

      return int.parse(response.body);
    } catch (e) {
      throw AttendanceException(code: _code);
    }
  }

  Future<int> countAbsentAll(int id) async {
    try {
      Response response =
          await get(Uri.parse('$baseUrl/attendance_count?absent=$id'));

      if (response.statusCode != 200) {
        _code = response.statusCode;
        throw AttendanceException(code: _code);
      }

      return int.parse(response.body);
    } catch (e) {
      throw AttendanceException(code: _code);
    }
  }

  Future<int> countLateAll(int id) async {
    try {
      Response response =
          await get(Uri.parse('$baseUrl/attendance_count?late=$id'));

      if (response.statusCode != 200) {
        _code = response.statusCode;
        throw AttendanceException(code: _code);
      }

      return int.parse(response.body);
    } catch (e) {
      throw AttendanceException(code: _code);
    }
  }

  Future<int> countPresentAll(int id) async {
    try {
      Response response =
          await get(Uri.parse('$baseUrl/attendance_count?present=$id'));

      if (response.statusCode != 200) {
        _code = response.statusCode;
        throw AttendanceException(code: _code);
      }

      return int.parse(response.body);
    } catch (e) {
      throw AttendanceException(code: _code);
    }
  }

  Future<int> countPermissionAll(int id) async {
    try {
      Response response =
          await get(Uri.parse('$baseUrl/attendance_count?permission=$id'));

      if (response.statusCode != 200) {
        _code = response.statusCode;
        throw AttendanceException(code: _code);
      }

      return int.parse(response.body);
    } catch (e) {
      throw AttendanceException(code: _code);
    }
  }

  Future<List<dynamic>> findAll() async {
    try {
      Response response = await get(Uri.parse('$baseUrl/showAll'));
      _code = response.statusCode;
      List<dynamic> jsondata = json.decode(response.body);
      // List<Attendance> att = [];

      // jsondata.asMap().forEach((key, value) {
      //   User _user = User.fromJson(value);

      //   List<Attendance> _attendances =
      //       attendancesFromJson(value["attendances"]);

      //   List<Attendance> attendances = _attendances.map((attendance) {
      //     return attendance.copyWith(users: _user);
      //   }).toList();
      //   att.addAll(attendances);
      // if (attendances.where((element) => element.userId == _user.id)) {
      //   print(attendances
      //       .where((element) => element.type == 'check in')
      //       .length);
      // }
      // });

      // List<Attendance> attendances = [Attendance(), Attendance()];
      return jsondata;
    } catch (e) {
      throw AttendanceException(code: _code);
    }
  }

  Future<List<AttendancesWithDateWithUser>> findMany() async {
    try {
      Response response = await get(Uri.parse('$baseUrl/attendances'));
      _code = response.statusCode;
      var jsondata = json.decode(response.body);
      List<AttendancesWithDateWithUser> awd = [];
      awd = attendancesWithUserbyDayFromJson(jsondata);
      return awd;
    } catch (e) {
      throw AttendanceException(code: _code);
    }
  }

  Future<AttendancesWithUser> findoneById(int id) async {
    try {
      Response response = await get(Uri.parse('$baseUrl/attendances/$id'));
      _code = response.statusCode;
      var jsondata = json.decode(response.body);
      var data = AttendancesWithUser.fromJson(jsondata);
      print(data);
      return data;
    } catch (e) {
      throw AttendanceException(code: _code);
    }
  }

  Future<List<AttendanceWithDate>> findManyByUserId({
    required int userId,
    DateTime? start,
    DateTime? end,
  }) async {
    return [];
    String startDate = _formatDate(start);
    String endDate = _formatDate(end);

    bool hasNoStartOrEndDate =
        start == null || end == null || startDate.isEmpty || endDate.isEmpty;

    String url = hasNoStartOrEndDate
        ? '$baseUrl/users/$userId/attendances'
        : '$baseUrl/users/$userId/attendances?start=$startDate&end=$endDate';
    try {
      Response response = await get(Uri.parse(url));

      _code = response.statusCode;
      if (response.statusCode == 200) {
        var jsondata = json.decode(response.body);
        // get the user object

        User _user = User.fromJson(jsondata['data']['user']);
        if (jsondata['data']["attendances"] != null &&
            jsondata['data']["attendances"].length > 0) {
          Map<String, dynamic>? map = jsondata['data']["attendances"];
          List<AttendanceWithDate> _attendances =
              attendancesByDayFromJson(map!);

          //adding user object to the attendances
          List<AttendanceWithDate> awds = _attendances.map((awd) {
            List<Attendance> atts = awd.list.map((attendance) {
              return attendance.copyWith(users: _user);
            }).toList();

            return awd.copyWith(list: atts);
          }).toList();
          return awds;
        } else {
          return [];
        }
      } else {
        throw AttendanceException(code: _code);
      }
    } catch (e) {
      throw AttendanceException(code: _code);
    }
  }

  Future<List<AttendanceWithDate>> findManyByUserIdNoOvertime({
    required int userId,
    DateTime? start,
    DateTime? end,
  }) async {
    String startDate = _formatDate(start);
    String endDate = _formatDate(end);

    bool hasNoStartOrEndDate =
        start == null || end == null || startDate.isEmpty || endDate.isEmpty;

    String url = hasNoStartOrEndDate
        ? '$baseUrl/users/$userId/attendances'
        : '$baseUrl/users/$userId/attendances?start=$startDate&end=$endDate&overtime=null';
    try {
      Response response = await get(Uri.parse(url));

      _code = response.statusCode;
      if (response.statusCode == 200) {
        var jsondata = json.decode(response.body);
        // get the user object

        User _user = User.fromJson(jsondata['data']['user']);
        if (jsondata['data']["attendances"] != null &&
            jsondata['data']["attendances"].length > 0) {
          Map<String, dynamic>? map = jsondata['data']["attendances"];
          List<AttendanceWithDate> _attendances =
              attendancesByDayFromJson(map!);

          //adding user object to the attendances
          List<AttendanceWithDate> awds = _attendances.map((awd) {
            List<Attendance> atts = awd.list.map((attendance) {
              return attendance.copyWith(users: _user);
            }).toList();

            return awd.copyWith(list: atts);
          }).toList();
          return awds;
        } else {
          return [];
        }
      } else {
        throw AttendanceException(code: _code);
      }
    } catch (e) {
      throw AttendanceException(code: _code);
    }
  }

  Future<Attendance> createOne({required Attendance attendance}) async {
    if (attendance.userId == null || attendance.type!.isEmpty) {
      throw AttendanceException(
          code: 0, message: "Required fields cannot be empty.");
    }
    var jsons =
        attendance.copyWith(date: attendance.date ?? DateTime.now()).toJson();

    try {
      Response response = await post(
        Uri.parse(
          '$baseUrl/attendances',
        ),
        headers: headers(),
        body: json.encode(jsons),
      );

      if (response.statusCode == 201) {
        var jsondata = json.decode(response.body);
        var createdAttendance = Attendance.fromJson(jsondata);
        return createdAttendance;
      }

      _code = response.statusCode;
      throw AttendanceException(code: _code);
    } catch (e) {
      throw AttendanceException(code: _code);
    }
  }

  Future<Attendance> updateOne(Attendance attendance) async {
    if (attendance.id!.isNaN ||
        attendance.id!.isNegative ||
        attendance.id == 0) {
      throw AttendanceException(code: 2);
    }

    int? attId = attendance.id;
    var jsons = attendance.toJson();

    try {
      Response response = await put(
        Uri.parse(
          '$baseUrl/attendances/$attId',
        ),
        headers: headers(),
        body: json.encode(jsons),
      );

      if (response.statusCode == 200) {
        var jsondata = json.decode(response.body);
        var attendance = Attendance.fromJson(jsondata);
        return attendance;
      } else {
        _code = response.statusCode;
        throw AttendanceException(code: _code);
      }
    } catch (e) {
      throw AttendanceException(code: _code);
    }
  }

  Future<bool> deleteOne(int id) async {
    try {
      Response response = await delete(
        Uri.parse('$baseUrl/attendances/$id'),
        headers: headers(),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        _code = response.statusCode;
        throw AttendanceException(code: _code);
      }
    } catch (e) {
      throw AttendanceException(code: _code);
      //
    }
  }

  Future<String> generateQRCode() async {
    try {
      Response response = await get(
        Uri.parse('$baseUrl/generateqrcode'),
        headers: headers(),
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        _code = response.statusCode;
        throw AttendanceException(code: _code);
      }
    } catch (e) {
      throw AttendanceException(code: _code);
    }
  }

  Future<bool> verifyQRCode(String code) async {
    try {
      Response response = await get(
        Uri.parse('$baseUrl/verifyqrcode?code=$code'),
        headers: headers(),
      );

      if (response.statusCode == 200) {
        return true;
      }
      if (response.statusCode == 404) {
        return false;
      } else {
        _code = response.statusCode;
        throw AttendanceException(code: _code);
      }
    } catch (e) {
      throw AttendanceException(code: _code);
      //
    }
  }

  Future<List<Attendances>> findManyAttendances() async {
    try {
      Response response = await get(Uri.parse('$baseUrl/attendances'));

      if (response.statusCode != 200) {
        _code = response.statusCode;
        throw 'error';
      }
      var jsondata = json.decode(response.body);
      var attendances = attendancessFromJson(jsondata);
      return attendances;
    } catch (e) {
      throw e;
    }
  }

  Future<List<AttendancesWithDate>> findManyAttendancesById({
    required int userId,
    DateTime? start,
    DateTime? end,
  }) async {
    String startDate = _formatDate(start);
    String endDate = _formatDate(end);

    bool hasNoStartOrEndDate =
        start == null || end == null || startDate.isEmpty || endDate.isEmpty;

    String url = hasNoStartOrEndDate
        ? '$baseUrl/users/$userId/attendances'
        : '$baseUrl/users/$userId/attendances?start=$startDate&end=$endDate&overtime=null';
    try {
      Response response = await get(Uri.parse(url));

      _code = response.statusCode;
      if (response.statusCode == 200) {
        var jsondata = json.decode(response.body);
        // get the user object

        User _user = User.fromJson(jsondata['data']['user']);
        if (jsondata['data']["attendances"] != null &&
            jsondata['data']["attendances"].length > 0) {
          Map<String, dynamic>? map = jsondata['data']["attendances"];
          List<AttendancesWithDate> _attendances =
              attendancesbyDayFromJson(map!);

          //adding user object to the attendances
          List<AttendancesWithDate> awds = _attendances.map((awd) {
            List<Attendances> atts = awd.list.map((attendance) {
              return attendance.copyWith(user: _user);
            }).toList();

            return awd.copyWith(list: atts);
          }).toList();
          return awds;
        } else {
          return [];
        }
      } else {
        throw AttendanceException(code: _code);
      }
    } catch (e) {
      throw e;
    }
  }
}
