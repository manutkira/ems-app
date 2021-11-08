import 'dart:developer';

import 'package:ems/screens/employee/employee_list_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:ems/constants.dart';
import 'package:ems/screens/employee/employee_edit_screen.dart';
import 'package:ems/screens/employee/employee_info_screen.dart';
import 'package:flutter/material.dart';
import '../../models/m_user.dart';
import '../../utils/services/m_user.dart';

class EmployeeList extends StatefulWidget {
  @override
  State<EmployeeList> createState() => _EmployeeListState();
}

class _EmployeeListState extends State<EmployeeList> {
  final color = const Color(0xff05445E);
  final color1 = const Color(0xff3B9AAD);

  String url = "http://rest-api-laravel-flutter.herokuapp.com/api/users";

  Future deleteData(int id) async {
    final response = await http.delete(Uri.parse("$url/$id"));
    if (response.statusCode == 200) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => EmployeeListScreen()));
    } else {
      return false;
    }
  }

  Future fetchData(String text) async {
    final response = await http.get(Uri.parse(
        "http://rest-api-laravel-flutter.herokuapp.com/api/search?search=${text}"));
    if (response.statusCode == 200) {
      print('okey');
    } else {
      print('not okey');
    }
  }

  List<User> users = [];
  List<User> userDisplay = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPost().then((usersFromServer) {
      setState(() {
        _isLoading = false;
        users.addAll(usersFromServer);
        userDisplay = users;
        userDisplay.sort(
            (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
          itemCount: userDisplay.length + 1,
          itemBuilder: (context, index) {
            if (!_isLoading) {
              return index == 0 ? _searchBar() : _listItem(index - 1);
            } else {
              return Container(
                padding: EdgeInsets.only(top: 320),
                alignment: Alignment.center,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                ),
              );
            }
          }),
    );
    // FutureBuilder(
    //   future: FetchData(),
    //   builder: (context, AsyncSnapshot<dynamic> snapshot) {
    //     if (snapshot.hasData) {
    //       return Container(
    //         decoration: BoxDecoration(
    //             borderRadius: BorderRadius.only(
    //               topLeft: Radius.circular(20),
    //               topRight: Radius.circular(20),
    //             ),
    //             gradient: LinearGradient(
    //               colors: [
    //                 color1,
    //                 color,
    //               ],
    //               begin: Alignment.topCenter,
    //               end: Alignment.bottomCenter,
    //             )),
    //         child: ListView.builder(
    //           shrinkWrap: true,
    //           scrollDirection: Axis.vertical,
    //           itemBuilder: (context, index) {
    //             return Container(
    //               width: double.infinity,
    //               padding: EdgeInsets.only(bottom: 20),
    //               margin: EdgeInsets.all(20),
    //               decoration: BoxDecoration(
    //                   border: Border(
    //                       bottom: BorderSide(color: Colors.black, width: 2))),
    //               child: Container(
    //                 width: double.infinity,
    //                 child: Row(
    //                   // mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                   children: [
    //                     Container(
    //                       child: Image.asset(
    //                         'assets/images/profile-icon-png-910.png',
    //                         width: 85,
    //                       ),
    //                     ),
    //                     SizedBox(
    //                       width: 10,
    //                     ),
    //                     Container(
    //                       width: 240,
    //                       child: Row(
    //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                         children: [
    //                           Column(
    //                             crossAxisAlignment: CrossAxisAlignment.start,
    //                             children: [
    //                               Row(
    //                                 children: [
    //                                   Text('Name: '),
    //                                   Text(
    //                                     (snapshot.data as dynamic)[index]
    //                                         ['name'],
    //                                   ),
    //                                 ],
    //                               ),
    //                               Row(
    //                                 children: [
    //                                   Text('ID: '),
    //                                   Text((snapshot.data as dynamic)[index]
    //                                           ['id']
    //                                       .toString()),
    //                                 ],
    //                               )
    //                             ],
    //                           ),
    //                           // SizedBox(
    //                           //   width: 50,
    //                           // ),
    //                           PopupMenuButton(
    //                             onSelected: (int selectedValue) {
    //                               if (selectedValue == 1) {
    //                                 print('clicked 1');
    //                                 int id =
    //                                     (snapshot.data as dynamic)[index]['id'];
    //                                 String name = (snapshot.data
    //                                     as dynamic)[index]['name'];
    //                                 String phone = (snapshot.data
    //                                     as dynamic)[index]['phone'];
    //                                 String email = (snapshot.data
    //                                         as dynamic)[index]['email']
    //                                     .toString();
    //                                 String address = (snapshot.data
    //                                         as dynamic)[index]['address']
    //                                     .toString();
    //                                 String position = (snapshot.data
    //                                         as dynamic)[index]['position']
    //                                     .toString();
    //                                 String skill = (snapshot.data
    //                                         as dynamic)[index]['skill']
    //                                     .toString();
    //                                 String salary = (snapshot.data
    //                                         as dynamic)[index]['salary']
    //                                     .toString();
    //                                 String role = (snapshot.data
    //                                         as dynamic)[index]['role']
    //                                     .toString();
    //                                 String status = (snapshot.data
    //                                         as dynamic)[index]['status']
    //                                     .toString();
    //                                 String rate = (snapshot.data
    //                                         as dynamic)[index]['rate']
    //                                     .toString();
    //                                 String background = (snapshot.data
    //                                         as dynamic)[index]['background']
    //                                     .toString();
    //                                 Navigator.of(context).pushReplacement(
    //                                     MaterialPageRoute(
    //                                         builder: (_) => EmployeeEditScreen(
    //                                             id,
    //                                             name,
    //                                             phone,
    //                                             email,
    //                                             address,
    //                                             position,
    //                                             skill,
    //                                             salary,
    //                                             role,
    //                                             status,
    //                                             rate,
    //                                             background)));
    //                               }
    //                               if (selectedValue == 0) {
    //                                 Navigator.of(context).pushNamed(
    //                                   EmployeeInfoScreen.routeName,
    //                                   arguments: (snapshot.data
    //                                       as dynamic)[index]['id'],
    //                                 );
    //                               }
    //                             },
    //                             itemBuilder: (_) => [
    //                               PopupMenuItem(
    //                                 child: Text('Info'),
    //                                 value: 0,
    //                               ),
    //                               PopupMenuItem(
    //                                 child: Text('Edit'),
    //                                 value: 1,
    //                               ),
    //                             ],
    //                             icon: Icon(Icons.more_vert),
    //                           )
    //                         ],
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             );
    //           },
    //           itemCount: (snapshot.data as dynamic).length,
    //         ),
    //       );
    //     } else {
    //       if (snapshot.hasError) {
    //         print(snapshot.error);
    //       }
    //       return Center(
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             Text('Fetching Data'),
    //             SizedBox(
    //               height: 10,
    //             ),
    //             const CircularProgressIndicator(
    //               color: kWhite,
    //             ),
    //           ],
    //         ),
    //       );
    //     }
    //   },
    // );
  }

  _searchBar() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: TextField(
        decoration: InputDecoration(
          suffixIcon: Icon(
            Icons.search,
            color: Colors.white,
          ),
          hintText: 'Search...',
          errorStyle: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        onChanged: (text) {
          text = text.toLowerCase();
          setState(() {
            // fetchData(text);
            userDisplay = users.where((user) {
              var userName = user.name.toLowerCase();
              return userName.contains(text);
            }).toList();
          });
        },
      ),
    );
  }

  _listItem(index) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(bottom: 20),
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black, width: 2))),
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
                            userDisplay[index].name,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text('ID: '),
                          Text(userDisplay[index].id.toString()),
                        ],
                      )
                    ],
                  ),
                  // SizedBox(
                  //   width: 50,
                  // ),
                  PopupMenuButton(
                    color: kDarkestBlue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    onSelected: (int selectedValue) {
                      if (selectedValue == 1) {
                        int id = userDisplay[index].id;
                        String name = userDisplay[index].name;
                        String phone = userDisplay[index].phone;
                        String email = userDisplay[index].email.toString();
                        String address = userDisplay[index].address.toString();
                        String position =
                            userDisplay[index].position.toString();
                        String skill = userDisplay[index].skill.toString();
                        String salary = userDisplay[index].salary.toString();
                        String role = userDisplay[index].role.toString();
                        String status = userDisplay[index].status.toString();
                        String rate = userDisplay[index].rate.toString();
                        String background =
                            userDisplay[index].background.toString();
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
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
                          arguments: userDisplay[index].id,
                        );
                      }
                      if (selectedValue == 2) {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text('Are you sure?'),
                            content: Text('This action cannot be undone!'),
                            actions: [
                              OutlineButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  deleteData(userDisplay[index].id);
                                },
                                child: Text('Yes'),
                                borderSide: BorderSide(color: Colors.green),
                              ),
                              OutlineButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                borderSide: BorderSide(color: Colors.red),
                                child: Text('No'),
                              )
                            ],
                          ),
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
  }
}
