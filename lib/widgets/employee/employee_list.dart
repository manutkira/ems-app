import 'package:ems/constants.dart';
import 'package:ems/models/user.dart';
import 'package:ems/screens/employee/employee_edit_screen.dart';
import 'package:ems/screens/employee/employee_info_screen.dart';
import 'package:ems/utils/services/users.dart';
import 'package:flutter/material.dart';

class EmployeeList extends StatelessWidget {
  const EmployeeList({Key? key}) : super(key: key);
  final color = const Color(0xff05445E);

  final color1 = const Color(0xff3B9AAD);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<User>>(
      future: UserService().getAllUsers(),
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
                  padding: EdgeInsets.only(bottom: 20),
                  margin: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.black, width: 2))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'assets/images/profile-icon-png-910.png',
                        width: 85,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('Name: '),
                              Text(
                                snapshot.data![index].name,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text('ID: '),
                              Text(
                                snapshot.data![index].id.toString(),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      PopupMenuButton(
                        onSelected: (int selectedValue) {
                          if (selectedValue == 1) {
                            Navigator.of(context).pushNamed(
                                EmployeeEditScreen.routeName,
                                arguments: snapshot.data![index].id);
                          }
                          if (selectedValue == 0) {
                            Navigator.of(context).pushNamed(
                                EmployeeInfoScreen.routeName,
                                arguments: snapshot.data![index].id);
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
                );
              },
              itemCount: snapshot.data!.length,
            ),
          );
        } else {
          if (snapshot.hasError) {
            print(snapshot.error);
          }
          return const CircularProgressIndicator(
            color: kWhite,
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
