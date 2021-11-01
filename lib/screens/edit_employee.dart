import 'package:ems/dummy_data.dart';
import 'package:ems/widgets/inputfield.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class EditEmployeeScreen extends StatelessWidget {
  static const routeName = '/edit-employee';
  @override
  Widget build(BuildContext context) {
    final employeeId = ModalRoute.of(context)!.settings.arguments as String;
    final selectedEmployee =
        indiEmployee.firstWhere((employee) => employee.id == employeeId);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kDarkestBlue,
        title: Text(
          'Edit Employee',
        ),
      ),
      body: Container(
        width: double.infinity,
        color: kBlue,
        child: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Row(
                  children: [
                    Text(
                      'Edit Employee: ',
                      style: kHeadingThree,
                    ),
                    Text(
                      selectedEmployee.name,
                      style: kHeadingFour,
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Name: ',
                    style: kHeadingThree,
                  ),
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
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              borderSide:
                                  BorderSide(color: Colors.black, width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                    color: const Color(0xFF8A3324), width: 2)),
                            hintText: 'Enter Name',
                            hintStyle: TextStyle(
                                fontSize: 16,
                                color: kWhite,
                                fontWeight: FontWeight.w200)),
                        controller:
                            TextEditingController(text: selectedEmployee.name),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ID: ',
                    style: kHeadingThree,
                  ),
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
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              borderSide:
                                  BorderSide(color: Colors.black, width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                    color: const Color(0xFF8A3324), width: 2)),
                            hintText: 'Enter ID',
                            hintStyle: TextStyle(
                                fontSize: 16,
                                color: kWhite,
                                fontWeight: FontWeight.w200)),
                        controller:
                            TextEditingController(text: selectedEmployee.id),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Date of Birth: ',
                    style: kHeadingThree,
                  ),
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
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              borderSide:
                                  BorderSide(color: Colors.black, width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                    color: const Color(0xFF8A3324), width: 2)),
                            hintText: 'Enter Date',
                            hintStyle: TextStyle(
                                fontSize: 16,
                                color: kWhite,
                                fontWeight: FontWeight.w200)),
                        controller:
                            TextEditingController(text: selectedEmployee.date),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Skill: ',
                    style: kHeadingThree,
                  ),
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
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              borderSide:
                                  BorderSide(color: Colors.black, width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                    color: const Color(0xFF8A3324), width: 2)),
                            hintText: 'Enter Skill',
                            hintStyle: TextStyle(
                                fontSize: 16,
                                color: kWhite,
                                fontWeight: FontWeight.w200)),
                        controller:
                            TextEditingController(text: selectedEmployee.skill),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Salary: ',
                    style: kHeadingThree,
                  ),
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
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              borderSide:
                                  BorderSide(color: Colors.black, width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                    color: const Color(0xFF8A3324), width: 2)),
                            hintText: 'Enter Salary',
                            hintStyle: TextStyle(
                                fontSize: 16,
                                color: kWhite,
                                fontWeight: FontWeight.w200)),
                        controller: TextEditingController(
                            text: selectedEmployee.salary.toString()),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Work-Rate: ',
                    style: kHeadingThree,
                  ),
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
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              borderSide:
                                  BorderSide(color: Colors.black, width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                    color: const Color(0xFF8A3324), width: 2)),
                            hintText: 'Enter Work-Rate',
                            hintStyle: TextStyle(
                                fontSize: 16,
                                color: kWhite,
                                fontWeight: FontWeight.w200)),
                        controller: TextEditingController(
                            text: selectedEmployee.workRate),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Contact: ',
                    style: kHeadingThree,
                  ),
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
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              borderSide:
                                  BorderSide(color: Colors.black, width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                    color: const Color(0xFF8A3324), width: 2)),
                            hintText: 'Enter Contact',
                            hintStyle: TextStyle(
                                fontSize: 16,
                                color: kWhite,
                                fontWeight: FontWeight.w200)),
                        controller: TextEditingController(
                            text: selectedEmployee.contact.toString()),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Background: ',
                    style: kHeadingThree,
                  ),
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
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              borderSide:
                                  BorderSide(color: Colors.black, width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                    color: const Color(0xFF8A3324), width: 2)),
                            hintText: 'Enter Background',
                            hintStyle: TextStyle(
                                fontSize: 16,
                                color: kWhite,
                                fontWeight: FontWeight.w200)),
                        controller: TextEditingController(
                            text: selectedEmployee.background),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.only(right: 10),
                    child: RaisedButton(
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor: Color(0xff043347),
                                title: Text('Are you sure?'),
                                content:
                                    Text('Do you want to save the changes?'),
                                actions: [
                                  RaisedButton(
                                    color: Color(0xff05445E),
                                    onPressed: () {},
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
                      child: Text('Save'),
                    ),
                  ),
                  RaisedButton(
                    color: Colors.red,
                    onPressed: () {},
                    child: Text('Back'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
