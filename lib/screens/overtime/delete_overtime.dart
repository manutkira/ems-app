import 'package:ems/models/overtime.dart';
import 'package:ems/services/attendance.dart';
import 'package:ems/utils/utils.dart';
import 'package:ems/widgets/baseline_row.dart';
import 'package:ems/widgets/statuses/error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../constants.dart';

class DeleteOvertime extends StatefulWidget {
  const DeleteOvertime({Key? key, required this.record}) : super(key: key);
  final Overtime record;

  @override
  _DeleteOvertimeState createState() => _DeleteOvertimeState();
}

class _DeleteOvertimeState extends State<DeleteOvertime> {
  bool isLoading = false;
  bool hasError = false;
  String error = "";
  final AttendanceService _attendanceService = AttendanceService.instance;
  late Overtime record;

  void deleteOvertime() async {
    setState(() {
      isLoading = true;
    });

    try {
      if (record.checkIn != null) {
        await _attendanceService.deleteOneRecord(record.checkIn?.id as int);
      }
      // if there is a check out record
      if (record.checkOut != null) {
        await _attendanceService.deleteOneRecord(record.checkOut?.id as int);
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
      goBack(context);
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

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BaselineRow(
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
                  onPressed: () => goBack(context),
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
