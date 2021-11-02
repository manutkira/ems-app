import 'package:ems/constants.dart';
import 'package:ems/models/user.dart';
import 'package:ems/utils/services/users.dart';
import 'package:flutter/material.dart';

class EmployeeEditScreen extends StatelessWidget {
  const EmployeeEditScreen({Key? key}) : super(key: key);

  static const routeName = '/employee-edit';

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
              return SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // SizedBox(
                          //   width: 10,
                          // ),
                          Text(
                            'ID ',
                            style: kParagraph.copyWith(
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.6),
                            child: Flexible(
                              child: TextField(
                                controller: TextEditingController(
                                    text: snapshot.data!.id.toString()),
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
                            style: kParagraph.copyWith(
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.6),
                            child: Flexible(
                              child: TextField(
                                controller: TextEditingController(
                                    text: snapshot.data!.name),
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
                            style: kParagraph.copyWith(
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.6),
                            child: Flexible(
                              child: TextField(
                                controller: TextEditingController(
                                    text: snapshot.data!.phone),
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
                            style: kParagraph.copyWith(
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.6),
                            child: Flexible(
                              child: TextField(
                                controller: TextEditingController(
                                    text: snapshot.data!.email),
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
                            style: kParagraph.copyWith(
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.6),
                            child: Flexible(
                              child: TextField(
                                controller: TextEditingController(
                                    text: snapshot.data!.address),
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
                            style: kParagraph.copyWith(
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.6),
                            child: Flexible(
                              child: TextField(
                                controller: TextEditingController(
                                    text: snapshot.data!.position),
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
                            style: kParagraph.copyWith(
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.6),
                            child: Flexible(
                              child: TextField(
                                controller: TextEditingController(
                                    text: snapshot.data!.skill),
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
                            style: kParagraph.copyWith(
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.6),
                            child: Flexible(
                              child: TextField(
                                controller: TextEditingController(
                                    text: snapshot.data!.salary.toString()),
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
                            style: kParagraph.copyWith(
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.6),
                            child: Flexible(
                              child: TextField(
                                controller: TextEditingController(
                                    text: snapshot.data!.rate),
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
                            style: kParagraph.copyWith(
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 1),
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
                                onPressed: () {},
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
          }),
    );
  }
}
