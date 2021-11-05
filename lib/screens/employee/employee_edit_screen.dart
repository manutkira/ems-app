import 'dart:convert';

import 'package:ems/widgets/textbox.dart';
import 'package:http/http.dart' as http;
import 'package:ems/constants.dart';
import 'package:ems/utils/services/users.dart';
import 'package:flutter/material.dart';

class EmployeeEditScreen extends StatefulWidget {
  final int id;
  final String name;
  final String phone;
  final String email;
  final String address;
  final String position;
  final String skill;
  final String password;
  final String rate;
  final String background;

  EmployeeEditScreen(
    this.id,
    this.name,
    this.phone,
    this.email,
    this.address,
    this.position,
    this.skill,
    this.password,
    this.rate,
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
  TextEditingController passwordController = TextEditingController();
  TextEditingController workrateController = TextEditingController();
  TextEditingController backgroundController = TextEditingController();

  @override
  void initState() {
    nameController.text = widget.name;
    phoneController.text = widget.phone;
    emailController.text = widget.email;
    addressController.text = widget.address;
    positionController.text = widget.position;
    skillController.text = widget.skill;
    passwordController.text = widget.password;
    workrateController.text = widget.rate;
    backgroundController.text = widget.background;

    super.initState();

    print('object');
  }
  // Future fetchData() async {
  //   final response = await http.get(Uri.parse(
  //       "http://rest-api-laravel-flutter.herokuapp.com/api/users/$employeeId"));

  //   return json.decode(response.body);
  // }

  // void _getUsers() {
  //   setState(() {});
  // idController.text = _user.id.toString();
  // final nameController = _user.name;
  // phoneController.text = _user.phone;
  // emailController.text = _user.email.toString();
  // addressController.text = _user.address.toString();
  // positionController.text = _user.position.toString();
  // skillController.text = _user.skill.toString();
  // passwordController.text = _user.password.toString();
  // workrateController.text = _user.rate.toString();
  // backgroundController.text = _user.background.toString();
  // }

  // @override
  // void didChangeDependencies() {
  //   employeeId = ModalRoute.of(context)!.settings.arguments as int;
  //   super.didChangeDependencies();
  //   _getUsers();
  // }

  // @override
  // initState() {
  //   super.initState();
  //   // _getUser();
  //   _getUsers();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Employee'),
      ),
      body:
          // FutureBuilder<User>(
          //     future: UserService().getUser(employeeId),
          //     builder: (context, snapshot) {
          //       if (snapshot.hasData) {
          //         return SingleChildScrollView(
          //           child:
          //   FutureBuilder(
          // builder: (context, snapshot) {
          //   if (snapshot.hasData) {
          //     return
          SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // SizedBox(
                  //   width: 10,
                  // ),
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
                        controller: nameController,
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
                        controller: phoneController,
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
                        controller: emailController,
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
                        controller: addressController,
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
                        controller: positionController,
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
                        controller: skillController,
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
                        controller: passwordController,
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
                        controller: workrateController,
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
                        controller: backgroundController,
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
                          updateData();
                        },
                        child: Text('Save'),
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    RaisedButton(
                      onPressed: () {},
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
      // } else if (snapshot.hasError) {
      //   print(snapshot.error);
      // }
      // return const CircularProgressIndicator(
      //   color: kWhite,
      // );
      // }),
      // );
      // },
      // future: fetchData(),
      // ),
    );
  }

  updateData() async {
    var aName = nameController.text;
    var aPhone = phoneController.text;
    var aEmail = emailController.text;
    var aAddress = addressController.text;
    var aPosition = positionController.text;
    var aSkill = skillController.text;
    var aPassword = passwordController.text;
    var aWorkrate = workrateController.text;
    var aBackground = backgroundController.text;

    var data = json.encode({
      "name": aName,
      "phone": aPhone,
      "email": aEmail,
      "address": aAddress,
      "position": aPosition,
      "skill": aSkill,
      "password": aPassword,
      "rate": aWorkrate,
      "background": aBackground,
    });
    var response = await http.put(Uri.parse("${url}/${widget.id}"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        },
        body: data);

    if (response.statusCode == 405) {
      print('succeeded');
    } else {
      print(response.statusCode);
    }
  }
}
