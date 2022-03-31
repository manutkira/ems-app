import 'package:ems/constants.dart';
import 'package:ems/screens/attendances_api/attendance_info.dart';
import 'package:ems/services/attendance.dart';
import 'package:ems/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CreateAttendance extends StatefulWidget {
  int id;
  CreateAttendance({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<CreateAttendance> createState() => _CreateAttendanceState();
}

class _CreateAttendanceState extends State<CreateAttendance> {
  // service
  AttendanceService _attendanceService = AttendanceService();

  // variables
  DateTime dateTo = DateTime.now();
  DateTime dateFrom = DateTime.now();
  DateTime? pickStart;
  DateTime? pickEnd;

  String? _mySelection;
  String? _mySelectionType;

  // text controller
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();

  // list
  List type = [
    {'type': 'Haft Day', 'value': ''},
    {'type': 'Full Day', 'value': 'fullday'}
  ];
  List note = [
    {'type': 'Absent', 'value': ''},
    {'type': 'Permission', 'value': 'permission'}
  ];

  // create one attendance
  createOne(
    int id,
    DateTime from,
    DateTime to,
    String? note,
    String? fullday,
  ) async {
    await _attendanceService.createOneRecord(
      userId: id,
      from: from,
      to: to,
      pnote: note,
      fullday: fullday,
    );
  }

  // date picker for start date
  void _startDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    ).then((picked) {
      if (picked == null) {
        return;
      }
      setState(() {
        pickStart = picked;
        startDateController.text = DateFormat('dd-MM-yyyy').format(pickStart!);
        // pick = true;
      });
    });
  }

  // date picker for end date
  void _endDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    ).then((picked) {
      if (picked == null) {
        return;
      }
      setState(() {
        pickEnd = picked;
        endDateController.text = DateFormat('dd-MM-yyyy').format(pickEnd!);
        // pick = true;
      });
    });
  }

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Attendance'),
      ),
      body: Form(
        key: _key,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Type'),
                  SizedBox(
                    width: 235,
                    child: DropdownButtonFormField(
                      validator: (value) {
                        if (value == null) {
                          return 'Pls select type';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        errorStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      items: type.map((e) {
                        return DropdownMenuItem(
                          child: Text(e['type']),
                          value: e['value'],
                        );
                      }).toList(),
                      hint: Text('Select type'),
                      onChanged: (value) {
                        setState(() {
                          _mySelectionType = value.toString();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Note'),
                  SizedBox(
                    width: 235,
                    child: DropdownButtonFormField(
                      validator: (value) {
                        if (value == null) {
                          return 'Pls select Note';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        errorStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      items: note.map((e) {
                        return DropdownMenuItem(
                          child: Text(e['type']),
                          value: e['value'],
                        );
                      }).toList(),
                      hint: Text('Select type'),
                      onChanged: (value) {
                        setState(() {
                          _mySelection = value.toString();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 15,
                right: 15,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${local?.startDate} ',
                    style: kParagraph.copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: isEnglish ? 36 : 29,
                  ),
                  Container(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.6),
                    child: Flex(
                      direction: Axis.horizontal,
                      children: [
                        Flexible(
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return '${local?.plsEnterDate}';
                              }
                              return null;
                            },
                            readOnly: true,
                            decoration: InputDecoration(
                              hintText: local?.selectEndDate,
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    _startDatePicker();
                                  },
                                  icon: const Icon(
                                    MdiIcons.calendar,
                                    color: Colors.white,
                                  )),
                              errorStyle: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            controller: startDateController,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 15,
                right: 15,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${local?.endDate} ',
                    style: kParagraph.copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: isEnglish ? 45 : 45,
                  ),
                  Container(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.6),
                    child: Flex(
                      direction: Axis.horizontal,
                      children: [
                        Flexible(
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return '${local?.plsEnterDate}';
                              }
                              return null;
                            },
                            readOnly: true,
                            decoration: InputDecoration(
                              hintText: local?.selectEndDate,
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    _endDatePicker();
                                  },
                                  icon: const Icon(
                                    MdiIcons.calendar,
                                    color: Colors.white,
                                  )),
                              errorStyle: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            controller: endDateController,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  RaisedButton(
                    onPressed: () async {
                      if (_key.currentState!.validate()) {
                        await createOne(widget.id, pickStart!, pickEnd!,
                            _mySelection, _mySelectionType);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    AttendancesInfoScreen(id: widget.id)));
                      }
                      // addLoan(_mySelection!);
                    },
                    color: Theme.of(context).primaryColor,
                    child: Text(
                      '${local?.save}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  RaisedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    color: Colors.red,
                    child: Text(
                      '${local?.cancel}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
