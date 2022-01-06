import 'package:ems/screens/card/card.screen.dart';
import 'package:ems/utils/utils.dart';
import 'package:ems/widgets/baseline_row.dart';
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
                    margin: EdgeInsets.only(top: 40),
                    padding: EdgeInsets.all(30),
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                      color: kDarkestBlue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 75,
                          height: 75,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100)),
                              border: Border.all(
                                width: 1,
                                color: Colors.white,
                              )),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(150),
                            child: (snapshot.data as dynamic)['image'] == null
                                ? Image.asset(
                                    'assets/images/profile-icon-png-910.png',
                                    width: 70,
                                  )
                                : Image.network(
                                    (snapshot.data as dynamic)['image'],
                                    height: 70,
                                  ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BaselineRow(
                              children: [
                                Text(
                                  '${local?.name} : ',
                                  style: kParagraph.copyWith(
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text((snapshot.data as dynamic)['name']
                                    .toString()),
                              ],
                            ),
                            BaselineRow(
                              children: [
                                Text(
                                  '${local?.id} : ',
                                  style: kParagraph.copyWith(
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text((snapshot.data as dynamic)['id']
                                    .toString()),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // SizedBox(
                  //   height: 30,
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                            onTap: () {
                              int id = (snapshot.data as dynamic)['id'] as int;
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) => NationalIdScreen(
                                    id: id.toString(),
                                  ),
                                ),
                              );
                            },
                            child: Text('${local?.optionView}')),
                        IconButton(
                            onPressed: () {
                              int id = (snapshot.data as dynamic)['id'] as int;
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
                              BaselineRow(
                                children: [
                                  Text(
                                    '${local?.name} ',
                                    style: kParagraph.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: isEnglish ? 80 : 90,
                                  ),
                                  Text(
                                    (snapshot.data as dynamic)['name'],
                                    style: kParagraph.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: isEnglish ? 20 : 10,
                              ),
                              BaselineRow(
                                children: [
                                  Text(
                                    '${local?.id} ',
                                    style: kParagraph.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: isEnglish ? 110 : 80,
                                  ),
                                  Text(
                                    (snapshot.data as dynamic)['id'].toString(),
                                    style: kParagraph.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: isEnglish ? 20 : 10,
                              ),
                              BaselineRow(
                                children: [
                                  Text(
                                    '${local?.email} ',
                                    style: kParagraph.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: isEnglish ? 85 : 90,
                                  ),
                                  Text(
                                    (snapshot.data as dynamic)['email']
                                        .toString(),
                                    style: kParagraph.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: isEnglish ? 20 : 10,
                              ),
                              BaselineRow(
                                children: [
                                  Text(
                                    '${local?.position} ',
                                    style: kParagraph.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: isEnglish ? 65 : 85,
                                  ),
                                  Text(
                                    (snapshot.data as dynamic)['position']
                                        .toString(),
                                    style: kParagraph.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: isEnglish ? 20 : 10,
                              ),
                              BaselineRow(
                                children: [
                                  Text(
                                    '${local?.skill} ',
                                    style: kParagraph.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: isEnglish ? 95 : 92,
                                  ),
                                  Text(
                                    (snapshot.data as dynamic)['skill']
                                        .toString(),
                                    style: kParagraph.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: isEnglish ? 20 : 10,
                              ),
                              BaselineRow(
                                children: [
                                  Text(
                                    '${local?.salary} ',
                                    style: kParagraph.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: isEnglish ? 78 : 85,
                                  ),
                                  Text(
                                    '\$${(snapshot.data as dynamic)['salary'].toString()}',
                                    style: kParagraph.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: isEnglish ? 20 : 10,
                              ),
                              BaselineRow(
                                children: [
                                  Text(
                                    '${local?.role} ',
                                    style: kParagraph.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: isEnglish ? 95 : 99,
                                  ),
                                  Text(
                                    (snapshot.data as dynamic)['role']
                                        .toString(),
                                    style: kParagraph.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: isEnglish ? 20 : 10,
                              ),
                              BaselineRow(
                                children: [
                                  Text(
                                    '${local?.status} ',
                                    style: kParagraph.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: isEnglish ? 78 : 78,
                                  ),
                                  Text(
                                    (snapshot.data as dynamic)['status']
                                        .toString(),
                                    style: kParagraph.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: isEnglish ? 20 : 10,
                              ),
                              BaselineRow(
                                children: [
                                  Text(
                                    '${local?.rate} ',
                                    style: kParagraph.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: isEnglish ? 93 : 77,
                                  ),
                                  Text(
                                    (snapshot.data as dynamic)['rate']
                                        .toString(),
                                    style: kParagraph.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: isEnglish ? 20 : 10,
                              ),
                              BaselineRow(
                                children: [
                                  Text(
                                    '${local?.phoneNumber} ',
                                    style: kParagraph.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: isEnglish ? 80 : 63,
                                  ),
                                  Text(
                                    (snapshot.data as dynamic)['phone']
                                        .toString(),
                                    style: kParagraph.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${local?.address} ',
                                      style: kParagraph.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                      height: 35,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 15,
                                        ),
                                        child: Text(
                                          (snapshot.data as dynamic)['address']
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${local?.background}: ',
                                      style: kParagraph.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 15),
                                      child: Text(
                                        (snapshot.data as dynamic)['background']
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
      ),
    );
  }
}
