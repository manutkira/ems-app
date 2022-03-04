// ignore_for_file: deprecated_member_use

import 'dart:convert';

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
import '../../services/payroll.dart' as new_service;
import '../../services/models/payment.dart' as new_model;

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
  final new_service.PayrollService _payrollService =
      new_service.PayrollService();

  // list payroll
  List<new_model.Payment> payrollList = [];
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

  // fetch payroll from api
  fetchPaymentById() async {
    try {
      setState(() {
        _isLoading = true;
      });
      List<new_model.Payment> payrollDisplay =
          await _payrollService.findManyPaymentsByUserId(widget.id);
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
    // bool isEnglish = isInEnglish(context);
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
                builder: (context) => Column(
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
                                        startRangeSelectionColor: Colors.green,
                                        endRangeSelectionColor: Colors.green,
                                        rangeSelectionColor: Colors.redAccent,
                                        view: DateRangePickerView.month,
                                        selectionMode:
                                            DateRangePickerSelectionMode
                                                .extendableRange,
                                        showActionButtons: true,
                                        controller: _datePickerController,
                                        onSubmit: (p0) async {
                                          setState(() {
                                            startDate = _datePickerController
                                                .selectedRange?.startDate;
                                            endDate = _datePickerController
                                                .selectedRange?.endDate;
                                          });
                                          Navigator.of(context).pop();
                                          if (startDate != null &&
                                              endDate != null) {
                                            await createOne(
                                                widget.id,
                                                startDate as DateTime,
                                                endDate as DateTime);
                                          }
                                          fetchPaymentById();
                                          _datePickerController.selectedRange =
                                              null;
                                        },
                                        onCancel: () {
                                          Navigator.pop(context);
                                          _datePickerController.selectedRange =
                                              null;
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
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                        child: ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        new_model.Payment record = payrollList[index];
                        return _buildPayment(context, record);
                      },
                      itemCount: payrollList.length,
                    )),
                    const SizedBox(
                      height: 30,
                    )
                  ],
                ),
              ));
  }

  Widget _buildPayment(context, new_model.Payment record) {
    AppLocalizations? local = AppLocalizations.of(context);
    // bool isEnglish = isInEnglish(context);
    return ExpansionTile(
      collapsedBackgroundColor: const Color(0xff254973),
      backgroundColor: const Color(0xff254973),
      textColor: Colors.white,
      iconColor: Colors.white,
      initiallyExpanded: false,
      title: Row(
        children: [
          Text(
            getDateStringFromDateTime(
                DateTime.parse(record.dateFrom.toString())),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: record.status == false ? Colors.orange : Colors.green,
            ),
            child: Padding(
              padding: const EdgeInsets.all(2.8),
              child: Text(
                record.status == false ? 'Pending' : 'Paid',
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
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
                    const Text('Ref no'),
                    Text(record.refNo!),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('From'),
                    Text(
                      DateFormat('dd-MM-yyyy')
                          .format(record.dateFrom as DateTime),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('To'),
                    Text(
                      DateFormat('dd-MM-yyyy')
                          .format(record.dateTo as DateTime),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    RaisedButton(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: kBlack,
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ViewPayrollScreen(paymentId: record.id!),
                          ),
                        );
                        payrollList = [];
                        fetchPaymentById();
                      },
                      child: const Text(
                        'View',
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    RaisedButton(
                      child: Text('Delete'),
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: Colors.red,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text('${local?.areYouSure}'),
                            content: Text('${local?.cannotUndone}'),
                            actions: [
                              OutlineButton(
                                onPressed: () async {
                                  await deleteData(record.id!, context);
                                  Navigator.of(context).pop();
                                  fetchPaymentById();
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
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  createOne(int id, DateTime dateFrom, DateTime dateTo) {
    _payrollService.createOnePayment(id, dateFrom: dateFrom, dateTo: dateTo);
  }
}
