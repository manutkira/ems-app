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
  DateTime? pickStart = DateTime.now();
  DateTime? pickEnd = DateTime.now();

  String? _mySelection;
  bool? _mySelectionType;

  // text controller
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();

  // list
  List type = [];
  List note = [];

  // create one attendance
  createOne(
    int id,
    DateTime from,
    DateTime to,
    String note,
    bool fullday,
  ) async {
    AppLocalizations? local = AppLocalizations.of(context);

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('${local?.adding}'),
              content: Flex(
                direction: Axis.horizontal,
                children: const [
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.only(left: 100),
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ));
    await _attendanceService.createAttendanceRequest(
      userId: id,
      from: from,
      to: to,
      note: note.toString(),
      fullDay: fullday,
    );
    Navigator.pop(context);
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
    setState(() {
      if (type.isEmpty) {
        type = [
          {'type': '${local?.haftDay}', 'value': false},
          {'type': '${local?.fullDay}', 'value': true}
        ];
      }
      if (note.isEmpty) {
        note = [
          {'type': '${local?.absent}', 'value': 'absent'},
          {'type': '${local?.permission}', 'value': 'permission'}
        ];
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: Text('${local?.createAttendance}'),
      ),
      body: Form(
        key: _key,
        child: Column(
          children: [
            _selectType(local),
            const SizedBox(
              height: 20,
            ),
            _selectNote(local),
            const SizedBox(
              height: 20,
            ),
            _pickStart(local, isEnglish, context),
            const SizedBox(
              height: 20,
            ),
            _pickEnd(local, isEnglish, context),
            const SizedBox(
              height: 20,
            ),
            _yesAndNotBtn(context, local),
          ],
        ),
      ),
    );
  }

// yes/no button for saving attendance or not
  Padding _yesAndNotBtn(BuildContext context, AppLocalizations? local) {
    return Padding(
      padding: const EdgeInsets.only(right: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          RaisedButton(
            onPressed: () async {
              if (_key.currentState!.validate()) {
                await createOne(widget.id, pickStart!, pickEnd ?? pickStart!,
                    _mySelection.toString(), _mySelectionType!);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => AttendancesInfoScreen(id: widget.id)));
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
    );
  }

// input for picking end date
  Padding _pickEnd(
      AppLocalizations? local, bool isEnglish, BuildContext context) {
    return Padding(
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
    );
  }

// input for picking start date
  Padding _pickStart(
      AppLocalizations? local, bool isEnglish, BuildContext context) {
    return Padding(
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
    );
  }

// input for selecting attendance note
  Padding _selectNote(AppLocalizations? local) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('${local?.note}'),
          SizedBox(
            width: 235,
            child: DropdownButtonFormField(
              validator: (value) {
                if (value == null) {
                  return '${local?.plsSelectNote}';
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
              hint: Text('${local?.selectNote}'),
              onChanged: (value) {
                setState(() {
                  _mySelection = value.toString();
                });
              },
            ),
          ),
        ],
      ),
    );
  }

// input for selecting attendance type
  Padding _selectType(AppLocalizations? local) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('${local?.type}'),
          SizedBox(
            width: 235,
            child: DropdownButtonFormField(
              validator: (value) {
                if (value == null) {
                  return '${local?.plsSelectType}';
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
              hint: Text('${local?.selectType}'),
              onChanged: (value) {
                setState(() {
                  _mySelectionType = (value as bool);
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
