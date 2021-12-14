import 'dart:convert';

import 'package:ems/models/overtime.dart';
import 'package:ems/models/user.dart';
import 'package:http/http.dart';

import 'base_service.dart';
import 'exceptions/attendance.dart';

class OvertimeService extends BaseService {
  static OvertimeService get instance => OvertimeService();
  int _code = 0;

  Future<List<OvertimeAttendance>> findManyByUserId(
      {required int userId}) async {
    try {
      Response response =
          await get(Uri.parse('$baseUrl/users/$userId/overtimes'));
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

      return overtimeWithUser;
    } catch (e) {
      throw AttendanceException(code: _code);
    }
  }
}
