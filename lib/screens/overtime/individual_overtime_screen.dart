import 'package:ems/constants.dart';
import 'package:ems/models/menu_options.dart';
import 'package:ems/models/overtime.dart';
import 'package:ems/models/user.dart';
import 'package:ems/screens/overtime/delete_overtime.dart';
import 'package:ems/screens/overtime/edit_overtime.dart';
import 'package:ems/screens/overtime/view_overtime.dart';
import 'package:ems/screens/overtime/widgets/blank_panel.dart';
import 'package:ems/utils/services/overtime_service.dart';
import 'package:ems/utils/utils.dart';
import 'package:ems/widgets/circle_avatar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'add_overtime.dart';

class IndividualOvertimeScreen extends StatefulWidget {
  const IndividualOvertimeScreen({Key? key, required this.user})
      : super(key: key);
  final User user;
  @override
  State<IndividualOvertimeScreen> createState() =>
      _IndividualOvertimeScreenState();
}

class _IndividualOvertimeScreenState extends State<IndividualOvertimeScreen> {
  late User user;

  String total = '00:00:00';
  final OvertimeService _overtimeService = OvertimeService.instance;
  String sortByValue = 'All Time';
  var dropdownItems = [
    'Day',
    'Multiple Days',
    'All Time',
  ];

  List<OvertimeAttendance> overtimeRecords = [];
  bool isFetching = false;
  bool isFilterExpanded = false;

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  var options = [
    MenuOptions.view,
    MenuOptions.edit,
    MenuOptions.delete,
  ];

  void addUser() async {
    await modalBottomSheetBuilder(
      context: context,
      maxHeight: 640,
      isDismissible: false,
      child: const AddOvertime(),
    );
  }

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
          await modalBottomSheetBuilder(
            context: context,
            maxHeight: 620,
            minHeight: 520,
            isDismissible: false,
            child: const EditOvertime(),
          );
        }
        break;
      case "Delete":
        {
          await modalBottomSheetBuilder(
            context: context,
            isDismissible: false,
            child: const DeleteOvertime(),
          );
        }
        break;
      default:
        {
          return;
        }
    }
  }

  void fetchOvertimeRecord() async {
    int userId = widget.user.id ?? 0;
    setState(() {
      total = '00:00:00';
      isFetching = true;
      isFilterExpanded = false;
      overtimeRecords = [];
    });
    OvertimeListWithTotal records;
    try {
      switch (sortByValue) {
        case 'Day':
          {
            records = await _overtimeService.findManyByUserId(
              userId: userId,
              start: startDate,
              end: startDate,
            );
            break;
          }
        case 'Multiple Days':
          {
            records = await _overtimeService.findManyByUserId(
              userId: userId,
              start: startDate,
              end: endDate,
            );
            break;
          }
        default:
          {
            records = await _overtimeService.findManyByUserId(userId: userId);
            break;
          }
      }

      setState(() {
        print('from setstate ${records.total}');
        total = records.total;
        overtimeRecords = records.listOfOvertime;
        if (overtimeRecords.isNotEmpty) {
          user = overtimeRecords[0].user as User;
        }
        isFetching = false;
      });
    } catch (err) {
      setState(() {
        isFetching = false;
      });
      //
    }
  }

  void _toggleFilter() {
    setState(() {
      isFilterExpanded = !isFilterExpanded;
    });
  }

  @override
  void initState() {
    super.initState();
    user = widget.user;
    fetchOvertimeRecord();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Detailed Overtime",
        ),
        actions: [
          IconButton(
            onPressed: addUser,
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
              Container(
                padding: kPaddingAll,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  color: kDarkestBlue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _buildUserInfo,
              ),
              const SizedBox(height: 20),
              Visibility(
                visible: isFetching,
                child: Flexible(
                  child: Column(
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
              Visibility(
                visible: overtimeRecords.isEmpty && !isFetching,
                child: _noRecord,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: overtimeRecords.length,
                  itemBuilder: (context, i) {
                    return _buildListItem(i);
                  },
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

  Widget _buildListItem(int i) {
    OvertimeAttendance record = overtimeRecords[i];
    OvertimeCheckin? checkIn = record.checkin;
    OvertimeCheckout? checkout = record.checkout;
    TimeOfDay _time = getTimeOfDayFromString(checkout!.overtime);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 5,
      ),
      color: i % 2 == 0 ? kDarkestBlue : kBlue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const SizedBox(width: 20),
              Text(
                DateFormat('dd/MM/yyyy')
                    .format(checkIn?.date as DateTime)
                    .toString(),
                style: kSubtitle,
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
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  '${_time.hour}h ${_time.minute}mn',
                  style: kSubtitle.copyWith(color: kGreenText),
                ),
              ),
              const SizedBox(width: 10),
              PopupMenuButton<String>(
                padding: EdgeInsets.zero,
                elevation: 200,
                color: kDarkestBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                icon: const Icon(MdiIcons.dotsVertical),
                itemBuilder: (BuildContext context) => options.map((e) {
                  return PopupMenuItem<String>(
                    value: e,
                    child: Text(e),
                  );
                }).toList(),
                onSelected: (selected) => moreMenu(selected, record),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget get _buildUserInfo {
    String placeholder = isFetching ? "loading..." : "---";
    TimeOfDay _time = getTimeOfDayFromString(total);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CustomCircleAvatar(
              imageUrl: "${user.image}",
              size: 60,
            ),
            const SizedBox(width: 10),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ID',
                      style: kParagraph.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Name',
                      style: kParagraph.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${user.id ?? placeholder}',
                      style: kParagraph,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      user.name ?? placeholder,
                      style: kParagraph,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        const SizedBox(width: 10),
        Text('${_time.hour}h ${_time.minute}mn'),
      ],
    );
  }
}
