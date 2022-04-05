import 'package:ems/constants.dart';
import 'package:ems/persistence/current_user.dart';
import 'package:ems/services/attendance.dart';
import 'package:ems/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AttendanceSummary extends ConsumerStatefulWidget {
  const AttendanceSummary({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _AttendanceSummaryState();
}

class _AttendanceSummaryState extends ConsumerState<AttendanceSummary> {
  final AttendanceService attService = AttendanceService.instance;
  double present = 0, late = 0, permission = 0, absent = 0;

  bool isFetching = false;

  void fetchData() async {
    bool isOnline = await InternetConnectionChecker().hasConnection;
    if (!isOnline) return;
    setState(() {
      isFetching = true;
    });
    var date = DateTime.now();
    int month = date.month;
    int year = date.year;
    int userId = intParse(ref.read(currentUserProvider).user.id);
    try {
      var ac = await attService.countAttendance(
        userId,
        start: DateTime(year, month, 1),
        end: DateTime(year, month, 31),
      );
      setState(() {
        present = (ac.totalPresent ?? 0) / 2;
        late = (ac.totalLate ?? 0) / 2;
        permission = (ac.totalPermission ?? 0) / 2;
        absent = (ac.totalAbsent ?? 0) / 2;
      });
    } catch (err) {
      //
    } finally {
      setState(() {
        isFetching = false;
      });
    }
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${local?.attendanceSummary(DateTime.now().month)}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            _buildFetchingButton(),
          ],
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
              count: present,
              label: '${local?.present}',
            ),
            _buildBox(
              backgroundColor: kYellowBackground,
              textColor: kYellowText,
              count: late,
              label: '${local?.late}',
            ),
            _buildBox(
              backgroundColor: kBlueBackground,
              textColor: kBlueText,
              count: permission,
              label: '${local?.permission}',
            ),
            _buildBox(
              backgroundColor: kRedBackground,
              textColor: kRedText,
              count: absent,
              label: '${local?.absent}',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFetchingButton() {
    return isFetching
        ? const SizedBox(
            height: 10,
            width: 10,
            child: CircularProgressIndicator(
              color: kWhite,
              strokeWidth: 2,
            ),
          )
        : GestureDetector(
            onTap: fetchData,
            child: const Icon(
              MdiIcons.refresh,
              color: kWhite,
              size: 16,
            ),
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
