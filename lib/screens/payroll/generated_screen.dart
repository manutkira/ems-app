import 'package:ems/constants.dart';
import 'package:ems/screens/payroll/generate_screen.dart';
import 'package:ems/screens/payroll/loan/loan_record.dart';
import 'package:ems/screens/payroll/view_payroll.dart';
import 'package:ems/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../services/models/payment.dart';

class GeneratedScreen extends StatefulWidget {
  List<Payment>? payment;
  GeneratedScreen({
    Key? key,
    this.payment,
  }) : super(key: key);

  @override
  State<GeneratedScreen> createState() => _GeneratedScreenState();
}

class _GeneratedScreenState extends State<GeneratedScreen> {
  @override
  Widget build(BuildContext context) {
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'created',
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  'Payment List',
                  style: kHeadingThree,
                )
              ],
            ),
          ),
          Expanded(
              child: ListView.builder(
            itemBuilder: (context, index) {
              return ExpansionTile(
                collapsedBackgroundColor: const Color(0xff254973),
                backgroundColor: const Color(0xff254973),
                textColor: Colors.white,
                iconColor: Colors.white,
                initiallyExpanded: false,
                title: Row(
                  children: [
                    Text(
                      DateFormat('dd/MM/yyyy')
                          .format(widget.payment![index].dateFrom!),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: widget.payment![index].status == false
                            ? Colors.orange
                            : Colors.green,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2.8),
                        child: Text(
                          widget.payment![index].status == false
                              ? '${local?.pending}'
                              : '${local?.paid}',
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
                              Text(widget.payment![index].refNo!),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${local?.from}'),
                              Text(
                                DateFormat('dd-MM-yyyy').format(widget
                                    .payment![index].dateFrom as DateTime),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${local?.to}'),
                              Text(
                                DateFormat('dd-MM-yyyy').format(
                                    widget.payment![index].dateTo as DateTime),
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
                                      builder: (_) => GeneratePaymentScreen(
                                          id: widget.payment![index].userId!),
                                    ),
                                  );
                                  // payrollList = [];
                                  // fetchPaymentById();
                                },
                                child: Text(
                                  '${local?.optionView}',
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              // isAdmin
                              //     ? RaisedButton(
                              //         child: Text('${local?.delete}'),
                              //         elevation: 10,
                              //         shape: RoundedRectangleBorder(
                              //           borderRadius: BorderRadius.circular(10),
                              //         ),
                              //         color: Colors.red,
                              //         onPressed: () {
                              //           showDialog(
                              //             context: context,
                              //             builder: (ctx) => AlertDialog(
                              //               title: Text('${local?.areYouSure}'),
                              //               content: Text('${local?.cannotUndone}'),
                              //               actions: [
                              //                 OutlineButton(
                              //                   onPressed: () async {
                              //                     // deleteData(record.id!, context);
                              //                     Navigator.of(context).pop();
                              //                     // fetchPaymentById();
                              //                   },
                              //                   child: Text('${local?.yes}'),
                              //                   borderSide:
                              //                       const BorderSide(color: Colors.green),
                              //                 ),
                              //                 OutlineButton(
                              //                   onPressed: () {
                              //                     Navigator.of(context).pop();
                              //                   },
                              //                   borderSide:
                              //                       const BorderSide(color: Colors.red),
                              //                   child: Text('${local?.no}'),
                              //                 )
                              //               ],
                              //             ),
                              //           );
                              //         },
                              //       )
                              //     : Container(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
            itemCount: widget.payment!.length,
          ))
        ],
      ),
    );
  }
}
