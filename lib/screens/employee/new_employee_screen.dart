import 'package:ems/screens/employee/employee_list_screen.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class NewEmployeeScreen extends StatelessWidget {
  const NewEmployeeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Employee'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ID ',
                      style: kParagraph.copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.6),
                      child: Flexible(
                        child: TextField(
                          decoration: InputDecoration(hintText: 'Enter ID'),
                          // controller: TextEditingController(
                          //     text: snapshot.data!.id.toString()),
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
                      style: kParagraph.copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.6),
                      child: Flexible(
                        child: TextField(
                          decoration: InputDecoration(hintText: 'Enter Name'),
                          // controller: TextEditingController(
                          //     text: snapshot.data!.name),
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
                      style: kParagraph.copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.6),
                      child: Flexible(
                        child: TextField(
                          decoration:
                              InputDecoration(hintText: 'Enter Phone Number'),
                          // controller: TextEditingController(
                          //     text: snapshot.data!.phone),
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
                      style: kParagraph.copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.6),
                      child: Flexible(
                        child: TextField(
                          decoration:
                              InputDecoration(hintText: 'Enter Email address'),
                          // controller: TextEditingController(
                          //     text: snapshot.data!.email),
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
                      style: kParagraph.copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.6),
                      child: Flexible(
                        child: TextField(
                          decoration:
                              InputDecoration(hintText: 'Enter Address'),
                          // controller: TextEditingController(
                          //     text: snapshot.data!.address),
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
                      style: kParagraph.copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.6),
                      child: Flexible(
                        child: TextField(
                          decoration:
                              InputDecoration(hintText: 'Enter Position'),
                          // controller: TextEditingController(
                          //     text: snapshot.data!.position),
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
                      style: kParagraph.copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.6),
                      child: Flexible(
                        child: TextField(
                          decoration: InputDecoration(hintText: 'Enter Skill'),
                          // controller: TextEditingController(
                          //     text: snapshot.data!.skill),
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
                      style: kParagraph.copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.6),
                      child: Flexible(
                        child: TextField(
                          decoration: InputDecoration(hintText: 'Enter Salary'),
                          // controller: TextEditingController(
                          //     text: snapshot.data!.salary.toString()),
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
                      style: kParagraph.copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.6),
                      child: Flexible(
                        child: TextField(
                          decoration:
                              InputDecoration(hintText: 'Enter Work-Rate'),
                          // controller: TextEditingController(
                          //     text: snapshot.data!.rate),
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
                      style: kParagraph.copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 1),
                      child: Flexible(
                        child: TextField(
                          decoration: InputDecoration(
                              hintText: 'Enter Employee background'),
                          // controller: TextEditingController(
                          //     text: snapshot.data!.background),
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
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                      title: Text('Are you sure?'),
                                      content: Text(
                                          'Do you want to add new employee?'),
                                      actions: [
                                        OutlineButton(
                                          borderSide:
                                              BorderSide(color: Colors.green),
                                          onPressed: () {},
                                          child: Text('Yes'),
                                        ),
                                        OutlineButton(
                                          borderSide:
                                              BorderSide(color: Colors.red),
                                          onPressed: () {},
                                          child: Text('No'),
                                        ),
                                      ],
                                    ));
                          },
                          child: Text('Save'),
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      RaisedButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => EmployeeListScreen(),
                            ),
                          );
                        },
                        child: Text('Cancel'),
                        color: Colors.red,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
