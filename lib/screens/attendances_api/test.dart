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
      _overtimeDisplay.add(overtimes);
    });

    setState(() {});
  }

  @override
  void initState() {
    getOvertime();
    super.initState();
    _userService.findOne(1).then((value) {
      setState(() {
        users.add(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: users.isEmpty
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
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Name: ',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        users[0].name!,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    height: 120,
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                      ),
                      itemBuilder: (ctx, index) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Overtime: ',
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(_overtimeDisplay[index].checkout!.overtime!),
                          ],
                        );
                      },
                      itemCount: _overtimeDisplay.length,
                    ),
                  ),
                ],
              ));
  }
}
