import 'dart:convert';
import 'package:ems/utils/utils.dart';
import 'package:ems/screens/attendances_api/attendance_info.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../constants.dart';

class AttedancesEdit extends StatefulWidget {
  final int id;
  final int userId;
  final String type;
  final DateTime date;
  final String? note;

  const AttedancesEdit(
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
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  String? _hour, _minute, _time;
  DateTime? dateTime;

  bool pick = false;
  late DateTime? _selectDate;

  @override
  void initState() {
    id.text = widget.id.toString();
    _selectDate = widget.date;
    selectedTime = TimeOfDay(
        hour: _selectDate?.hour as int, minute: _selectDate?.minute as int);
    idController.text = widget.userId.toString();
    typeController.text = widget.type;
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
    ).then((picked) {
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Attendance'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // SizedBox(
            //   height: 30,
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ID ',
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
                      enabled: false,
                      controller: id,
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
                  'User ID ',
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
                      enabled: false,
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
                  'Type ',
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
                        hintText: 'Enter Name',
                        errorStyle: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      controller: typeController,
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
                  'Name ',
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
                  'Name ',
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
                        hintText: 'Enter Name',
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
                                  title: Text('Are you sure?'),
                                  content:
                                      Text('Do you want to save the changes'),
                                  actions: [
                                    OutlineButton(
                                      borderSide:
                                          BorderSide(color: Colors.green),
                                      child: Text('Yes'),
                                      onPressed: () {
                                        uploadImage();
                                      },
                                    ),
                                    OutlineButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('No'),
                                      borderSide: BorderSide(color: Colors.red),
                                    )
                                  ],
                                ));
                      },
                      child: Text('Save'),
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                                title: Text('Are you Sure?'),
                                content: Text('Your changes will be lost.'),
                                actions: [
                                  OutlineButton(
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                      await Navigator.of(context)
                                          .pushReplacementNamed(
                                        AttendancesInfoScreen(widget.id)
                                            .toString(),
                                      );
                                    },
                                    child: Text('Yes'),
                                    borderSide: BorderSide(color: Colors.green),
                                  ),
                                  OutlineButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('No'),
                                    borderSide: BorderSide(color: Colors.red),
                                  )
                                ],
                              ));
                    },
                    child: Text('Cancel'),
                    color: Colors.red,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  uploadImage() async {
    var aUserId = idController.text;
    var aType = typeController.text;
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
    request.files.add(http.MultipartFile.fromString('type', aType));
    request.files.add(http.MultipartFile.fromString('date', aDate.toString()));

    request.headers.addAll(headers);

    var res = await request.send();
    if (res.statusCode == 200) {
      Navigator.of(context).pop();
    }
    res.stream.transform(utf8.decoder).listen((event) {
      print(event);
    });
  }
}
