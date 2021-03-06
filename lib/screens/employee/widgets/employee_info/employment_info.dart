// ignore_for_file: deprecated_member_use

import 'package:ems/models/rating.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:ems/models/user.dart';
import 'package:ems/screens/employee/widgets/employee_info/position_record.dart';
import 'package:ems/utils/utils.dart';
import 'package:ems/widgets/baseline_row.dart';

import '../../../../constants.dart';
import '../../employee_edit_employment.dart';
import '../../../../services/rating.dart';

// ignore: must_be_immutable
class EmploymentInfo extends StatelessWidget {
  List<User> userDisplay;
  List<User> user;
  List<Rating> rateDisplay;
  List rateList;
  List positionDisplay;
  final Function fetchUserById;
  final Function checkRole;
  final Function checkSatus;
  final Function checkRate;
  final Function addRateList;
  final Function deleteRateItem;
  final Function fetchRateDate;
  final Function fetchUserPosition;
  TextEditingController rateNameController;
  TextEditingController rateScoreController;
  TextEditingController idController;
  BuildContext contextt;

  EmploymentInfo({
    Key? key,
    required this.userDisplay,
    required this.positionDisplay,
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
    required this.fetchUserPosition,
    required this.rateNameController,
    required this.rateScoreController,
    required this.idController,
    required this.contextt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);

    // service
    RatingService _rateService = RatingService();

    // text controller
    TextEditingController skillNameController = TextEditingController();
    TextEditingController scoreController = TextEditingController();

    int? rateId;

    // edit rate from api
    updateRate(Rating rate) async {
      await _rateService.updateOne(rate);
    }

    GlobalKey<FormState> _key = GlobalKey<FormState>();

    void showInSnackBar(String value) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          duration: const Duration(milliseconds: 2000),
          backgroundColor: kBlueBackground,
          content: Text(
            value,
            style: kHeadingFour.copyWith(color: Colors.black),
          ),
        ),
      );
    }

    // delete rate from api
    Future deleteData(int id) async {
      AppLocalizations? local = AppLocalizations.of(context);
      final response = await http.delete(Uri.parse(
          "http://rest-api-laravel-flutter.herokuapp.com/api/rating/$id"));
      showInSnackBar("${local?.deletingSkill}");
      if (response.statusCode == 200) {
        fetchRateDate();
        showInSnackBar("${local?.deletedSkill}");
      } else {
        return false;
      }
    }

    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(
          left: 20,
          right: 20,
        ),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _employmentTextAndEditBtn(local, context),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: isEnglish ? 20 : 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _postionName(local, isEnglish),
                        _viewPositionIcon(context)
                      ],
                    ),
                    SizedBox(
                      height: isEnglish ? 20 : 10,
                    ),
                    _salaryInfo(local, isEnglish),
                    SizedBox(
                      height: isEnglish ? 20 : 10,
                    ),
                    _roleInfo(local, isEnglish),
                    SizedBox(
                      height: isEnglish ? 20 : 10,
                    ),
                    _statusInfo(local, isEnglish),
                    SizedBox(
                      height: isEnglish ? 20 : 10,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 14,
            ),
            _skillTextAndAddNewBtn(local, _key, isEnglish, context),
            // ignore: avoid_unnecessary_containers
            Container(
              child: Center(
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8),
                  itemCount: rateDisplay.length,
                  itemBuilder: (_, index) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  width: 1,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(rateDisplay[index].skillName.toString()),
                                _scoreAndEditDeleteBtn(
                                    index,
                                    rateId,
                                    skillNameController,
                                    scoreController,
                                    _key,
                                    local,
                                    isEnglish,
                                    context,
                                    updateRate,
                                    deleteData),
                              ],
                            ),
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 65,
            )
          ],
        ),
      ),
    );
  }

// skill's score and edit/delete button
  Row _scoreAndEditDeleteBtn(
    int index,
    int? rateId,
    TextEditingController skillNameController,
    TextEditingController scoreController,
    GlobalKey<FormState> _key,
    AppLocalizations? local,
    bool isEnglish,
    BuildContext context,
    Future<Null> updateRate(Rating rate),
    Future<dynamic> deleteData(int id),
  ) {
    return Row(
      children: [
        Text('${rateDisplay[index].score.toString()} / 10'),
        const SizedBox(
          width: 5,
        ),
        _editBtn(
          rateId,
          index,
          skillNameController,
          scoreController,
          _key,
          local,
          isEnglish,
          context,
          updateRate,
        ),
        _deleteBtn(context, local, deleteData, index),
      ],
    );
  }

