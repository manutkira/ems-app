import 'dart:convert';

import 'package:ems/models/overtime.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class Testscreen extends StatefulWidget {
  @override
  _TestscreenState createState() => _TestscreenState();
}

class _TestscreenState extends State<Testscreen> {
  List<OvertimeAttendance> overtimes = [];

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
      // print(value[0]);
      OvertimeAttendance overtimeModel = new OvertimeAttendance();
      overtimeModel = OvertimeAttendance(
        checkin: OvertimeCheckin.fromMap(
          value[0],
        ),
        checkout: OvertimeCheckout.fromMap(
          value[1],
        ),
      );
      print(overtimeModel.checkout!.overtime);
    });

    setState(() {});
  }

  @override
  void initState() {
    getOvertime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
