import 'package:dio/dio.dart';
import 'package:ems/services/base.dart';
import 'package:ems/services/models/overtime.dart';
import 'package:ems/models/user.dart';
import '../utils/utils.dart';

class OvertimeService extends BaseService {
  static OvertimeService get instance => OvertimeService();

  findMany({
    DateTime? start,
    DateTime? end,
  }) async {
    try {
      String startDate = "${convertDateTimeToString(start)}";
      String endDate = "${convertDateTimeToString(end)}";

      bool hasValidFilter = (startDate.isNotEmpty && startDate != "null") ||
          (endDate.isNotEmpty && endDate != "null");
      String path = hasValidFilter
          ? 'overtimes?start=$startDate&end=$endDate'
          : 'overtimes';

      Response res = await dio.get(
        path,
        options: Options(validateStatus: (status) => status == 200),
      );

      List<OvertimesByDate> list =
          overtimesByDatesFromJson(res.data['attendance']);
      return list;
    } catch (err) {
       if (err is DioError) {
        throw Exception(err.response?.data['message']);
      }
      throw Exception(err.toString());
    }
  }

  findManyByUserId({
    required int userId,
    DateTime? start,
    DateTime? end,
  }) async {
    try {
      String startDate = "${convertDateTimeToString(start)}";
      String endDate = "${convertDateTimeToString(end)}";

      bool hasValidFilter = (startDate.isNotEmpty && startDate != "null") ||
          (endDate.isNotEmpty && endDate != "null");
      String path = hasValidFilter
          ? 'users/$userId/overtimes?start=$startDate&end=$endDate'
          : 'users/$userId/overtimes';

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

      if (data['attendances'].length == 0) {
        return OvertimesWithTotal.fromJson(
          data['total_hour'],
          [],
        );
      }

      User user = User.fromJson(data['users']);
      // the overtime list will not have a user object.
      // list.first.overtimes?.first.user?.name would return null
      List<OvertimesByDate> list = overtimesByDatesFromJson(
        data['attendances'],
      );

      // add user object to overtime.user
      // list.first.overtimes?.first.user?.name would return the user name
      List<OvertimesByDate> listWithUsers = list
          .map(
            // add all new overtime records
            (obd) => obd.copyWith(
              overtimes: obd.overtimes
                  ?.map(
                    // add user to the new overtime record
                    (ot) => ot.copyWith(
                      user: user,
                    ),
                  )
                  .toList(),
            ),
          )
          .toList();

      OvertimesWithTotal owt = OvertimesWithTotal.fromJson(
        data['total_hour'],
        listWithUsers,
      );

      return owt;
    } catch (err) {
       if (err is DioError) {
        throw Exception(err.response?.data['message']);
      }
      throw Exception(err.toString());
    }
  }
}
