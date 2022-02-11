import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;

import 'package:ems/models/bank.dart';
import 'package:ems/models/user.dart';
import 'package:ems/utils/utils.dart';
import 'package:ems/widgets/baseline_row.dart';

import '../../../../constants.dart';
import '../../employee_edit_screen.dart';

class PersonalInfo extends StatelessWidget {
  List<User> userDisplay;
  List<Bank> bankDisplay;

  List<User> user;
  final Function fetchUserById;
  final Function fetchBankData;
  PersonalInfo({
    Key? key,
    required this.userDisplay,
    required this.bankDisplay,
    required this.user,
    required this.fetchUserById,
    required this.fetchBankData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController bankNameController = TextEditingController();
    TextEditingController accountNumberController = TextEditingController();
    TextEditingController accountNameController = TextEditingController();
    int? bankId;

    String urlUser = "http://rest-api-laravel-flutter.herokuapp.com/api/users";

    addBankList() async {
      AppLocalizations? local = AppLocalizations.of(context);
      bool isEnglish = isInEnglish(context);
      var aBankName = bankNameController.text;
      var aAccountNumber = accountNumberController.text;
      var aAccountName = accountNameController.text;
      var request = await http.MultipartRequest(
          'POST', Uri.parse("$urlUser/${userDisplay[0].id}/bank"));
      Map<String, String> headers = {
        "Accept": "application/json",
        "Content": "charset-UTF-8",
      };
      request.files.add(http.MultipartFile.fromString('bank_name', aBankName));
      request.files
          .add(http.MultipartFile.fromString('account_number', aAccountNumber));
      request.files
          .add(http.MultipartFile.fromString('account_name', aAccountName));

      request.headers.addAll(headers);

      var res = await request.send();
      print(res.statusCode);
      if (res.statusCode == 201) {
        Navigator.of(context).pop();
      }
      res.stream.transform(utf8.decoder).listen((event) {});
    }

    editBank() async {
      AppLocalizations? local = AppLocalizations.of(context);
      bool isEnglish = isInEnglish(context);
      var aBankName = bankNameController.text;
      var aAccountNumber = accountNumberController.text;
      var aAccountName = accountNameController.text;

      var request = await http.MultipartRequest(
          'POST',
          Uri.parse(
              "http://rest-api-laravel-flutter.herokuapp.com/api/bank/$bankId?_method=PUT"));
      Map<String, String> headers = {
        "Accept": "application/json",
        "Content": "charset-UTF-8",
      };

      request.files.add(http.MultipartFile.fromString('bank_name', aBankName));
      request.files
          .add(http.MultipartFile.fromString('account_number', aAccountNumber));
      request.files
          .add(http.MultipartFile.fromString('account_name', aAccountName));

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
          "http://rest-api-laravel-flutter.herokuapp.com/api/bank/$id"));
      showInSnackBar("${local?.deletingAttendance}");
      if (response.statusCode == 200) {
        fetchBankData();
        showInSnackBar("${local?.deletedAttendance}");
      } else {
        return false;
      }
    }

    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(
              left: 20,
              right: 10,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${local?.personal}',
                        style: TextStyle(
                          fontSize: 27,
                        ),
                      ),
                      IconButton(
                          onPressed: () async {
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => EmployeeEditScreen(
                                        userDisplay[0].id as int,
                                        userDisplay[0].name.toString(),
                                        userDisplay[0].phone.toString(),
                                        userDisplay[0].email.toString(),
                                        userDisplay[0].address.toString(),
                                        userDisplay[0].position.toString(),
                                        userDisplay[0].skill.toString(),
                                        userDisplay[0].salary.toString(),
                                        userDisplay[0].role.toString(),
                                        userDisplay[0].status.toString(),
                                        userDisplay[0].rate.toString(),
                                        userDisplay[0].background.toString(),
                                        userDisplay[0].image.toString(),
                                        userDisplay[0].imageId.toString())));
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
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              userDisplay[0].name.toString(),
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
                          '${local?.id} ',
                          style: kParagraph.copyWith(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: isEnglish ? 110 : 80,
                        ),
                        Text(
                          userDisplay[0].id.toString(),
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
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: isEnglish ? 85 : 90,
                        ),
                        SizedBox(
                          width: 210,
                          child: Text(
                            userDisplay[0].email.toString(),
                            style: kParagraph.copyWith(
                              color: Colors.white,
                              height: 1.3,
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
                          '${local?.phoneNumber} ',
                          style: kParagraph.copyWith(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: isEnglish ? 80 : 62,
                        ),
                        Text(
                          userDisplay[0].phone.toString(),
                          style: kParagraph.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
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
                            width: isEnglish ? 50 : 50,
                          ),
                          SizedBox(
                            width: 220,
                            // height: 35,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 15,
                              ),
                              child: Text(
                                userDisplay[0].address == null
                                    ? '${local?.noData}'
                                    : userDisplay[0].address.toString(),
                                style: kParagraph.copyWith(
                                  color: Colors.white,
                                  height: 1.3,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
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
                            width: isEnglish ? 16 : 46,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text(
                              userDisplay[0].background == null
                                  ? '${local?.noData}'
                                  : userDisplay[0].background.toString(),
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
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: 20,
              left: 20,
              right: 10,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${local?.bank}',
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
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 3,
                                              child: Text(
                                                '${local?.bankName} ',
                                                style: kParagraph.copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            SizedBox(
                                              width: isEnglish ? 52 : 20,
                                            ),
                                            Expanded(
                                              flex: 4,
                                              child: Container(
                                                height: 35,
                                                child: TextFormField(
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.only(
                                                            left: 10),
                                                    hintText:
                                                        '${local?.enterbankName}',
                                                    errorStyle: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  controller:
                                                      bankNameController,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 3,
                                              child: Text(
                                                '${local?.accountBankName} ',
                                                style: kParagraph.copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            SizedBox(
                                              width: isEnglish ? 52 : 20,
                                            ),
                                            Expanded(
                                              flex: 4,
                                              child: Container(
                                                height: 35,
                                                child: TextFormField(
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.only(
                                                            left: 10),
                                                    hintText:
                                                        '${local?.enteraccountBankName}',
                                                    errorStyle: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  controller:
                                                      accountNameController,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 3,
                                              child: Text(
                                                '${local?.accountBankNumber} ',
                                                style: kParagraph.copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            SizedBox(
                                              width: isEnglish ? 52 : 20,
                                            ),
                                            Expanded(
                                              flex: 4,
                                              child: Container(
                                                height: 35,
                                                child: TextFormField(
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.only(
                                                            left: 10),
                                                    hintText:
                                                        '${local?.enteraccountBankNumber}',
                                                    errorStyle: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  controller:
                                                      accountNumberController,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 50,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 30),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            RaisedButton(
                                              onPressed: () {
                                                addBankList();
                                                // Navigator.pop(context);
                                                bankNameController.text = '';
                                                accountNumberController.text =
                                                    '';
                                                accountNameController.text = '';
                                              },
                                              color: Theme.of(context)
                                                  .primaryColor,
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
                          fetchBankData();
                        },
                        icon: Icon(Icons.add),
                      )
                    ],
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Table(
                        columnWidths: {
                          0: FlexColumnWidth(2),
                          1: FlexColumnWidth(4),
                        },
                        border: TableBorder.all(width: 1, color: Colors.white),
                        children: bankDisplay.map<TableRow>((e) {
                          return TableRow(children: [
                            TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Padding(
                                  padding: const EdgeInsets.all(13.0),
                                  child: Text(
                                    e.bankName.toString(),
                                    textAlign: TextAlign.center,
                                  ),
                                )),
                            TableCell(
                                child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 13, bottom: 13, left: 8, right: 2),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 175,
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${local?.accountName}: ',
                                            ),
                                            Text(
                                              e.accountName == null
                                                  ? userDisplay[0]
                                                      .name
                                                      .toString()
                                                  : e.accountName == 'null'
                                                      ? userDisplay[0]
                                                          .name
                                                          .toString()
                                                      : e.accountName
                                                          .toString(),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: isEnglish ? 15 : 4,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${local?.accountNumber}: ',
                                            ),
                                            Text(e.accoutNumber.toString()),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )),
                            TableCell(
                              verticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              child: PopupMenuButton(
                                color: kBlack,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                onSelected: (int selectedValue) async {
                                  if (selectedValue == 0) {
                                    bankId = e.id;
                                    bankNameController.text =
                                        e.bankName.toString();
                                    accountNameController.text =
                                        e.accountName.toString();
                                    accountNumberController.text =
                                        e.accoutNumber.toString();
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
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 10),
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 3,
                                                        child: Text(
                                                          'Bank Name ',
                                                          style: kParagraph
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            isEnglish ? 52 : 20,
                                                      ),
                                                      Expanded(
                                                        flex: 4,
                                                        child: Container(
                                                          height: 35,
                                                          child: TextFormField(
                                                            decoration:
                                                                InputDecoration(
                                                              contentPadding:
                                                                  EdgeInsets.only(
                                                                      left: 10),
                                                              hintText:
                                                                  'Enter Bank Name',
                                                              errorStyle:
                                                                  TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            controller:
                                                                bankNameController,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 10),
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 3,
                                                        child: Text(
                                                          'Account Name ',
                                                          style: kParagraph
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            isEnglish ? 52 : 20,
                                                      ),
                                                      Expanded(
                                                        flex: 4,
                                                        child: Container(
                                                          height: 35,
                                                          child: TextFormField(
                                                            decoration:
                                                                InputDecoration(
                                                              contentPadding:
                                                                  EdgeInsets.only(
                                                                      left: 10),
                                                              hintText:
                                                                  'Enter Account Name',
                                                              errorStyle:
                                                                  TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            controller:
                                                                accountNameController,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 10),
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 3,
                                                        child: Text(
                                                          'Account Number ',
                                                          style: kParagraph
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            isEnglish ? 52 : 20,
                                                      ),
                                                      Expanded(
                                                        flex: 4,
                                                        child: Container(
                                                          height: 35,
                                                          child: TextFormField(
                                                            decoration:
                                                                InputDecoration(
                                                              contentPadding:
                                                                  EdgeInsets.only(
                                                                      left: 10),
                                                              hintText:
                                                                  'Enter Account Number',
                                                              errorStyle:
                                                                  TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            controller:
                                                                accountNumberController,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 50,
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
                                                          editBank();
                                                        },
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        child: Text(
                                                          '${local?.save}',
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
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
                                                                FontWeight.bold,
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
                                    bankNameController.text = '';
                                    accountNameController.text = '';
                                    accountNumberController.text = '';
                                    fetchBankData();
                                  }
                                  if (selectedValue == 1) {
                                    bankId = e.id;
                                    await showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: Text('${local?.areYouSure}'),
                                        content: Text('${local?.cannotUndone}'),
                                        actions: [
                                          OutlineButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              deleteData(bankId!);
                                            },
                                            child: Text('${local?.yes}'),
                                            borderSide:
                                                BorderSide(color: Colors.green),
                                          ),
                                          OutlineButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            borderSide:
                                                BorderSide(color: Colors.red),
                                            child: Text('${local?.no}'),
                                          )
                                        ],
                                      ),
                                    );
                                    fetchBankData();
                                  }
                                },
                                itemBuilder: (_) => [
                                  PopupMenuItem(
                                    child: Text(
                                      '${local?.edit}',
                                      style: TextStyle(
                                        fontSize: isEnglish ? 15 : 16,
                                      ),
                                    ),
                                    value: 0,
                                  ),
                                  PopupMenuItem(
                                    child: Text(
                                      '${local?.delete}',
                                      style: TextStyle(
                                          fontSize: isEnglish ? 15 : 16),
                                    ),
                                    value: 1,
                                  ),
                                ],
                                icon: Icon(Icons.more_vert),
                              ),
                            )
                          ]);
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 45,
          ),
        ],
      ),
    );
  }
}
