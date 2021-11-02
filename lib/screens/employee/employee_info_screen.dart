import 'package:ems/models/user.dart';
import 'package:ems/utils/services/users.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class EmployeeInfoScreen extends StatelessWidget {
  const EmployeeInfoScreen({Key? key}) : super(key: key);
  static const routeName = '/employee-infomation';
  @override
  Widget build(BuildContext context) {
    final employeeId = ModalRoute.of(context)!.settings.arguments as int;
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
                                        width: 85,
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
                                        width: 50,
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
