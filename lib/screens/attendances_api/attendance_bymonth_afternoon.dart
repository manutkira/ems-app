import 'package:ems/screens/attendances_api/tap_screen.dart';
import 'package:ems/screens/attendances_api/tap_screen_alltime.dart';
import 'package:intl/intl.dart';
import 'package:ems/models/user.dart';
import 'package:ems/utils/services/user_service.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../screens/attendances_api/attendance_all_time.dart';
import '../../screens/attendances_api/attendance_by_day_screen.dart';
import '../../utils/services/attendance_service.dart';

class AttendancesByMonthScreenAfternoon extends StatefulWidget {
  @override
  _AttendancesByMonthScreenState createState() =>
      _AttendancesByMonthScreenState();
}

class _AttendancesByMonthScreenState
    extends State<AttendancesByMonthScreenAfternoon> {
  AttendanceService _attendanceService = AttendanceService.instance;
  UserService _userService = UserService.instance;

  List userDisplay = [];
  List attendanceDisplay = [];
  List<User> users = [];
  bool _isLoading = true;
  final color = const Color(0xff05445E);
  final color1 = const Color(0xff3982A0);

  @override
  void initState() {
    super.initState();
    _attendanceService.findMany().then((value) {
      attendanceDisplay.addAll(value);
    });
    _userService.findMany().then((value) {
      users.addAll(value);
      userDisplay = users;
      userDisplay.sort((a, b) => a.id!.compareTo(b.id as int));
    });
  }

  DateTime? _selectDate;
  var _selectMonth;
  final yearController = TextEditingController();
  var _controller = TextEditingController();
  var pickedYear;

  void clearText() {
    _controller.clear();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    yearController.dispose();
    super.dispose();
  }

  void _byDayDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1990),
            lastDate: DateTime.now(),
            initialEntryMode: DatePickerEntryMode.calendarOnly,
            initialDatePickerMode: DatePickerMode.year)
        .then((picked) {
      if (picked == null) {
        return;
      }
      setState(() {
        _selectDate = picked;
      });
    });
  }

  String? get _errorText {
    final text = yearController.value.text;
    if (text.isEmpty || text == null) {
      return 'Please Enter Year';
    }
    if (double.tryParse(text) == null) {
      return 'Please Enter valid number';
    }
    if (text.length < 4 || text.length > 4) {
      return 'Enter 4 Digits';
    }
    return null;
  }

  bool _validate = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Attendance'),
        actions: [
          PopupMenuButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              color: Color(0xff43c3c52),
              onSelected: (item) => onSelected(context, item as int),
              icon: Icon(Icons.filter_list),
              itemBuilder: (_) => [
                    PopupMenuItem(
                      child: Text(
                        'By Day',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      value: 0,
                    ),
                    PopupMenuItem(
                      child: Text(
                        'By All-Time',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      value: 1,
                    ),
                  ])
        ],
      ),
      body: Form(
        key: _formKey,
        child: Container(
          margin: EdgeInsets.only(top: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: 20, bottom: 10),
                child: Row(
                  children: [
                    Text(
                      _selectMonth == null
                          ? 'Pick a Month'
                          : 'Date: $_selectMonth/$pickedYear',
                      style: kHeadingFour,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    OutlineButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                            title: Text('Pick a month'),
                            content: Container(
                              height: 280,
                              width: 400,
                              child: Column(
                                children: [
                                  Column(
                                    children: [
                                      TextField(
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            errorText: _validate
                                                ? 'Please Enter 4 digits'
                                                : 'Please Enter 4 digits',
                                            hintText: 'Enter year'),
                                        controller: yearController,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              yearController.text.isNotEmpty &&
                                                      yearController.value.text
                                                              .length ==
                                                          4
                                                  ? setState(() {
                                                      _selectMonth = 1;
                                                      pickedYear =
                                                          yearController.text;
                                                      Navigator.of(context)
                                                          .pop();
                                                    })
                                                  : _validate = true;
                                            },
                                            child: const Text('Jan'),
                                            style: ButtonStyle(
                                                shape: MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        side: BorderSide(
                                                            color: Colors.teal,
                                                            width: 2.0)))),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              yearController.text.isNotEmpty &&
                                                      yearController.value.text
                                                              .length ==
                                                          4
                                                  ? setState(() {
                                                      _selectMonth = 2;
                                                      pickedYear =
                                                          yearController.text;
                                                      Navigator.of(context)
                                                          .pop();
                                                    })
                                                  : _validate = true;
                                            },
                                            child: Text('Feb'),
                                            style: ButtonStyle(
                                                shape: MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        side: BorderSide(
                                                            color: Colors.teal,
                                                            width: 2.0)))),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              yearController.text.isNotEmpty &&
                                                      yearController.value.text
                                                              .length ==
                                                          4
                                                  ? setState(() {
                                                      _selectMonth = 3;
                                                      pickedYear =
                                                          yearController.text;
                                                      Navigator.of(context)
                                                          .pop();
                                                    })
                                                  : _validate = true;
                                            },
                                            child: Text('Mar'),
                                            style: ButtonStyle(
                                                shape: MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        side: BorderSide(
                                                            color: Colors.teal,
                                                            width: 2.0)))),
                                          )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () async {
                                              yearController.text.isNotEmpty &&
                                                      yearController.value.text
                                                              .length ==
                                                          4
                                                  ? setState(() {
                                                      _selectMonth = 4;
                                                      pickedYear =
                                                          yearController.text;
                                                      Navigator.of(context)
                                                          .pop();
                                                    })
                                                  : _validate = true;
                                            },
                                            child: Text('Apr'),
                                            style: ButtonStyle(
                                                shape: MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        side: BorderSide(
                                                            color: Colors.teal,
                                                            width: 2.0)))),
                                          ),
                                          ElevatedButton(
                                            onPressed: () async {
                                              yearController.text.isNotEmpty &&
                                                      yearController.value.text
                                                              .length ==
                                                          4
                                                  ? setState(() {
                                                      _selectMonth = 5;
                                                      pickedYear =
                                                          yearController.text;
                                                      Navigator.of(context)
                                                          .pop();
                                                    })
                                                  : _validate = true;
                                            },
                                            child: Text('May'),
                                            style: ButtonStyle(
                                                shape: MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        side: BorderSide(
                                                            color: Colors.teal,
                                                            width: 2.0)))),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              yearController.text.isNotEmpty &&
                                                      yearController.value.text
                                                              .length ==
                                                          4
                                                  ? setState(() {
                                                      _selectMonth = 6;
                                                      pickedYear =
                                                          yearController.text;
                                                      Navigator.of(context)
                                                          .pop();
                                                    })
                                                  : _validate = true;
                                            },
                                            child: Text('Jun'),
                                            style: ButtonStyle(
                                                shape: MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        side: BorderSide(
                                                            color: Colors.teal,
                                                            width: 2.0)))),
                                          )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () async {
                                              yearController.text.isNotEmpty &&
                                                      yearController.value.text
                                                              .length ==
                                                          4
                                                  ? setState(() {
                                                      _selectMonth = 7;
                                                      pickedYear =
                                                          yearController.text;
                                                      Navigator.of(context)
                                                          .pop();
                                                    })
                                                  : _validate = true;
                                            },
                                            child: Text('Jul'),
                                            style: ButtonStyle(
                                                shape: MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        side: BorderSide(
                                                            color: Colors.teal,
                                                            width: 2.0)))),
                                          ),
                                          ElevatedButton(
                                            onPressed: () async {
                                              yearController.text.isNotEmpty &&
                                                      yearController.value.text
                                                              .length ==
                                                          4
                                                  ? setState(() {
                                                      _selectMonth = 8;
                                                      pickedYear =
                                                          yearController.text;
                                                      Navigator.of(context)
                                                          .pop();
                                                    })
                                                  : _validate = true;
                                            },
                                            child: Text('Aug'),
                                            style: ButtonStyle(
                                                shape: MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        side: BorderSide(
                                                            color: Colors.teal,
                                                            width: 2.0)))),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              yearController.text.isNotEmpty &&
                                                      yearController.value.text
                                                              .length ==
                                                          4
                                                  ? setState(() {
                                                      _selectMonth = 9;
                                                      pickedYear =
                                                          yearController.text;
                                                      Navigator.of(context)
                                                          .pop();
                                                    })
                                                  : _validate = true;
                                            },
                                            child: Text('Sep'),
                                            style: ButtonStyle(
                                                shape: MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        side: BorderSide(
                                                            color: Colors.teal,
                                                            width: 2.0)))),
                                          )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () async {
                                              yearController.text.isNotEmpty &&
                                                      yearController.value.text
                                                              .length ==
                                                          4
                                                  ? setState(() {
                                                      _selectMonth = 10;
                                                      pickedYear =
                                                          yearController.text;
                                                      Navigator.of(context)
                                                          .pop();
                                                    })
                                                  : _validate = true;
                                            },
                                            child: Text('Oct'),
                                            style: ButtonStyle(
                                                shape: MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        side: BorderSide(
                                                            color: Colors.teal,
                                                            width: 2.0)))),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              yearController.text.isNotEmpty &&
                                                      yearController.value.text
                                                              .length ==
                                                          4
                                                  ? setState(() {
                                                      _selectMonth = 11;
                                                      pickedYear =
                                                          yearController.text;
                                                      Navigator.of(context)
                                                          .pop();
                                                    })
                                                  : _validate = true;
                                            },
                                            child: Text('Nov'),
                                            style: ButtonStyle(
                                                shape: MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        side: BorderSide(
                                                            color: Colors.teal,
                                                            width: 2.0)))),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              yearController.text.isNotEmpty &&
                                                      yearController.value.text
                                                              .length ==
                                                          4
                                                  ? setState(() {
                                                      _selectMonth = 12;
                                                      pickedYear =
                                                          yearController.text;
                                                      Navigator.of(context)
                                                          .pop();
                                                    })
                                                  : _validate = true;
                                            },
                                            child: Text('Dec'),
                                            style: ButtonStyle(
                                                shape: MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        side: BorderSide(
                                                            color: Colors.teal,
                                                            width: 2.0)))),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      child: Text('Pick A Month'),
                      borderSide: BorderSide(color: Colors.green),
                    ),
                  ],
                ),
              ),
              yearController.text.isEmpty
                  ? Container(
                      padding: EdgeInsets.only(top: 150, left: 70),
                      child: Column(
                        children: [
                          Text(
                            'Please pick a month!!',
                            style: kHeadingTwo.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Image.asset(
                            'assets/images/calendar.jpeg',
                            width: 220,
                          ),
                        ],
                      ),
                    )
                  : Expanded(
                      flex: 3,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                            gradient: LinearGradient(
                              colors: [
                                color1,
                                color,
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            )),
                        child: userDisplay.isEmpty
                            ? Column(
                                children: [
                                  _searchBar(),
                                  Container(
                                    padding: EdgeInsets.only(top: 150),
                                    child: Column(
                                      children: [
                                        Text(
                                          'Employee not found!!',
                                          style: kHeadingThree.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        Image.asset(
                                          'assets/images/notfound.png',
                                          width: 220,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  _searchBar(),
                                  Expanded(
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: userDisplay.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          padding: EdgeInsets.only(bottom: 20),
                                          margin: EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      color: Colors.black,
                                                      width: 2))),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    width: 75,
                                                    height: 75,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    100)),
                                                        border: Border.all(
                                                          width: 1,
                                                          color: Colors.white,
                                                        )),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              150),
                                                      child: userDisplay[index]
                                                                  .image ==
                                                              null
                                                          ? Image.asset(
                                                              'assets/images/profile-icon-png-910.png',
                                                              width: 75,
                                                            )
                                                          : Image.network(
                                                              userDisplay[index]
                                                                  .image
                                                                  .toString(),
                                                              fit: BoxFit.cover,
                                                              width: 65,
                                                              height: 75,
                                                            ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'Name: ',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          Text(
                                                            userDisplay[index]
                                                                        .name
                                                                        .length >=
                                                                    13
                                                                ? '${userDisplay[index].name.substring(0, 11).toString()}...'
                                                                : userDisplay[
                                                                        index]
                                                                    .name
                                                                    // .substring(
                                                                    //     userDisplay[index].name.length - 7)
                                                                    .toString(),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'ID: ',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          Text(
                                                              userDisplay[index]
                                                                  .id
                                                                  .toString()),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                  child: Row(
                                                children: [
                                                  Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text('P:'),
                                                          Text(
                                                            attendanceDisplay
                                                                .where(
                                                                    (element) {
                                                                  return element
                                                                              .userId ==
                                                                          userDisplay[
                                                                                  index]
                                                                              .id &&
                                                                      element
                                                                              .date
                                                                              .month ==
                                                                          _selectMonth &&
                                                                      element.type ==
                                                                          'checkin' &&
                                                                      element.code ==
                                                                          'cin2' &&
                                                                      element.date
                                                                              .hour <
                                                                          8 &&
                                                                      element.date
                                                                              .minute <
                                                                          21 &&
                                                                      element.date
                                                                              .year ==
                                                                          int.parse(
                                                                              pickedYear);
                                                                })
                                                                .length
                                                                .toString(),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text('A:'),
                                                          Text(
                                                            attendanceDisplay
                                                                .where((element) => (element
                                                                            .userId ==
                                                                        userDisplay[
                                                                                index]
                                                                            .id &&
                                                                    element
                                                                            .date
                                                                            .month ==
                                                                        _selectMonth &&
                                                                    element.code ==
                                                                        'cin2' &&
                                                                    element.type ==
                                                                        'absent' &&
                                                                    element.date
                                                                            .year ==
                                                                        int.parse(
                                                                            pickedYear)))
                                                                .length
                                                                .toString(),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text('L:'),
                                                          Text(
                                                            attendanceDisplay
                                                                .where((element) => (element
                                                                            .userId ==
                                                                        userDisplay[
                                                                                index]
                                                                            .id &&
                                                                    element
                                                                            .date
                                                                            .month ==
                                                                        _selectMonth &&
                                                                    element.code ==
                                                                        'cin2' &&
                                                                    element.type ==
                                                                        'checkin' &&
                                                                    element.date
                                                                            .hour >
                                                                        8 &&
                                                                    element.date
                                                                            .year ==
                                                                        int.parse(
                                                                            pickedYear)))
                                                                .length
                                                                .toString(),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text('E:'),
                                                          Text(
                                                            attendanceDisplay
                                                                .where((element) => (element
                                                                            .userId ==
                                                                        userDisplay[
                                                                                index]
                                                                            .id &&
                                                                    element
                                                                            .date
                                                                            .month ==
                                                                        _selectMonth &&
                                                                    element.code ==
                                                                        'cin2' &&
                                                                    element.type ==
                                                                        'check out' &&
                                                                    element.date
                                                                            .hour <
                                                                        17 &&
                                                                    element.date
                                                                            .year ==
                                                                        int.parse(
                                                                            pickedYear)))
                                                                .length
                                                                .toString(),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text('PM:'),
                                                          Text(
                                                            attendanceDisplay
                                                                .where((element) => (element
                                                                            .userId ==
                                                                        userDisplay[
                                                                                index]
                                                                            .id &&
                                                                    element.code ==
                                                                        'cin2' &&
                                                                    element
                                                                            .date
                                                                            .month ==
                                                                        _selectMonth &&
                                                                    element.type ==
                                                                        'permission' &&
                                                                    element.date
                                                                            .year ==
                                                                        int.parse(
                                                                            pickedYear)))
                                                                .length
                                                                .toString(),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ))
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  _searchBar() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                suffixIcon: _controller.text.isEmpty
                    ? Icon(
                        Icons.search,
                        color: Colors.white,
                      )
                    : IconButton(
                        onPressed: () {
                          setState(() {
                            clearText();
                            userDisplay = users.where((user) {
                              var userName = user.name!.toLowerCase();
                              print(userName);
                              return userName.contains(_controller.text);
                            }).toList();
                          });
                        },
                        icon: Icon(
                          Icons.clear,
                          color: Colors.white,
                        ),
                      ),
                hintText: 'Search...',
                errorStyle: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onChanged: (text) {
                text = _controller.text.toLowerCase();
                setState(() {
                  userDisplay = users.where((user) {
                    var userName = user.name!.toLowerCase();
                    print(userName);
                    return userName.contains(text);
                  }).toList();
                });
              },
            ),
          ),
          PopupMenuButton(
            color: kDarkestBlue,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            onSelected: (int selectedValue) {
              if (selectedValue == 0) {
                setState(() {
                  userDisplay.sort((a, b) =>
                      a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
                });
              }
              if (selectedValue == 1) {
                setState(() {
                  userDisplay.sort((b, a) =>
                      a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
                });
              }
              if (selectedValue == 2) {
                setState(() {
                  userDisplay.sort((a, b) => a.id!.compareTo(b.id as int));
                });
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('From A-Z'),
                value: 0,
              ),
              PopupMenuItem(
                child: Text('From Z-A'),
                value: 1,
              ),
              PopupMenuItem(
                child: Text('by ID'),
                value: 2,
              ),
            ],
            icon: Icon(Icons.sort),
          ),
        ],
      ),
    );
  }
}

void onSelected(BuildContext context, int item) {
  switch (item) {
    case 0:
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => TapScreen(),
        ),
      );
      break;
    case 1:
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => TapScreenAlltime(),
        ),
      );
      break;
  }
}
