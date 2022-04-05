import 'package:ems/constants.dart';
import 'package:ems/models/attendance_count.dart';
import 'package:ems/persistence/current_user.dart';
import 'package:ems/services/attendance.dart';
import 'package:ems/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AttendanceSummary extends ConsumerStatefulWidget {
  const AttendanceSummary({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _AttendanceSummaryState();
}

class _AttendanceSummaryState extends ConsumerState<AttendanceSummary> {
  final AttendanceService attService = AttendanceService.instance;
  late AttendanceCount attendanceCount;

  void fetchData() async {
    var date = DateTime.now();
    int month = date.month;
    int year = date.year;
    int userId = intParse(ref.read(currentUserProvider).user.id);
    var ac = await attService.countAttendance(
      userId,
      start: DateTime(year, month - 3, 1),
      end: DateTime(year, month, 31),
    );
    setState(() {
      attendanceCount = ac;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? local = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${local?.attendanceSummary}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        GridView.count(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 3,
          children: [
            _buildBox(
              backgroundColor: kGreenBackground,
              textColor: kGreenText,
              count: (attendanceCount.totalPresent ?? 0) / 2,
              label: '${local?.present}',
            ),
            _buildBox(
              backgroundColor: kYellowBackground,
              textColor: kYellowText,
              count: (attendanceCount.totalLate ?? 0) / 2,
              label: '${local?.late}',
            ),
            _buildBox(
              backgroundColor: kBlueBackground,
              textColor: kBlueText,
              // count: (attendanceCount ?? 0) / 2,
              label: '${local?.permission}',
            ),
            _buildBox(
              backgroundColor: kRedBackground,
              textColor: kRedText,
              label: '${local?.absent}',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBox({
    required Color backgroundColor,
    required Color textColor,
    double count = 0,
    required String label,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        color: kWhite,
        child: Row(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: backgroundColor,
                ),
                child: Center(
                  child: Text(
                    count.toString(),
                    style: TextStyle(
                      color: textColor,
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: kBlack,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
