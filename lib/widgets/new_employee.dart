import 'package:ems/widgets/inputfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants.dart';
import '../constants.dart';

class NewEmployee extends StatefulWidget {
  final Function addEmployee;

  NewEmployee(this.addEmployee);

  @override
  State<NewEmployee> createState() => _NewEmployeeState();
}

class _NewEmployeeState extends State<NewEmployee> {
  final color = const Color(0xff05445E);
  final color1 = const Color(0xff3B9AAD);
  final _nameController = TextEditingController();
  final _idController = TextEditingController();
  final _dateController = TextEditingController();
  final _skillController = TextEditingController();
  final _salaryController = TextEditingController();
  final _workRateController = TextEditingController();
  final _contactController = TextEditingController();
  final _backgroundController = TextEditingController();
  DateTime? _selectDate;

  void _submitData() {
    if (_nameController.text.isEmpty) {
      return;
    }
    final enteredName = _nameController.text;
    final enteredId = _idController.text;
    final enteredDate = _dateController.text;
    final enteredSkill = _skillController.text;
    final enteredSalary = double.parse(_salaryController.text);
    final enteredWorkRate = _workRateController.text;
    final enteredContact = int.parse(_contactController.text);
    final enteredBackground = _backgroundController.text;

    if (enteredName.isEmpty ||
        enteredId.isEmpty ||
        enteredDate.isEmpty ||
        enteredSkill.isEmpty ||
        enteredWorkRate.isEmpty ||
        enteredBackground.isEmpty) {
      return;
    }

    widget.addEmployee(
      enteredName,
      enteredId,
      enteredDate,
      enteredSkill,
      enteredSalary,
      enteredWorkRate,
      enteredContact,
      enteredBackground,
    );

    Navigator.of(context).pop();
  }

