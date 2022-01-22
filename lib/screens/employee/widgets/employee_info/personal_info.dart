import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:ems/models/bank.dart';
import 'package:ems/models/user.dart';
import 'package:ems/utils/utils.dart';
import 'package:ems/widgets/baseline_row.dart';

import '../../../../constants.dart';
import '../../employee_edit_screen.dart';

class PersonalInfo extends StatelessWidget {
  List<User> userDisplay;
  List<Bank> bankDisplay;

  List<User> user;
  final Function fetchUserById;
  final Function fetchBankData;
  PersonalInfo({
    Key? key,
    required this.userDisplay,
    required this.bankDisplay,
    required this.user,
    required this.fetchUserById,
    required this.fetchBankData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(
              left: 20,
              right: 10,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${local?.personal}',
                        style: TextStyle(
                          fontSize: 27,
                        ),
                      ),
                      IconButton(
                          onPressed: () async {
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => EmployeeEditScreen(
                                        userDisplay[0].id as int,
                                        userDisplay[0].name.toString(),
                                        userDisplay[0].phone.toString(),
                                        userDisplay[0].email.toString(),
                                        userDisplay[0].address.toString(),
                                        userDisplay[0].position.toString(),
                                        userDisplay[0].skill.toString(),
                                        userDisplay[0].salary.toString(),
                                        userDisplay[0].role.toString(),
                                        userDisplay[0].status.toString(),
                                        userDisplay[0].rate.toString(),
                                        userDisplay[0].background.toString(),
                                        userDisplay[0].image.toString(),
                                        userDisplay[0].imageId.toString())));
                            fetchUserById();
                          },
                          icon: Icon(Icons.edit)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BaselineRow(
                          children: [
                            Text(
                              '${local?.name} ',
                              style: kParagraph.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: isEnglish ? 80 : 90,
                            ),
                            Text(
                              userDisplay[0].name.toString(),
                              style: kParagraph.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: isEnglish ? 20 : 10,
                    ),
                    BaselineRow(
                      children: [
                        Text(
                          '${local?.id} ',
                          style: kParagraph.copyWith(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: isEnglish ? 110 : 80,
                        ),
                        Text(
                          userDisplay[0].id.toString(),
                          style: kParagraph.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: isEnglish ? 20 : 10,
                    ),
                    BaselineRow(
                      children: [
                        Text(
                          '${local?.email} ',
                          style: kParagraph.copyWith(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: isEnglish ? 85 : 90,
                        ),
                        SizedBox(
                          width: 210,
                          child: Text(
                            userDisplay[0].email.toString(),
                            style: kParagraph.copyWith(
                              color: Colors.white,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: isEnglish ? 20 : 10,
                    ),
                    BaselineRow(
                      children: [
                        Text(
                          '${local?.phoneNumber} ',
                          style: kParagraph.copyWith(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: isEnglish ? 80 : 62,
                        ),
                        Text(
                          userDisplay[0].phone.toString(),
                          style: kParagraph.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${local?.address} ',
                            style: kParagraph.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: isEnglish ? 50 : 50,
                          ),
                          SizedBox(
                            width: 220,
                            // height: 35,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 15,
                              ),
                              child: Text(
                                userDisplay[0].address == null
                                    ? '${local?.noData}'
                                    : userDisplay[0].address.toString(),
                                style: kParagraph.copyWith(
                                  color: Colors.white,
                                  height: 1.3,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${local?.background}: ',
                            style: kParagraph.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: isEnglish ? 16 : 46,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text(
                              userDisplay[0].background == null
                                  ? '${local?.noData}'
                                  : userDisplay[0].background.toString(),
                              style: kParagraph.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: 20,
              left: 20,
              right: 10,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Bank',
                        style: TextStyle(
                          fontSize: 27,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Center(
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.all(8),
                      itemCount: bankDisplay.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Container(
                                // decoration: BoxDecoration(
                                //   border: Border(
                                //     bottom: BorderSide(
                                //       width: 1,
                                //       color: Colors.black,
                                //     ),
                                //   ),
                                // ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(bankDisplay[index].bankName),
                                    Row(
                                      children: [
                                        Text(
                                            '${bankDisplay[index].accoutNumber.toString()}'),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        // IconButton(
                                        //   onPressed: () async {
                                        //     rateId = rateDisplay[index].id;
                                        //     skillNameController.text =
                                        //         rateDisplay[index].rateName;
                                        //     scoreController.text =
                                        //         rateDisplay[index].score;
                                        //     await showModalBottomSheet(
                                        //         context: context,
                                        //         builder: (_) {
                                        //           return Container(
                                        //             height: 340,
                                        //             decoration: const BoxDecoration(
                                        //               color: kBlue,
                                        //               borderRadius:
                                        //                   BorderRadius.only(
                                        //                 topRight:
                                        //                     Radius.circular(30),
                                        //                 topLeft:
                                        //                     Radius.circular(30),
                                        //               ),
                                        //             ),
                                        //             child: Column(
                                        //               children: [
                                        //                 SizedBox(
                                        //                   height: 20,
                                        //                 ),
                                        //                 Padding(
                                        //                   padding:
                                        //                       const EdgeInsets.all(
                                        //                           8.0),
                                        //                   child: Row(
                                        //                     children: [
                                        //                       Padding(
                                        //                         padding:
                                        //                             const EdgeInsets
                                        //                                     .only(
                                        //                                 left: 20,
                                        //                                 right: 20,
                                        //                                 bottom: 15),
                                        //                         child: Row(
                                        //                           mainAxisAlignment:
                                        //                               MainAxisAlignment
                                        //                                   .spaceBetween,
                                        //                           children: [
                                        //                             Text(
                                        //                               '${local?.skill} ',
                                        //                               style: kParagraph.copyWith(
                                        //                                   fontWeight:
                                        //                                       FontWeight
                                        //                                           .bold),
                                        //                             ),
                                        //                             SizedBox(
                                        //                               width:
                                        //                                   isEnglish
                                        //                                       ? 52
                                        //                                       : 50,
                                        //                             ),
                                        //                             Container(
                                        //                               constraints: BoxConstraints(
                                        //                                   maxWidth: MediaQuery.of(context)
                                        //                                           .size
                                        //                                           .width *
                                        //                                       0.6),
                                        //                               child: Flex(
                                        //                                 direction: Axis
                                        //                                     .horizontal,
                                        //                                 children: [
                                        //                                   Flexible(
                                        //                                     child:
                                        //                                         Container(
                                        //                                       height:
                                        //                                           35,
                                        //                                       child:
                                        //                                           TextFormField(
                                        //                                         decoration:
                                        //                                             InputDecoration(
                                        //                                           contentPadding: EdgeInsets.only(left: 10),
                                        //                                           hintText: '${local?.enterSkill}',
                                        //                                           errorStyle: TextStyle(
                                        //                                             fontSize: 15,
                                        //                                             fontWeight: FontWeight.bold,
                                        //                                           ),
                                        //                                         ),
                                        //                                         controller:
                                        //                                             skillNameController,
                                        //                                         // initialValue:
                                        //                                         //     rateDisplay[0][index]['skill_name'].toString(),
                                        //                                         // controller:
                                        //                                         //     rateNameController,
                                        //                                       ),
                                        //                                     ),
                                        //                                   ),
                                        //                                 ],
                                        //                               ),
                                        //                             ),
                                        //                           ],
                                        //                         ),
                                        //                       ),
                                        //                     ],
                                        //                   ),
                                        //                 ),
                                        //                 Padding(
                                        //                   padding:
                                        //                       const EdgeInsets.all(
                                        //                           8.0),
                                        //                   child: Row(
                                        //                     children: [
                                        //                       Padding(
                                        //                         padding:
                                        //                             const EdgeInsets
                                        //                                     .only(
                                        //                                 left: 20,
                                        //                                 right: 20,
                                        //                                 bottom: 15),
                                        //                         child: Row(
                                        //                           mainAxisAlignment:
                                        //                               MainAxisAlignment
                                        //                                   .spaceBetween,
                                        //                           children: [
                                        //                             Text(
                                        //                               '${local?.score} ',
                                        //                               style: kParagraph.copyWith(
                                        //                                   fontWeight:
                                        //                                       FontWeight
                                        //                                           .bold),
                                        //                             ),
                                        //                             SizedBox(
                                        //                               width:
                                        //                                   isEnglish
                                        //                                       ? 40
                                        //                                       : 70,
                                        //                             ),
                                        //                             Container(
                                        //                               constraints: BoxConstraints(
                                        //                                   maxWidth: MediaQuery.of(context)
                                        //                                           .size
                                        //                                           .width *
                                        //                                       0.6),
                                        //                               child: Flex(
                                        //                                 direction: Axis
                                        //                                     .horizontal,
                                        //                                 children: [
                                        //                                   Flexible(
                                        //                                     child:
                                        //                                         Container(
                                        //                                       height:
                                        //                                           35,
                                        //                                       child:
                                        //                                           TextFormField(
                                        //                                         decoration:
                                        //                                             InputDecoration(
                                        //                                           contentPadding: EdgeInsets.only(left: 10),
                                        //                                           hintText: '${local?.enterScore}',
                                        //                                           errorStyle: TextStyle(
                                        //                                             fontSize: 15,
                                        //                                             fontWeight: FontWeight.bold,
                                        //                                           ),
                                        //                                         ),
                                        //                                         controller:
                                        //                                             scoreController,
                                        //                                         // initialValue:
                                        //                                         //     rateDisplay[0][index]['score'].toString(),
                                        //                                       ),
                                        //                                     ),
                                        //                                   ),
                                        //                                 ],
                                        //                               ),
                                        //                             ),
                                        //                           ],
                                        //                         ),
                                        //                       ),
                                        //                     ],
                                        //                   ),
                                        //                 ),
                                        //                 SizedBox(
                                        //                   height: 20,
                                        //                 ),
                                        //                 Padding(
                                        //                   padding:
                                        //                       const EdgeInsets.only(
                                        //                           right: 30),
                                        //                   child: Row(
                                        //                     mainAxisAlignment:
                                        //                         MainAxisAlignment
                                        //                             .end,
                                        //                     children: [
                                        //                       RaisedButton(
                                        //                         onPressed: () {
                                        //                           editRate();
                                        //                         },
                                        //                         color: Theme.of(
                                        //                                 context)
                                        //                             .primaryColor,
                                        //                         child: Text(
                                        //                           '${local?.save}',
                                        //                           style: TextStyle(
                                        //                             fontSize: 15,
                                        //                             fontWeight:
                                        //                                 FontWeight
                                        //                                     .bold,
                                        //                           ),
                                        //                         ),
                                        //                       ),
                                        //                       SizedBox(
                                        //                         width: 15,
                                        //                       ),
                                        //                       RaisedButton(
                                        //                         onPressed: () {
                                        //                           Navigator.pop(
                                        //                               context);
                                        //                         },
                                        //                         color: Colors.red,
                                        //                         child: Text(
                                        //                           '${local?.cancel}',
                                        //                           style: TextStyle(
                                        //                             fontSize: 15,
                                        //                             fontWeight:
                                        //                                 FontWeight
                                        //                                     .bold,
                                        //                           ),
                                        //                         ),
                                        //                       ),
                                        //                     ],
                                        //                   ),
                                        //                 ),
                                        //               ],
                                        //             ),
                                        //           );
                                        //         });
                                        //     fetchBankData();
                                        //   },
                                        //   icon: Icon(
                                        //     Icons.edit,
                                        //     size: 20,
                                        //   ),
                                        // ),
                                        // IconButton(
                                        //     padding: EdgeInsets.only(left: 0),
                                        //     constraints: BoxConstraints(),
                                        //     onPressed: () async {
                                        //       await showDialog(
                                        //         context: context,
                                        //         builder: (ctx) => AlertDialog(
                                        //           title:
                                        //               Text('${local?.areYouSure}'),
                                        //           content: Text(
                                        //               '${local?.cannotUndone}'),
                                        //           actions: [
                                        //             OutlineButton(
                                        //               onPressed: () {
                                        //                 Navigator.of(context).pop();
                                        //                 deleteData(
                                        //                     rateDisplay[index].id);
                                        //               },
                                        //               child: Text('${local?.yes}'),
                                        //               borderSide: BorderSide(
                                        //                   color: Colors.green),
                                        //             ),
                                        //             OutlineButton(
                                        //               onPressed: () {
                                        //                 Navigator.of(context).pop();
                                        //               },
                                        //               borderSide: BorderSide(
                                        //                   color: Colors.red),
                                        //               child: Text('${local?.no}'),
                                        //             )
                                        //           ],
                                        //         ),
                                        //       );
                                        //       fetchBankData();
                                        //     },
                                        //     icon: Icon(
                                        //       Icons.delete,
                                        //       size: 20,
                                        //       color: Colors.red,
                                        //     )),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
