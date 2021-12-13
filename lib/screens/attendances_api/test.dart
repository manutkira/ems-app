import 'dart:convert';

import 'package:ems/models/overtime.dart';
import 'package:ems/models/user.dart';
import 'package:ems/utils/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class Testscreen extends StatefulWidget {
  @override
  _TestscreenState createState() => _TestscreenState();
}

class _TestscreenState extends State<Testscreen> {
  OvertimeAttendance overtimes = new OvertimeAttendance();
  UserService _userService = UserService.instance;
  List<OvertimeAttendance> _overtimeDisplay = [];
  List<User> users = [];

  getOvertime() async {
    var url =
        'http://rest-api-laravel-flutter.herokuapp.com/api/users/1/attendances/';
    var response = await get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    var jsonData = jsonDecode(response.body);

    // var overtime = OvertimeAttendances.fromMap(jsonData["data"]);
    var attendences = jsonData['data']['attendances'];

    attendences.forEach((key, value) {
      OvertimeAttendance overtimeModel = new OvertimeAttendance();
      overtimes = OvertimeAttendance(
        checkin: OvertimeCheckin.fromMap(
          value[0],
        ),
        checkout: OvertimeCheckout.fromMap(
          value[1],
        ),
      );
    });

    setState(() {});
  }

  @override
  void initState() {
    getOvertime();
    super.initState();
    _userService.findOne(1).then((value) {
      users.add(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: overtimes.checkout == null
          ? Container(
              padding: EdgeInsets.only(top: 300),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      'fetching data',
                      style: TextStyle(fontSize: 30),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    ),
                  ],
                ),
              ),
            )
          : Center(
              child: Container(
                padding: EdgeInsets.only(top: 300),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Name: '),
                        Text(users[0].name!),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Overtime: '),
                        Text(overtimes.checkout!.overtime!),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