  void _dobDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    ).then((picked) {
      if (picked == null) {
        return;
      }
      setState(() {
        _selectDate = picked;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        elevation: 5,
        child: Container(
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
          height: 500,
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add Employee',
                    style: TextStyle(fontSize: 30),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Name: '),
                      Flexible(
                        child: Container(
                          margin: EdgeInsets.all(10),
                          height: 40,
                          width: 177,
                          child: TextField(
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10),
                                filled: true,
                                fillColor: Colors.black,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  borderSide:
                                      BorderSide(color: Colors.black, width: 2),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    borderSide: BorderSide(
                                        color: const Color(0xFF8A3324),
                                        width: 2)),
                                hintText: 'Enter Name',
                                hintStyle: TextStyle(
                                    fontSize: 16,
                                    color: kWhite,
                                    fontWeight: FontWeight.w200)),
                            controller: _nameController,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('ID: '),
                      Flexible(
                        child: Container(
                          margin: EdgeInsets.all(10),
                          height: 40,
                          width: 177,
                          child: TextField(
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10),
                                filled: true,
                                fillColor: Colors.black,
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 2)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    borderSide: BorderSide(
                                        color: const Color(0xFF8A3324),
                                        width: 2)),
                                hintText: 'Enter ID',
                                hintStyle: TextStyle(
                                    fontSize: 16,
                                    color: kWhite,
                                    fontWeight: FontWeight.w200)),
                            controller: _idController,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Container(
                  //   height: 80,
                  //   child: Row(
                  //     children: [
                  //       Text(_selectDate == null
                  //           ? 'Date of Birth'
                  //           : 'Date: ${DateFormat.yMd().format(_selectDate as DateTime)}'),
                  //       FlatButton(
                  //           onPressed: () => _dobDatePicker(),
                  //           child: Text('Choose Date'))
                  //     ],
                  //   ),
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Date of Birth: '),
                      Flexible(
                        child: Container(
                          margin: EdgeInsets.all(10),
                          height: 40,
                          width: 177,
                          child: TextField(
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10),
                                filled: true,
                                fillColor: Colors.black,
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 2)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    borderSide: BorderSide(
                                        color: const Color(0xFF8A3324),
                                        width: 2)),
                                hintText: 'Enter Date',
                                hintStyle: TextStyle(
                                    fontSize: 16,
                                    color: kWhite,
                                    fontWeight: FontWeight.w200)),
                            controller: _dateController,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Skill: '),
                      Flexible(
                        child: Container(
                          margin: EdgeInsets.all(10),
                          height: 40,
                          width: 177,
                          child: TextField(
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10),
                                filled: true,
                                fillColor: Colors.black,
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 2)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    borderSide: BorderSide(
                                        color: const Color(0xFF8A3324),
                                        width: 2)),
                                hintText: 'Enter Skill',
                                hintStyle: TextStyle(
                                    fontSize: 16,
                                    color: kWhite,
                                    fontWeight: FontWeight.w200)),
                            controller: _skillController,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Salary: '),
                      Flexible(
                        child: Container(
                          margin: EdgeInsets.all(10),
                          height: 40,
                          width: 177,
                          child: TextField(
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10),
                                filled: true,
                                fillColor: Colors.black,
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 2)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    borderSide: BorderSide(
                                        color: const Color(0xFF8A3324),
                                        width: 2)),
                                hintText: 'Enter Salary',
                                hintStyle: TextStyle(
                                    fontSize: 16,
                                    color: kWhite,
                                    fontWeight: FontWeight.w200)),
                            controller: _salaryController,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Work-Rate: '),
                      Flexible(
                        child: Container(
                          margin: EdgeInsets.all(10),
                          height: 40,
                          width: 177,
                          child: TextField(
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10),
                                filled: true,
                                fillColor: Colors.black,
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 2)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    borderSide: BorderSide(
                                        color: const Color(0xFF8A3324),
                                        width: 2)),
                                hintText: 'Enter Work-Rate',
                                hintStyle: TextStyle(
                                    fontSize: 16,
                                    color: kWhite,
                                    fontWeight: FontWeight.w200)),
                            controller: _workRateController,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Contact: '),
                      Flexible(
                        child: Container(
                          margin: EdgeInsets.all(10),
                          height: 40,
                          width: 177,
                          child: TextField(
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10),
                                filled: true,
                                fillColor: Colors.black,
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 2)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    borderSide: BorderSide(
                                        color: const Color(0xFF8A3324),
                                        width: 2)),
                                hintText: 'Enter Contact',
                                hintStyle: TextStyle(
                                    fontSize: 16,
                                    color: kWhite,
                                    fontWeight: FontWeight.w200)),
                            controller: _contactController,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Background: '),
                      Flexible(
                        child: Container(
                          margin: EdgeInsets.all(10),
                          height: 40,
                          width: 177,
                          child: TextField(
                            cursorColor: Colors.white,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10),
                                filled: true,
                                fillColor: Colors.black,
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 2)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    borderSide: BorderSide(
                                        color: const Color(0xFF8A3324),
                                        width: 2)),
                                hintText: 'Enter Background',
                                hintStyle: TextStyle(
                                    fontSize: 16,
                                    color: kWhite,
                                    fontWeight: FontWeight.w200)),
                            controller: _backgroundController,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: EdgeInsets.all(10),
                        child: RaisedButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    backgroundColor: Color(0xff043347),
                                    title: Text('Are you sure?'),
                                    content: Text(
                                        'Do you want to add this new employee?'),
                                    actions: [
                                      RaisedButton(
                                        color: Color(0xff05445E),
                                        onPressed: _submitData,
                                        child: Text('Yes'),
                                      ),
                                      RaisedButton(
                                        color: Colors.red,
                                        onPressed: () {},
                                        child: Text('No'),
                                      ),
                                    ],
                                  );
                                });
                          },
                          color: kDarkestBlue,
                          child: Text(
                            'Confirm',
                            style: kHeadingThree,
                          ),
                        ),
                      ),
                      RaisedButton(
                        onPressed: () {},
                        color: Colors.red,
                        child: Text(
                          'Cancel',
                          style: kHeadingThree,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
