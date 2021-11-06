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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Employee'),
        ),
        body: SingleChildScrollView(
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
                        child: TextField(
                          decoration: InputDecoration(hintText: 'Enter Name'),
                          controller: name,
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
                        child: TextField(
                          decoration:
                              InputDecoration(hintText: 'Enter Phone Number'),
                          controller: phone,
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
                        child: TextField(
                          decoration:
                              InputDecoration(hintText: 'Enter Email address'),
                          controller: email,
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
                        child: TextField(
                          decoration:
                              InputDecoration(hintText: 'Enter Password'),
                          controller: password,
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
                        child: TextField(
                          decoration:
                              InputDecoration(hintText: 'Enter Address'),
                          controller: address,
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
                        child: TextField(
                          decoration:
                              InputDecoration(hintText: 'Enter Position'),
                          controller: position,
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
                        child: TextField(
                          decoration: InputDecoration(hintText: 'Enter Skill'),
                          controller: skill,
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
                        child: TextField(
                          decoration: InputDecoration(hintText: 'Enter Salary'),
                          controller: salary,
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
                    // Container(
                    //   constraints: BoxConstraints(
                    //       maxWidth: MediaQuery.of(context).size.width * 0.6),
                    //   child: Flexible(
                    //     child: TextField(
                    //       decoration: InputDecoration(hintText: 'Enter Role'),
                    //       controller: role,
                    //     ),
                    //   ),
                    // ),
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
                    // Container(
                    //   constraints: BoxConstraints(
                    //       maxWidth: MediaQuery.of(context).size.width * 0.6),
                    //   child: Flexible(
                    //     child: TextField(
                    //       decoration: InputDecoration(
                    //           hintText: 'Enter employee status'),
                    //       controller: status,
                    //     ),
                    //   ),
                    // ),
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
                    // Container(
                    //   constraints: BoxConstraints(
                    //       maxWidth: MediaQuery.of(context).size.width * 0.6),
                    //   child: Flexible(
                    //     child: TextField(
                    //       decoration:
                    //           InputDecoration(hintText: 'Enter employee rate'),
                    //       controller: workrate,
                    //     ),
                    //   ),
                    // ),
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
                        child: TextField(
                          decoration: InputDecoration(
                              hintText: 'Enter Employee background'),
                          controller: background,
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
                                            addNew();
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
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => EmployeeListScreen(),
                            ),
                          );
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
