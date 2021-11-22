import 'package:ems/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../constants.dart';

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
    final color1 = const Color(0xff3982A0);
    return Scaffold(
        appBar: AppBar(
          title: Text('Employee'),
        ),
        body: FutureBuilder(
          future: fetchData(),
          builder: (context, snapshot) {
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
                              margin: EdgeInsets.only(
                                left: 10,
                              ),
                              child: Expanded(
                                flex: 3,
                                child: Image.asset(
                                  'assets/images/profile-icon-png-910.png',
                                  width: 80,
                                ),
                              ),
                            ),
                            Container(
                              height: 55,
                              margin: EdgeInsets.only(left: 15, top: 13),
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
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(top: 3),
                                          child: Text(
                                            'Name: ',
                                            style: kParagraph.copyWith(
                                                color: Colors.black),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4),
                                          child: Text(
                                            (snapshot.data as dynamic)['name'],
                                            style: kParagraph.copyWith(
                                                color: Colors.black),
                                          ),
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
                      margin: EdgeInsets.only(top: 28),
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
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 11),
                                          child: Text(
                                            'Name ',
                                            style: kParagraph.copyWith(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 26),
                                          child: Text(
                                            'ID ',
                                            style: kParagraph.copyWith(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          child: Text(
                                            'Email ',
                                            style: kParagraph.copyWith(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          child: Text(
                                            'Position ',
                                            style: kParagraph.copyWith(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          child: Text(
                                            'Skill ',
                                            style: kParagraph.copyWith(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          child: Text(
                                            'Salary ',
                                            style: kParagraph.copyWith(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          child: Text(
                                            'Role ',
                                            style: kParagraph.copyWith(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          child: Text(
                                            'Status ',
                                            style: kParagraph.copyWith(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          child: Text(
                                            'Work-Rate ',
                                            style: kParagraph.copyWith(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                      ],
                                    ),
                                    Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 34,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10, left: 30),
                                              child: Text(
                                                (snapshot.data
                                                    as dynamic)['name'],
                                                style: kParagraph,
                                              ),
                                            ),
                                          ),
                                          // SizedBox(
                                          //   height: 14,
                                          // ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20, left: 30),
                                            child: Text(
                                              (snapshot.data as dynamic)['id']
                                                  .toString(),
                                              style: kParagraph,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20, left: 30, bottom: 8),
                                            child: Text(
                                              (snapshot.data
                                                      as dynamic)['email']
                                                  .toString(),
                                              style: kParagraph,
                                            ),
                                          ),
                                          Container(
                                            height: 35,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                top: 11,
                                                left: 30,
                                              ),
                                              child: Text(
                                                (snapshot.data
                                                        as dynamic)['position']
                                                    .toString(),
                                                style: kParagraph,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 35,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 15, left: 30),
                                              child: Text(
                                                (snapshot.data
                                                        as dynamic)['skill']
                                                    .toString(),
                                                style: kParagraph,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20, left: 30),
                                            child: Text(
                                              '\$${(snapshot.data as dynamic)['salary'].toString()}',
                                              style: kParagraph,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20, left: 30),
                                            child: Text(
                                              (snapshot.data as dynamic)['role']
                                                  .toString(),
                                              style: kParagraph,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20, left: 30),
                                            child: Text(
                                              (snapshot.data
                                                      as dynamic)['status']
                                                  .toString(),
                                              style: kParagraph,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20, left: 30),
                                            child: Text(
                                              (snapshot.data as dynamic)['rate']
                                                  .toString(),
                                              style: kParagraph,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Address ',
                                        style: kParagraph.copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Container(
                                        height: 35,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            left: 15,
                                          ),
                                          child: Text(
                                            (snapshot.data
                                                    as dynamic)['address']
                                                .toString(),
                                            style: kParagraph,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Work-Background: ',
                                        style: kParagraph.copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 15),
                                        child: Text(
                                          (snapshot.data
                                                  as dynamic)['background']
                                              .toString(),
                                          style: kParagraph,
                                        ),
                                      ),
                                    ],
                                  ),
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
