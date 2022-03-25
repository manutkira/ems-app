// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AttendanceByMonthButton extends StatefulWidget {
  bool validate;
  var yearController;
  var controller;
  var selectMonth;
  var pickedYear;

  AttendanceByMonthButton({
    Key? key,
    required this.validate,
    required this.controller,
    required this.selectMonth,
    required this.pickedYear,
  }) : super(key: key);

  @override
  _AttendanceByMonthButtonState createState() =>
      _AttendanceByMonthButtonState();
}

class _AttendanceByMonthButtonState extends State<AttendanceByMonthButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              errorText: widget.validate
                  ? 'Please Enter 4 digits'
                  : 'Please Enter 4 digits',
              hintText: 'Enter year'),
          controller: widget.yearController,
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                widget.yearController.text.isNotEmpty &&
                        widget.yearController.value.text.length == 4
                    ? setState(() {
                        widget.selectMonth = 1;
                        widget.pickedYear = widget.yearController.text;
                        Navigator.of(context).pop();
                      })
                    : widget.validate = true;
              },
              child: const Text('Jan'),
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: const BorderSide(
                              color: Colors.teal, width: 2.0)))),
            ),
            ElevatedButton(
              onPressed: () {
                widget.yearController.text.isNotEmpty &&
                        widget.yearController.value.text.length == 4
                    ? setState(() {
                        widget.selectMonth = 2;
                        widget.pickedYear = widget.yearController.text;
                        Navigator.of(context).pop();
                      })
                    : widget.validate = true;
              },
              child: const Text('Feb'),
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: const BorderSide(
                              color: Colors.teal, width: 2.0)))),
            ),
            ElevatedButton(
              onPressed: () {
                widget.yearController.text.isNotEmpty &&
                        widget.yearController.value.text.length == 4
                    ? setState(() {
                        widget.selectMonth = 3;
                        widget.pickedYear = widget.yearController.text;
                        Navigator.of(context).pop();
                      })
                    : widget.validate = true;
              },
              child: const Text('Mar'),
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: const BorderSide(
                              color: Colors.teal, width: 2.0)))),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () async {
                widget.yearController.text.isNotEmpty &&
                        widget.yearController.value.text.length == 4
                    ? setState(() {
                        widget.selectMonth = 4;
                        widget.pickedYear = widget.yearController.text;
                        Navigator.of(context).pop();
                      })
                    : widget.validate = true;
              },
              child: const Text('Apr'),
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: const BorderSide(
                              color: Colors.teal, width: 2.0)))),
            ),
            ElevatedButton(
              onPressed: () async {
                widget.yearController.text.isNotEmpty &&
                        widget.yearController.value.text.length == 4
                    ? setState(() {
                        widget.selectMonth = 5;
                        widget.pickedYear = widget.yearController.text;
                        Navigator.of(context).pop();
                      })
                    : widget.validate = true;
              },
              child: const Text('May'),
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: const BorderSide(
                              color: Colors.teal, width: 2.0)))),
            ),
            ElevatedButton(
              onPressed: () {
                widget.yearController.text.isNotEmpty &&
                        widget.yearController.value.text.length == 4
                    ? setState(() {
                        widget.selectMonth = 6;
                        widget.pickedYear = widget.yearController.text;
                        Navigator.of(context).pop();
                      })
                    : widget.validate = true;
              },
              child: const Text('Jun'),
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: const BorderSide(
                              color: Colors.teal, width: 2.0)))),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () async {
                widget.yearController.text.isNotEmpty &&
                        widget.yearController.value.text.length == 4
                    ? setState(() {
                        widget.selectMonth = 7;
                        widget.pickedYear = widget.yearController.text;
                        Navigator.of(context).pop();
                      })
                    : widget.validate = true;
              },
              child: const Text('Jul'),
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: const BorderSide(
                              color: Colors.teal, width: 2.0)))),
            ),
            ElevatedButton(
              onPressed: () async {
                widget.yearController.text.isNotEmpty &&
                        widget.yearController.value.text.length == 4
                    ? setState(() {
                        widget.selectMonth = 8;
                        widget.pickedYear = widget.yearController.text;
                        Navigator.of(context).pop();
                      })
                    : widget.validate = true;
              },
              child: const Text('Aug'),
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: const BorderSide(
                              color: Colors.teal, width: 2.0)))),
            ),
            ElevatedButton(
              onPressed: () {
                widget.yearController.text.isNotEmpty &&
                        widget.yearController.value.text.length == 4
                    ? setState(() {
                        widget.selectMonth = 9;
                        widget.pickedYear = widget.yearController.text;
                        Navigator.of(context).pop();
                      })
                    : widget.validate = true;
              },
              child: const Text('Sep'),
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: const BorderSide(
                              color: Colors.teal, width: 2.0)))),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () async {
                widget.yearController.text.isNotEmpty &&
                        widget.yearController.value.text.length == 4
                    ? setState(() {
                        widget.selectMonth = 10;
                        widget.pickedYear = widget.yearController.text;
                        Navigator.of(context).pop();
                      })
                    : widget.validate = true;
              },
              child: const Text('Oct'),
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: const BorderSide(
                              color: Colors.teal, width: 2.0)))),
            ),
            ElevatedButton(
              onPressed: () {
                widget.yearController.text.isNotEmpty &&
                        widget.yearController.value.text.length == 4
                    ? setState(() {
                        widget.selectMonth = 11;
                        widget.pickedYear = widget.yearController.text;
                        Navigator.of(context).pop();
                      })
                    : widget.validate = true;
              },
              child: const Text('Nov'),
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: const BorderSide(
                              color: Colors.teal, width: 2.0)))),
            ),
            ElevatedButton(
              onPressed: () {
                widget.yearController.text.isNotEmpty &&
                        widget.yearController.value.text.length == 4
                    ? setState(() {
                        widget.selectMonth = 12;
                        widget.pickedYear = widget.yearController.text;
                        Navigator.of(context).pop();
                      })
                    : widget.validate = true;
              },
              child: const Text('Dec'),
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: const BorderSide(
                              color: Colors.teal, width: 2.0)))),
            )
          ],
        ),
      ],
    );
  }
}
