import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:ems/utils/utils.dart';

import '../../constants.dart';

class AttedancesEdit extends StatefulWidget {
  final int id;
  final DateTime date;
  String? note;
  final TimeOfDay time;

  AttedancesEdit({
    Key? key,
    required this.id,
    required this.date,
    this.note,
    required this.time,
  }) : super(key: key);
  @override
  _AttedancesEditState createState() => _AttedancesEditState();
}

class _AttedancesEditState extends State<AttedancesEdit> {
  String url =
      "http://rest-api-laravel-flutter.herokuapp.com/api/attendance_record";

  // text controller
  TextEditingController idController = TextEditingController();
  TextEditingController id = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TextEditingController? _noteController = TextEditingController();

  // boolean
  bool pick = false;

  // variables
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  String? _hour, _minute, _time;
  DateTime? dateTime;
  String type = '';
  String defualtCode = '';
  late DateTime? _selectDate;

  @override
  void initState() {
    id.text = widget.id.toString();
    _selectDate = widget.date;
    selectedTime =
        TimeOfDay(hour: widget.time.hour, minute: widget.time.minute);
    _noteController?.text = widget.note.toString();
    dateController.text = DateFormat('dd-MM-yyyy').format(widget.date);
    _timeController.text = widget.time.hour.toString().padLeft(2, '0') +
        ':' +
        widget.time.minute.toString().padLeft(2, '0');
    super.initState();
  }

  // date picker popup
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

  // time picker popup
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

  @override
  Widget build(BuildContext context) {
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('${local?.editAttendance}'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${local?.id} ',
                    style: kParagraph.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 20,
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
                            controller: id,
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                      ],
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
                    '${local?.date} ',
                    style: kParagraph.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 20,
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
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    // _fullTime();
                                    // _byDayDatePicker();
                                  },
                                  icon: const Icon(Icons.calendar_today)),
                              hintText: 'Enter Name',
                              errorStyle: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            controller: dateController,
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${local?.time} ',
                    style: kParagraph.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 20,
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
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    _selectTime();
                                  },
                                  icon: const Icon(MdiIcons.clockOutline)),
                              errorStyle: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            controller: _timeController,
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                      ],
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
                  const SizedBox(
                    width: 20,
                  ),
                  Container(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.6),
                    child: Flex(
                      direction: Axis.horizontal,
                      children: [
                        Flexible(
                          child: TextFormField(
                            maxLines: 5,
                            decoration: const InputDecoration(
                              errorStyle: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            controller: _noteController,
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(right: 10),
                      // ignore: deprecated_member_use
                      child: RaisedButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                    title: Text('${local?.areYouSure}'),
                                    content: Text('${local?.saveChanges}'),
                                    actions: [
                                      // ignore: deprecated_member_use
                                      OutlineButton(
                                        borderSide: const BorderSide(
                                            color: Colors.green),
                                        child: Text('${local?.yes}'),
                                        onPressed: () {
                                          uploadImage();
                                          Navigator.pop(context);
                                          showDialog(
                                              context: context,
                                              builder: (ctx) => AlertDialog(
                                                    title: Text(
                                                        '${local?.editing}'),
                                                    content: Flex(
                                                      direction:
                                                          Axis.horizontal,
                                                      children: const [
                                                        Flexible(
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 100),
                                                            child:
                                                                CircularProgressIndicator(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ));
                                        },
                                      ),
                                      // ignore: deprecated_member_use
                                      OutlineButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('${local?.no}'),
                                        borderSide:
                                            const BorderSide(color: Colors.red),
                                      )
                                    ],
                                  ));
                        },
                        child: Text('${local?.save}'),
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    // ignore: deprecated_member_use
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
    var aNote = _noteController?.text;
    var aTime = _time;

    var request = await http.MultipartRequest(
        'POST', Uri.parse("$url/${widget.id}?_method=PUT"));
    Map<String, String> headers = {
      "Accept": "application/json",
      "Content": "charset-UTF-8",
    };
    if (aNote!.isNotEmpty) {
      request.files
          .add(http.MultipartFile.fromString('note', aNote.toString()));
    }
    if (aTime != null) {
      request.files
          .add(http.MultipartFile.fromString('time', aTime.toString()));
    }

    request.headers.addAll(headers);

    var res = await request.send();
    print(res.statusCode);
    if (res.statusCode == 200) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text('${local?.success}'),
                content: Text('${local?.edited}'),
                actions: [
                  // ignore: deprecated_member_use
                  OutlineButton(
                    borderSide: const BorderSide(color: Colors.grey),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('${local?.done}'),
                  ),
                  // ignore: deprecated_member_use
                  OutlineButton(
                    borderSide: const BorderSide(color: Colors.green),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Text('${local?.back}'),
                  ),
                ],
              ));
    }
    res.stream.transform(utf8.decoder).listen((event) {});
  }
}
