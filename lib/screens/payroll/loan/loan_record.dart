import 'dart:convert';

import 'package:ems/utils/utils.dart';
import 'package:flutter/material.dart';

import 'package:ems/models/loan.dart';
import 'package:ems/utils/services/payroll_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:http/http.dart' as http;

import '../../../constants.dart';

class LoanRecord extends StatefulWidget {
  int id;
  LoanRecord({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  _LoanRecordState createState() => _LoanRecordState();
}

class _LoanRecordState extends State<LoanRecord> {
  // service
  PayrollService _payrollService = PayrollService.instance;

  // list laon
  List<Loan> loanList = [];

  // boolean
  bool _isLoading = true;

  // datetime
  DateTime? pickStart;

  // url
  String urlUser = "http://rest-api-laravel-flutter.herokuapp.com/api/users";

  // text controller
  TextEditingController amountController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController reasonController = TextEditingController();

  // fetch loan from api
  fetchLoanById() async {
    try {
      List<Loan> loanDisplay =
          await _payrollService.findManyLoanById(widget.id);
      if (mounted) {
        setState(() {
          _isLoading = true;
          loanList = loanDisplay;
          _isLoading = false;
        });
      }
    } catch (err) {
      rethrow;
    }
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
    fetchLoanById();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Loan'),
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (_) {
                    return Container(
                      height: 370,
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
                          Padding(
                            padding: const EdgeInsets.all(0),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 25, right: 15, bottom: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Date ',
                                    style: kParagraph.copyWith(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: isEnglish ? 36 : 29,
                                  ),
                                  Container(
                                    constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                                0.6),
                                    child: Flex(
                                      direction: Axis.horizontal,
                                      children: [
                                        Flexible(
                                          child: Container(
                                            height: 50,
                                            child: TextFormField(
                                              readOnly: true,
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.only(
                                                        left: 10),
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
                              padding: const EdgeInsets.only(
                                  left: 25, right: 15, bottom: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Amount',
                                    style: kParagraph.copyWith(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: isEnglish ? 52 : 48,
                                  ),
                                  Container(
                                    constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                                0.6),
                                    child: Flex(
                                      direction: Axis.horizontal,
                                      children: [
                                        Flexible(
                                          child: Container(
                                            height: 50,
                                            child: TextFormField(
                                              decoration: const InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.only(left: 10),
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
                              padding: const EdgeInsets.only(
                                  left: 25, right: 15, bottom: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Reason',
                                    style: kParagraph.copyWith(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: isEnglish ? 52 : 48,
                                  ),
                                  Container(
                                    constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                                0.6),
                                    child: Flex(
                                      direction: Axis.horizontal,
                                      children: [
                                        Flexible(
                                          child: TextFormField(
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
                                    addLoan();
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
                  });
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: _isLoading
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
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Row(
                    children: [
                      Text(
                        'Loan Record',
                        style: kHeadingTwo,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      Loan record = loanList[index];
                      return _buildResult(
                        record,
                        context,
                      );
                    },
                    itemCount: loanList.length,
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildResult(Loan record, BuildContext context) {
    AppLocalizations? local = AppLocalizations.of(context);

    return ExpansionTile(
      collapsedBackgroundColor: const Color(0xff254973),
      backgroundColor: const Color(0xff254973),
      textColor: Colors.white,
      iconColor: Colors.white,
      initiallyExpanded: true,
      title: Text(
        getDateStringFromDateTime(DateTime.parse(record.date.toString())),
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      children: [
        Container(
          color: Colors.black38,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 18,
              top: 10,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ID',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(record.id.toString()),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Amount',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('\$${record.amount}'),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Reason',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 150,
                      child: Text(
                        record.reason,
                        textAlign: TextAlign.end,
                        style: TextStyle(height: 1.5),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Repay',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(record.repay.toString()),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Remain',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      record.remain.toString(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  addLoan() async {
    var aAmount = amountController.text;
    var aReason = reasonController.text;
    DateTime aDate = pickStart!;

    var request = await http.MultipartRequest(
        'POST', Uri.parse("$urlUser/${widget.id}/loan"));
    Map<String, String> headers = {
      "Accept": "application/json",
      "Content": "charset-UTF-8",
    };
    request.files.add(http.MultipartFile.fromString('amount', aAmount));
    request.files.add(http.MultipartFile.fromString('reason', aReason));
    request.files.add(http.MultipartFile.fromString('date', aDate.toString()));

    request.headers.addAll(headers);

    var res = await request.send();
    print(res.statusCode);
    if (res.statusCode == 201) {
      Navigator.of(context).pop();
      fetchLoanById();
    }
    res.stream.transform(utf8.decoder).listen((event) {});
  }
}
