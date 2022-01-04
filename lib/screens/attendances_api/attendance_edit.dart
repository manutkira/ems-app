import 'dart:convert';
import 'package:ems/utils/utils.dart';
import 'package:ems/screens/attendances_api/attendance_info.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../constants.dart';

class AttedancesEdit extends StatefulWidget {
  final int id;
  final int userId;
  final String type;
  final DateTime date;
  String? note;

  AttedancesEdit(
      {Key? key,
      required this.id,
      required this.userId,
      required this.type,
      required this.date,
      this.note})
      : super(key: key);
  @override
  _AttedancesEditState createState() => _AttedancesEditState();
}

class _AttedancesEditState extends State<AttedancesEdit> {
  String url = "http://rest-api-laravel-flutter.herokuapp.com/api/attendances";
  TextEditingController idController = TextEditingController();
  TextEditingController id = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TextEditingController? _noteController = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  String? _hour, _minute, _time;
  DateTime? dateTime;
  String type = '';

  bool pick = false;
  late DateTime? _selectDate;

  @override
  void initState() {
    // type = widget.type;
    id.text = widget.id.toString();
    _selectDate = widget.date;
    selectedTime = TimeOfDay(
        hour: _selectDate?.hour as int, minute: _selectDate?.minute as int);
    idController.text = widget.userId.toString();
    typeController.text = widget.type;
    _noteController?.text = widget.note.toString();
    dateController.text = DateFormat('dd-MM-yyyy').format(widget.date);
    _timeController.text = DateFormat('HH:mm:ss').format(widget.date);
    super.initState();
  }

  void _byDayDatePicker() {
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
        _selectDate = picked;
        dateController.text = DateFormat('dd-MM-yyyy').format(_selectDate!);
        pick = true;
      });
    });
  }

  void _selectTime() async {
    showTimePicker(
            context: context,
            initialTime: selectedTime,
            initialEntryMode: TimePickerEntryMode.input)
        .then((picked) {
      if (picked != null) {
        setState(() {
          selectedTime = picked;
          _hour = selectedTime.hour.toString();
          _minute = selectedTime.minute.toString();
          _time = _hour! + ':' + _minute! + ':00';
          _timeController.text = _time!;
        });
      }
    });
  }

  // void _fullTime() {
  //   dateTime = _selectDate! + selectedTime;
  // }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);
    print('note: ${widget.note}');
    checkType() {
      if (widget.type == 'checkin') {
        return local!.checkIn;
      }
      if (widget.type == 'checkout') {
        return local!.checkOut;
      }
      if (widget.type == 'absent') {
        return local!.absent;
      } else {
        return local!.permission;
      }
    }

    setState(() {
      if (type.isEmpty) {
        type = checkType();
      }
      // if (widget.note == null) {
      //   _noteController!.text = 'null';
      // }
    });
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Edit Attendance'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${local?.id} ',
                    style: kParagraph.copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.6),
                    child: Flexible(
                      child: TextFormField(
                        readOnly: true,
                        controller: id,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${local?.userId} ',
                    style: kParagraph.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: isEnglish ? 15 : 15.5),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.6),
                    child: Flexible(
                      child: TextFormField(
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: 'Enter Name',
                          errorStyle: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        controller: idController,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${local?.type} ',
                    style: kParagraph.copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    width: 233,
                    child: DropdownButtonFormField(
                      dropdownColor: kDarkestBlue,
                      icon: Icon(Icons.expand_more),
                      value: type,
                      onChanged: (String? newValue) {
                        setState(() {
                          type = newValue!;
                        });
                        widget.type;
                      },
                      items: <String>[
                        '${local?.checkIn}',
                        '${local?.checkOut}',
                        '${local?.absent}',
                        '${local?.permission}',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                            ));
                      }).toList(),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${local?.date} ',
                    style: kParagraph.copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.6),
                    child: Flexible(
                      child: TextFormField(
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () {
                                // _fullTime();
                                _byDayDatePicker();
                              },
                              icon: Icon(Icons.calendar_today)),
                          hintText: 'Enter Name',
                          errorStyle: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        controller: dateController,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${local?.time} ',
                    style: kParagraph.copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.6),
                    child: Flexible(
                      child: TextFormField(
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () {
                                _selectTime();
                              },
                              icon: Icon(MdiIcons.clockOutline)),
                          errorStyle: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        controller: _timeController,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${local?.note} ',
                    style: kParagraph.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: isEnglish ? 15 : 15.5),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.6),
                    child: Flexible(
                      child: TextFormField(
                        maxLines: 5,
                        decoration: InputDecoration(
                          errorStyle: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        controller: _noteController,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.only(right: 10),
                      child: RaisedButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                    title: Text('${local?.areYouSure}'),
                                    content: Text('${local?.saveChanges}'),
                                    actions: [
                                      OutlineButton(
                                        borderSide:
                                            BorderSide(color: Colors.green),
                                        child: Text('${local?.yes}'),
                                        onPressed: () {
                                          uploadImage();
                                          Navigator.pop(context);
                                        },
                                      ),
                                      OutlineButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('${local?.no}'),
                                        borderSide:
                                            BorderSide(color: Colors.red),
                                      )
                                    ],
                                  ));
                        },
                        child: Text('${local?.save}'),
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    RaisedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('${local?.cancel}'),
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  uploadImage() async {
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);
    var aUserId = idController.text;
    var aType = type;
    var aNote = _noteController?.text;
    DateTime aDate = _selectDate?.copyWith(
        hour: selectedTime.hour,
        minute: selectedTime.minute,
        second: 0) as DateTime;

    var request = await http.MultipartRequest(
        'POST', Uri.parse("$url/${widget.id}?_method=PUT"));
    Map<String, String> headers = {
      "Accept": "application/json",
      "Content": "charset-UTF-8",
    };
    request.files.add(http.MultipartFile.fromString('user_id', aUserId));
    String checkType() {
      if (aType == local?.checkIn) {
        return 'checkin';
      }
      if (aType == local?.checkOut) {
        return 'checkout';
      }
      if (aType == local?.absent) {
        return 'absent';
      }
      if (aType == local?.permission) {
        return 'permission';
      } else {
        return '';
      }
    }

    request.files.add(http.MultipartFile.fromString('note', aNote.toString()));
    request.files.add(http.MultipartFile.fromString('type', checkType()));
    request.files.add(http.MultipartFile.fromString('date', aDate.toString()));

    request.headers.addAll(headers);

    var res = await request.send();
    print(res.statusCode);
    if (res.statusCode == 200) {
      Navigator.pop(context);
    }
    res.stream.transform(utf8.decoder).listen((event) {
      print(event);
    });
  }
}
