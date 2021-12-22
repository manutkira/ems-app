import 'package:ems/constants.dart';
import 'package:ems/models/menu_options.dart';
import 'package:ems/models/overtime.dart';
import 'package:ems/models/user.dart';
import 'package:ems/screens/overtime/view_overtime.dart';
import 'package:ems/screens/overtime/widgets/blank_panel.dart';
import 'package:ems/utils/services/overtime_service.dart';
import 'package:ems/utils/utils.dart';
import 'package:ems/widgets/circle_avatar.dart';
import 'package:ems/widgets/statuses/error.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'delete_overtime.dart';
import 'edit_overtime.dart';
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

  var options = [
    MenuOptions.view,
    MenuOptions.edit,
    MenuOptions.delete,
  ];

  String error = '';
  bool isFetching = false;
  bool isFilterExpanded = false;

  /// initializing dates
  DateTime selectedDate = DateTime.now();
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  /// toggles filter section
  void _toggleFilter() {
    setState(() {
      isFilterExpanded = !isFilterExpanded;
    });
  }

  /// fetches data from overtime service, set the received data to overtime record
  void fetchOvertimeRecord() async {
    setState(() {
      // shows loading
      isFetching = true;
      // closes filter
      isFilterExpanded = false;
      // reset overtime records
      overtimeRecords = [];
      // reset error
      error = '';
    });
    List<OvertimeByDay> records = [];
    try {
      // reads the sort filter condition
      switch (sortByValue) {
        // one day data
        case 'Day':
          {
            records = await _overtimeService.findMany(
              start: startDate,
              end: startDate,
            );
            break;
          }
        // multiple days data
        case 'Multiple Days':
          {
            records = await _overtimeService.findMany(
              start: startDate,
              end: endDate,
            );
            break;
          }
        // anything else, which in this case is All Time option
        default:
          {
            records = await _overtimeService.findMany();
            break;
          }
      }

      setState(() {
        // set newly received data to as overtime records
        overtimeRecords = records;
        // stop loading
        isFetching = false;
      });
    } catch (err) {
      setState(() {
        error = err.toString();
        isFetching = false;
      });
      //
    }
  }

  /// show filtered date range
  String filterRange() {
    switch (sortByValue) {
      case 'Day':
        {
          return "from ${getDateStringFromDateTime(startDate)}";
        }
      case 'Multiple Days':
        {
          return "from ${getDateStringFromDateTime(startDate)} to ${getDateStringFromDateTime(endDate)}";
        }
      default:
        {
          return "all records";
        }
    }
  }

  /// more menu
  void moreMenu(String value, OvertimeAttendance record) async {
    switch (value) {
      case "View":
        {
          await modalBottomSheetBuilder(
            context: context,
            maxHeight: MediaQuery.of(context).size.height * 0.55,
            minHeight: MediaQuery.of(context).size.height * 0.4,
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
            maxHeight: MediaQuery.of(context).size.height * 0.7,
            minHeight: MediaQuery.of(context).size.height * 0.6,
            isDismissible: false,
            child: EditOvertime(record: record),
          );
          fetchOvertimeRecord();
        }
        break;
      case "Delete":
        {
          await modalBottomSheetBuilder(
            context: context,
            isDismissible: false,
            child: DeleteOvertime(record: record),
          );
          fetchOvertimeRecord();
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
          "Overtime Manager",
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Filter
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
                            size: 22,
                          ),
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
                                child: _buildDropdownMenu,
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
                                    DateTime? picked =
                                        await buildDateTimePicker(
                                            context: context, date: startDate);
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
                                      Text(
                                          getDateStringFromDateTime(startDate)),
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
                                    DateTime? picked =
                                        await buildDateTimePicker(
                                      context: context,
                                      date: endDate,
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
                                      Text(getDateStringFromDateTime(endDate)),
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
                                    const SizedBox(width: 8),
                                    Text(
                                      'Go',
                                      style: kParagraph.copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const Icon(MdiIcons.chevronRight)
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
              // Loading
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
              // date range card
              Visibility(
                visible: !isFetching && error.isEmpty,
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: kDarkestBlue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Showing ${filterRange()}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Text(
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
              // no record
              Visibility(
                visible: overtimeRecords.isEmpty && !isFetching,
                child: _noRecord,
              ),
              // error
              Visibility(
                visible: error.isNotEmpty && !isFetching,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      StatusError(text: error),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              // result
              Visibility(
                visible: !isFetching && overtimeRecords.isNotEmpty,
                child: Expanded(
                  child: ListView.builder(
                    itemCount: overtimeRecords.length,
                    itemBuilder: (context, i) {
                      OvertimeByDay record = overtimeRecords[i];
                      // title date
                      return _buildResult(record);
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

  /// result
  Widget _buildResult(OvertimeByDay record) {
    return ExpansionTile(
      textColor: Colors.white,
      iconColor: Colors.white,
      initiallyExpanded: true,
      title: Text(
        getDateStringFromDateTime(record.date),
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

            // list of overtime
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
                      CustomCircleAvatar(
                        imageUrl: "${user.image}",
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => IndividualOvertimeScreen(
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
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Text(
                          '${overtimeTotal.hour}h ${overtimeTotal.minute}mn',
                          style: kSubtitle.copyWith(
                            fontSize: 12,
                            color: kGreenText,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      PopupMenuButton<String>(
                        color: kDarkestBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        icon: const Icon(MdiIcons.dotsVertical),
                        itemBuilder: (BuildContext context) {
                          return options.map((option) {
                            return _buildMoreMenu(option);
                          }).toList();
                        },
                        onSelected: (value) => moreMenu(value, overtime),
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
  }

  /// more menu
  PopupMenuEntry<String> _buildMoreMenu(String option) {
    return PopupMenuItem<String>(
      height: 24,
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
      ),
      value: option,
      child: Text(
        option,
        style: const TextStyle(
          fontSize: 14,
        ),
      ),
    );
  }

  /// drop down menu for filter
  Widget get _buildDropdownMenu {
    return DropdownButton(
      borderRadius: const BorderRadius.all(kBorderRadius),
      dropdownColor: kDarkestBlue,
      underline: Container(),
      style: kParagraph.copyWith(fontWeight: FontWeight.bold),
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
      },
    );
  }

  /// no record
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
