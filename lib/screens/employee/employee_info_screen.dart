import 'package:ems/models/user.dart';
import 'package:ems/utils/services/users.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class EmployeeInfoScreen extends StatelessWidget {
  const EmployeeInfoScreen({Key? key}) : super(key: key);
  static const routeName = '/employee-infomation';
  @override
  Widget build(BuildContext context) {
    final color = const Color(0xff05445E);

    final color1 = const Color(0xff3B9AAD);
    final employeeId = ModalRoute.of(context)!.settings.arguments as int;
    print(employeeId);
    return Scaffold(
        appBar: AppBar(
          title: Text('Employee'),
        ),
        body: FutureBuilder<User>(
          future: UserService().getUser(employeeId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 10, left: 20, right: 20),
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
                            margin: EdgeInsets.only(left: 30),
                            child: Expanded(
                              flex: 7,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'ID: ',
                                        style: kHeadingThree.copyWith(
                                            color: Colors.black),
                                      ),
                                      SizedBox(
                                        width: 65,
                                      ),
                                      Text(
                                        snapshot.data!.id.toString(),
                                        style: kHeadingThree.copyWith(
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Name: ',
                                        style: kHeadingThree.copyWith(
                                            color: Colors.black),
                                      ),
                                      SizedBox(
                                        width: 30,
                                      ),
                                      Text(
                                        snapshot.data!.name,
                                        style: kHeadingThree.copyWith(
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
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Name: ',
                                    style: kHeadingFour.copyWith(
                                        color: Colors.black),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    'ID: ',
                                    style: kHeadingFour.copyWith(
                                        color: Colors.black),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    'Skill: ',
                                    style: kHeadingFour.copyWith(
                                        color: Colors.black),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    'Salary: ',
                                    style: kHeadingFour.copyWith(
                                        color: Colors.black),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    'Work-Quality: ',
                                    style: kHeadingFour.copyWith(
                                        color: Colors.black),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    'Phone: ',
                                    style: kHeadingFour.copyWith(
                                        color: Colors.black),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    'Email: ',
                                    style: kHeadingFour.copyWith(
                                        color: Colors.black),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    'Address: ',
                                    style: kHeadingFour.copyWith(
                                        color: Colors.black),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    'Position: ',
                                    style: kHeadingFour.copyWith(
                                        color: Colors.black),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        'Work-Background: ',
                                        style: kHeadingFour.copyWith(
                                            color: Colors.black),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        snapshot.data!.background.toString(),
                                        style: kParagraph,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    snapshot.data!.name,
                                    style: kParagraph,
                                  ),
                                  SizedBox(
                                    height: 22,
                                  ),
                                  Text(
                                    snapshot.data!.id.toString(),
                                    style: kParagraph,
                                  ),
                                  SizedBox(
                                    height: 22,
                                  ),
                                  Text(
                                    snapshot.data!.skill as String,
                                    style: kParagraph.copyWith(fontSize: 12),
                                  ),
                                  SizedBox(
                                    height: 22,
                                  ),
                                  Text(
                                    '\$${snapshot.data!.salary.toString()}',
                                    style: kParagraph,
                                  ),
                                  SizedBox(
                                    height: 22,
                                  ),
                                  Text(
                                    snapshot.data!.rate as String,
                                    style: kParagraph,
                                  ),
                                  SizedBox(
                                    height: 22,
                                  ),
                                  Text(
                                    snapshot.data!.phone as String,
                                    style: kParagraph,
                                  ),
                                  SizedBox(
                                    height: 22,
                                  ),
                                  Text(
                                    snapshot.data!.email as String,
                                    style: kParagraph.copyWith(fontSize: 12),
                                  ),
                                  SizedBox(
                                    height: 22,
                                  ),
                                  Text(
                                    snapshot.data!.address.toString(),
                                    style: kParagraph,
                                  ),
                                  SizedBox(
                                    height: 22,
                                  ),
                                  Text(
                                    snapshot.data!.position as String,
                                    style: kParagraph,
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
              );
            }
            return const CircularProgressIndicator(
              color: kWhite,
            );
          },
        ));
  }
}
