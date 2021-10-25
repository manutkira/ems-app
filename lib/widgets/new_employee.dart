import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '';

class NewEmployee extends StatefulWidget {
  final Function addEmployee;

  NewEmployee(this.addEmployee);

  @override
  _NewEmployeeState createState() => _NewEmployeeState();
}

class _NewEmployeeState extends State<NewEmployee> {
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
        enteredSalary <= 0 ||
        enteredWorkRate.isEmpty ||
        enteredContact <= 0 ||
        _selectDate == null) {
      return;
    }

    widget.addEmployee(
        enteredName,
        enteredId,
        enteredDate,
        enteredSkill,
        enteredSalary,
        enteredSalary,
        enteredWorkRate,
        enteredContact,
        _selectDate);

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
                  Color(0xff3B9AAD),
                  Colors.blue,
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
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter Name',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                    controller: _nameController,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter ID',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                    controller: _idController,
                  ),
                  Container(
                    height: 80,
                    child: Row(
                      children: [
                        Text(_selectDate == null
                            ? 'Date of Birth'
                            : 'Date: ${DateFormat.yMd().format(_selectDate as DateTime)}'),
                        FlatButton(
                            onPressed: () => _dobDatePicker(),
                            child: Text('Choose Date'))
                      ],
                    ),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Employee skill',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                    controller: _skillController,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Employee salary',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                    controller: _salaryController,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'EMployee WorkRate',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                    controller: _idController,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Employee Contact',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                    controller: _contactController,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Employee Background',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                    controller: _backgroundController,
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
