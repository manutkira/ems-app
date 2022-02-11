import 'dart:convert';
import 'dart:developer';

import 'package:ems/models/position.dart';
import 'package:http/http.dart' as http;
import 'package:ems/screens/card/card.screen.dart';
import 'package:ems/utils/services/position_service.dart';
import 'package:ems/utils/utils.dart';
import 'package:ems/widgets/baseline_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../../../constants.dart';

class TestPosition extends StatefulWidget {
  final String imageUrl;
  final String name;
  final int id;

  TestPosition({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.id,
  }) : super(key: key);

  @override
  State<TestPosition> createState() => _TestPositionState();
}

class _TestPositionState extends State<TestPosition> {
  String urlUser = "http://rest-api-laravel-flutter.herokuapp.com/api/users";
  bool table = false;
  final PositionService _rateService = PositionService.instance;
  List positionDisplay = [];
  DateTime? startDate;
  DateTime? endDate;
  bool _isLoading = true;
  TextEditingController positionName = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  DateTime? pickStart;
  DateTime? pickEnd;
  int? positionId;

  void _startDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    ).then((picked) {
      if (picked == null) {
        return;
      }
      setState(() {
        pickStart = picked;
        startDateController.text = DateFormat('dd-MM-yyyy').format(pickStart!);
        // pick = true;
      });
    });
  }

  void _endDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    ).then((picked) {
      if (picked == null) {
        return;
      }
      setState(() {
        pickEnd = picked;
        endDateController.text = DateFormat('dd-MM-yyyy').format(pickEnd!);
        // pick = true;
      });
    });
  }

  fetchPosition() {
    try {
      _isLoading = true;
      _rateService.findOne(widget.id).then((usersFromServer) {
        if (mounted) {
          setState(() {
            positionDisplay = [];
            positionDisplay.add(usersFromServer);
            _isLoading = false;
          });
        }
      });
    } catch (err) {}
  }

  final PositionServices _positionServices = PositionServices.instance;
  List<Position> positionsDisplay = [];

  fetchPositions() {
    try {
      _isLoading = true;
      _positionServices.findOne(widget.id).then((usersFromServer) {
        if (mounted) {
          setState(() {
            positionsDisplay = [];
            positionsDisplay.addAll(usersFromServer);
            _isLoading = false;
          });
        }
      });
    } catch (err) {}
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void showInSnackBar(String value) {
    _scaffoldKey.currentState!.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: Duration(milliseconds: 2000),
        backgroundColor: kBlueBackground,
        content: Text(
          value,
          style: kHeadingFour.copyWith(color: Colors.black),
        ),
      ),
    );
  }

  Future deleteData(int id) async {
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);
    final response = await http.delete(Uri.parse(
        "http://rest-api-laravel-flutter.herokuapp.com/api/position/$id"));
    showInSnackBar("${local!.deletingAttendance}");
    if (response.statusCode == 200) {
      fetchPositions();
      showInSnackBar("${local.deletedAttendance}");
    } else {
      return false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchPosition();
    fetchPositions();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('${local!.position}'),
        actions: [
          IconButton(
            onPressed: () async {
              await showModalBottomSheet(
                  context: context,
                  builder: (_) {
                    return Container(
                      height: 340,
                      decoration: const BoxDecoration(
                        color: kBlue,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30),
                          topLeft: Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${local.position} ',
                                      style: kParagraph.copyWith(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: isEnglish ? 52 : 56,
                                    ),
                                    Container(
                                      constraints: BoxConstraints(
                                          maxWidth: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.6),
                                      child: Flex(
                                        direction: Axis.horizontal,
                                        children: [
                                          Flexible(
                                            child: Container(
                                              height: 45,
                                              child: TextFormField(
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.only(left: 10),
                                                  hintText:
                                                      '${local.enterPosition}',
                                                  errorStyle: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                controller: positionName,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 30, left: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${local.startDate} ',
                                  style: kParagraph.copyWith(
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Container(
                                  constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.6),
                                  child: Flex(
                                    direction: Axis.horizontal,
                                    children: [
                                      Flexible(
                                        child: TextFormField(
                                          readOnly: true,
                                          decoration: InputDecoration(
                                            hintText:
                                                '${local.selectStartDate}',
                                            suffixIcon: IconButton(
                                                onPressed: () {
                                                  _startDatePicker();
                                                },
                                                icon: const Icon(
                                                    MdiIcons.calendar,
                                                    color: Colors.white)),
                                            errorStyle: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          controller: startDateController,
                                          textInputAction: TextInputAction.next,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 30, left: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${local.endDate} ',
                                  style: kParagraph.copyWith(
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Container(
                                  constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.6),
                                  child: Flex(
                                    direction: Axis.horizontal,
                                    children: [
                                      Flexible(
                                        child: TextFormField(
                                          readOnly: true,
                                          decoration: InputDecoration(
                                            hintText: '${local.selectEndDate}',
                                            suffixIcon: IconButton(
                                                onPressed: () {
                                                  _endDatePicker();
                                                },
                                                icon: const Icon(
                                                  MdiIcons.calendar,
                                                  color: Colors.white,
                                                )),
                                            errorStyle: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          controller: endDateController,
                                          textInputAction: TextInputAction.next,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                RaisedButton(
                                  onPressed: () {
                                    addPosition();
                                    // Navigator.pop(context);
                                    positionName.text = '';
                                    startDateController.text = '';
                                    endDateController.text = '';
                                  },
                                  color: Theme.of(context).primaryColor,
                                  child: Text(
                                    '${local.save}',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                RaisedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  color: Colors.red,
                                  child: Text(
                                    '${local.cancel}',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  });
              fetchPositions();
            },
            icon: Icon(
              Icons.add,
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${local.fetchData}'),
                  const CircularProgressIndicator(
                    color: kWhite,
                  ),
                ],
              ),
            )
          : ListView(
              children: [
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 19, right: 20, bottom: 20),
                  child: Container(
                    margin: EdgeInsets.only(top: 0),
                    padding: EdgeInsets.only(
                        top: 20, bottom: 20, right: 16, left: 30),
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                      color: kDarkestBlue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 75,
                          height: 75,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100)),
                              border: Border.all(
                                width: 1,
                                color: Colors.white,
                              )),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(150),
                            child: widget.imageUrl == 'null'
                                ? Image.asset(
                                    'assets/images/profile-icon-png-910.png',
                                    width: 70,
                                  )
                                : Image.network(
                                    widget.imageUrl.toString(),
                                    height: 70,
                                  ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BaselineRow(
                              children: [
                                Text(
                                  '${local.name} : ',
                                  style: kParagraph.copyWith(
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                SizedBox(
                                  width: 130,
                                  child: Text(widget.name.toString()),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            BaselineRow(
                              children: [
                                Text(
                                  '${local.id} : ',
                                  style: kParagraph.copyWith(
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(widget.id.toString()),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 30, left: 10, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${local.positionRecord}',
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            table = !table;
                          });
                        },
                        child: Row(
                          children: [
                            Text(
                                table ? '${local.timeline}' : '${local.table}'),
                            const SizedBox(
                              width: 5,
                            ),
                            Icon(
                              table ? MdiIcons.timeline : MdiIcons.table,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                !table
                    ? ListView.builder(
                        // reverse: true,
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          startDate =
                              DateTime.parse(positionsDisplay[index].startDate);
                          endDate = DateTime.tryParse(
                              positionsDisplay[index].endDate.toString());
                          return Stack(
                            children: [
                              Positioned(
                                top: 50.0,
                                right: -4,
                                child: PopupMenuButton(
                                  color: kBlack,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  onSelected: (int selectedValue) async {
                                    if (selectedValue == 0) {
                                      positionId = positionsDisplay[index].id;
                                      positionName.text =
                                          positionsDisplay[index].positionName;
                                      startDateController.text =
                                          DateFormat('dd-MM-yyyy').format(
                                              DateTime.tryParse(
                                                  positionsDisplay[index]
                                                      .startDate)!);
                                      endDateController.text =
                                          positionsDisplay[index].endDate ==
                                                  null
                                              ? 'Null'
                                              : DateFormat('dd-MM-yyyy').format(
                                                  DateTime.tryParse(
                                                      positionsDisplay[index]
                                                          .endDate
                                                          .toString())!);
                                      pickStart = DateTime.tryParse(
                                          positionsDisplay[index].startDate);
                                      if (positionsDisplay[index].endDate !=
                                          null) {
                                        pickEnd = DateTime.tryParse(
                                            positionsDisplay[index]
                                                .endDate
                                                .toString());
                                      }
                                      await showModalBottomSheet(
                                          context: context,
                                          builder: (_) {
                                            return Container(
                                              height: 340,
                                              decoration: const BoxDecoration(
                                                color: kBlue,
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(30),
                                                  topLeft: Radius.circular(30),
                                                ),
                                              ),
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 20,
                                                                  right: 20,
                                                                  bottom: 15),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                '${local.position} ',
                                                                style: kParagraph.copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              SizedBox(
                                                                width: isEnglish
                                                                    ? 52
                                                                    : 48,
                                                              ),
                                                              Container(
                                                                constraints: BoxConstraints(
                                                                    maxWidth: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.6),
                                                                child: Flex(
                                                                  direction: Axis
                                                                      .horizontal,
                                                                  children: [
                                                                    Flexible(
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            40,
                                                                        child:
                                                                            TextFormField(
                                                                          decoration:
                                                                              InputDecoration(
                                                                            contentPadding:
                                                                                EdgeInsets.only(left: 10),
                                                                            hintText:
                                                                                '${local.enterPosition}',
                                                                            errorStyle:
                                                                                TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                          ),
                                                                          controller:
                                                                              positionName,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 20,
                                                                  right: 20,
                                                                  bottom: 15),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                '${local.startDate} ',
                                                                style: kParagraph.copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              SizedBox(
                                                                width: isEnglish
                                                                    ? 40
                                                                    : 29,
                                                              ),
                                                              Container(
                                                                constraints: BoxConstraints(
                                                                    maxWidth: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.6),
                                                                child: Flex(
                                                                  direction: Axis
                                                                      .horizontal,
                                                                  children: [
                                                                    Flexible(
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            50,
                                                                        child:
                                                                            TextFormField(
                                                                          readOnly:
                                                                              true,
                                                                          decoration:
                                                                              InputDecoration(
                                                                            contentPadding:
                                                                                EdgeInsets.only(left: 10),
                                                                            hintText:
                                                                                '${local.selectEndDate}',
                                                                            suffixIcon: IconButton(
                                                                                onPressed: () {
                                                                                  _startDatePicker();
                                                                                },
                                                                                icon: const Icon(
                                                                                  MdiIcons.calendar,
                                                                                  color: Colors.white,
                                                                                )),
                                                                            errorStyle:
                                                                                const TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                          ),
                                                                          controller:
                                                                              startDateController,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 20,
                                                                  right: 20,
                                                                  bottom: 15),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                '${local.endDate} ',
                                                                style: kParagraph.copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              SizedBox(
                                                                width: isEnglish
                                                                    ? 40
                                                                    : 45,
                                                              ),
                                                              Container(
                                                                constraints: BoxConstraints(
                                                                    maxWidth: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.6),
                                                                child: Flex(
                                                                  direction: Axis
                                                                      .horizontal,
                                                                  children: [
                                                                    Flexible(
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            50,
                                                                        child:
                                                                            TextFormField(
                                                                          readOnly:
                                                                              true,
                                                                          decoration:
                                                                              InputDecoration(
                                                                            contentPadding:
                                                                                EdgeInsets.only(left: 10),
                                                                            hintText:
                                                                                '${local.selectEndDate}',
                                                                            suffixIcon: IconButton(
                                                                                onPressed: () {
                                                                                  _endDatePicker();
                                                                                },
                                                                                icon: const Icon(
                                                                                  MdiIcons.calendar,
                                                                                  color: Colors.white,
                                                                                )),
                                                                            errorStyle:
                                                                                const TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                          ),
                                                                          controller:
                                                                              endDateController,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 30),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        RaisedButton(
                                                          onPressed: () {
                                                            editPosition();
                                                          },
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          child: Text(
                                                            '${local.save}',
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 15,
                                                        ),
                                                        RaisedButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          color: Colors.red,
                                                          child: Text(
                                                            '${local.cancel}',
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          });
                                      positionName.text = '';
                                      startDateController.text = '';
                                      endDateController.text = '';
                                      fetchPositions();
                                    }
                                    if (selectedValue == 1) {
                                      positionId = positionsDisplay[index].id;
                                      await showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: Text('${local.areYouSure}'),
                                          content:
                                              Text('${local.cannotUndone}'),
                                          actions: [
                                            OutlineButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                deleteData(positionId!);
                                              },
                                              child: Text('${local.yes}'),
                                              borderSide: BorderSide(
                                                  color: Colors.green),
                                            ),
                                            OutlineButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              borderSide:
                                                  BorderSide(color: Colors.red),
                                              child: Text('${local.no}'),
                                            )
                                          ],
                                        ),
                                      );
                                      fetchPosition();
                                    }
                                  },
                                  itemBuilder: (_) => [
                                    PopupMenuItem(
                                      child: Text(
                                        '${local.edit}',
                                        style: TextStyle(
                                          fontSize: isEnglish ? 15 : 16,
                                        ),
                                      ),
                                      value: 0,
                                    ),
                                    PopupMenuItem(
                                      child: Text(
                                        '${local.delete}',
                                        style: TextStyle(
                                            fontSize: isEnglish ? 15 : 16),
                                      ),
                                      value: 1,
                                    ),
                                  ],
                                  icon: Icon(Icons.more_vert),
                                ),
                              ),
                              Positioned(
                                top: 50.0,
                                left: 11.0,
                                child: Text(
                                  DateFormat('dd-MM-yyyy').format(startDate!),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 130.0),
                                child: Card(
                                  margin: EdgeInsets.all(20.0),
                                  child: Container(
                                    width: 200,
                                    height: 110.0,
                                    decoration: BoxDecoration(
                                      color: kDarkestBlue,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            positionsDisplay[index]
                                                .positionName,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  '${local.from}:',
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 5),
                                                  child: Text(
                                                    DateFormat('dd-MM-yyyy')
                                                        .format(startDate!),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: isEnglish ? 8 : 0,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  '${local.to}:',
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 5),
                                                  child: Text(
                                                    endDate == null
                                                        ? '${local.now}'
                                                        : DateFormat(
                                                                'dd-MM-yyyy')
                                                            .format(endDate
                                                                as DateTime),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0.0,
                                bottom: 0.0,
                                left: 120.0,
                                child: Container(
                                  height: double.infinity,
                                  width: 1.0,
                                  color: Colors.blue,
                                ),
                              ),
                              Positioned(
                                top: 50.0,
                                left: 110.0,
                                child: Container(
                                  height: 20.0,
                                  width: 20.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  child: Container(
                                    margin: new EdgeInsets.all(5.0),
                                    height: 30.0,
                                    width: 30.0,
                                    decoration: new BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.red),
                                  ),
                                ),
                              )
                            ],
                          );
                        },
                        itemCount: positionsDisplay.length,
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Table(
                          columnWidths: {
                            0: FlexColumnWidth(2),
                            1: FlexColumnWidth(4),
                          },
                          border:
                              TableBorder.all(width: 1, color: Colors.white),
                          children: positionsDisplay.map<TableRow>((e) {
                            startDate = DateTime.parse(e.startDate);
                            endDate = DateTime.tryParse(e.endDate.toString());
                            return TableRow(children: [
                              TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.all(13.0),
                                    child: Text(
                                      e.positionName,
                                      textAlign: TextAlign.center,
                                    ),
                                  )),
                              TableCell(
                                  child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 13, bottom: 13, left: 8, right: 2),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 190,
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '${local.from}: ',
                                              ),
                                              Text(
                                                DateFormat('dd-MM-yyyy')
                                                    .format(startDate!),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: isEnglish ? 15 : 4,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '${local.to}: ',
                                              ),
                                              Text(
                                                endDate == null
                                                    ? '${local.now}'
                                                    : DateFormat('dd-MM-yyyy')
                                                        .format(endDate!),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                              TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: IconButton(
                                      onPressed: () {},
                                      icon: Icon(Icons.more_vert)))
                            ]);
                          }).toList(),
                        ),
                      )
              ],
            ),
    );
  }

  addPosition() async {
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);
    var aPositionName = positionName.text;
    DateTime aStartDate = pickStart!;

    var request = await http.MultipartRequest(
        'POST', Uri.parse("$urlUser/${widget.id}/position"));
    Map<String, String> headers = {
      "Accept": "application/json",
      "Content": "charset-UTF-8",
    };
    request.files
        .add(http.MultipartFile.fromString('position_name', aPositionName));
    request.files.add(
        http.MultipartFile.fromString('start_date', aStartDate.toString()));
    if (pickEnd != null) {
      DateTime aEndDate = pickEnd!;
      request.files
          .add(http.MultipartFile.fromString('end_date', aEndDate.toString()));
    }

    request.headers.addAll(headers);

    var res = await request.send();
    print(res.statusCode);
    if (res.statusCode == 201) {
      Navigator.of(context).pop();
    }
    res.stream.transform(utf8.decoder).listen((event) {});
  }

  editPosition() async {
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);
    var aPositionName = positionName.text;

    var request = await http.MultipartRequest(
        'POST',
        Uri.parse(
            "http://rest-api-laravel-flutter.herokuapp.com/api/position/${positionId}?_method=PUT"));
    Map<String, String> headers = {
      "Accept": "application/json",
      "Content": "charset-UTF-8",
    };

    request.files
        .add(http.MultipartFile.fromString('position_name', aPositionName));

    if (pickStart != null) {
      DateTime aStartDate = pickStart as DateTime;
      request.files.add(
          http.MultipartFile.fromString('start_date', aStartDate.toString()));
    }
    if (pickEnd != null) {
      var aEndDate = pickEnd as DateTime;
      request.files
          .add(http.MultipartFile.fromString('end_date', aEndDate.toString()));
    }

    request.headers.addAll(headers);

    var res = await request.send();
    print(res.statusCode);
    if (res.statusCode == 200) {
      Navigator.pop(context);
    }
    res.stream.transform(utf8.decoder).listen((event) {});
  }
}
