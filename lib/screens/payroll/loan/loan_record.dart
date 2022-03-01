// ignore_for_file: deprecated_member_use

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
  String id;
  LoanRecord({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  _LoanRecordState createState() => _LoanRecordState();
}

class _LoanRecordState extends State<LoanRecord> {
  // service
  final PayrollService _payrollService = PayrollService.instance;

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

  bottomSheet(function) {
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (_) {
          return Padding(
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
                    height: 20,
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
                      padding: const EdgeInsets.only(
                          left: 25, right: 15, bottom: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          onPressed: () => function,
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
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Loan'),
        actions: [
          IconButton(
            onPressed: () {
              MybottonSheet(
                () => addLoan(),
                context,
                isEnglish,
                local,
              );
            },
            icon: const Icon(Icons.add),
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
          : loanList.isEmpty
              ? Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 90,
                      ),
                      Text(
                        'No loan has been recorded yet!',
                        style: kHeadingTwo,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        '🤷🏼',
                        style: kHeadingTwo.copyWith(fontSize: 50),
                      )
                    ],
                  ),
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Row(
                        children: const [
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
                        itemBuilder: (contexxt, index) {
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

  Future<dynamic> MybottonSheet(Function function, BuildContext context,
      bool isEnglish, AppLocalizations? local) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (_) {
          return Padding(
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
                    height: 20,
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
                      padding: const EdgeInsets.only(
                          left: 25, right: 15, bottom: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            function();
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
        });
  }

  Widget _buildResult(Loan record, BuildContext context) {
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);
    return ExpansionTile(
      collapsedBackgroundColor: const Color(0xff254973),
      backgroundColor: const Color(0xff254973),
      textColor: Colors.white,
      iconColor: Colors.white,
      initiallyExpanded: false,
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
                    const Text(
                      'ID',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(record.id.toString()),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Amount',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('\$${record.amount}'),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
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
                        style: const TextStyle(height: 1.5),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    RaisedButton(
                      elevation: 10,
                      color: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      onPressed: () async {
                        int loanId = record.id;
                        amountController.text = record.amount;
                        dateController.text = DateFormat('dd-MM-yyyy')
                            .format(DateTime.tryParse(record.date.toString())!);
                        reasonController.text = record.reason;
                        pickStart = DateTime.tryParse(record.date!.toString());

                        await MybottonSheet(
                            () => editLoan(loanId), context, isEnglish, local);
                        amountController.text = '';
                        dateController.text = '';
                        reasonController.text = '';
                        fetchLoanById();
                      },
                      child: Text('Edit'),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    RaisedButton(
                      elevation: 10,
                      color: Colors.red,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Text('Delete'),
                      onPressed: () async {
                        int loanId = record.id;
                        await showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text('${local?.areYouSure}'),
                            content: Text('${local?.cannotUndone}'),
                            actions: [
                              OutlineButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  deleteData(loanId, context);
                                },
                                child: Text('${local?.yes}'),
                                borderSide:
                                    const BorderSide(color: Colors.green),
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
                        fetchLoanById();
                      },
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

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void showInSnackBar(String value, context) {
    _scaffoldKey.currentState!.showSnackBar(
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

  // delete position from api
  Future deleteData(int id, context) async {
    AppLocalizations? local = AppLocalizations.of(context);
    final response = await http.delete(Uri.parse(
        "http://rest-api-laravel-flutter.herokuapp.com/api/loan/$id"));
    showInSnackBar('${local?.deletingPosition}', context);
    if (response.statusCode == 200) {
      fetchLoanById();
      showInSnackBar('${local?.deletedPosition}', context);
    } else {
      return false;
    }
  }

  editLoan(int loanId) async {
    var aAmount = amountController.text;
    var aReason = reasonController.text;
    DateTime aDate = pickStart!;

    var request = await http.MultipartRequest(
        'POST',
        Uri.parse(
            "http://rest-api-laravel-flutter.herokuapp.com/api/loan/$loanId?_method=PUT"));
    Map<String, String> headers = {
      "Accept": "application/json",
      "Content": "charset-UTF-8",
    };

    request.files.add(http.MultipartFile.fromString('amount', aAmount));
    request.files.add(http.MultipartFile.fromString('reasons', aReason));

    if (pickStart != null) {
      DateTime aStartDate = pickStart as DateTime;
      request.files
          .add(http.MultipartFile.fromString('date', aDate.toString()));
    }

    request.headers.addAll(headers);

    var res = await request.send();
    print(res.statusCode);
    if (res.statusCode == 200) {
      Navigator.pop(context);
    }
    res.stream.transform(utf8.decoder).listen((event) {});
  }

  addLoan() async {
    var aAmount = amountController.text;
    var aReason = reasonController.text;

    var request = await http.MultipartRequest(
        'POST', Uri.parse("$urlUser/${widget.id}/loan"));
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
      Navigator.of(context).pop();
      amountController.text = '';
      dateController.text = '';
      reasonController.text = '';
      fetchLoanById();
    }
    res.stream.transform(utf8.decoder).listen((event) {});
  }
}
