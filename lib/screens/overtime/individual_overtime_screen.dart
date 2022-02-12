import 'package:ems/constants.dart';
import 'package:ems/models/overtime.dart';
import 'package:ems/models/user.dart';
import 'package:ems/persistence/current_user.dart';
import 'package:ems/screens/overtime/delete_overtime.dart';
import 'package:ems/screens/overtime/edit_overtime.dart';
import 'package:ems/screens/overtime/view_overtime.dart';
import 'package:ems/screens/overtime/widgets/blank_panel.dart';
import 'package:ems/screens/overtime/widgets/drop_down_menu.dart';
import 'package:ems/screens/overtime/widgets/more_menu_item.dart';
import 'package:ems/utils/services/overtime_service.dart';
import 'package:ems/utils/utils.dart';
import 'package:ems/widgets/baseline_row.dart';
import 'package:ems/widgets/circle_avatar.dart';
import 'package:ems/widgets/statuses/error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class IndividualOvertimeScreen extends ConsumerStatefulWidget {
  const IndividualOvertimeScreen({Key? key, required this.user})
      : super(key: key);
  final User user;
  @override
  ConsumerState createState() => _IndividualOvertimeScreenState();
}

class _IndividualOvertimeScreenState
    extends ConsumerState<IndividualOvertimeScreen> {
  late User user;
  String error = '';
  String total = '00:00:00';
  final OvertimeService _overtimeService = OvertimeService.instance;
  String sortByValue = '';
  List<String> options = [];
  List<String> dropdownItems = [];

  List<OvertimeRecord> overtimeRecords = [];
  bool isFetching = false;
  bool isFilterExpanded = false;

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  /// more menu
  void handleMoreMenu(String value, OvertimeRecord record) async {
    AppLocalizations? local = AppLocalizations.of(context);
    if (value == local?.optionView) {
      await modalBottomSheetBuilder(
        context: context,
        maxHeight: MediaQuery.of(context).size.height * 0.55,
        minHeight: MediaQuery.of(context).size.height * 0.4,
        child: ViewOvertime(
          record: record,
        ),
      );
    }
    if (value == local?.optionEdit) {
      await modalBottomSheetBuilder(
        context: context,
        maxHeight: MediaQuery.of(context).size.height * 0.7,
        minHeight: MediaQuery.of(context).size.height * 0.6,
        isDismissible: false,
        child: EditOvertime(record: record),
      );
      fetchOvertimeRecord();
    }
    if (value == local?.optionDelete) {
      await modalBottomSheetBuilder(
        context: context,
        isDismissible: false,
        child: DeleteOvertime(record: record),
      );
      fetchOvertimeRecord();
    }
  }

  /// fetching data from service
  void fetchOvertimeRecord() async {
    AppLocalizations? local = AppLocalizations.of(context);
    int userId = widget.user.id ?? 0;
    setState(() {
      isFetching = true;
      isFilterExpanded = false;
      // resetting
      error = '';
      total = '00:00:00';
      overtimeRecords = [];
    });
    OvertimeListWithTotal records;
    try {
      if (sortByValue == "${local?.optionDay}") {
        records = await _overtimeService.findManyByUserId(
          userId: userId,
          start: startDate,
          end: startDate,
        );
      } else if (sortByValue == "${local?.optionMultiDay}") {
        records = await _overtimeService.findManyByUserId(
          userId: userId,
          start: startDate,
          end: endDate,
        );
      } else {
        records = await _overtimeService.findManyByUserId(userId: userId);
      }

      setState(() {
        total = records.total;
        overtimeRecords = records.listOfOvertime;
        if (overtimeRecords.isNotEmpty) {
          user = overtimeRecords[0].user as User;
        }
        isFetching = false;
      });
    } catch (err) {
      setState(() {
        error = err.toString();
        isFetching = false;
      });
    }
  }

  /// init fetch
  void initFetch() async {
    int userId = widget.user.id ?? 0;
    setState(() {
      isFetching = true;
      isFilterExpanded = false;
      // resetting
      error = '';
      total = '00:00:00';
      overtimeRecords = [];
    });
    OvertimeListWithTotal records;
    try {
      records = await _overtimeService.findManyByUserId(userId: userId);

      setState(() {
        total = records.total;
        overtimeRecords = records.listOfOvertime;
        if (overtimeRecords.isNotEmpty) {
          user = overtimeRecords[0].user as User;
        }
        isFetching = false;
      });
    } catch (err) {
      setState(() {
        error = err.toString();
        isFetching = false;
      });
    }
  }

  /// show/hide filter
  void _toggleFilter() {
    setState(() {
      isFilterExpanded = !isFilterExpanded;
    });
  }

  /// show filtered date range
  String filterRange() {
    AppLocalizations? local = AppLocalizations.of(context);
    if (sortByValue == '${local?.optionDay}') {
      return "${local?.from} ${getDateStringFromDateTime(startDate)}";
    } else if (sortByValue == '${local?.optionMultiDay}') {
      return "${local?.from} ${getDateStringFromDateTime(startDate)} ${local?.to} ${getDateStringFromDateTime(endDate)}";
    } else {
      return "${local?.allRecords}";
    }
  }

  init() {
    User _currentUser = ref.read(currentUserProvider).user;
    bool isAdmin = _currentUser.role?.toLowerCase() == 'admin';
    AppLocalizations? local = AppLocalizations.of(context);
    setState(() {
      if (sortByValue.isEmpty) {
        sortByValue = '${local?.optionAllTime}';
      }
      if (isAdmin) {
        options = [
          "${local?.optionView}",
          "${local?.optionEdit}",
          "${local?.optionDelete}",
        ];
      } else {
        options = [
          "${local?.optionView}",
        ];
      }
      dropdownItems = [
        '${local?.optionDay}',
        '${local?.optionMultiDay}',
        '${local?.optionAllTime}',
      ];
    });
  }

  @override
  void initState() {
    super.initState();
    user = widget.user;
    initFetch();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? local = AppLocalizations.of(context);
    init();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${local?.employeeOvertime}",
        ),
        // actions: [
        //   IconButton(
        //     onPressed: addUser,
        //     icon: const Icon(Icons.add),
        //   )
        // ],
      ),
      body: SafeArea(
        bottom: false,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // filter
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
                            '${local?.filter}',
                            style: kParagraph.copyWith(
                              fontSize: 18,
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
                              Text('${local?.dateRange}', style: kParagraph),
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
                            visible: sortByValue != '${local?.optionAllTime}',
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  sortByValue == '${local?.optionDay}'
                                      ? "${local?.date}"
                                      : '${local?.from}',
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
                                        await buildDateTimePicker(
                                      context: context,
                                      date: startDate,
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
                                      Text(
                                        getDateStringFromDateTime(startDate),
                                      ),
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
                            visible: sortByValue == '${local?.optionMultiDay}',
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${local?.to}', style: kParagraph),
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
                                      Text(
                                        getDateStringFromDateTime(endDate),
                                      ),
                                      const SizedBox(width: 10),
                                      const Icon(MdiIcons.calendar),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          /// GO BUTTON
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
                                      '${local?.go}',
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
              // user info card
              Container(
                padding: kPaddingAll,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  color: kDarkestBlue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _buildUserInfo,
              ),
              // date range card
              Visibility(
                visible: error.isEmpty,
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
                        '${local?.showing} ${filterRange()}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${local?.tapToShowHide}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // loading
              Visibility(
                visible: isFetching,
                child: Flexible(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      const CircularProgressIndicator(
                        color: Colors.white,
                      ),
                      const SizedBox(height: 10),
                      Text('${local?.loadingOvertime}...'),
                    ],
                  ),
                ),
              ),
              // error
              Visibility(
                visible: error.isNotEmpty && !isFetching,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      StatusError(text: error),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              // no record
              Visibility(
                visible: overtimeRecords.isEmpty && !isFetching,
                child: _noRecord,
              ),
              // results
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    fetchOvertimeRecord();
                  },
                  strokeWidth: 2,
                  backgroundColor: Colors.transparent,
                  displacement: 3 + 0,
                  color: kWhite,
                  child: ListView.builder(
                    itemCount: overtimeRecords.length,
                    itemBuilder: (context, i) {
                      return _buildListItem(i);
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

  /// no record
  Widget get _noRecord {
    AppLocalizations? local = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "🤷🏽‍",
            style: kHeadingOne.copyWith(fontSize: 100),
          ),
          Text('${local?.overtimeNotFound}', style: kParagraph),
        ],
      ),
    );
  }

  /// result widget
  Widget _buildListItem(int i) {
    OvertimeRecord record = overtimeRecords[i];
    AttendanceRecord? checkIn = record.checkIn;
    AttendanceRecord? checkout = record.checkOut;
    TimeOfDay _time = getTimeOfDayFromString(record.duration);

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
                getDateStringFromDateTime(record.date),
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
                color: kBlueText,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                icon: const Icon(MdiIcons.dotsVertical),
                itemBuilder: (BuildContext context) => options.map((option) {
                  return buildMoreMenu(option);
                }).toList(),
                onSelected: (selected) => handleMoreMenu(selected, record),
              ),
            ],
          )
        ],
      ),
    );
  }

  /// drop down menu for filter
  Widget get _buildDropdownMenu {
    return DropDownMenu(
      dropDownItems: dropdownItems,
      sortByValue: sortByValue,
      onChanged: (String? newValue) {
        if (sortByValue == newValue) return;
        setState(() {
          sortByValue = newValue as String;
        });
      },
    );
  }

  /// user info card
  Widget get _buildUserInfo {
    AppLocalizations? local = AppLocalizations.of(context);
    String placeholder = isFetching ? "${local?.loading}..." : "---";
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BaselineRow(
                  children: [
                    Text(
                      '${local?.id}',
                      style: kParagraph.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '${user.id ?? placeholder}',
                      style: kParagraph,
                    ),
                  ],
                ),
                BaselineRow(
                  children: [
                    Text(
                      '${local?.name}',
                      style: kParagraph.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(width: 10),
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
