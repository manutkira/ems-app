import 'dart:convert';

import 'package:ems/screens/employee/employee_list_screen.dart';
import 'package:ems/widgets/textbox.dart';
import 'package:http/http.dart' as http;
import 'package:ems/constants.dart';
import 'package:flutter/material.dart';

class EmployeeEditScreen extends StatefulWidget {
  final int id;
  final String name;
  final String phone;
  final String email;
  final String address;
  final String position;
  final String skill;
  final String salary;
  final String role;
  final String status;
  final String ratee;
  final String background;

  EmployeeEditScreen(
    this.id,
    this.name,
    this.phone,
    this.email,
    this.address,
    this.position,
    this.skill,
    this.salary,
    this.role,
    this.status,
    this.ratee,
    this.background,
  );
  static const routeName = '/employee-edit';

  @override
  State<EmployeeEditScreen> createState() => _EmployeeEditScreenState();
}

class _EmployeeEditScreenState extends State<EmployeeEditScreen> {
  String url = "http://rest-api-laravel-flutter.herokuapp.com/api/users";

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController positionController = TextEditingController();
  TextEditingController skillController = TextEditingController();
  TextEditingController salaryController = TextEditingController();
  TextEditingController backgroundController = TextEditingController();
  String role = 'Admin';
  String status = 'Active';
  String rate = 'Good';

  final _form = GlobalKey<FormState>();

  @override
  void initState() {
    nameController.text = widget.name;
    phoneController.text = widget.phone;
    emailController.text = widget.email;
    addressController.text = widget.address;
    positionController.text = widget.position;
    skillController.text = widget.skill;
    salaryController.text = widget.salary;
    backgroundController.text = widget.background;
    role = widget.role;
    status = widget.status;
    rate = widget.ratee;

    super.initState();

    print('object');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Edit Employee'),
          leading: IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                          title: Text('Are you Sure?'),
                          content: Text('Your changes will be lost.'),
                          actions: [
                            OutlineButton(
                              onPressed: () async {
                                // Navigator.of(context).pushReplacement(
                                //   MaterialPageRoute(
                                //     builder: (BuildContext context) =>
                                //         EmployeeListScreen(),
                                //   ),
                                // );
                                Navigator.of(context).pop();
                                await Navigator.of(context)
                                    .pushReplacementNamed(
                                  EmployeeListScreen.routeName,
                                );
                              },
                              child: Text('Yes'),
                              borderSide: BorderSide(color: Colors.green),
                            ),
                            OutlineButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('No'),
                              borderSide: BorderSide(color: Colors.red),
                            )
                          ],
                        ));
              },
              icon: Icon(Icons.arrow_back)),
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
                            controller: nameController,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value!.isEmpty) {
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
                              hintText: 'Enter Phone number',
                              errorStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            controller: phoneController,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please Enter Phone Number';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Please Enter valid number';
                              }
                              if (value.length < 9 || value.length > 10) {
                                return 'Enter Between 8-9 Digits';
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
                            controller: emailController,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value!.isEmpty ||
                                  !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}')
                                      .hasMatch(value)) {
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
                              ),
                            ),
                            controller: addressController,
                            textInputAction: TextInputAction.next,
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
                              ),
                            ),
                            controller: positionController,
                            textInputAction: TextInputAction.next,
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
                              ),
                            ),
                            controller: skillController,
                            textInputAction: TextInputAction.next,
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
                              ),
                            ),
                            controller: salaryController,
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
                          value: role,
                          onChanged: (String? newValue) {
                            setState(() {
                              role = newValue!;
                            });
                            widget.role;
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
                          value: status,
                          onChanged: (String? newValue) {
                            setState(() {
                              status = newValue!;
                            });
                            widget.status;
                          },
                          items: <String>[
                            'Active',
                            'Inactive',
                            'Resigned',
                            'Fired'
                          ].map<DropdownMenuItem<String>>((String value) {
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
                          value: rate,
                          onChanged: (String? newValue) {
                            setState(() {
                              rate = newValue!;
                            });
                            widget.ratee;
                          },
                          items: <String>['Very\ Good', 'Good', 'Meduim', 'Low']
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
                              ),
                            ),
                            controller: backgroundController,
                            textInputAction: TextInputAction.done,
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
                                            'Do you want to save the changes'),
                                        actions: [
                                          OutlineButton(
                                            borderSide:
                                                BorderSide(color: Colors.green),
                                            child: Text('Yes'),
                                            onPressed: () {
                                              if (_form.currentState!
                                                  .validate()) {
                                                updateData();
                                              }
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          OutlineButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('No'),
                                            borderSide:
                                                BorderSide(color: Colors.red),
                                          )
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
                                      title: Text('Are you Sure?'),
                                      content:
                                          Text('Your changes will be lost.'),
                                      actions: [
                                        OutlineButton(
                                          onPressed: () async {
                                            // Navigator.of(context).pushReplacement(
                                            //   MaterialPageRoute(
                                            //     builder: (BuildContext context) =>
                                            //         EmployeeListScreen(),
                                            //   ),
                                            // );
                                            Navigator.of(context).pop();
                                            await Navigator.of(context)
                                                .pushReplacementNamed(
                                              EmployeeListScreen.routeName,
                                            );
                                          },
                                          child: Text('Yes'),
                                          borderSide:
                                              BorderSide(color: Colors.green),
                                        ),
                                        OutlineButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('No'),
                                          borderSide:
                                              BorderSide(color: Colors.red),
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
        ),
      ),
    );
  }

  updateData() async {
    var aName = nameController.text;
    var aPhone = phoneController.text;
    var aEmail = emailController.text;
    var aAddress = addressController.text;
    var aPosition = positionController.text;
    var aSkill = skillController.text;
    var aSalary = salaryController.text;
    var aBackground = backgroundController.text;
    var aRole = role;
    var aStatus = status;
    var aRate = rate;

    var data = json.encode({
      "name": aName,
      "phone": aPhone,
      "email": aEmail,
      "address": aAddress,
      "position": aPosition,
      "skill": aSkill,
      "salary": aSalary,
      "background": aBackground,
      "role": aRole,
      "status": aStatus,
      "rate": aRate,
    });
    var response = await http.put(Uri.parse("${url}/${widget.id}"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        },
        body: data);

    if (response.statusCode == 200) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => EmployeeListScreen()));
    } else {
      print(response.statusCode);
    }
  }
}
