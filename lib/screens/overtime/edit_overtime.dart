import 'package:ems/models/attendance.dart';
import 'package:ems/models/overtime.dart';
import 'package:ems/models/user.dart';
import 'package:ems/utils/services/attendance_service.dart';
import 'package:ems/utils/utils.dart';
import 'package:ems/widgets/baseline_row.dart';
import 'package:ems/widgets/circle_avatar.dart';
import 'package:ems/widgets/statuses/error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../constants.dart';

class EditOvertime extends StatefulWidget {
  const EditOvertime({Key? key, required this.record}) : super(key: key);
  final OvertimeAttendance record;

  @override
  _EditOvertimeState createState() => _EditOvertimeState();
}

class _EditOvertimeState extends State<EditOvertime> {
  final AttendanceService _attendanceService = AttendanceService.instance;
  DateTime selectedDate = DateTime.now();
  TimeOfDay startedTime = TimeOfDay.now();
  TimeOfDay endedTime = TimeOfDay.now();
  final TextEditingController _noteController = TextEditingController();
  bool isLoading = false;
  String error = '';

  late OvertimeAttendance record;
  late User? user;
  late OvertimeCheckin? checkIn;
  late OvertimeCheckout? checkOut;

  void _closePanel() {
    if (!isLoading) {
      Navigator.of(context).pop();
    }
  }

