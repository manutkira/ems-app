// ignore_for_file: deprecated_member_use

import 'package:ems/models/user.dart';
import 'package:ems/screens/payroll/loan/loan_record.dart';
import 'package:ems/services/loan.dart';
import 'package:ems/services/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../constants.dart';
import '../../../models/loan_record.dart' as record;
import '../../../utils/utils.dart';

class NewLoanScreen extends StatefulWidget {
  const NewLoanScreen({Key? key}) : super(key: key);

  @override
  _NewLoanScreenState createState() => _NewLoanScreenState();
}

class _NewLoanScreenState extends State<NewLoanScreen> {
  // service
  final UserService _userService = UserService.instance;
  final LoanService _loanService = LoanService();

  // user list
  List<User> userList = [];

  // loan
  // record.LoanRecord loanRecord = record.LoanRecord();

  // boolean
  bool _isloading = true;

  // datetime
  DateTime? pickStart;

  // url
  String urlUser = "http://rest-api-laravel-flutter.herokuapp.com/api/users";

  String? _mySelection;

  // text controller
  TextEditingController amountController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController reasonController = TextEditingController();

  // fetch data from api
  fetchAllUser() async {
    _isloading = true;
    try {
      List<User> userDisplay = await _userService.findMany();
      setState(() {
        userList = userDisplay;
        _isloading = false;
      });
    } catch (err) {
      rethrow;
    }
  }

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  // date picker for start date
  void _startDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    ).then((picked) {
      if (picked == null) {
        return;
      }
      setState(() {
        pickStart = picked;
        dateController.text = DateFormat('dd-MM-yyyy').format(pickStart!);
        // pick = true;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    fetchAllUser();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('${local?.loan}'),
      ),
      body: _isloading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${local?.fetchData}'),
                  const CircularProgressIndicator(
                    color: kWhite,
                  ),
                ],
              ),
            )
          : Form(
              key: _key,
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 30, top: 10, right: 17),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${local?.username}',
                          style:
                              kParagraph.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 235,
                          child: DropdownButtonFormField(
                            validator: (value) {
                              if (value == null) {
                                return '${local?.plsSelectName}';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              errorStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            items: userList.map((item) {
                              return DropdownMenuItem(
                                child: Text(item.name.toString()),
                                value: item.id.toString(),
                              );
                            }).toList(),
                            hint: Text('${local?.select}'),
                            onChanged: (newVal) {
                              setState(() {
                                _mySelection = newVal.toString();
                              });
                            },
                            value: _mySelection,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 25, right: 15, bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${local?.payrollDate} ',
                          style:
                              kParagraph.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: isEnglish ? 36 : 29,
                        ),
                        Container(
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.6),
                          child: Flex(
                            direction: Axis.horizontal,
                            children: [
                              Flexible(
                                child: TextFormField(
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return '${local?.plsEnterDate}';
                                    }
                                    return null;
                                  },
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    hintText: '${local?.enterDate}',
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          _startDatePicker();
                                        },
                                        icon: const Icon(
                                          MdiIcons.calendar,
                                          color: Colors.white,
                                        )),
                                    errorStyle: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  controller: dateController,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 25, right: 15, bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${local?.amount} ',
                          style:
                              kParagraph.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Container(
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.6),
                          child: Flex(
                            direction: Axis.horizontal,
                            children: [
                              Flexible(
                                child: TextFormField(
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp('[0-9.,]+')),
                                  ],
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: '${local?.enterAmount} ',
                                    errorStyle: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  controller: amountController,
                                  textInputAction: TextInputAction.next,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return '${local?.plsEnterAmount}';
                                    }

                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 25, right: 15, bottom: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${local?.reason}',
                            style: kParagraph.copyWith(
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: isEnglish ? 52 : 48,
                          ),
                          Container(
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.6),
                            child: Flex(
                              direction: Axis.horizontal,
                              children: [
                                Flexible(
                                  child: TextFormField(
                                    textInputAction: TextInputAction.done,
                                    maxLines: 5,
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.only(
                                        left: 10,
                                        top: 20,
                                      ),
                                      hintText: '${local?.enterReason}',
                                      errorStyle: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    controller: reasonController,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        RaisedButton(
                          onPressed: () async {
                            if (_key.currentState!.validate()) {
                              record.LoanRecord loanRecord = record.LoanRecord(
                                  amount: doubleParse(amountController.text),
                                  reason: reasonController.text,
                                  date: pickStart);
                              await createLoan(_mySelection!, loanRecord);
                              amountController.text = '';
                              dateController.text = '';
                              reasonController.text = '';
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          LoanRecord(id: _mySelection!)));
                            }
                            // addLoan(_mySelection!);
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
                  ),
                ],
              ),
            ),
    );
  }

  createLoan(String id, record.LoanRecord record) async {
    await _loanService.createOneRecord(id, record);
  }
}
