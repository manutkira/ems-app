import 'package:ems/models/overtime.dart';
import 'package:ems/utils/services/attendance_service.dart';
import 'package:ems/utils/utils.dart';
import 'package:ems/widgets/statuses/error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../constants.dart';

class Overtime {
  static get uid => 1;
  static get name => "Kim Song";
  static get date => DateTime.now();
  static get startedTime => TimeOfDay.now();
  static get endedTime => TimeOfDay.now();
  static get note => "finish the project";
}

class DeleteOvertime extends StatefulWidget {
  const DeleteOvertime({Key? key, required this.record}) : super(key: key);
  final OvertimeAttendance record;

  @override
  _DeleteOvertimeState createState() => _DeleteOvertimeState();
}

class _DeleteOvertimeState extends State<DeleteOvertime> {
  bool isLoading = false;
  bool hasError = false;
  String error = "";
  final AttendanceService _attendanceService = AttendanceService.instance;
  late OvertimeAttendance record;
  void _closePanel() {
    Navigator.of(context).pop();
  }

  void deleteOvertime() async {
    setState(() {
      isLoading = true;
    });

    try {
      await _attendanceService.deleteOne(int.parse("${record.checkin?.id}"));
      // if there is a check out record
      if (record.checkin?.id != record.checkout?.id) {
        await _attendanceService.deleteOne(int.parse("${record.checkout?.id}"));
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
        error = e.toString();
      });
    }

    setState(() {
      isLoading = false;
      _closePanel();
    });
  }

  @override
  void initState() {
    super.initState();
    record = widget.record;
    deleteOvertime();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);
    // deleteOvertime();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${local?.deleteOvertime}',
                style: kHeadingTwo,
              ),
              Visibility(
                visible: !isLoading,
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    primary: Colors.white,
                    textStyle: kParagraph.copyWith(fontWeight: FontWeight.w700),
                    backgroundColor: kBlack.withOpacity(0.3),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(kBorderRadius),
                    ),
                  ),
                  onPressed: _closePanel,
                  child: const Icon(
                    MdiIcons.close,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Visibility(
            visible: !isLoading && hasError,
            child: StatusError(text: "${local?.errorDeletingOvertime}"),
          ),
          SizedBox(
            height: 250,
            child: Center(
              child: Visibility(
                visible: isLoading,
                child: const CircularProgressIndicator(color: kWhite),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