  void _updateOvertime() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      try {
        /// creating Attendance objects
        Attendance checkInAttendance = Attendance(
          id: checkIn?.id,
          userId: user?.id,
          date: selectedDate.copyWith(
            hour: startedTime.hour,
            minute: startedTime.minute,
          ),
          type: AttendanceType.typeCheckIn,
          note: _noteController.text,
          code: 'cin3',
        );
        Attendance checkOutAttendance = Attendance(
          id: checkOut?.id,
          userId: user?.id,
          date: selectedDate.copyWith(
            hour: endedTime.hour,
            minute: endedTime.minute,
          ),
          type: AttendanceType.typeCheckOut,
          note: _noteController.text,
          code: 'cout3',
        );

        /// the service will use the same data for check in and check out object
        /// if there's no check out data from the api.
        bool hasNoCheckout = checkIn?.id == checkOut?.id;

        await _attendanceService.updateOne(checkInAttendance);

        /// if there's no checkout, create one.
        if (hasNoCheckout) {
          Attendance checkOutAttendance = Attendance(
            userId: user?.id,
            date: selectedDate.copyWith(
              hour: endedTime.hour,
              minute: endedTime.minute,
            ),
            type: AttendanceType.typeCheckOut,
            note: _noteController.text,
            code: 'cout3',
          );
          await _attendanceService.createOne(attendance: checkOutAttendance);
        }

        /// otherwise, just update the record
        else {
          await _attendanceService.updateOne(checkOutAttendance);
        }

        setState(() {
          isLoading = false;
        });
        _closePanel();
      } catch (err) {
        setState(() {
          isLoading = false;
          error = err.toString();
        });
      }
    }
  }

  void setUpScreen() {
    setState(() {
      record = widget.record.copyWith();
      user = record.user;
      checkIn = record.checkin;
      checkOut = record.checkout;

      // hour and minute
      int checkInHour = checkIn?.date?.hour as int;
      int checkInMinute = checkIn?.date?.minute as int;
      int checkOutHour = checkOut?.date?.hour as int;
      int checkOutMinute = checkOut?.date?.minute as int;

      selectedDate = checkIn?.date as DateTime;

      // timeOfDay
      startedTime = TimeOfDay(hour: checkInHour, minute: checkInMinute);
      endedTime = TimeOfDay(hour: checkOutHour, minute: checkOutMinute);
      _noteController.text = "${checkIn?.note}";
    });
  }

  String formatToHourAndMinute(TimeOfDay time) {
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  }

  @override
  void initState() {
    super.initState();
    setUpScreen();
  }

  @override
  void dispose() {
    super.dispose();
    _noteController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? local = AppLocalizations.of(context);
    Size _size = MediaQuery.of(context).size;
    bool isEnglish = isInEnglish(context);

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.65,
      child: Scaffold(
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${local?.viewOvertime}',
                      style: kHeadingThree,
                    ),
                    Visibility(
                      visible: isEnglish,
                      child: const SizedBox(height: 5),
                    ),
                    Text(
                      '${local?.enterAllInfo}',
                      style: kSubtitle.copyWith(
                        color: kSubtitle.color?.withOpacity(0.75),
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: isLoading,
                  child: const CircularProgressIndicator(color: kWhite),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildUserInfo(_size, user),
            const SizedBox(height: 20),
            BaselineRow(
              children: [
                Text(
                  "${local?.date}",
                  style: kParagraph,
                ),
                const SizedBox(
                  width: 20,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                    textStyle: kParagraph,
                    backgroundColor: kDarkestBlue,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(kBorderRadius),
                    ),
                  ),
                  onPressed: () async {
                    final DateTime? picked = await buildDateTimePicker(
                      context: context,
                      date: selectedDate,
                    );
                    if (picked != null && picked != selectedDate) {
                      setState(() {
                        selectedDate = picked;
                      });
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        getDateStringFromDateTime(selectedDate),
                      ),
                      const SizedBox(width: 10),
                      const Icon(MdiIcons.calendar),
                    ],
                  ),
                ),
              ],
            ),
            _buildSpacer,
            BaselineRow(
              children: [
                Text(
                  "${local?.from}",
                  style: kParagraph,
                ),
                const SizedBox(
                  width: 20,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                    textStyle: kParagraph,
                    backgroundColor: kDarkestBlue,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(kBorderRadius),
                    ),
                  ),
                  onPressed: () async {
                    final TimeOfDay? picked = await buildTimePicker(
                      context: context,
                      time: startedTime,
                    );

                    if (picked != null && picked != startedTime) {
                      setState(() {
                        startedTime = picked;
                      });
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          "${startedTime.hour.toString().padLeft(2, '0')}:${startedTime.minute.toString().padLeft(2, '0')}"),
                      const SizedBox(width: 10),
                      const Icon(MdiIcons.clockOutline),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  "${local?.to}",
                  style: kParagraph,
                ),
                const SizedBox(
                  width: 20,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                    textStyle: kParagraph,
                    backgroundColor: kDarkestBlue,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(kBorderRadius),
                    ),
                  ),
                  onPressed: () async {
                    final TimeOfDay? picked = await buildTimePicker(
                      context: context,
                      time: endedTime,
                    );

                    if (picked != null && picked != endedTime) {
                      setState(() {
                        endedTime = picked;
                      });
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formatToHourAndMinute(endedTime),
                      ),
                      const SizedBox(width: 10),
                      const Icon(MdiIcons.clockOutline),
                    ],
                  ),
                ),
              ],
            ),
            _buildSpacer,
            Text("${local?.note}", style: kParagraph),
            _buildSpacer,
            TextField(
              minLines: 5,
              maxLines: 5,
              keyboardType: TextInputType.multiline,
              controller: _noteController,
            ),
            const SizedBox(height: 20),
            Visibility(
              visible: error.isNotEmpty,
              child: Column(
                children: [
                  StatusError(text: "Error: $error"),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    padding: kPadding.copyWith(
                        top: isEnglish ? 10 : 4, bottom: isEnglish ? 10 : 4),
                    primary: Colors.white,
                    textStyle: kParagraph.copyWith(fontWeight: FontWeight.w700),
                    backgroundColor: kBlack.withOpacity(0.3),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(kBorderRadius),
                    ),
                  ),
                  onPressed: _updateOvertime,
                  child: Text(
                    '${local?.update}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                const SizedBox(width: 10),
                TextButton(
                  autofocus: true,
                  style: TextButton.styleFrom(
                    padding: kPadding.copyWith(
                        top: isEnglish ? 10 : 4, bottom: isEnglish ? 10 : 4),
                    primary: Colors.white,
                    textStyle: kParagraph.copyWith(fontWeight: FontWeight.w700),
                    backgroundColor: kRedText,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(kBorderRadius),
                    ),
                  ),
                  onPressed: _closePanel,
                  child: Text(
                    '${local?.cancel}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget get _buildSpacer => SizedBox(height: isInEnglish(context) ? 10 : 14);

  Widget _buildUserInfo(Size size, User? user) {
    return Container(
      height: 60,
      width: size.width,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: kDarkestBlue,
        borderRadius: BorderRadius.circular(6),
      ),
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
                    "${user?.id}",
                    style: kParagraph,
                  ),
                ],
              ),
              BaselineRow(
                children: [
                  Text(
                    'Name',
                    style: kParagraph.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(width: 5),
                  SizedBox(
                    width: size.width * 0.45,
                    child: Text(
                      '${user?.name}',
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
}
