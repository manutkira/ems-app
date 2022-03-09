// ignore_for_file: deprecated_member_use

import 'package:ems/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import '../../services/payroll.dart' as new_service;
import '../../services/models/payroll.dart' as new_model;

class ViewPayrollScreen extends StatefulWidget {
  int paymentId;
  ViewPayrollScreen({
    Key? key,
    required this.paymentId,
  }) : super(key: key);

  @override
  _ViewPayrollScreenState createState() => _ViewPayrollScreenState();
}

class _ViewPayrollScreenState extends State<ViewPayrollScreen> {
  // service
  final new_service.PayrollService _payrollService =
      new_service.PayrollService();

  //  payroll
  new_model.Payroll? payroll;

  // boolean
  bool _isLoading = true;
  bool pending = true;
  bool _isfolded = true;

  // variable
  String urlUser = "http://rest-api-laravel-flutter.herokuapp.com/api/users";

  fetchPayrollById() async {
    setState(() {
      _isLoading = true;
    });
    try {
      new_model.Payroll payrollDisplay =
          await _payrollService.findOne(widget.paymentId);
      if (mounted) {
        setState(() {
          payroll = payrollDisplay;
          _isLoading = false;
        });
      }
    } catch (err) {
      rethrow;
    }
  }

  updateStatus() async {
    try {
      await _payrollService.markAsPaid(widget.paymentId);
    } catch (err) {
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPayrollById();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? local = AppLocalizations.of(context);
    // bool isEnglish = isInEnglish(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('${local?.payment}'),
      ),
      body: Column(
        children: [
          _isLoading
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
              : Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 18, right: 25, top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${local?.payrollDate}',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${local?.from} ${DateFormat('dd-MM-yyyy').format(payroll!.dateFrom!)}',
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                '${local?.to} ${DateFormat('dd-MM-yyyy').format(payroll!.dateTo!)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 18, right: 25, top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${local?.status}',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            !payroll!.status!
                                ? '${local?.pending}'
                                : '${local?.paid}',
                            style: TextStyle(
                              color: !payroll!.status!
                                  ? Colors.orange
                                  : Colors.green,
                              fontSize: 16,
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
                          const EdgeInsets.only(left: 18, right: 25, top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${local?.dayOfWork}',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${payroll?.dayOfWork} ${local?.day}',
                            style: const TextStyle(
                              fontSize: 16,
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
                          const EdgeInsets.only(left: 18, right: 25, top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${local?.basicSalary}',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '\$${payroll?.salary}/${local?.day}',
                            style: const TextStyle(
                              fontSize: 16,
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
                          const EdgeInsets.only(left: 18, right: 25, top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${local?.loan}',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          AnimatedContainer(
                            duration: Duration(milliseconds: 400),
                            width: _isfolded ? 76 : 120,
                            height: _isfolded ? 30 : 56,
                            decoration: BoxDecoration(),
                            child: _isfolded
                                ? AnimatedContainer(
                                    duration: Duration(milliseconds: 400),
                                    child: RaisedButton(
                                      color: Colors.black,
                                      elevation: 10,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      onPressed: () {
                                        setState(() {
                                          _isfolded = !_isfolded;
                                        });
                                      },
                                      child: Text(
                                        '${local?.input}',
                                        style: TextStyle(
                                          color: kWhite,
                                        ),
                                      ),
                                    ),
                                  )
                                : Expanded(
                                    child: Container(
                                      padding: EdgeInsets.only(left: 16),
                                      child: !_isfolded
                                          ? TextField(
                                              decoration: InputDecoration(
                                                hintText: 'amount',
                                                hintStyle: TextStyle(),
                                                border: InputBorder.none,
                                              ),
                                            )
                                          : null,
                                    ),
                                  ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 18, right: 25, top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${local?.netSalary}',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '\$${payroll?.netSalary}',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          RaisedButton(
                            onPressed: () async {
                              await showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text('${local?.areYouSure}'),
                                  content: const Text('Do you want to pay?'),
                                  actions: [
                                    OutlineButton(
                                      onPressed: () async {
                                        await updateStatus();
                                        Navigator.of(context).pop();
                                        fetchPayrollById();
                                      },
                                      child: Text('${local?.yes}'),
                                      borderSide:
                                          const BorderSide(color: Colors.green),
                                    ),
                                    OutlineButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      borderSide:
                                          const BorderSide(color: Colors.red),
                                      child: Text('${local?.no}'),
                                    )
                                  ],
                                ),
                              );
                              fetchPayrollById();
                            },
                            child: Text('${local?.pay}'),
                          )
                        ],
                      ),
                    )
                  ],
                ),
        ],
      ),
    );
  }
}
