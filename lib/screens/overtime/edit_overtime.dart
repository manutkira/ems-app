import 'package:ems/models/attendance.dart';
import 'package:ems/models/overtime.dart';
import 'package:ems/models/user.dart';
import 'package:ems/utils/services/attendance_service.dart';
import 'package:ems/utils/utils.dart';
import 'package:ems/widgets/circle_avatar.dart';
import 'package:ems/widgets/statuses/error.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  void _deleteOvertime() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      Future.delayed(const Duration(seconds: 3), () {
        setState(() {
          isLoading = false;
        });
        _closePanel();
      });
    }
  }

  void _updateOvertime() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      print('checkin ${checkIn?.id} checkout ${checkOut?.id}');
      try {
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

        bool sameTime =
            checkIn?.date?.compareTo(checkOut?.date as DateTime) == 0;

        await _attendanceService.updateOne(checkInAttendance);
        if (sameTime) {
          print('true');
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
        } else {
          print('false');
          await _attendanceService.updateOne(checkOutAttendance);
        }
        setState(() {
          isLoading = false;
        });
        _closePanel();
      } catch (err, stk) {
        print(stk);
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
      int checkInHour = checkIn?.date?.hour as int;
      int checkInMinute = checkIn?.date?.minute as int;
      int checkOutHour = checkOut?.date?.hour as int;
      int checkOutMinute = checkOut?.date?.minute as int;
      selectedDate = checkIn?.date as DateTime;

      startedTime = TimeOfDay(hour: checkInHour, minute: checkInMinute);
      endedTime = TimeOfDay(hour: checkOutHour, minute: checkOutMinute);
      _noteController.text = "${checkIn?.note}";
    });
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
    Size _size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Edit Overtime',
                    style: kHeadingTwo,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Please enter all information below.',
                    style: kSubtitle.copyWith(
                      color: kSubtitle.color?.withOpacity(0.75),
                    ),
                  ),
                ],
              ),
              isLoading
                  ? const CircularProgressIndicator(color: kWhite)
                  : TextButton(
                      style: TextButton.styleFrom(
                        padding: kPadding.copyWith(top: 10, bottom: 10),
                        primary: Colors.white,
                        textStyle:
                            kParagraph.copyWith(fontWeight: FontWeight.w700),
                        backgroundColor: kRedText,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(kBorderRadius),
                        ),
                      ),
                      onPressed: _deleteOvertime,
                      child: const Text('Delete'),
                    ),
            ],
          ),
          const SizedBox(height: 30),
          Container(
            height: 60,
            width: _size.width,
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
                    Row(
                      children: [
                        Text(
                          'ID',
                          style:
                              kParagraph.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          "${user?.id}",
                          style: kParagraph,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Name',
                          style:
                              kParagraph.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(width: 5),
                        SizedBox(
                          width: _size.width * 0.45,
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
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Text(
                "Date",
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
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2025),
                    locale: const Locale('km'),
                    helpText: "Pick a date",
                    errorFormatText: 'Enter valid date',
                    errorInvalidText: 'Enter date in valid range',
                    fieldLabelText: 'Date',
                    fieldHintText: 'Date/Month/Year',
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
                    Text(DateFormat('dd/MM/yyyy').format(selectedDate)),
                    const SizedBox(width: 10),
                    const Icon(MdiIcons.calendar),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text(
                "From",
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
                  final TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialEntryMode: TimePickerEntryMode.input,
                    initialTime: startedTime,
                    // hourLabelText: "mong",
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
              const Text(
                "To",
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
                  final TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialEntryMode: TimePickerEntryMode.input,
                    initialTime: endedTime,
                    // hourLabelText: "mong",
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
                        "${endedTime.hour.toString().padLeft(2, '0')}:${endedTime.minute.toString().padLeft(2, '0')}"),
                    const SizedBox(width: 10),
                    const Icon(MdiIcons.clockOutline),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text('Note', style: kParagraph),
          const SizedBox(height: 10),
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
                  padding: kPadding.copyWith(top: 10, bottom: 10),
                  primary: Colors.white,
                  textStyle: kParagraph.copyWith(fontWeight: FontWeight.w700),
                  backgroundColor: kBlack.withOpacity(0.3),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(kBorderRadius),
                  ),
                ),
                onPressed: _updateOvertime,
                child: const Text('Update'),
              ),
              const SizedBox(width: 10),
              TextButton(
                autofocus: true,
                style: TextButton.styleFrom(
                  padding: kPadding.copyWith(top: 10, bottom: 10),
                  primary: Colors.white,
                  textStyle: kParagraph.copyWith(fontWeight: FontWeight.w700),
                  backgroundColor: kRedText,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(kBorderRadius),
                  ),
                ),
                onPressed: _closePanel,
                child: const Text('Cancel'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