// delete skill button
  IconButton _deleteBtn(
    BuildContext context,
    AppLocalizations? local,
    Future<dynamic> deleteData(int id),
    int index,
  ) {
    return IconButton(
        padding: const EdgeInsets.only(left: 0),
        constraints: const BoxConstraints(),
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('${local?.areYouSure}'),
              content: Text('${local?.cannotUndone}'),
              actions: [
                OutlineButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    deleteData(rateDisplay[index].id as int);
                  },
                  child: Text('${local?.yes}'),
                  borderSide: const BorderSide(color: Colors.green),
                ),
                OutlineButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  borderSide: const BorderSide(color: Colors.red),
                  child: Text('${local?.no}'),
                )
              ],
            ),
          );
          fetchRateDate();
        },
        icon: const Icon(
          Icons.delete,
          size: 20,
          color: Colors.red,
        ));
  }

// edit skill button
  IconButton _editBtn(
    int? rateId,
    int index,
    TextEditingController skillNameController,
    TextEditingController scoreController,
    GlobalKey<FormState> _key,
    AppLocalizations? local,
    bool isEnglish,
    BuildContext context,
    Future<Null> updateRate(Rating rate),
  ) {
    return IconButton(
      onPressed: () async {
        rateId = rateDisplay[index].id;
        skillNameController.text = rateDisplay[index].skillName.toString();
        scoreController.text = rateDisplay[index].score.toString();
        await showModalBottomSheet(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
              topRight: Radius.circular(30),
              topLeft: Radius.circular(30),
            )),
            isScrollControlled: true,
            context: contextt,
            builder: (_) {
              return Form(
                key: _key,
                child: Padding(
                  padding: MediaQuery.of(contextt).viewInsets,
                  child: Container(
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
                        const SizedBox(
                          height: 20,
                        ),
                        _skillNameInput(
                          local,
                          isEnglish,
                          context,
                          skillNameController,
                        ),
                        _scoreInput(
                          local,
                          isEnglish,
                          context,
                          scoreController,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        _yesAndNoBtn(
                          _key,
                          rateId,
                          skillNameController,
                          scoreController,
                          updateRate,
                          context,
                          local,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
        rateNameController.text = '';
        rateScoreController.text = '';
        idController.text = '';
        fetchRateDate();
      },
      icon: const Icon(
        Icons.edit,
        size: 20,
      ),
    );
  }

// yes/no button for updating or not
  Padding _yesAndNoBtn(
    GlobalKey<FormState> _key,
    int? rateId,
    TextEditingController skillNameController,
    TextEditingController scoreController,
    Future<Null> updateRate(Rating rate),
    BuildContext context,
    AppLocalizations? local,
  ) {
    return Padding(
      padding: const EdgeInsets.only(right: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          RaisedButton(
            onPressed: () async {
              if (_key.currentState!.validate()) {
                Rating rate = Rating(
                  id: rateId,
                  skillName: skillNameController.text,
                  score: int.tryParse(
                    scoreController.text,
                  ),
                );

                await updateRate(rate);
                Navigator.pop(context);
              }
            },
            color: Theme.of(context).primaryColor,
            child: Text(
              '${local?.save}',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          RaisedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.red,
            child: Text(
              '${local?.cancel}',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

// score input for edit skill
  Padding _scoreInput(AppLocalizations? local, bool isEnglish,
      BuildContext context, TextEditingController scoreController) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${local?.score} ',
                  style: kParagraph.copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: isEnglish ? 40 : 70,
                ),
                Container(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.6),
                  child: Flex(
                    direction: Axis.horizontal,
                    children: [
                      Flexible(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'required';
                            }
                            if (int.parse(value) < 1 || int.parse(value) > 10) {
                              return 'Please enter between 1-10';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(left: 10),
                            hintText: '${local?.enterScore}',
                            errorStyle: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          controller: scoreController,
                          // initialValue:
                          //     rateDisplay[0][index]['score'].toString(),
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
    );
  }

// skill name input for edit skill
  Padding _skillNameInput(AppLocalizations? local, bool isEnglish,
      BuildContext context, TextEditingController skillNameController) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${local?.skill} ',
                  style: kParagraph.copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: isEnglish ? 52 : 50,
                ),
                Container(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.6),
                  child: Flex(
                    direction: Axis.horizontal,
                    children: [
                      Flexible(
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'required';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(left: 10),
                            hintText: '${local?.enterSkill}',
                            errorStyle: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          controller: skillNameController,
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
    );
  }

// skill rate text and button for add new skill&rate
  Padding _skillTextAndAddNewBtn(
    AppLocalizations? local,
    GlobalKey<FormState> _key,
    bool isEnglish,
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${local?.rate}',
            style: const TextStyle(
              fontSize: 27,
            ),
          ),
          IconButton(
              onPressed: () async {
                await showModalBottomSheet(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30),
                    )),
                    isScrollControlled: true,
                    context: contextt,
                    builder: (_) {
                      return Form(
                        key: _key,
                        child: Padding(
                          padding: MediaQuery.of(contextt).viewInsets,
                          child: Container(
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
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            width: isEnglish ? 52 : 50,
                                          ),
                                          Container(
                                            constraints: BoxConstraints(
                                                maxWidth: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.6),
                                            child: Flex(
                                              direction: Axis.horizontal,
                                              children: [
                                                Flexible(
                                                  // ignore: sized_box_for_whitespace
                                                  child: TextFormField(
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return 'required';
                                                      }

                                                      return null;
                                                    },
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          const EdgeInsets.only(
                                                              left: 10),
                                                      hintText:
                                                          '${local?.enterSkill}',
                                                      errorStyle:
                                                          const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    controller:
                                                        rateNameController,
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
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            width: isEnglish ? 40 : 70,
                                          ),
                                          Container(
                                            constraints: BoxConstraints(
                                                maxWidth: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.6),
                                            child: Flex(
                                              direction: Axis.horizontal,
                                              children: [
                                                Flexible(
                                                  child: TextFormField(
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return 'required';
                                                      }
                                                      if (int.parse(value) <
                                                              1 ||
                                                          int.parse(value) >
                                                              10) {
                                                        return 'Please enter between 1-10';
                                                      }
                                                      return null;
                                                    },
                                                    keyboardType:
                                                        TextInputType.number,
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          const EdgeInsets.only(
                                                              left: 10),
                                                      hintText:
                                                          '${local?.enterScore}',
                                                      errorStyle:
                                                          const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    controller:
                                                        rateScoreController,
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
                                const SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 30),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      RaisedButton(
                                        onPressed: () async {
                                          if (_key.currentState!.validate()) {
                                            await addRateList();
                                            Navigator.pop(context);
                                            rateNameController.text = '';
                                            rateScoreController.text = '';
                                            idController.text = '';
                                          }
                                        },
                                        color: Theme.of(context).primaryColor,
                                        child: Text(
                                          '${local?.save}',
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      RaisedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          rateNameController.text = '';
                                          rateScoreController.text = '';
                                          idController.text = '';
                                        },
                                        color: Colors.red,
                                        child: Text(
                                          '${local?.cancel}',
                                          style: const TextStyle(
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
                          ),
                        ),
                      );
                    });
                rateNameController.text = '';
                rateScoreController.text = '';
                idController.text = '';
                fetchRateDate();
              },
              icon: const Icon(Icons.add))
        ],
      ),
    );
  }

// status information row
  BaselineRow _statusInfo(AppLocalizations? local, bool isEnglish) {
    return BaselineRow(
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
    );
  }

// role information now
  BaselineRow _roleInfo(AppLocalizations? local, bool isEnglish) {
    return BaselineRow(
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
    );
  }

// salary information row
  BaselineRow _salaryInfo(AppLocalizations? local, bool isEnglish) {
    return BaselineRow(
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
    );
  }

// button for viewing and edit and delete position record
  IconButton _viewPositionIcon(BuildContext context) {
    return IconButton(
      onPressed: () async {
        await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => TestPosition(
                      imageUrl: userDisplay[0].image.toString(),
                      name: userDisplay[0].name.toString(),
                      id: userDisplay[0].id as int,
                    )));
        fetchUserPosition();
      },
      icon: const Icon(MdiIcons.eye, size: 18),
    );
  }

// postion information row
  BaselineRow _postionName(AppLocalizations? local, bool isEnglish) {
    return BaselineRow(
      children: [
        Text(
          '${local?.position} ',
          style: kParagraph.copyWith(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: isEnglish ? 65 : 85,
        ),
        Text(
          positionDisplay[0].isEmpty
              ? '${local?.noData}'
              : userDisplay[0].positions![0].name.toString(),
          style: kParagraph.copyWith(
            color: Colors.white,
          ),
        ),
      ],
    );
  }

// employment text and edit employment information icon
  Padding _employmentTextAndEditBtn(
    AppLocalizations? local,
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${local?.employment}',
            style: const TextStyle(
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
                              "userDisplay[0].position.toString()",
                              "userDisplay[0].skill.toString()",
                              userDisplay[0].salary.toString(),
                              userDisplay[0].role.toString(),
                              userDisplay[0].status.toString(),
                              "userDisplay[0].rate.toString()",
                            )));
                user = [];
                userDisplay = [];
                fetchUserById();
              },
              icon: const Icon(Icons.edit)),
        ],
      ),
    );
  }
}
