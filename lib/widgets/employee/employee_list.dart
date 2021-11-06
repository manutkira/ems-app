import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ems/constants.dart';
import 'package:ems/models/user.dart';
import 'package:ems/screens/employee/employee_edit_screen.dart';
import 'package:ems/screens/employee/employee_info_screen.dart';
import 'package:ems/utils/services/users.dart';
import 'package:flutter/material.dart';

class EmployeeList extends StatefulWidget {
  @override
  State<EmployeeList> createState() => _EmployeeListState();
}

class _EmployeeListState extends State<EmployeeList> {
  final color = const Color(0xff05445E);
  final color1 = const Color(0xff3B9AAD);

  String url = "http://rest-api-laravel-flutter.herokuapp.com/api/users";

  Future FetchData() async {
    final response = await http.get(Uri.parse(url));

    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FetchData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
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
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(bottom: 20),
                  margin: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.black, width: 2))),
                  child: Container(
                    width: double.infinity,
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Image.asset(
                            'assets/images/profile-icon-png-910.png',
                            width: 85,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: 240,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text('Name: '),
                                      Text(
                                        (snapshot.data as dynamic)[index]
                                            ['name'],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text('ID: '),
                                      Text((snapshot.data as dynamic)[index]
                                              ['id']
                                          .toString()),
                                    ],
                                  )
                                ],
                              ),
                              // SizedBox(
                              //   width: 50,
                              // ),
                              PopupMenuButton(
                                onSelected: (int selectedValue) {
                                  if (selectedValue == 1) {
                                    print('clicked 1');
                                    int id =
                                        (snapshot.data as dynamic)[index]['id'];
                                    String name = (snapshot.data
                                        as dynamic)[index]['name'];
                                    String phone = (snapshot.data
                                        as dynamic)[index]['phone'];
                                    String email = (snapshot.data
                                            as dynamic)[index]['email']
                                        .toString();
                                    String address = (snapshot.data
                                            as dynamic)[index]['address']
                                        .toString();
                                    String position = (snapshot.data
                                            as dynamic)[index]['position']
                                        .toString();
                                    String skill = (snapshot.data
                                            as dynamic)[index]['skill']
                                        .toString();
                                    String salary = (snapshot.data
                                            as dynamic)[index]['salary']
                                        .toString();
                                    String role = (snapshot.data
                                            as dynamic)[index]['role']
                                        .toString();
                                    String status = (snapshot.data
                                            as dynamic)[index]['status']
                                        .toString();
                                    String rate = (snapshot.data
                                            as dynamic)[index]['rate']
                                        .toString();
                                    String background = (snapshot.data
                                            as dynamic)[index]['background']
                                        .toString();
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (_) => EmployeeEditScreen(
                                                id,
                                                name,
                                                phone,
                                                email,
                                                address,
                                                position,
                                                skill,
                                                salary,
                                                role,
                                                status,
                                                rate,
                                                background)));
                                  }
                                  if (selectedValue == 0) {
                                    Navigator.of(context).pushNamed(
                                      EmployeeInfoScreen.routeName,
                                      arguments: (snapshot.data
                                          as dynamic)[index]['id'],
                                    );
                                  }
                                },
                                itemBuilder: (_) => [
                                  PopupMenuItem(
                                    child: Text('Info'),
                                    value: 0,
                                  ),
                                  PopupMenuItem(
                                    child: Text('Edit'),
                                    value: 1,
                                  ),
                                  PopupMenuItem(
                                    child: Text('Delete'),
                                    value: 2,
                                  ),
                                ],
                                icon: Icon(Icons.more_vert),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: (snapshot.data as dynamic).length,
            ),
          );
        } else {
          if (snapshot.hasError) {
            print(snapshot.error);
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
        }
      },
    );
  }
}

// void onSelected(BuildContext context, int item) {
//   switch (item) {
//     case 0:
//       break;
//     case 1:
//       Navigator.of(context)
//           .pushNamed(EmployeeEditScreen.routeName, arguments: snap);
//       break;
//     case 2:
//       break;
//   }
// }
