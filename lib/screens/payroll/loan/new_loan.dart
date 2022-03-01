import 'dart:convert';

import 'package:ems/models/user.dart';
import 'package:ems/screens/payroll/loan/loan_record.dart';
import 'package:ems/utils/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:http/http.dart' as http;

import '../../../constants.dart';
import '../../../utils/utils.dart';

class NewLoanScreen extends StatefulWidget {
  const NewLoanScreen({Key? key}) : super(key: key);

  @override
  _NewLoanScreenState createState() => _NewLoanScreenState();
}

class _NewLoanScreenState extends State<NewLoanScreen> {
  // service
  UserService _userService = UserService.instance;

  // user list
  List<User> userList = [];

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
    } catch (err) {}
  }

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
      appBar: AppBar(
        title: Text('Loan'),
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
          : Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 30, top: 10, right: 17),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Username'),
                      SizedBox(
                        width: 255,
                        child: DropdownButtonFormField(
                          items: userList.map((item) {
                            return DropdownMenuItem(
                              child: Text(item.name.toString()),
                              value: item.id.toString(),
                            );
                          }).toList(),
                          hint: Text('select'),
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
                  padding: const EdgeInsets.all(0),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 25, right: 15, bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Date ',
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
                                child: SizedBox(
                                  height: 50,
                                  child: TextFormField(
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.only(left: 10),
                                      hintText: 'Enter Date',
                                      suffixIcon: IconButton(
                                          onPressed: () {
                                            _startDatePicker();
                                          },
                                          icon: const Icon(
                                            MdiIcons.calendar,
                                            color: Colors.white,
                                          )),
                                      errorStyle: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    controller: dateController,
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
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 25, right: 15, bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Amount',
                          style:
                              kParagraph.copyWith(fontWeight: FontWeight.bold),
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
                                child: SizedBox(
                                  height: 50,
                                  child: TextFormField(
                                    textInputAction: TextInputAction.next,
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.only(left: 10),
                                      hintText: 'Enter Amount',
                                      errorStyle: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    controller: amountController,
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
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 25, right: 15, bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Reason',
                          style:
                              kParagraph.copyWith(fontWeight: FontWeight.bold),
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
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.only(
                                      left: 10,
                                      top: 20,
                                    ),
                                    hintText: 'Enter Reason',
                                    errorStyle: TextStyle(
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
                        onPressed: () {
                          addLoan(_mySelection!);
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
    );
  }

  addLoan(String id) async {
    var aAmount = amountController.text;
    var aReason = reasonController.text;

    var request =
        await http.MultipartRequest('POST', Uri.parse("$urlUser/$id/loan"));
    Map<String, String> headers = {
      "Accept": "application/json",
      "Content": "charset-UTF-8",
    };
    if (pickStart != null) {
      request.files.add(http.MultipartFile.fromString('amount', aAmount));
      request.files.add(http.MultipartFile.fromString('reason', aReason));
      DateTime aDate = pickStart!;
      request.files
          .add(http.MultipartFile.fromString('date', aDate.toString()));
    }

    request.headers.addAll(headers);

    var res = await request.send();
    print(res.statusCode);
    if (res.statusCode == 201) {
      amountController.text = '';
      dateController.text = '';
      reasonController.text = '';
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => LoanRecord(id: _mySelection!)));
    }
    res.stream.transform(utf8.decoder).listen((event) {});
  }
}
