import 'package:flutter/material.dart';

import '../dummy_data.dart';
import '../models/employee.dart';
import '../constants.dart';
import '../screens/edit_employee.dart';

class IndiEmployee extends StatelessWidget {
  final color = const Color(0xff05445E);
  final color1 = const Color(0xff3B9AAD);
  final String name;
  final String id;
  final String date;
  final String skill;
  final String workRate;
  final int contact;
  final String background;

  IndiEmployee({
    required this.name,
    required this.id,
    required this.date,
    required this.skill,
    required this.workRate,
    required this.contact,
    required this.background,
  });

  void editEmployee(BuildContext context) {
    Navigator.of(context).pushNamed(
      EditEmployeeScreen.routeName,
      arguments: id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
            color: Colors.white,
            onPressed: () => editEmployee(context),
            icon: Icon(Icons.edit)),
        Container(
          margin: EdgeInsets.only(top: 10, left: 20, right: 20),
          height: 139,
          width: double.infinity,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                              style:
                                  kHeadingThree.copyWith(color: Colors.black),
                            ),
                            SizedBox(
                              width: 85,
                            ),
                            Text(
                              id,
                              style:
                                  kHeadingThree.copyWith(color: Colors.black),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Name: ',
                              style:
                                  kHeadingThree.copyWith(color: Colors.black),
                            ),
                            SizedBox(
                              width: 50,
                            ),
                            Text(
                              name,
                              style:
                                  kHeadingThree.copyWith(color: Colors.black),
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
                margin: EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Name: ',
                            style: kHeadingFour.copyWith(color: Colors.black),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10, bottom: 15),
                            child: Text(
                              name,
                              style: kParagraph,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ID: ',
                            style: kHeadingFour.copyWith(color: Colors.black),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10, bottom: 15),
                            child: Text(
                              id,
                              style: kParagraph,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Date of Birth: ',
                            style: kHeadingFour.copyWith(color: Colors.black),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10, bottom: 15),
                            child: Text(
                              date,
                              style: kParagraph,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Skill: ',
                            style: kHeadingFour.copyWith(color: Colors.black),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10, bottom: 15),
                            child: Text(
                              skill,
                              style: kParagraph,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Work-Quality: ',
                            style: kHeadingFour.copyWith(color: Colors.black),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10, bottom: 15),
                            child: Text(
                              workRate,
                              style: kParagraph,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Work-Background: ',
                            style: kHeadingFour.copyWith(color: Colors.black),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10, bottom: 15),
                            child: Text(
                              background,
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
    );
  }
}
