import 'package:ems/screens/card/card.screen.dart';
import 'package:ems/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);
    final color = const Color(0xff05445E);
    final color1 = const Color(0xff3982A0);
    return Scaffold(
        appBar: AppBar(
          title: Text('Employee'),
        ),
        body: FutureBuilder(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${local?.fetchData}'),
                    const CircularProgressIndicator(
                      color: kWhite,
                    ),
                  ],
                ),
              );
            } else {
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
                                child: Container(
                                  width: 85,
                                  height: 85,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(100)),
                                      border: Border.all(
                                        width: 1,
                                        color: Colors.white,
                                      )),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(150),
                                    child: (snapshot.data
                                                as dynamic)['image'] ==
                                            null
                                        ? Image.asset(
                                            'assets/images/profile-icon-png-910.png')
                                        : Image.network(
                                            (snapshot.data as dynamic)['image'],
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: 75,
                                          ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 65,
                              margin: EdgeInsets.only(left: 15, top: 13),
                              child: Expanded(
                                flex: 7,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          '${local?.id} : ',
                                          style: kParagraph.copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          width: isEnglish ? 45 : 20,
                                        ),
                                        Text(
                                          (snapshot.data as dynamic)['id']
                                              .toString(),
                                          style: kParagraph.copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(
                                              top: isEnglish ? 3 : 00),
                                          child: Text(
                                            '${local?.name} : ',
                                            style: kParagraph.copyWith(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: isEnglish ? 4 : 0),
                                          child: Text(
                                            (snapshot.data as dynamic)['name'],
                                            style: kParagraph.copyWith(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
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
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                              onTap: () {
                                int id =
                                    (snapshot.data as dynamic)['id'] as int;
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (ctx) => NationalIdScreen(
                                      id: id.toString(),
                                    ),
                                  ),
                                );
                              },
                              child: Text('view')),
                          IconButton(
                              onPressed: () {
                                int id =
                                    (snapshot.data as dynamic)['id'] as int;
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (ctx) => NationalIdScreen(
                                      id: id.toString(),
                                    ),
                                  ),
                                );
                              },
                              icon: Icon(Icons.credit_card)),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 0),
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
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 26),
                                          child: Text(
                                            'ID ',
                                            style: kParagraph.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          child: Text(
                                            'Email ',
                                            style: kParagraph.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          child: Text(
                                            'Position ',
                                            style: kParagraph.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          child: Text(
                                            'Skill ',
                                            style: kParagraph.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          child: Text(
                                            'Salary ',
                                            style: kParagraph.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          child: Text(
                                            'Role ',
                                            style: kParagraph.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          child: Text(
                                            'Status ',
                                            style: kParagraph.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          child: Text(
                                            'Work-Rate ',
                                            style: kParagraph.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          child: Text(
                                            'Phone ',
                                            style: kParagraph.copyWith(
                                                color: Colors.white,
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
                                                  top: 10, left: 55),
                                              child: Text(
                                                (snapshot.data
                                                    as dynamic)['name'],
                                                style: kParagraph.copyWith(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20, left: 55),
                                            child: Text(
                                              (snapshot.data as dynamic)['id']
                                                  .toString(),
                                              style: kParagraph.copyWith(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20, left: 55, bottom: 8),
                                            child: Text(
                                              (snapshot.data
                                                      as dynamic)['email']
                                                  .toString(),
                                              style: kParagraph.copyWith(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 35,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                top: 11,
                                                left: 55,
                                              ),
                                              child: Text(
                                                (snapshot.data
                                                        as dynamic)['position']
                                                    .toString(),
                                                style: kParagraph.copyWith(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 35,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 15, left: 55),
                                              child: Text(
                                                (snapshot.data
                                                        as dynamic)['skill']
                                                    .toString(),
                                                style: kParagraph.copyWith(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20, left: 55),
                                            child: Text(
                                              '\$${(snapshot.data as dynamic)['salary'].toString()}',
                                              style: kParagraph.copyWith(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20, left: 55),
                                            child: Text(
                                              (snapshot.data as dynamic)['role']
                                                  .toString(),
                                              style: kParagraph.copyWith(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20, left: 55),
                                            child: Text(
                                              (snapshot.data
                                                      as dynamic)['status']
                                                  .toString(),
                                              style: kParagraph.copyWith(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20, left: 55),
                                            child: Text(
                                              (snapshot.data as dynamic)['rate']
                                                  .toString(),
                                              style: kParagraph.copyWith(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 25, left: 55),
                                            child: Text(
                                              (snapshot.data
                                                      as dynamic)['phone']
                                                  .toString(),
                                              style: kParagraph.copyWith(
                                                color: Colors.white,
                                              ),
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
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
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
                                            style: kParagraph.copyWith(
                                              color: Colors.white,
                                            ),
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
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
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
                                          style: kParagraph.copyWith(
                                            color: Colors.white,
                                          ),
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
          },
        ));
  }
}
