import 'dart:convert';

import 'package:ems/models/attendance.dart';
import 'package:ems/models/user.dart';
import 'package:http/http.dart';

import 'base_service.dart';
import 'exceptions/attendance.dart';

class AttendanceService extends BaseService {
  AttendanceService get instance => this;
  int _code = 0;

  Future<Attendance> findOne(int id) async {
    try {
      Response response = await get(Uri.parse('$baseUrl/attendances/$id'));
      _code = response.statusCode;
      var jsondata = json.decode(response.body);
      print(response.body);
      var attendance = Attendance.fromJson(jsondata);
      return attendance;
    } catch (e) {
      throw AttendanceException(code: _code);
    }
  }

  Future<List<Attendance>> findMany() async {
    try {
      Response response = await get(Uri.parse('$baseUrl/attendances'));
      _code = response.statusCode;
      var jsondata = json.decode(response.body);
      var attendances = attendancesFromJson(jsondata);
      print(attendances[0].users?.name);
      return attendances;
    } catch (e) {
      throw AttendanceException(code: _code);
    }
  }

  Future<List<Attendance>> findManyByUserId({required int userId}) async {
    try {
      Response response =
          await get(Uri.parse('$baseUrl/users/$userId/attendances'));
      _code = response.statusCode;
      var jsondata = json.decode(response.body);
      // get the user object
      User _user = User.fromJson(jsondata["users"]);
      // attendance object without user object
      List<Attendance> _attendances =
          attendancesFromJson(jsondata["users"]["attendances"]);

      //adding user object to the attendances
      List<Attendance> attendances = _attendances.map((attendance) {
        return attendance.copyWith(users: _user);
      }).toList();

      return attendances;
    } catch (e) {
      throw AttendanceException(code: _code);
    }
  }

  Future<Attendance> createOne({required Attendance attendance}) async {
    if (attendance.userId == null ||
        attendance.type!.isEmpty ||
        attendance.date == null) {
      throw AttendanceException(
          code: 0, message: "Required fields cannot be empty.");
    }
    var jsons = attendance.toJson();
    try {
      Response response = await post(
        Uri.parse(
          '$baseUrl/attendances',
        ),
        headers: headers,
        body: json.encode(jsons),
      );
      _code = response.statusCode;
      print(response.body);
      var jsondata = json.decode(response.body);
      var attendance = Attendance.fromJson(jsondata);
      return attendance;
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
          '$baseUrl/attendances/${attId}',
        ),
        headers: headers,
        body: json.encode(jsons),
      );
      _code = response.statusCode;
      var jsondata = json.decode(response.body);
      var attendance = Attendance.fromJson(jsondata);
      return attendance;
    } catch (e) {
      throw AttendanceException(code: _code);
    }
  }

  Future<bool> deleteOne(int id) async {
    try {
      Response response = await delete(Uri.parse('$baseUrl/attendances/$id'));

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
}
