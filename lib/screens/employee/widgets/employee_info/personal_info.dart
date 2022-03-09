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
import '../../../../services/models/bank.dart' as model_bank;
import '../../../../services/bank.dart' as service_bank;

class PersonalInfo extends StatelessWidget {
  List<User> userDisplay;
  List<User> user;
  List<model_bank.Bank> bankDisplay;
  final Function fetchUserById;
  final Function fetchBankData;
  BuildContext contextt;
  PersonalInfo({
    Key? key,
    required this.contextt,
    required this.userDisplay,
    required this.bankDisplay,
    required this.user,
    required this.fetchUserById,
    required this.fetchBankData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // service
    service_bank.BankService _bankService = service_bank.BankService();
    // text contorller
    TextEditingController bankNameController = TextEditingController();
    TextEditingController accountNumberController = TextEditingController();
    TextEditingController accountNameController = TextEditingController();
    int? bankId;

    // key
    GlobalKey<FormState> _key = GlobalKey<FormState>();

    String urlUser = "http://rest-api-laravel-flutter.herokuapp.com/api/users";

    // add new bank info to api
    createOneBank(model_bank.Bank bank) async {
      await _bankService.createOne(bank);
    }

    // edit bank info in api
    updateOneBank(model_bank.Bank bank) async {
      await _bankService.updateOne(bank);
    }

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

    // delete bank info from api
    Future deleteData(int id) async {
      AppLocalizations? local = AppLocalizations.of(context);
      final response = await http.delete(Uri.parse(
          "http://rest-api-laravel-flutter.herokuapp.com/api/bank/$id"));
      showInSnackBar("${local?.deletingBank}");
      if (response.statusCode == 200) {
        fetchBankData();
        showInSnackBar("${local?.deletedBank}");
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
            margin: const EdgeInsets.only(
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
                        style: const TextStyle(
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
                                        // TODO: CHANGE HERE
                                        "userDisplay[0].position.toString()",
                                        "userDisplay[0].skill.toString()",
                                        userDisplay[0].salary.toString(),
                                        userDisplay[0].role.toString(),
                                        userDisplay[0].status.toString(),
                                        "userDisplay[0].rate.toString()",
                                        userDisplay[0].background.toString(),
                                        userDisplay[0].image.toString(),
                                        userDisplay[0].imageId.toString())));
                            fetchUserById();
                          },
                          icon: const Icon(Icons.edit)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
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
                                userDisplay[0].address == 'null'
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
                              userDisplay[0].background == 'null'
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
            margin: const EdgeInsets.only(
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
                        style: const TextStyle(
                          fontSize: 27,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          await showModalBottomSheet(
                              isScrollControlled: true,
                              context: contextt,
                              builder: (_) {
                                return Form(
                                  key: _key,
                                  child: Padding(
                                    padding: MediaQuery.of(context).viewInsets,
                                    child: Container(
                                      height: 400,
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
                                            height: 15,
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 10),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
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
                                                  width: isEnglish ? 32 : 20,
                                                ),
                                                Expanded(
                                                  flex: 4,
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
                                                          '${local?.enterbankName}',
                                                      errorStyle:
                                                          const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    controller:
                                                        bankNameController,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 10),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
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
                                                  width: isEnglish ? 32 : 20,
                                                ),
                                                Expanded(
                                                  flex: 4,
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
                                                          '${local?.enteraccountBankName}',
                                                      errorStyle:
                                                          const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    controller:
                                                        accountNameController,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 10),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
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
                                                  width: isEnglish ? 32 : 20,
                                                ),
                                                Expanded(
                                                  flex: 4,
                                                  child: TextFormField(
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return 'required';
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
                                                          '${local?.enteraccountBankNumber}',
                                                      errorStyle:
                                                          const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    controller:
                                                        accountNumberController,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 30),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                // ignore: deprecated_member_use
                                                RaisedButton(
                                                  onPressed: () async {
                                                    if (_key.currentState!
                                                        .validate()) {
                                                      model_bank.Bank bank =
                                                          model_bank.Bank(
                                                        name: bankNameController
                                                            .text,
                                                        accountName:
                                                            accountNameController
                                                                .text,
                                                        accountNumber:
                                                            accountNumberController
                                                                .text,
                                                        userId:
                                                            userDisplay[0].id,
                                                      );
                                                      await createOneBank(bank);
                                                      Navigator.pop(context);
                                                      bankNameController.text =
                                                          '';
                                                      accountNumberController
                                                          .text = '';
                                                      accountNameController
                                                          .text = '';
                                                    }
                                                  },
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  child: Text(
                                                    '${local?.save}',
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 15,
                                                ),
                                                // ignore: deprecated_member_use
                                                RaisedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  color: Colors.red,
                                                  child: Text(
                                                    '${local?.cancel}',
                                                    style: const TextStyle(
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
                                    ),
                                  ),
                                );
                              });
                          fetchBankData();
                        },
                        icon: const Icon(Icons.add),
                      )
                    ],
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Table(
                        columnWidths: const {
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
                                    e.name.toString(),
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
                                  SizedBox(
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
                                            Text(e.accountNumber.toString()),
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
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                onSelected: (int selectedValue) async {
                                  if (selectedValue == 0) {
                                    bankId = e.id;
                                    bankNameController.text = e.name.toString();
                                    accountNameController.text =
                                        e.accountName.toString();
                                    accountNumberController.text =
                                        e.accountNumber.toString();
                                    await showModalBottomSheet(
                                        isScrollControlled: true,
                                        context: contextt,
                                        builder: (_) {
                                          return Form(
                                            key: _key,
                                            child: Padding(
                                              padding: MediaQuery.of(context)
                                                  .viewInsets,
                                              child: Container(
                                                height: 400,
                                                decoration: const BoxDecoration(
                                                  color: kBlue,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(30),
                                                    topLeft:
                                                        Radius.circular(30),
                                                  ),
                                                ),
                                                child: Column(
                                                  children: [
                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                    Container(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 20,
                                                          vertical: 10),
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            flex: 3,
                                                            child: Text(
                                                              '${local?.bankName} ',
                                                              style: kParagraph.copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: isEnglish
                                                                ? 52
                                                                : 20,
                                                          ),
                                                          Expanded(
                                                            flex: 4,
                                                            child:
                                                                TextFormField(
                                                              validator:
                                                                  (value) {
                                                                if (value!
                                                                    .isEmpty) {
                                                                  return 'required';
                                                                }
                                                                return null;
                                                              },
                                                              decoration:
                                                                  InputDecoration(
                                                                contentPadding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            10),
                                                                hintText:
                                                                    '${local?.enterbankName}',
                                                                errorStyle:
                                                                    const TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              controller:
                                                                  bankNameController,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 20,
                                                          vertical: 10),
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            flex: 3,
                                                            child: Text(
                                                              '${local?.accountBankName} ',
                                                              style: kParagraph.copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: isEnglish
                                                                ? 52
                                                                : 20,
                                                          ),
                                                          Expanded(
                                                            flex: 4,
                                                            child:
                                                                TextFormField(
                                                              validator:
                                                                  (value) {
                                                                if (value!
                                                                    .isEmpty) {
                                                                  return 'required';
                                                                }
                                                                return null;
                                                              },
                                                              decoration:
                                                                  InputDecoration(
                                                                contentPadding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            10),
                                                                hintText:
                                                                    '${local?.enteraccountBankName}',
                                                                errorStyle:
                                                                    const TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              controller:
                                                                  accountNameController,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 20,
                                                          vertical: 10),
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            flex: 3,
                                                            child: Text(
                                                              '${local?.accountBankNumber} ',
                                                              style: kParagraph.copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: isEnglish
                                                                ? 52
                                                                : 20,
                                                          ),
                                                          Expanded(
                                                            flex: 4,
                                                            child:
                                                                TextFormField(
                                                              validator:
                                                                  (value) {
                                                                if (value!
                                                                    .isEmpty) {
                                                                  return 'required';
                                                                }
                                                                return null;
                                                              },
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              decoration:
                                                                  InputDecoration(
                                                                contentPadding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            10),
                                                                hintText:
                                                                    '${local?.enteraccountBankNumber}',
                                                                errorStyle:
                                                                    const TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              controller:
                                                                  accountNumberController,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 30),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          // ignore: deprecated_member_use
                                                          RaisedButton(
                                                            onPressed:
                                                                () async {
                                                              if (_key
                                                                  .currentState!
                                                                  .validate()) {
                                                                model_bank.Bank
                                                                    bank =
                                                                    model_bank
                                                                        .Bank(
                                                                  name:
                                                                      bankNameController
                                                                          .text,
                                                                  accountName:
                                                                      accountNameController
                                                                          .text,
                                                                  accountNumber:
                                                                      accountNumberController
                                                                          .text,
                                                                  id: bankId,
                                                                );
                                                                await updateOneBank(
                                                                    bank);
                                                                Navigator.pop(
                                                                    context);
                                                              }
                                                            },
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            child: Text(
                                                              '${local?.save}',
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 15,
                                                          ),
                                                          // ignore: deprecated_member_use
                                                          RaisedButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            color: Colors.red,
                                                            child: Text(
                                                              '${local?.cancel}',
                                                              style:
                                                                  const TextStyle(
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
                                              ),
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
                                          // ignore: deprecated_member_use
                                          OutlineButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              deleteData(bankId!);
                                            },
                                            child: Text('${local?.yes}'),
                                            borderSide: const BorderSide(
                                                color: Colors.green),
                                          ),
                                          // ignore: deprecated_member_use
                                          OutlineButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            borderSide: const BorderSide(
                                                color: Colors.red),
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
                                icon: const Icon(Icons.more_vert),
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
