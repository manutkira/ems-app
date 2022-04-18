// ignore_for_file: deprecated_member_use

import 'package:ems/models/payroll.dart' as new_model;
import 'package:ems/persistence/current_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../services/payroll.dart' as new_service;

// ignore: must_be_immutable
class ViewPayrollScreen extends ConsumerStatefulWidget {
  int paymentId;
  ViewPayrollScreen({
    Key? key,
    required this.paymentId,
  }) : super(key: key);

  @override
  ConsumerState createState() => _ViewPayrollScreenState();
}

class _ViewPayrollScreenState extends ConsumerState<ViewPayrollScreen> {
  // service
  final new_service.PayrollService _payrollService =
      new_service.PayrollService();

  //  payroll
  new_model.Payroll? payroll;

  // boolean
  bool _isLoading = true;
  bool pending = true;

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

  updateStatus(String loan) async {
    try {
      await _payrollService.markAsPaid(widget.paymentId, loan);
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
    bool isAdmin = ref.read(currentUserProvider).isAdmin;
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
              ? _fetchingData(local)
              : Column(
                  children: [
                    _dateFrom(local),
                    const SizedBox(
                      height: 10,
                    ),
                    _dateTo(local),
                    _status(local),
                    const SizedBox(
                      height: 10,
                    ),
                    _dayOfWork(local),
                    const SizedBox(
                      height: 10,
                    ),
                    _basicSalary(local),
                    const SizedBox(
                      height: 10,
                    ),
                    _loan(local),
                    const SizedBox(
                      height: 10,
                    ),
                    _subtotal(local),
                    const SizedBox(
                      height: 10,
                    ),
                    _netSalary(local),
                    isAdmin ? _payBtn(context, local) : Container()
                  ],
                ),
        ],
      ),
    );
  }

// pay button
  Padding _payBtn(BuildContext context, AppLocalizations? local) {
    return Padding(
      padding: const EdgeInsets.all(28.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            onPressed: !payroll!.status!
                ? () async {
                    await showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text('${local?.areYouSure}'),
                        content: Text('${local?.doYouWantToPay}'),
                        actions: [
                          OutlineButton(
                            onPressed: () async {
                              await updateStatus(payroll!.repay.toString());
                              Navigator.of(context).pop();
                              fetchPayrollById();
                            },
                            child: Text('${local?.yes}'),
                            borderSide: const BorderSide(color: Colors.green),
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
                    fetchPayrollById();
                  }
                : null,
            child: Text('${local?.pay}'),
          )
        ],
      ),
    );
  }

// net salary of an employee
  Padding _netSalary(AppLocalizations? local) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 25, top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${local?.netSalary}',
            style: const TextStyle(
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
    );
  }

// subtotal of an employee
  Padding _subtotal(AppLocalizations? local) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 25, top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${local?.subtotal}',
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            '\$${payroll?.subtotal}',
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

// loan that employee has to pay back
  Padding _loan(AppLocalizations? local) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 25, top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${local?.repay}(\$${payroll?.loanTotal})',
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          // payroll!.status!
          Text('\$${payroll!.repay.toString()}')
          //  AnimatedContainer(
          //     duration: const Duration(milliseconds: 400),
          //     width: _isfolded ? 76 : 120,
          //     height: _isfolded ? 30 : 56,
          //     decoration: const BoxDecoration(),
          //     child: _isfolded
          //         ? AnimatedContainer(
          //             duration:
          //                 const Duration(milliseconds: 400),
          //             child: RaisedButton(
          //               color: Colors.black,
          //               elevation: 10,
          //               shape: RoundedRectangleBorder(
          //                   borderRadius:
          //                       BorderRadius.circular(10)),
          //               onPressed: () {
          //                 setState(() {
          //                   _isfolded = !_isfolded;
          //                 });
          //               },
          //               child: Text(
          //                 '${local?.input}',
          //                 style: const TextStyle(
          //                   color: kWhite,
          //                 ),
          //               ),
          //             ),
          //           )
          //         : Container(
          //             padding:
          //                 const EdgeInsets.only(left: 16),
          //             child: !_isfolded
          //                 ? Flex(
          //                     direction: Axis.horizontal,
          //                     children: [
          //                       Flexible(
          //                         child: TextField(
          //                           controller:
          //                               _loanController,
          //                           decoration:
          //                               InputDecoration(
          //                             hintText:
          //                                 '${local?.amount}',
          //                             border:
          //                                 InputBorder.none,
          //                           ),
          //                         ),
          //                       ),
          //                     ],
          //                   )
          //                 : null,
          //           ),
          //   )
        ],
      ),
    );
  }

// basic salary of an employee
  Padding _basicSalary(AppLocalizations? local) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 25, top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${local?.basicSalary}',
            style: const TextStyle(
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
    );
  }

// doy of work of an employee
  Padding _dayOfWork(AppLocalizations? local) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 25, top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${local?.dayOfWork}',
            style: const TextStyle(
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
    );
  }

// payment status
  Padding _status(AppLocalizations? local) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 25, top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${local?.status}',
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            !payroll!.status! ? '${local?.pending}' : '${local?.paid}',
            style: TextStyle(
              color: !payroll!.status! ? Colors.orange : Colors.green,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

// date that payment generated to
  Padding _dateTo(AppLocalizations? local) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 25, top: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${local?.to}',
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            DateFormat('dd-MM-yyyy').format(payroll!.dateTo!),
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

// date that payment generated from
  Padding _dateFrom(AppLocalizations? local) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 25, top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${local?.from}',
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            DateFormat('dd-MM-yyyy').format(payroll!.dateFrom!),
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

// fetching and loading widget
  Container _fetchingData(AppLocalizations? local) {
    return Container(
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
    );
  }
}
