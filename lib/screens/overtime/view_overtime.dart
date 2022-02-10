import 'package:ems/models/overtime.dart';
import 'package:ems/models/user.dart';
import 'package:ems/utils/utils.dart';
import 'package:ems/widgets/baseline_row.dart';
import 'package:ems/widgets/circle_avatar.dart';
import 'package:ems/widgets/statuses/error.dart';
import 'package:flutter/material.dart';
// class Overtime {
//   static get uid => 1;
//   static get name => "Kim Song";
//   static get date => DateTime.now();
//   static get startedTime => TimeOfDay.now();
//   static get endedTime => TimeOfDay.now();
//   static get note => "finish the project";
// }
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../constants.dart';

class ViewOvertime extends StatefulWidget {
  const ViewOvertime({Key? key, required this.record}) : super(key: key);
  final OvertimeRecord record;

  @override
  _ViewOvertimeState createState() => _ViewOvertimeState();
}

class _ViewOvertimeState extends State<ViewOvertime> {
  String error = "";

  void _closePanel() {
    Navigator.of(context).pop();
  }

  String formatTime(TimeOfDay? time) {
    AppLocalizations? local = AppLocalizations.of(context);
    if (time != null) {
      return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
    } else {
      // return "${local?.errorParsingTime}";
      return '00:00';
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? local = AppLocalizations.of(context);
    Size _size = MediaQuery.of(context).size;
    OvertimeRecord record = widget.record;
    AttendanceRecord? checkIn = record.checkIn;
    AttendanceRecord? checkOut = record.checkOut;
    TimeOfDay _time = getTimeOfDayFromString(record.duration);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // title
          BaselineRow(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${local?.viewOvertime}',
                style: kHeadingThree,
              ),
              TextButton(
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
                  color: Colors.redAccent,
                  size: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          //user info
          _buildUserInfo(_size),
          const SizedBox(height: 20),
          //date
          BaselineRow(
            children: [
              Text(
                "${local?.date}",
                style: kParagraph.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                width: 20,
              ),
              Text(
                getDateStringFromDateTime(record.date),
                style: kParagraph,
              ),
            ],
          ),
          _buildSpacer(),
          // from/to
          BaselineRow(
            children: [
              Text(
                "${local?.from}",
                style: kParagraph.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                width: 20,
              ),
              Text(
                formatTime(checkIn?.time),
                style: kParagraph,
              ),
              const SizedBox(
                width: 20,
              ),
              Text(
                "${local?.to}",
                style: kParagraph.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                width: 20,
              ),
              Text(
                formatTime(checkOut?.time),
                style: kParagraph,
              ),
            ],
          ),
          _buildSpacer(),
          // total
          BaselineRow(
            children: [
              Text(
                "${local?.total}",
                style: kParagraph.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(width: 20),
              Text("${_time.hour}h ${_time.minute}mn", style: kParagraph),
            ],
          ),
          _buildSpacer(),
          // note
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${local?.note}',
                style: kParagraph.copyWith(fontWeight: FontWeight.w700),
              ),
              _buildSpacer(),
              Text(checkIn?.note ?? "", style: kParagraph),
              const SizedBox(height: 20),
            ],
          ),
          // error
          Visibility(
            visible: error.isNotEmpty,
            child: Column(
              children: [
                StatusError(text: "${local?.error}"),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfo(Size _size) {
    AppLocalizations? local = AppLocalizations.of(context);
    OvertimeRecord record = widget.record;
    User? user = record.user;

    return Container(
      height: 60,
      width: _size.width,
      decoration: BoxDecoration(
        color: kDarkestBlue,
        borderRadius: BorderRadius.circular(6),
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomCircleAvatar(
            imageUrl: "${user?.image}",
            size: 50,
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BaselineRow(
                children: [
                  Text(
                    'ID',
                    style: kParagraph.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '${user?.id ?? ""}',
                    style: kParagraph,
                  ),
                ],
              ),
              BaselineRow(
                children: [
                  Text(
                    '${local?.name}',
                    style: kParagraph.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(width: 5),
                  SizedBox(
                    width: _size.width * 0.5,
                    child: Text(
                      user?.name ?? "",
                      style: kParagraph,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }

  Widget _buildSpacer() => SizedBox(height: isInEnglish(context) ? 10 : 14);
}
