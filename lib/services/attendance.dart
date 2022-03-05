import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ems/services/base.dart';
import 'package:ems/services/models/attendance.dart';

import '../models/attendance_count.dart';
import '../models/user.dart';
import '../utils/utils.dart';

class AttendanceService extends BaseService {
  static AttendanceService get instance => AttendanceService();

  Future<List<AttendancesByDate>> findMany({
    DateTime? start,
    DateTime? end,
  }) async {
    String startDate = "${convertDateTimeToString(start)}";
    String endDate = "${convertDateTimeToString(end)}";

    bool hasValidFilter = (startDate.isNotEmpty && startDate != "null") ||
        (endDate.isNotEmpty && endDate != "null");
    String path = hasValidFilter
        ? 'attendances?start=$startDate&end=$endDate'
        : 'attendances';
    try {
      Response res = await dio.get(path);
      var data = res.data['attendances'];
      List<AttendancesByDate> list = attendancesByDatesFromJson(data);
      return list;
    } catch (err) {
      if (err is DioError) {
        throw Exception(err.response?.data['message']);
      }
      throw Exception(err.toString());
    }
  }

  Future<List<AttendancesByDate>> findManyByUserId(
    int userId, {
    DateTime? start,
    DateTime? end,
  }) async {
    try {
      String startDate = "${convertDateTimeToString(start)}";
      String endDate = "${convertDateTimeToString(end)}";

      bool hasValidFilter = (startDate.isNotEmpty && startDate != "null") ||
          (endDate.isNotEmpty && endDate != "null");
      String path = hasValidFilter
          ? 'users/$userId/attendances?start=$startDate&end=$endDate'
          : 'users/$userId/attendances';

      Response res = await dio.get(
        path,
        options: Options(validateStatus: (status) => status == 200),
      );

      // the data return from the api is not consistent
      // res.data should return
      // {
      //  data: {
      //    user: {...user data here},
      //    attendances: {date: [attendances]}
      // }
      // }
      var data = res.data['data'];
      if (data['attendances']?.length == 0) {
        return [];
      }

      User user = User.fromJson(data['users']);
      // the overtime list will not have a user object.
      // list.first.overtimes?.first.user?.name would return null
      List<AttendancesByDate> list = attendancesByDatesFromJson(
        data['attendances'],
      );

      // add user object to overtime.user
      // list.first.overtimes?.first.user?.name would return the user name
      List<AttendancesByDate> finalList = list
          .map((awd) => awd.copyWith(
                attendances: awd.attendances
                    ?.map((att) => att.copyWith(user: user))
                    .toList(),
              ))
          .toList();
      return finalList;
    } catch (err) {
      if (err is DioError) {
        throw Exception(err.response?.data['message']);
      }
      throw Exception(err.toString());
    }
  }

  Future<AttendanceRecord> findOneRecord(int id) async {
    try {
      Response res = await dio.get(
        'attendance_record/$id',
        options: Options(validateStatus: (status) => status == 200),
      );
      return AttendanceRecord.fromJson(res.data);
    } catch (err) {
      if (err is DioError) {
        throw Exception(err.response?.data['message']);
      }
      throw Exception(err.toString());
    }
  }

  Future<AttendanceRecord> updateOneRecord(AttendanceRecord record) async {
    try {
      var payload = record.toJson();
      Response res = await dio.put(
        'attendance_record/${record.id}',
        data: payload,
        options: Options(validateStatus: (status) => status == 200),
      );
      return AttendanceRecord.fromJson(res.data);
    } catch (err) {
      if (err is DioError) {
        throw Exception(err.response?.data['message']);
      }
      throw Exception(err.toString());
    }
  }

  Future<void> deleteOneRecord(int id) async {
    try {
      await dio.delete(
        'attendance_record/$id',
        options: Options(validateStatus: (status) => status == 200),
      );
    } catch (err) {
      if (err is DioError) {
        throw Exception(err.response?.data['message']);
      }
      throw Exception(err.toString());
    }
  }

  Future<void> createOneRecord({
    required int userId,
    required DateTime date,
    String? note,
  }) async {
    try {
      var payload = {
        "user_id": userId,
        "date": date.toIso8601String(),
      };
      if (note != null && note.isNotEmpty) {
        payload['note'] = note.toString();
      }
      await dio.post(
        'attendances',
        data: payload,
        options: Options(validateStatus: (status) => status == 200),
      );
    } catch (err) {
      if (err is DioError) {
        throw Exception(err.response?.data['message']);
      }
      throw Exception(err.toString());
    }
  }

  Future<void> createManyRecords(List<dynamic> cache) async {
    if (cache.toString() == "[]" || cache.toString() == "null") {
      return;
    }
    // removes unnecessary user object
    // decoding the encoded object to actually copy the object.
    // with other methods, the local cache got modified.
    var clean = json.decode(json.encode(cache)).map((att) {
      att.removeWhere((key, value) => key == 'user');
      return att;
    }).toList();

    try {
      await dio.post(
        'attendances/mass',
        data: {
          "data": clean,
        },
        options: Options(validateStatus: (status) => status == 200),
      );
    } catch (err) {
      if (err is DioError) {
        throw Exception(err.response?.data['message']);
      }
      throw Exception(err.toString());
    }
  }

  Future<AttendanceCount> countAttendance(int userId,
      {DateTime? start, DateTime? end}) async {
    String startDate = "${convertDateTimeToString(start)}";
    String endDate = "${convertDateTimeToString(end)}";

    bool hasValidFilter = (startDate.isNotEmpty && startDate != "null") ||
        (endDate.isNotEmpty && endDate != "null");
    String path = hasValidFilter
        ? 'users/$userId/attendance_count?start=$startDate&end=$endDate'
        : 'users/$userId/attendance_count';

    try {
      Response res = await dio.get(
        path,
        options: Options(validateStatus: (status) => status == 200),
      );
      return AttendanceCount.fromJson(res.data);
    } catch (err) {
      if (err is DioError) {
        throw Exception(err.response?.data['message']);
      }
      throw Exception(err.toString());
    }
  }
}
