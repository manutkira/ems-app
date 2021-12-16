import 'dart:convert';

import 'package:ems/models/attendance_no_s.dart';
import 'package:ems/models/overtime.dart';
import 'package:ems/models/user.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

import 'base_service.dart';
import 'exceptions/attendance.dart';

class OvertimeService extends BaseService {
  static OvertimeService get instance => OvertimeService();
  int _code = 0;

  Future<OvertimeListWithTotal> findManyByUserId({
    required int userId,
    DateTime? start,
    DateTime? end,
  }) async {
    String startDate = start != null ? DateFormat('y-M-d').format(start) : '';
    String endDate = end != null ? DateFormat('y-M-d').format(end) : '';

    bool noStartOrEndDate =
        start == null || end == null || startDate.isEmpty || endDate.isEmpty;

    String url = noStartOrEndDate
        ? '$baseUrl/users/$userId/overtimes'
        : '$baseUrl/users/$userId/overtimes?start=$startDate&end=$endDate';
    try {
      Response response = await get(
        Uri.parse(
          url,
        ),
      );
      _code = response.statusCode;
      var jsondata = json.decode(response.body);

      List<OvertimeAttendance> _overtimeWithoutUser =
          overtimesFromJson(jsondata['data']['attendances']);

      // get the user object
      User _user = User.fromJson(jsondata["data"]["user"]);
      // attendance object without user object

      //adding user object to the overtime object
      List<OvertimeAttendance> overtimeWithUser =
          _overtimeWithoutUser.map((overtime) {
        return overtime.copyWith(user: _user);
      }).toList();

      return OvertimeListWithTotal(
        total: jsondata['data']['total_hour'],
        listOfOvertime: overtimeWithUser,
      );
    } catch (e) {
      throw AttendanceException(code: _code);
    }
  }
}

class AttendanceByIdService extends BaseService {
  static AttendanceByIdService get instance => AttendanceByIdService();
  int _code = 0;

  Future<List<AttendanceById>> findByUserId({required int userId}) async {
    try {
      Response response =
          await get(Uri.parse('$baseUrl/user/$userId/attendance'));
      _code = response.statusCode;
      var jsondata = json.decode(response.body);

      List<AttendanceById> _overtimeWithoutUser =
          attendanceByIdFromJson(jsondata['data']['attendances']);
      // print('Service $_overtimeWithoutUser');

      // get the user object
      User _user = User.fromJson(jsondata["data"]["user"]);
      // attendance object without user object

      //adding user object to the overtime object
      List<AttendanceById> overtimeWithUser =
          _overtimeWithoutUser.map((overtime) {
        return overtime.copyWith(user: _user);
      }).toList();

      return overtimeWithUser;
    } catch (e) {
      throw AttendanceException(code: _code);
    }
  }
}
