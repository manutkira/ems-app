// ignore_for_file: deprecated_member_use, must_be_immutable

// import 'package:ems/models/loan.dart';
import 'package:ems/screens/attendances_api/widgets/attendance_info/attendance_info_name_id.dart';
import 'package:ems/screens/payroll/loan/loan_record.dart';
import 'package:ems/services/models/payment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../constants.dart';
import '../../../services/loan.dart' as new_service;
import '../../../services/models/loan.dart';

class LoanTotalIndividual extends StatefulWidget {
  int id;
  LoanTotalIndividual({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  _LoanTotalIndividualState createState() => _LoanTotalIndividualState();
}

class _LoanTotalIndividualState extends State<LoanTotalIndividual> {
  // service
  final new_service.LoanService _loanService = new_service.LoanService();

  // loan
  Loan? loan;
  List<Payment> loans = [];

  // boolean
  bool _isloading = true;

  // fetch loan from api
  fetchOneLoan() async {
    setState(() {
      _isloading = true;
    });
    try {
      Loan loanDIsplay = await _loanService.findOneLoanByUserId(widget.id);
      setState(() {
        loan = loanDIsplay;
        loans = loan!.user!.payment!
            .where((element) => element.loan != '0')
            .toList();
        _isloading = false;
      });
    } catch (err) {
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchOneLoan();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? local = AppLocalizations.of(context);
    // bool isEnglish = isInEnglish(context);
    return Scaffold(
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
          : Column(
              children: [
                Container(
                    margin: const EdgeInsets.only(top: 25),
                    padding: const EdgeInsets.all(15),
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                      color: kDarkestBlue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: AttendanceInfoNameId(
                        name: loan!.user!.name!,
                        id: loan!.user!.id.toString(),
                        image: loan!.user!.image.toString())),
                const SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${local?.totalAmount}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            '\$${loan!.amountTotal.toString()}',
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${local?.repay}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            '\$${loan!.repay.toString()}',
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${local?.remain}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            '\$${loan!.remain.toString()}',
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          RaisedButton(
                            color: Colors.black,
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      LoanRecord(id: loan!.user!.id.toString()),
                                ),
                              );
                              fetchOneLoan();
                            },
                            child: Text(
                              '${local?.viewRecord}',
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
