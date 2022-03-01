// ignore_for_file: deprecated_member_use

import 'package:ems/constants.dart';
import 'package:flutter/material.dart';

import 'package:ems/models/payroll.dart';
import 'package:ems/utils/services/payroll_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

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
  final PayrollService _payrollService = PayrollService.instance;

  //  payroll
  Payroll? payroll;

  // boolean
  bool _isLoading = true;
  bool pending = true;
  bool _isfolded = true;

  // variable
  String urlUser = "http://rest-api-laravel-flutter.herokuapp.com/api/users";

  fetchPayrollById() async {
    try {
      Payroll payrollDisplay =
          await _payrollService.findOnePayroll(paymentId: widget.paymentId);
      if (mounted) {
        setState(() {
          _isLoading = true;
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
      await _payrollService.updateStatus(widget.paymentId);
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
        title: const Text('Payroll'),
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
                          const Text(
                            'Date',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'From ${DateFormat('dd-MM-yyyy').format(payroll!.dateFrom)}',
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                'To ${DateFormat('dd-MM-yyyy').format(payroll!.dateTo)}',
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
                          const Text(
                            'Status',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            !payroll!.status ? 'Pending' : 'Paid',
                            style: TextStyle(
                              color: !payroll!.status
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
                          const Text(
                            'Day of works',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${payroll?.dayOfWork} days',
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
                          const Text(
                            'Basic salary',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '\$${payroll?.salary}/day',
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
                          const Text(
                            'Loan',
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
                                        'Input',
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
                          const Text(
                            'Net Salary',
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
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        updateStatus();
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
                            child: const Text('Pay'),
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
