import 'package:ems/models/user.dart';

import '../../utils/utils.dart';

class AttendanceCount {
  int? morningPresent;
  int? morningLate;
  int? morningAbsent;
  int? morningPermission;
  int? afternoonPresent;
  int? afternoonLate;
  int? afternoonAbsent;
  int? afternoonPermission;
  int? totalPresent;
  int? totalLate;
  int? totalAbsent;
  int? totalPermission;
  User? user;

  AttendanceCount({
    this.morningPresent,
    this.morningLate,
    this.morningAbsent,
    this.morningPermission,
    this.afternoonPresent,
    this.afternoonLate,
    this.afternoonAbsent,
    this.afternoonPermission,
    this.totalPresent,
    this.totalLate,
    this.totalAbsent,
    this.totalPermission,
    this.user,
  });

  factory AttendanceCount.fromJson(Map<String, dynamic>? json) {
    var user = json?['users'];
    var attendanceCount = json?['attendance_count'];
    var morning = attendanceCount['morning'];
    var afternoon = attendanceCount['afternoon'];
    var total = attendanceCount['total'];
    // print(total);
    return AttendanceCount(
      morningPresent: intParse(morning['present']),
      morningLate: intParse(morning['late']),
      morningAbsent: intParse(morning['absent']),
      morningPermission: intParse(morning['permission']),
      afternoonPresent: intParse(afternoon['present']),
      afternoonLate: intParse(afternoon['late']),
      afternoonAbsent: intParse(afternoon['absent']),
      afternoonPermission: intParse(afternoon['permission']),
      totalPresent: intParse(total['present']),
      totalLate: intParse(total['late']),
      totalAbsent: intParse(total['absent']),
      totalPermission: intParse(total['permission']),
      user: User.fromJson(user),
    );
  }
}
