import 'package:ems/constants.dart';
import 'package:ems/models/menu_options.dart';
import 'package:ems/models/overtime.dart';
import 'package:ems/models/user.dart';
import 'package:ems/screens/overtime/view_overtime.dart';
import 'package:ems/screens/overtime/widgets/blank_panel.dart';
import 'package:ems/utils/services/overtime_service.dart';
import 'package:ems/utils/utils.dart';
import 'package:ems/widgets/circle_avatar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'individual_overtime_screen.dart';

class OvertimeScreen extends StatefulWidget {
  const OvertimeScreen({Key? key}) : super(key: key);

  @override
  State<OvertimeScreen> createState() => _OvertimeScreenState();
}

class _OvertimeScreenState extends State<OvertimeScreen> {
  final OvertimeService _overtimeService = OvertimeService.instance;
  List<OvertimeByDay> overtimeRecords = [];
  String sortByValue = 'All Time';
  var dropdownItems = [
    'Day',
    'Multiple Days',
    'All Time',
  ];
  bool isFetching = false;
  bool isFilterExpanded = false;

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  void _toggleFilter() {
    setState(() {
      isFilterExpanded = !isFilterExpanded;
    });
  }

  void fetchOvertimeRecord() async {
    setState(() {
      isFetching = true;
      isFilterExpanded = false;
      // overtimeRecords = [];
    });
    List<OvertimeByDay> records = [];
    try {
      switch (sortByValue) {
        case 'Day':
          {
            records = await _overtimeService.findMany(
              start: startDate,
              end: startDate,
            );
            break;
          }
        case 'Multiple Days':
          {
            records = await _overtimeService.findMany(
              start: startDate,
              end: endDate,
            );
            break;
          }
        default:
          {
            records = await _overtimeService.findMany();
            break;
          }
      }

      // List<OvertimeByDay> list = await _overtimeService.findMany();
      // list.forEach((e) {
      //   // print(e.date);
      //   print(e.toString());
      // });

      setState(() {
        overtimeRecords = records;
        // total = records.total;
        // overtimeRecords = records.listOfOvertime;
        // if (overtimeRecords.isNotEmpty) {
        //   user = overtimeRecords[0].user as User;
        // }
        isFetching = false;
      });
    } catch (err) {
      setState(() {
        isFetching = false;
      });
      //
    }
  }

  DateTime selectedDate = DateTime.now();

  var options = [
    MenuOptions.view,
    MenuOptions.edit,
    MenuOptions.delete,
  ];

