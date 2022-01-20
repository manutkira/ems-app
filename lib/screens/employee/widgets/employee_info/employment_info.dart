import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:ems/models/user.dart';
import 'package:ems/utils/utils.dart';
import 'package:ems/widgets/baseline_row.dart';

import '../../../../constants.dart';
import '../../employee_edit_employment.dart';

class EmploymentInfo extends StatelessWidget {
  List<User> userDisplay;
  List<User> user;
  List rateDisplay;
  List rateList;
  final Function fetchUserById;
  final Function checkRole;
  final Function checkSatus;
  final Function checkRate;
  final Function addRateList;
  final Function deleteRateItem;
  final Function fetchRateDate;
  TextEditingController rateNameController;
  TextEditingController rateScoreController;
  TextEditingController idController;

  EmploymentInfo({
    Key? key,
    required this.userDisplay,
    required this.user,
    required this.rateDisplay,
    required this.rateList,
    required this.fetchUserById,
    required this.checkRole,
    required this.checkSatus,
    required this.checkRate,
    required this.addRateList,
    required this.deleteRateItem,
    required this.fetchRateDate,
    required this.rateNameController,
    required this.rateScoreController,
    required this.idController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);
    final _scaffoldKey = GlobalKey<ScaffoldState>();

    TextEditingController skillNameController = TextEditingController();
    TextEditingController scoreController = TextEditingController();
    int? rateId;

    editRate() async {
      AppLocalizations? local = AppLocalizations.of(context);
      bool isEnglish = isInEnglish(context);
      var aName = skillNameController.text;
      var aScore = scoreController.text;

      var request = await http.MultipartRequest(
          'POST',
          Uri.parse(
              "http://rest-api-laravel-flutter.herokuapp.com/api/ratework/${rateId}?_method=PUT"));
      Map<String, String> headers = {
        "Accept": "application/json",
        "Content": "charset-UTF-8",
      };

      request.files.add(http.MultipartFile.fromString('skill_name', aName));
      request.files.add(http.MultipartFile.fromString('score', aScore));

      request.headers.addAll(headers);

      var res = await request.send();

      if (res.statusCode == 200) {
        Navigator.pop(context);
      }
      res.stream.transform(utf8.decoder).listen((event) {});
    }

    void showInSnackBar(String value) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          duration: Duration(milliseconds: 2000),
          backgroundColor: kBlueBackground,
          content: Text(
            value,
            style: kHeadingFour.copyWith(color: Colors.black),
          ),
        ),
      );
    }

    Future deleteData(int id) async {
      AppLocalizations? local = AppLocalizations.of(context);
      bool isEnglish = isInEnglish(context);
      final response = await http.delete(Uri.parse(
          "http://rest-api-laravel-flutter.herokuapp.com/api/ratework/$id"));
      showInSnackBar("${local?.deletingAttendance}");
      if (response.statusCode == 200) {
        fetchRateDate();
        showInSnackBar("${local?.deletedAttendance}");
      } else {
        return false;
      }
    }

    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(
          left: 20,
          right: 20,
        ),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${local?.employment}',
                        style: TextStyle(
                          fontSize: 27,
                        ),
                      ),
                      IconButton(
                          onPressed: () async {
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => EmployeeEditEmployment(
                                          userDisplay[0].name.toString(),
                                          userDisplay[0].phone.toString(),
                                          userDisplay[0].id as int,
                                          userDisplay[0].position.toString(),
                                          userDisplay[0].skill.toString(),
                                          userDisplay[0].salary.toString(),
                                          userDisplay[0].role.toString(),
                                          userDisplay[0].status.toString(),
                                          userDisplay[0].rate.toString(),
                                        )));
                            user = [];
                            userDisplay = [];
                            fetchUserById();
                          },
                          icon: Icon(Icons.edit)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: isEnglish ? 20 : 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
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
                              userDisplay[0].position == null
                                  ? '${local?.noData}'
                                  : userDisplay[0].position.toString(),
                              style: kParagraph.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ],
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
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: isEnglish ? 95 : 92,
                        ),
                        SizedBox(
                          width: 170,
                          child: Text(
                            userDisplay[0].skill == null
                                ? '${local?.noData}'
                                : userDisplay[0].skill.toString(),
                            style: kParagraph.copyWith(
                              color: Colors.white,
                            ),
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
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: isEnglish ? 78 : 85,
                        ),
                        Text(
                          userDisplay[0].salary == null
                              ? '${local?.noData}'
                              : '\$${userDisplay[0].salary.toString()}',
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
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: isEnglish ? 95 : 99,
                        ),
                        Text(
                          checkRole(),
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
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: isEnglish ? 78 : 78,
                        ),
                        Text(
                          checkSatus(),
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
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: isEnglish ? 93 : 77,
                        ),
                        Text(
                          checkRate(),
                          style: kParagraph.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 14,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${local?.rate}',
                    style: TextStyle(
                      fontSize: 27,
                    ),
                  ),
                  IconButton(
                      onPressed: () async {
                        await showModalBottomSheet(
                            context: context,
                            builder: (_) {
                              return Container(
                                height: 340,
                                decoration: const BoxDecoration(
                                  color: kBlue,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(30),
                                    topLeft: Radius.circular(30),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '${local?.skill} ',
                                                style: kParagraph.copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                width: isEnglish ? 52 : 20,
                                              ),
                                              Container(
                                                constraints: BoxConstraints(
                                                    maxWidth:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.6),
                                                child: Flex(
                                                  direction: Axis.horizontal,
                                                  children: [
                                                    Flexible(
                                                      child: Container(
                                                        height: 35,
                                                        child: TextFormField(
                                                          decoration:
                                                              InputDecoration(
                                                            contentPadding:
                                                                EdgeInsets.only(
                                                                    left: 10),
                                                            hintText:
                                                                '${local?.enterSkill}',
                                                            errorStyle:
                                                                TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          controller:
                                                              rateNameController,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, right: 20, bottom: 15),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '${local?.score} ',
                                                style: kParagraph.copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                width: isEnglish ? 40 : 40,
                                              ),
                                              Container(
                                                constraints: BoxConstraints(
                                                    maxWidth:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.6),
                                                child: Flex(
                                                  direction: Axis.horizontal,
                                                  children: [
                                                    Flexible(
                                                      child: Container(
                                                        height: 35,
                                                        child: TextFormField(
                                                          decoration:
                                                              InputDecoration(
                                                            contentPadding:
                                                                EdgeInsets.only(
                                                                    left: 10),
                                                            hintText:
                                                                '${local?.enterScore}',
                                                            errorStyle:
                                                                TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          controller:
                                                              rateScoreController,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 30),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          RaisedButton(
                                            onPressed: () {
                                              addRateList();
                                              // Navigator.pop(context);
                                              rateNameController.text = '';
                                              rateScoreController.text = '';
                                              idController.text = '';
                                            },
                                            color:
                                                Theme.of(context).primaryColor,
                                            child: Text(
                                              '${local?.save}',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          RaisedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            color: Colors.red,
                                            child: Text(
                                              '${local?.cancel}',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            });
                        fetchRateDate();
                      },
                      icon: Icon(Icons.add))
                ],
              ),
            ),
            Container(
              child: Center(
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.all(8),
                  itemCount: rateDisplay[0].length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(rateDisplay[0][index]['skill_name']),
                              Row(
                                children: [
                                  Text(
                                      '${rateDisplay[0][index]['score'].toString()} / 10'),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      rateId = rateDisplay[0][index]['id'];
                                      skillNameController.text =
                                          rateDisplay[0][index]['skill_name'];
                                      scoreController.text =
                                          rateDisplay[0][index]['score'];
                                      await showModalBottomSheet(
                                          context: context,
                                          builder: (_) {
                                            return Container(
                                              height: 340,
                                              decoration: const BoxDecoration(
                                                color: kBlue,
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(30),
                                                  topLeft: Radius.circular(30),
                                                ),
                                              ),
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 20,
                                                                  right: 20,
                                                                  bottom: 15),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                '${local?.skill} ',
                                                                style: kParagraph.copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              SizedBox(
                                                                width: isEnglish
                                                                    ? 52
                                                                    : 50,
                                                              ),
                                                              Container(
                                                                constraints: BoxConstraints(
                                                                    maxWidth: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.6),
                                                                child: Flex(
                                                                  direction: Axis
                                                                      .horizontal,
                                                                  children: [
                                                                    Flexible(
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            35,
                                                                        child:
                                                                            TextFormField(
                                                                          decoration:
                                                                              InputDecoration(
                                                                            contentPadding:
                                                                                EdgeInsets.only(left: 10),
                                                                            hintText:
                                                                                '${local?.enterSkill}',
                                                                            errorStyle:
                                                                                TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                          ),
                                                                          controller:
                                                                              skillNameController,
                                                                          // initialValue:
                                                                          //     rateDisplay[0][index]['skill_name'].toString(),
                                                                          // controller:
                                                                          //     rateNameController,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 20,
                                                                  right: 20,
                                                                  bottom: 15),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                '${local?.score} ',
                                                                style: kParagraph.copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              SizedBox(
                                                                width: isEnglish
                                                                    ? 40
                                                                    : 70,
                                                              ),
                                                              Container(
                                                                constraints: BoxConstraints(
                                                                    maxWidth: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.6),
                                                                child: Flex(
                                                                  direction: Axis
                                                                      .horizontal,
                                                                  children: [
                                                                    Flexible(
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            35,
                                                                        child:
                                                                            TextFormField(
                                                                          decoration:
                                                                              InputDecoration(
                                                                            contentPadding:
                                                                                EdgeInsets.only(left: 10),
                                                                            hintText:
                                                                                '${local?.enterScore}',
                                                                            errorStyle:
                                                                                TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                          ),
                                                                          controller:
                                                                              scoreController,
                                                                          // initialValue:
                                                                          //     rateDisplay[0][index]['score'].toString(),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 30),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        RaisedButton(
                                                          onPressed: () {
                                                            editRate();
                                                          },
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          child: Text(
                                                            '${local?.save}',
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 15,
                                                        ),
                                                        RaisedButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          color: Colors.red,
                                                          child: Text(
                                                            '${local?.cancel}',
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          });
                                      fetchRateDate();
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      size: 20,
                                    ),
                                  ),
                                  IconButton(
                                      padding: EdgeInsets.only(left: 0),
                                      constraints: BoxConstraints(),
                                      onPressed: () async {
                                        await showDialog(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            title: Text('${local?.areYouSure}'),
                                            content:
                                                Text('${local?.cannotUndone}'),
                                            actions: [
                                              OutlineButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  deleteData(rateDisplay[0]
                                                      [index]['id']);
                                                },
                                                child: Text('${local?.yes}'),
                                                borderSide: BorderSide(
                                                    color: Colors.green),
                                              ),
                                              OutlineButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                borderSide: BorderSide(
                                                    color: Colors.red),
                                                child: Text('${local?.no}'),
                                              )
                                            ],
                                          ),
                                        );
                                        fetchRateDate();
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        size: 20,
                                        color: Colors.red,
                                      )),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              height: 65,
            )
          ],
        ),
      ),
    );
  }
}
