class IndividualAttendance {
  final String name;
  final String id;
  final String totalPresent;
  final String totalAbsent;
  final String totalPermission;
  final String totalLate;
  final DateTime isAbsent;
  final DateTime isPermission;

  IndividualAttendance({
    required this.name,
    required this.id,
    required this.totalPresent,
    required this.totalAbsent,
    required this.totalPermission,
    required this.totalLate,
    required this.isAbsent,
    required this.isPermission,
  });
}
