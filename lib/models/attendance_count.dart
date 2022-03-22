import 'package:ems/models/user.dart';

import '../../utils/utils.dart';

class AttendanceCount {
  int? morningPresent;
  int? morningLate;
  int? afternoonPresent;
  int? afternoonLate;
  int? totalPresent;
  int? totalLate;
  User? user;

  AttendanceCount({
    this.morningPresent,
    this.morningLate,
    this.afternoonPresent,
    this.afternoonLate,
    this.totalPresent,
    this.totalLate,
    this.user,
  });

  factory AttendanceCount.fromJson(Map<String, dynamic>? json) {
    var user = json?['users'];
    var attendanceCount = json?['attendance_count'];
    var morning = attendanceCount['morning'];
    var afternoon = attendanceCount['afternoon'];
    var total = attendanceCount['total'];
    return AttendanceCount(
      morningPresent: intParse(morning['present']),
      morningLate: intParse(morning['late']),
      afternoonPresent: intParse(afternoon['present']),
      afternoonLate: intParse(afternoon['late']),
      totalPresent: intParse(total['present']),
      totalLate: intParse(total['late']),
      user: User.fromJson(user),
    );
  }
}