  void moreMenu(String value, OvertimeAttendance record) async {
    switch (value) {
      case "View":
        {
          await modalBottomSheetBuilder(
            context: context,
            maxHeight: 460,
            child: ViewOvertime(
              record: record,
            ),
          );
        }
        break;
      case "Edit":
        {
          // Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (context) =>
          //         const HomeScreen(),
          //   ),
          // );
        }
        break;
      case "Delete":
        {
          // Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (context) =>
          //         const HomeScreen(),
          //   ),
          // );
        }
        break;
      default:
        {
          return;
        }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchOvertimeRecord();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Overtime",
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Filter
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: _toggleFilter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Filter',
                            style: kParagraph.copyWith(
                              fontSize: 20,
                            ),
                          ),
                          Icon(
                              isFilterExpanded
                                  ? MdiIcons.chevronUp
                                  : MdiIcons.chevronDown,
                              size: 22),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: isFilterExpanded,
                      child: Column(
                        children: [
                          const SizedBox(height: 20),

                          /// SORT FILTER
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Sort by', style: kParagraph),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: kDarkestBlue,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: DropdownButton(
                                  borderRadius:
                                      const BorderRadius.all(kBorderRadius),
                                  dropdownColor: kDarkestBlue,
                                  underline: Container(),
                                  style: kParagraph.copyWith(
                                      fontWeight: FontWeight.bold),
                                  isDense: true,
                                  value: sortByValue,
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  items: dropdownItems.map((String items) {
                                    return DropdownMenuItem(
                                      value: items,
                                      child: Text(items),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    if (sortByValue == newValue) return;
                                    setState(() {
                                      sortByValue = newValue as String;
                                    });
                                    print('$sortByValue ${dropdownItems[0]}');
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),

                          /// FROM FILTER
                          Visibility(
                            visible: sortByValue != 'All Time',
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  sortByValue == 'Day' ? "Date" : 'From',
                                  style: kParagraph,
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    primary: Colors.white,
                                    textStyle: kParagraph,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    backgroundColor: kDarkestBlue,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(kBorderRadius),
                                    ),
                                  ),
                                  onPressed: () async {
                                    final DateTime? picked =
                                        await showDatePicker(
                                      context: context,
                                      initialDate: startDate,
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2025),
                                      locale: const Locale('km'),
                                      helpText: "Pick a date",
                                      errorFormatText: 'Enter valid date',
                                      errorInvalidText:
                                          'Enter date in valid range',
                                      fieldLabelText: 'Date',
                                      fieldHintText: 'Date/Month/Year',
                                    );
                                    if (picked != null && picked != startDate) {
                                      setState(() {
                                        startDate = picked;
                                      });
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(DateFormat('dd/MM/yyyy')
                                          .format(startDate)),
                                      const SizedBox(width: 10),
                                      const Icon(MdiIcons.calendar),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          /// TO FILTER
                          Visibility(
                            visible: sortByValue == 'Multiple Days',
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('To', style: kParagraph),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    primary: Colors.white,
                                    textStyle: kParagraph,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    backgroundColor: kDarkestBlue,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(kBorderRadius),
                                    ),
                                  ),
                                  onPressed: () async {
                                    final DateTime? picked =
                                        await showDatePicker(
                                      context: context,
                                      initialDate: endDate,
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2025),
                                      locale: const Locale('km'),
                                      helpText: "Pick a date",
                                      errorFormatText: 'Enter valid date',
                                      errorInvalidText:
                                          'Enter date in valid range',
                                      fieldLabelText: 'Date',
                                      fieldHintText: 'Date/Month/Year',
                                    );
                                    if (picked != null && picked != endDate) {
                                      setState(() {
                                        endDate = picked;
                                      });
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(DateFormat('dd/MM/yyyy')
                                          .format(endDate)),
                                      const SizedBox(width: 10),
                                      const Icon(MdiIcons.calendar),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 16),
                                  primary: Colors.white,
                                  textStyle: kParagraph,
                                  backgroundColor: Colors.black38,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(kBorderRadius),
                                  ),
                                ),
                                onPressed: fetchOvertimeRecord,
                                child: Row(
                                  children: [
                                    SizedBox(width: 8),
                                    Text(
                                      'Go',
                                      style: kParagraph.copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Icon(MdiIcons.chevronRight)
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: isFetching,
                child: Container(
                  margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * .35,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        CircularProgressIndicator(
                          color: Colors.white,
                        ),
                        SizedBox(height: 10),
                        Text('Fetching overtime records...'),
                      ],
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: overtimeRecords.isEmpty && !isFetching,
                child: _noRecord,
              ),
              // Visibility(
              //   visible: overtimeRecords.isNotEmpty,
              //   child: Expanded(
              //     child: ListView.builder(
              //       itemCount: overtimeRecords.length,
              //       itemBuilder: (context, i) {
              //         OvertimeByDay record = overtimeRecords[i];
              //         return Container(
              //           child: Text('hi'),
              //         );
              //       },
              //     ),
              //   ),
              //   // return Container(
              //   //   padding: const EdgeInsets.symmetric(
              //   //     horizontal: 15,
              //   //     vertical: 5,
              //   //   ),
              //   //   color: i % 2 == 0 ? kDarkestBlue : kBlue,
              //   //   child: Row(
              //   //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   //     children: [
              //   //       Row(
              //   //         children: [
              //   //           const CircleAvatar(),
              //   //           const SizedBox(
              //   //             width: 10,
              //   //           ),
              //   //           GestureDetector(
              //   //             onTap: () => Navigator.of(context).push(
              //   //               MaterialPageRoute(
              //   //                 builder: (context) =>
              //   //                     IndividualOvertimeScreen(
              //   //                   user: User(id: 1, name: 'Kira Manut'),
              //   //                 ),
              //   //               ),
              //   //             ),
              //   //             child: const SizedBox(
              //   //               width: 200,
              //   //               child: Text(
              //   //                 'Employee Name',
              //   //                 style: kSubtitle,
              //   //                 overflow: TextOverflow.fade,
              //   //                 softWrap: false,
              //   //                 maxLines: 1,
              //   //               ),
              //   //             ),
              //   //           ),
              //   //         ],
              //   //       ),
              //   //       Row(
              //   //         children: [
              //   //           Container(
              //   //             width: 50,
              //   //             alignment: Alignment.center,
              //   //             padding: const EdgeInsets.symmetric(
              //   //               horizontal: 10,
              //   //               vertical: 2,
              //   //             ),
              //   //             decoration: BoxDecoration(
              //   //               color: kGreenBackground,
              //   //               borderRadius: BorderRadius.circular(3),
              //   //             ),
              //   //             child: Text(
              //   //               '1h',
              //   //               style:
              //   //                   kSubtitle.copyWith(color: kGreenText),
              //   //             ),
              //   //           ),
              //   //           const SizedBox(width: 10),
              //   //           PopupMenuButton<String>(
              //   //             color: kDarkestBlue,
              //   //             shape: RoundedRectangleBorder(
              //   //               borderRadius: BorderRadius.circular(10),
              //   //             ),
              //   //             icon: const Icon(MdiIcons.dotsVertical),
              //   //             itemBuilder: (BuildContext context) =>
              //   //                 options.map((e) {
              //   //               return PopupMenuItem<String>(
              //   //                 value: e,
              //   //                 child: Text(e),
              //   //               );
              //   //             }).toList(),
              //   //             onSelected: moreMenu,
              //   //           ),
              //   //         ],
              //   //       )
              //   //     ],
              //   //   ),
              //   // );
              // ),

              // ...overtimeRecords.map(
              //   (record) {
              //     return Text(record.date.toIso8601String(),);
              //   },
              // ),
              Visibility(
                visible: !isFetching && overtimeRecords.isNotEmpty,
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: kDarkestBlue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Daily Overtime Records',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Tap on date to show/hide the record.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: !isFetching && overtimeRecords.isNotEmpty,
                child: Expanded(
                  child: ListView.builder(
                    itemCount: overtimeRecords.length,
                    itemBuilder: (context, i) {
                      OvertimeByDay record = overtimeRecords[i];
                      return ExpansionTile(
                        textColor: Colors.white,
                        iconColor: Colors.white,
                        initiallyExpanded: true,
                        title: Text(
                          getStringFromDateTime(record.date),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            itemCount: record.overtimes.length,
                            itemBuilder: (context, i) {
                              OvertimeAttendance overtime = record.overtimes[i];
                              User user = overtime.user as User;

                              TimeOfDay overtimeTotal = getTimeOfDayFromString(
                                overtime.checkout!.overtime,
                              );

                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 5,
                                ),
                                color: i % 2 == 0 ? kDarkestBlue : kBlue,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        CustomCircleAvatar(
                                          imageUrl: "${user.image}",
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        GestureDetector(
                                          onTap: () =>
                                              Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  IndividualOvertimeScreen(
                                                user: user,
                                              ),
                                            ),
                                          ),
                                          child: SizedBox(
                                            width: 120,
                                            child: Text(
                                              '${user.name}',
                                              style: kSubtitle,
                                              overflow: TextOverflow.fade,
                                              softWrap: false,
                                              maxLines: 1,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          width: 82,
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: kGreenBackground,
                                            borderRadius:
                                                BorderRadius.circular(3),
                                          ),
                                          child: Text(
                                            '${overtimeTotal.hour}h ${overtimeTotal.minute}mn',
                                            style: kSubtitle.copyWith(
                                                color: kGreenText),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        PopupMenuButton<String>(
                                          color: kDarkestBlue,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          icon:
                                              const Icon(MdiIcons.dotsVertical),
                                          itemBuilder: (BuildContext context) =>
                                              options.map((e) {
                                            return PopupMenuItem<String>(
                                              value: e,
                                              child: Text(e),
                                            );
                                          }).toList(),
                                          onSelected: (value) =>
                                              moreMenu(value, overtime),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget get _noRecord {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "🤷🏽‍",
            style: kHeadingOne.copyWith(fontSize: 100),
          ),
          const Text('No Record Found.', style: kParagraph),
        ],
      ),
    );
  }
}

// ListView.builder(
// shrinkWrap: true,
// physics: ClampingScrollPhysics(),
// itemCount: record.overtimes.length,
// itemBuilder: (context, i) {
// return Container(
// padding: const EdgeInsets.symmetric(
// horizontal: 15,
// vertical: 5,
// ),
// color: i % 2 == 0 ? kDarkestBlue : kBlue,
// child: Row(
// mainAxisAlignment:
// MainAxisAlignment.spaceBetween,
// children: [
// Row(
// children: [
// const CircleAvatar(),
// const SizedBox(
// width: 10,
// ),
// GestureDetector(
// onTap: () =>
// Navigator.of(context).push(
// MaterialPageRoute(
// builder: (context) =>
// IndividualOvertimeScreen(
// user: User(
// id: 1,
// name: 'Kira Manut'),
// ),
// ),
// ),
// child: const SizedBox(
// width: 200,
// child: Text(
// 'Employee Name',
// style: kSubtitle,
// overflow: TextOverflow.fade,
// softWrap: false,
// maxLines: 1,
// ),
// ),
// ),
// ],
// ),
// Row(
// children: [
// Container(
// width: 50,
// alignment: Alignment.center,
// padding:
// const EdgeInsets.symmetric(
// horizontal: 10,
// vertical: 2,
// ),
// decoration: BoxDecoration(
// color: kGreenBackground,
// borderRadius:
// BorderRadius.circular(3),
// ),
// child: Text(
// '1h',
// style: kSubtitle.copyWith(
// color: kGreenText),
// ),
// ),
// const SizedBox(width: 10),
// PopupMenuButton<String>(
// color: kDarkestBlue,
// shape: RoundedRectangleBorder(
// borderRadius:
// BorderRadius.circular(10),
// ),
// icon: const Icon(
// MdiIcons.dotsVertical),
// itemBuilder:
// (BuildContext context) =>
// options.map((e) {
// return PopupMenuItem<String>(
// value: e,
// child: Text(e),
// );
// }).toList(),
// onSelected: moreMenu,
// ),
// ],
// )
// ],
// ),
// );
// })
