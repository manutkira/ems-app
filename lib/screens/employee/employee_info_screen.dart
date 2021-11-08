import 'package:ems/models/user.dart';
import 'package:ems/utils/services/users.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../constants.dart';
import '../edit_employee.dart';

class EmployeeInfoScreen extends StatefulWidget {
  static const routeName = '/employee-infomation';

  @override
  State<EmployeeInfoScreen> createState() => _EmployeeInfoScreenState();
}

class _EmployeeInfoScreenState extends State<EmployeeInfoScreen> {
  late int employeeId;

  Future fetchData() async {
    final response = await http.get(Uri.parse(
        "http://rest-api-laravel-flutter.herokuapp.com/api/users/$employeeId"));

    return json.decode(response.body);
  }

  @override
  void didChangeDependencies() {
    employeeId = ModalRoute.of(context)!.settings.arguments as int;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final color = const Color(0xff05445E);

    final color1 = const Color(0xff3B9AAD);
    //  employeeId = ModalRoute.of(context)!.settings.arguments as int;
    // print(employeeId);
    return Scaffold(
        appBar: AppBar(
          title: Text('Employee'),
          // actions: [
          //   IconButton(onPressed: (){
          //     int id =
          //                               (snapshot.data as dynamic)[index]['id'];
          //                           String name = (snapshot.data
          //                               as dynamic)[index]['name'];
          //                           String phone = (snapshot.data
          //                               as dynamic)[index]['phone'];
          //                           String email = (snapshot.data
          //                                   as dynamic)[index]['email']
          //                               .toString();
          //                           String address = (snapshot.data
          //                                   as dynamic)[index]['address']
          //                               .toString();
          //                           String position = (snapshot.data
          //                                   as dynamic)[index]['position']
          //                               .toString();
          //                           String skill = (snapshot.data
          //                                   as dynamic)[index]['skill']
          //                               .toString();
          //                           String salary = (snapshot.data
          //                                   as dynamic)[index]['salary']
          //                               .toString();
          //                           String role = (snapshot.data
          //                                   as dynamic)[index]['role']
          //                               .toString();
          //                           String status = (snapshot.data
          //                                   as dynamic)[index]['status']
          //                               .toString();
          //                           String rate = (snapshot.data
          //                                   as dynamic)[index]['rate']
          //                               .toString();
          //                           String background = (snapshot.data
          //                                   as dynamic)[index]['background']
          //                               .toString();
          //                           Navigator.of(context).pushReplacement(
          //                               MaterialPageRoute(
          //                                   builder: (_) => EmployeeEditScreen(
          //                                       id,
          //                                       name,
          //                                       phone,
          //                                       email,
          //                                       address,
          //                                       position,
          //                                       skill,
          //                                       salary,
          //                                       role,
          //                                       status,
          //                                       rate,
          //                                       background)));
          //   }, icon: Icon(Icons.edit))
          // ],
        ),
        body: FutureBuilder(
          future: fetchData(),
          builder: (context, snapshot) {
            print(snapshot);
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                      height: 139,
                      width: double.infinity,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        color: kLightBlue,
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Expanded(
                                flex: 3,
                                child: Image.asset(
                                  'assets/images/profile-icon-png-910.png',
                                  width: 80,
                                ),
                              ),
                            ),
                            Container(
                              height: 50,
                              margin: EdgeInsets.only(left: 15),
                              child: Expanded(
                                flex: 7,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'ID: ',
                                          style: kParagraph.copyWith(
                                              color: Colors.black),
                                        ),
                                        SizedBox(
                                          width: 45,
                                        ),
                                        Text(
                                          (snapshot.data as dynamic)['id']
                                              .toString(),
                                          style: kParagraph.copyWith(
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Name: ',
                                          style: kParagraph.copyWith(
                                              color: Colors.black),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          (snapshot.data as dynamic)['name'],
                                          style: kParagraph.copyWith(
                                              color: Colors.black),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 30),
                      width: double.infinity,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        )),
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
                          child: Container(
                            margin: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Name ',
                                          style: kHeadingFour.copyWith(
                                              color: Colors.black),
                                        ),
                                        SizedBox(
                                          height: 28,
                                        ),
                                        Text(
                                          'ID ',
                                          style: kHeadingFour.copyWith(
                                              color: Colors.black),
                                        ),
                                        SizedBox(
                                          height: 28,
                                        ),
                                        Text(
                                          'Email ',
                                          style: kHeadingFour.copyWith(
                                              color: Colors.black),
                                        ),
                                        SizedBox(
                                          height: 28,
                                        ),
                                        Text(
                                          'Address ',
                                          style: kHeadingFour.copyWith(
                                              color: Colors.black),
                                        ),
                                        SizedBox(
                                          height: 28,
                                        ),
                                        Text(
                                          'Position ',
                                          style: kHeadingFour.copyWith(
                                              color: Colors.black),
                                        ),
                                        SizedBox(
                                          height: 28,
                                        ),
                                        Text(
                                          'Skill ',
                                          style: kHeadingFour.copyWith(
                                              color: Colors.black),
                                        ),
                                        SizedBox(
                                          height: 28,
                                        ),
                                        Text(
                                          'Salary ',
                                          style: kHeadingFour.copyWith(
                                              color: Colors.black),
                                        ),
                                        SizedBox(
                                          height: 28,
                                        ),
                                        Text(
                                          'Role ',
                                          style: kHeadingFour.copyWith(
                                              color: Colors.black),
                                        ),
                                        SizedBox(
                                          height: 28,
                                        ),
                                        Text(
                                          'Status ',
                                          style: kHeadingFour.copyWith(
                                              color: Colors.black),
                                        ),
                                        SizedBox(
                                          height: 28,
                                        ),
                                        Text(
                                          'Work-Rate ',
                                          style: kHeadingFour.copyWith(
                                              color: Colors.black),
                                        ),
                                        SizedBox(
                                          height: 28,
                                        ),
                                        // Column(
                                        //   crossAxisAlignment:
                                        //       CrossAxisAlignment.start,
                                        //   children: [
                                        //     Text(
                                        //       'Address: ',
                                        //       style: kHeadingFour.copyWith(
                                        //           color: Colors.black),
                                        //     ),
                                        //     SizedBox(
                                        //       height: 15,
                                        //     ),
                                        //     Padding(
                                        //       padding:
                                        //           const EdgeInsets.only(left: 15),
                                        //       child: Text(
                                        //         (snapshot.data
                                        //             as dynamic)['address'],
                                        //         style: kParagraph,
                                        //       ),
                                        //     ),
                                        //   ],
                                        // ),
                                        // SizedBox(
                                        //   height: 28,
                                        // ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 25,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          (snapshot.data as dynamic)['name'],
                                          style: kParagraph,
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        Text(
                                          (snapshot.data as dynamic)['id']
                                              .toString(),
                                          style: kParagraph,
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        Text(
                                          (snapshot.data as dynamic)['email']
                                              .toString(),
                                          style: kParagraph,
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        Text(
                                          (snapshot.data as dynamic)['address']
                                              .toString(),
                                          style: kParagraph,
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        Text(
                                          (snapshot.data as dynamic)['position']
                                              .toString(),
                                          style: kParagraph,
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        Text(
                                          (snapshot.data as dynamic)['skill']
                                              .toString(),
                                          style: kParagraph,
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        Text(
                                          '\$${(snapshot.data as dynamic)['salary'].toString()}',
                                          style: kParagraph,
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        Text(
                                          (snapshot.data as dynamic)['role']
                                              .toString(),
                                          style: kParagraph,
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        Text(
                                          (snapshot.data as dynamic)['status']
                                              .toString(),
                                          style: kParagraph,
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        Text(
                                          (snapshot.data as dynamic)['rate']
                                              .toString(),
                                          style: kParagraph,
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Work-Background: ',
                                      style: kHeadingFour.copyWith(
                                          color: Colors.black),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 15),
                                      child: Text(
                                        (snapshot.data as dynamic)['background']
                                            .toString(),
                                        style: kParagraph,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            }
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Fetching Data'),
                  SizedBox(
                    height: 10,
                  ),
                  const CircularProgressIndicator(
                    color: kWhite,
                  ),
                ],
              ),
            );
          },
        ));
  }
}
