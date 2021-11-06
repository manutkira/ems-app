import 'package:ems/screens/employee/employee_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbols.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../constants.dart';

class NewEmployeeScreen extends StatefulWidget {
  @override
  State<NewEmployeeScreen> createState() => _NewEmployeeScreenState();
}

class _NewEmployeeScreenState extends State<NewEmployeeScreen> {
  String url = "http://rest-api-laravel-flutter.herokuapp.com/api/users";

  TextEditingController name = TextEditingController();

  TextEditingController phone = TextEditingController();

  TextEditingController email = TextEditingController();

  TextEditingController address = TextEditingController();

  TextEditingController position = TextEditingController();

  TextEditingController skill = TextEditingController();

  TextEditingController salary = TextEditingController();

  TextEditingController role = TextEditingController();

  TextEditingController status = TextEditingController();

  TextEditingController password = TextEditingController();

  TextEditingController workrate = TextEditingController();

  TextEditingController background = TextEditingController();

  String dropDownValue = 'Active';

  String dropDownValue1 = 'Admin';

  String dropDownValue2 = 'Very\ Good';

  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Employee'),
        ),
        body: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
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
                              hintText: 'Enter Name',
                              errorStyle: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            controller: name,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value!.isEmpty ||
                                  !RegExp(r'^[a-z A-Z]+$').hasMatch(value!)) {
                                return 'Please Enter Correct Name';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Phone ',
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
                              hintText: 'Enter Phone Number',
                              errorStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            controller: phone,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value!.isEmpty ||
                                  !RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]+$')
                                      .hasMatch(value!)) {
                                return 'Please Enter Correct Phone';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Email ',
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
                              hintText: 'Enter Email address',
                              errorStyle: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            controller: email,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value!.isEmpty ||
                                  !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}')
                                      .hasMatch(value!)) {
                                return 'Please Enter Correct Email';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Password ',
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
                              hintText: 'Enter Password',
                              errorStyle: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            controller: password,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please Enter Password';
                              }
                              if (value!.length < 8) {
                                return 'Enter more than 8 characters';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Address ',
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
                                hintText: 'Enter Address',
                                errorStyle: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                )),
                            controller: address,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please Enter address';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Position ',
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
                                hintText: 'Enter Position',
                                errorStyle: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                )),
                            controller: position,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please Enter Position';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Skill ',
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
                                hintText: 'Enter Skill',
                                errorStyle: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                )),
                            controller: skill,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please Enter Skill';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Salary ',
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
                                hintText: 'Enter Salary',
                                errorStyle: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                )),
                            controller: salary,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please Enter Salary';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Please Enter valid number';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Role ',
                        style: kParagraph.copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        width: 233,
                        child: DropdownButtonFormField(
                          icon: Icon(Icons.expand_more),
                          value: dropDownValue1,
                          onChanged: (String? newValue) {
                            setState(() {
                              dropDownValue1 = newValue!;
                            });
                          },
                          items: <String>['Admin', 'Employee']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                ));
                          }).toList(),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Status ',
                        style: kParagraph.copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        width: 233,
                        child: DropdownButtonFormField(
                          icon: Icon(Icons.expand_more),
                          value: dropDownValue,
                          onChanged: (String? newValue) {
                            setState(() {
                              dropDownValue = newValue!;
                            });
                          },
                          items: <String>[
                            'Active',
                            'Inactive',
                            'Resigned',
                            'Fired'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Rate ',
                        style: kParagraph.copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        width: 233,
                        child: DropdownButtonFormField(
                          icon: Icon(Icons.expand_more),
                          value: dropDownValue2,
                          onChanged: (String? newValue) {
                            setState(() {
                              dropDownValue2 = newValue!;
                            });
                          },
                          items: <String>[
                            'Very \Good',
                            'Good',
                            'Meduim',
                            'Low',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Background ',
                        style: kParagraph.copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 1),
                        child: Flexible(
                          child: TextFormField(
                            decoration: InputDecoration(
                                hintText: 'Enter Employee background',
                                errorStyle: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                )),
                            controller: background,
                            textInputAction: TextInputAction.done,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please Enter Employee Background';
                              }
                              if (value!.length < 10) {
                                return 'Enter more than 10 characters';
                              }
                              return null;
                            },
                            maxLines: 8,
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
                                        content: Text(
                                            'Do you want to add new employee?'),
                                        actions: [
                                          OutlineButton(
                                            borderSide:
                                                BorderSide(color: Colors.green),
                                            onPressed: () {
                                              if (_form.currentState!
                                                  .validate()) {
                                                addNew();
                                              }
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Yes'),
                                          ),
                                          OutlineButton(
                                            borderSide:
                                                BorderSide(color: Colors.red),
                                            onPressed: () {},
                                            child: Text('No'),
                                          ),
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
                                      title: Text('Are you sure?'),
                                      content: Text('Your data will be lost.'),
                                      actions: [
                                        OutlineButton(
                                          borderSide:
                                              BorderSide(color: Colors.green),
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pushReplacement(
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    EmployeeListScreen(),
                                              ),
                                            );
                                          },
                                          child: Text('Yes'),
                                        ),
                                        OutlineButton(
                                          borderSide:
                                              BorderSide(color: Colors.red),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('No'),
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
          ),
        ));
  }

  addNew() async {
    var aName = name.text;
    var aPhone = phone.text;
    var aEmail = email.text;
    var aAddress = address.text;
    var aPosition = position.text;
    var aSkill = skill.text;
    var aSalary = salary.text;
    var aRole = dropDownValue1;
    var aStatus = dropDownValue;
    var apassword = password.text;
    var aWorkrate = dropDownValue2;
    var aBackground = background.text;

    var data = json.encode({
      "name": aName,
      "phone": aPhone,
      "email": aEmail,
      "address": aAddress,
      "position": aPosition,
      "skill": aSkill,
      "salary": aSalary,
      "role": aRole,
      "status": aStatus,
      "password": apassword,
      "rate": aWorkrate,
      "background": aBackground,
    });

    var response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: data,
    );

    if (response.statusCode == 201) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => EmployeeListScreen()));
    } else {
      print(response.statusCode);
    }
  }
}
