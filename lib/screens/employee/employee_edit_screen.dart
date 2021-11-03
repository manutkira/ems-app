import 'dart:convert';

import 'package:ems/models/user.dart';
import 'package:ems/utils/services/base_api.dart';
import 'package:ems/widgets/textbox.dart';
import 'package:http/http.dart' as http;
import 'package:ems/constants.dart';
import 'package:ems/utils/services/users.dart';
import 'package:flutter/material.dart';

import '../../models/user.dart';

class EmployeeEditScreen extends StatefulWidget {
  const EmployeeEditScreen({Key? key}) : super(key: key);

  static const routeName = '/employee-edit';

  @override
  State<EmployeeEditScreen> createState() => _EmployeeEditScreenState();
}

class _EmployeeEditScreenState extends State<EmployeeEditScreen> {
  late int employeeId;

  late Future<User> _user;

  final idController = TextEditingController();
  // final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final positionController = TextEditingController();
  final skillController = TextEditingController();
  final salaryController = TextEditingController();
  final workrateController = TextEditingController();
  final backgroundController = TextEditingController();

  void _getUsers() {
    setState(() {
      _user = UserService().getUser(employeeId);
    });
    // idController.text = _user.id.toString();
    // final nameController = _user.name;
    // phoneController.text = _user.phone;
    // emailController.text = _user.email.toString();
    // addressController.text = _user.address.toString();
    // positionController.text = _user.position.toString();
    // skillController.text = _user.skill.toString();
    // salaryController.text = _user.salary.toString();
    // workrateController.text = _user.rate.toString();
    // backgroundController.text = _user.background.toString();
  }

  @override
  void didChangeDependencies() {
    employeeId = ModalRoute.of(context)!.settings.arguments as int;
    super.didChangeDependencies();
    _getUsers();
  }

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
        title: Text('Employee'),
      ),
      body:
          // FutureBuilder<User>(
          //     future: UserService().getUser(employeeId),
          //     builder: (context, snapshot) {
          //       if (snapshot.hasData) {
          //         return SingleChildScrollView(
          //           child:
          FutureBuilder<User>(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ID ',
                          style:
                              kParagraph.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.6),
                          child: Flexible(
                            child: TextBoxCustom(
                              textHint: 'hint',
                              getValue: (value) {
                                setState(() {
                                  snapshot.data!.id = value;
                                });
                              },
                              defaultText: snapshot.data!.id.toString(),
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
                        // SizedBox(
                        //   width: 10,
                        // ),
                        Text(
                          'Name ',
                          style:
                              kParagraph.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.6),
                          child: Flexible(
                            child: TextBoxCustom(
                              textHint: 'hint',
                              getValue: (value) {
                                setState(() {
                                  snapshot.data!.name = value;
                                });
                              },
                              defaultText: snapshot.data!.name,
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
                          style:
                              kParagraph.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.6),
                          child: Flexible(
                            child: TextBoxCustom(
                              textHint: 'hint',
                              getValue: (value) {
                                setState(() {
                                  snapshot.data!.phone = value;
                                });
                              },
                              defaultText: snapshot.data!.phone,
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
                          style:
                              kParagraph.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.6),
                          child: Flexible(
                            child: TextBoxCustom(
                              textHint: 'hint',
                              getValue: (value) {
                                setState(() {
                                  snapshot.data!.email = value;
                                });
                              },
                              defaultText: snapshot.data!.email.toString(),
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
                          style:
                              kParagraph.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.6),
                          child: Flexible(
                            child: TextBoxCustom(
                              textHint: 'hint',
                              getValue: (value) {
                                setState(() {
                                  snapshot.data!.address = value;
                                });
                              },
                              defaultText: snapshot.data!.address.toString(),
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
                          style:
                              kParagraph.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.6),
                          child: Flexible(
                            child: TextBoxCustom(
                              textHint: 'hint',
                              getValue: (value) {
                                setState(() {
                                  snapshot.data!.position = value;
                                });
                              },
                              defaultText: snapshot.data!.position.toString(),
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
                          style:
                              kParagraph.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.6),
                          child: Flexible(
                            child: TextBoxCustom(
                              textHint: 'hint',
                              getValue: (value) {
                                setState(() {
                                  snapshot.data!.skill = value;
                                });
                              },
                              defaultText: snapshot.data!.skill.toString(),
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
                          style:
                              kParagraph.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.6),
                          child: Flexible(
                            child: TextBoxCustom(
                              textHint: 'hint',
                              getValue: (value) {
                                setState(() {
                                  snapshot.data!.salary = value;
                                });
                              },
                              defaultText: snapshot.data!.salary.toString(),
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
                          style:
                              kParagraph.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.6),
                          child: Flexible(
                            child: TextBoxCustom(
                              textHint: 'hint',
                              getValue: (value) {
                                setState(() {
                                  snapshot.data!.rate = value;
                                });
                              },
                              defaultText: snapshot.data!.rate.toString(),
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
                          style:
                              kParagraph.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 1),
                          child: Flexible(
                            child: TextField(
                              controller: TextEditingController(
                                  text: snapshot.data!.background),
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
                                // updateData();
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
            );
          } else if (snapshot.hasError) {
            print(snapshot.error);
          }
          return const CircularProgressIndicator(
            color: kWhite,
          );
          // }),
          // );
        },
        future: _user,
      ),
    );
    // } else if (snapshot.hasError) {
    //   print(snapshot.error);
    // }
    // return const CircularProgressIndicator(
    //   color: kWhite,
    // );
    // }),
    // );
  }

//   updateData() async {
//     var id = idController.text;
//     // var name = nameController.text;
//     var phone = phoneController.text;
//     var email = emailController.text;
//     var address = addressController.text;
//     var position = positionController.text;
//     var skill = skillController.text;
//     var salary = salaryController.text;
//     var workrate = workrateController.text;
//     var background = backgroundController.text;

//     var data = json.encode({
//       "id": id,
//       // "name": name,
//       "phone": phone,
//       "email": email,
//       "address": address,
//       "position": position,
//       "skill": skill,
//       "salary": salary,
//       "rate": workrate,
//       "background": background,
//     });
//     var url =
//         "https://laravel-rest-api-app.herokuapp.com/api/users/$employeeId";
//     var response = await http.put(Uri.parse(url), body: data);

//     if (response.statusCode == 200) {
//       print('succeeded');
//     } else {
//       print(response.statusCode);
//     }
//   }
}
