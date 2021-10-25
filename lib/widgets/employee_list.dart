import 'package:ems/widgets/employee_info.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/employee.dart';

class EmployeeList extends StatelessWidget {
  final List<Employee> employees;

  EmployeeList(this.employees);
  final color = const Color(0xff05445E);
  final color1 = const Color(0xff3B9AAD);
  void selectEmployee(BuildContext context, id) {
    var empId = employees.where((employee) => employee.id == id).toList();
    Navigator.of(context).pushNamed(EmployeeInfo.routeName, arguments: {
      'id': empId[0].id,
      'name': empId[0].name,
    });
  }

  @override
  Widget build(BuildContext context) {
    return employees.isEmpty
        ? LayoutBuilder(builder: (builder, constriants) {
            return Column(
              children: [
                Text(
                  'No Employee added yet!',
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: constriants.maxHeight * 0.6,
                  margin: EdgeInsets.only(
                    top: 20,
                  ),
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            );
          })
        : Container(
            margin: EdgeInsets.only(top: 130),
            child: Card(
              color: color,
              elevation: 15,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    gradient: LinearGradient(
                      colors: [
                        color1,
                        Colors.blue,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    )),
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(
                        right: 20,
                        left: 20,
                        top: 15,
                      ),
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(width: 2))),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: InkWell(
                              onTap: () =>
                                  selectEmployee(context, employees[index].id),
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 15,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: color,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                padding: EdgeInsets.all(8),
                                child: (Image.asset(
                                    'assets/images/profile-icon-png-910.png')),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 7,
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Name: ' + employees[index].name,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'ID: ' + employees[index].id,
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            child: IconButton(
                              icon: Icon(Icons.more_vert),
                              onPressed: () {},
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    );
                  },
                  itemCount: employees.length,
                ),
              ),
            ),
          );
  }
}
