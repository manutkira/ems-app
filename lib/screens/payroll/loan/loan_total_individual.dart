// ignore_for_file: deprecated_member_use

// import 'package:ems/models/loan.dart';
import 'package:ems/screens/payroll/loan/loan_record.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../constants.dart';
import '../../../utils/utils.dart';
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
        _isloading = false;
      });
    } catch (err) {}
  }

  @override
  void initState() {
    super.initState();
    fetchOneLoan();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loan'),
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
                  child: Row(
                    children: [
                      Container(
                        width: 65,
                        height: 65,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color: Colors.white,
                            width: 1,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(150),
                          child: Image.asset(
                            'assets/images/profile-icon-png-910.png',
                            width: 50,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Name: ',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(
                                width: 17,
                              ),
                              Text(
                                loan!.user!.name.toString(),
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'ID:',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(
                                width: 45,
                              ),
                              Text(
                                loan!.user!.id.toString(),
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Amount',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            '\$${loan!.amountTotal.toString()}',
                            style: TextStyle(
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
                            'Repay',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            '\$${loan!.repay.toString()}',
                            style: TextStyle(
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
                            'Remain',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            '\$${loan!.remain.toString()}',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
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
                            child: const Text(
                              'View Record',
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
