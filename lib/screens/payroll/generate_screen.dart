import 'dart:convert';
import 'dart:ffi';

import 'package:ems/models/payroll.dart';
import 'package:ems/screens/payroll/view_payroll.dart';
import 'package:ems/utils/services/payroll_service.dart';
import 'package:ems/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart';

class GeneratePaymentScreen extends StatefulWidget {
  int id;
  GeneratePaymentScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  _GeneratePaymentScreenState createState() => _GeneratePaymentScreenState();
}

class _GeneratePaymentScreenState extends State<GeneratePaymentScreen> {
  // service
  final PayrollService _payrollService = PayrollService.instance;

  // list payroll
  List<Payment> payrollList = [];
  Payroll? payroll;

  // datetime
  final DateRangePickerController _datePickerController =
      DateRangePickerController();
  DateTime? startDate = DateTime.now();
  DateTime? endDate = DateTime.now();

  // boolean
  bool _isLoading = true;

  // variable
  String urlUser = "http://rest-api-laravel-flutter.herokuapp.com/api/users";
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  // fetch payroll from api
  fetchPaymentById() async {
    try {
      setState(() {
        _isLoading = true;
      });
      List<Payment> payrollDisplay =
          await _payrollService.findManyPayrollById(widget.id);
      if (mounted) {
        setState(() {
          payrollList = payrollDisplay;
          _isLoading = false;
        });
      }
    } catch (err) {
      rethrow;
    }
  }

  void showInSnackBar(String value, context) {
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

  Future deleteData(int id, context) async {
    AppLocalizations? local = AppLocalizations.of(context);
    final response = await http.delete(Uri.parse(
        "http://rest-api-laravel-flutter.herokuapp.com/api/payment/$id"));
    showInSnackBar("${local?.deletingPayment}", context);
    if (response.statusCode == 200) {
      fetchPaymentById();
      showInSnackBar("${local?.deletedPayment}", context);
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPaymentById();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Payroll'),
        ),
        body: _isLoading
            ? Container(
                padding: const EdgeInsets.only(top: 320),
                alignment: Alignment.center,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('${local?.fetchData}'),
                      const SizedBox(
                        height: 10,
                      ),
                      Image.asset(
                        'assets/images/Gear-0.5s-200px.gif',
                        width: 60,
                      )
                    ],
                  ),
                ),
              )
            : Builder(
                builder: (context) => SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Payroll List',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              // ignore: deprecated_member_use
                              child: RaisedButton(
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                color: kBlack,
                                child: const Text(
                                  'Generate New',
                                  style: TextStyle(),
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      content: SizedBox(
                                        height: 400,
                                        width: 400,
                                        child: SfDateRangePicker(
                                          todayHighlightColor: kBlueBackground,
                                          startRangeSelectionColor:
                                              Colors.green,
                                          endRangeSelectionColor: Colors.green,
                                          rangeSelectionColor: Colors.redAccent,
                                          view: DateRangePickerView.month,
                                          selectionMode:
                                              DateRangePickerSelectionMode
                                                  .extendableRange,
                                          showActionButtons: true,
                                          controller: _datePickerController,
                                          onSubmit: (p0) {
                                            setState(() {
                                              startDate = _datePickerController
                                                  .selectedRange?.startDate;
                                              endDate = _datePickerController
                                                  .selectedRange?.endDate;
                                              Navigator.of(context).pop();
                                              addPayment();
                                            });
                                          },
                                          onCancel: () {
                                            Navigator.pop(context);
                                            _datePickerController
                                                .selectedRange = null;
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Table(
                          columnWidths: const {
                            0: FlexColumnWidth(2),
                            1: FlexColumnWidth(3),
                          },
                          border:
                              TableBorder.all(width: 1, color: Colors.white),
                          children: payrollList.map<TableRow>((e) {
                            return TableRow(children: [
                              TableCell(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: e.status == false
                                            ? Colors.orange
                                            : Colors.green,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.8),
                                        child: Text(
                                          e.status == false
                                              ? 'Pending'
                                              : 'Paid',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, left: 10),
                                      child: Text(
                                        e.refNo,
                                      ),
                                    ),
                                  ],
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
                                      width: 150,
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '${local?.from}: ',
                                              ),
                                              Text(
                                                DateFormat('dd-MM-yyyy')
                                                    .format(e.dateFrom),
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
                                                '${local?.to}: ',
                                              ),
                                              Text(
                                                endDate == null
                                                    ? '${local?.now}'
                                                    : DateFormat('dd-MM-yyyy')
                                                        .format(e.dateTo),
                                              ),
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
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  onSelected: (int selectedValue) async {
                                    if (selectedValue == 0) {
                                      int paymentId = e.id;
                                      await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => ViewPayrollScreen(
                                                  paymentId: paymentId)));
                                      fetchPaymentById();
                                    }
                                    if (selectedValue == 1) {
                                      deleteData(e.id, context);
                                    }
                                  },
                                  itemBuilder: (_) => [
                                    PopupMenuItem(
                                      child: Text(
                                        '${local?.optionView}',
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
                                          fontSize: isEnglish ? 15 : 16,
                                        ),
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
                      const SizedBox(
                        height: 30,
                      )
                    ],
                  ),
                ),
              ));
  }

  addPayment() async {
    DateTime aStart = startDate!;
    DateTime aEnd = endDate!;

    var request = await http.MultipartRequest(
        'POST', Uri.parse("$urlUser/${widget.id}/payment"));
    Map<String, String> headers = {
      "Accept": "application/json",
      "Content": "charset-UTF-8",
    };
    request.files
        .add(http.MultipartFile.fromString('date_from', aStart.toString()));
    request.files
        .add(http.MultipartFile.fromString('date_to', aEnd.toString()));

    request.headers.addAll(headers);

    var res = await request.send();
    print(res.statusCode);
    if (res.statusCode == 201) {
      fetchPaymentById();
      _datePickerController.selectedRange = null;
    }
    res.stream.transform(utf8.decoder).listen((event) {});
  }
}
