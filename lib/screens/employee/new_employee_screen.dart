import 'package:ems/screens/employee/employee_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbols.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../constants.dart';

class NewEmployeeScreen extends StatelessWidget {
  String url = "http://rest-api-laravel-flutter.herokuapp.com/api/users";
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController position = TextEditingController();
  TextEditingController skill = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController workrate = TextEditingController();
  TextEditingController background = TextEditingController();

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
                      'password ',
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
                              InputDecoration(hintText: 'Enter password'),
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
                      'Work-Rate ',
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
                              InputDecoration(hintText: 'Enter Work-Rate'),
                          controller: workrate,
                        ),
                      ),
                    ),
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
    var apassword = password.text;
    var aWorkrate = workrate.text;
    var aBackground = background.text;

    var data = json.encode({
      "name": aName,
      "phone": aPhone,
      "email": aEmail,
      "address": aAddress,
      "position": aPosition,
      "skill": aSkill,
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
      print(response.body);
    } else {
      print(response.statusCode);
    }
  }
}
