// ignore_for_file: deprecated_member_use

import 'package:ems/models/user.dart';
import 'package:ems/persistence/current_user.dart';
import 'package:ems/screens/attendances_api/widgets/attendance_info/attendance_info_name_id.dart';
import 'package:ems/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:http/http.dart' as http;
import '../../../services/loan.dart';
import '../../../services/models/loan_record.dart' as loanRecord;
import '../../../services/models/loan_record.dart' as records;
import '../../../services/user.dart';

import '../../../constants.dart';

class LoanRecord extends ConsumerStatefulWidget {
  String id;
  LoanRecord({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  ConsumerState createState() => _LoanRecordState();
}

class _LoanRecordState extends ConsumerState<LoanRecord> {
  // service
  final LoanService _loanService = LoanService();
  final UserService _userService = UserService();

  // list laon
  List<records.LoanRecord> loanList = [];
  List<User> user = [];
  List<User> userDisplay = [];

  // boolean
  bool _isLoading = true;
  bool _loadingUser = true;

  // datetime
  DateTime? pickStart;

  // url
  String urlUser = "http://rest-api-laravel-flutter.herokuapp.com/api/users";

  // text controller
  TextEditingController amountController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController reasonController = TextEditingController();

  // fetch user from api
  fetchUserById() async {
    try {
      _loadingUser = true;
      _userService.findOne(intParse(widget.id)).then((usersFromServer) {
        if (mounted) {
          setState(() {
            _loadingUser = true;
            user = [];
            userDisplay = [];
            user.add(usersFromServer);
            userDisplay = user;
            _loadingUser = false;
          });
        }
      });
    } catch (err) {}
  }

  // fetch loan from api
  fetchLoanById() async {
    try {
      setState(() {
        _isLoading = true;
      });
      List<records.LoanRecord> loanDisplay =
          await _loanService.findManyRecords(widget.id);
      if (mounted) {
        setState(() {
          loanList = loanDisplay;
          _isLoading = false;
        });
      }
    } catch (err) {}
  }

  GlobalKey<FormState> _key = GlobalKey<FormState>();

  // date picker for start date
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
        dateController.text = DateFormat('dd-MM-yyyy').format(pickStart!);
        // pick = true;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    fetchLoanById();
    fetchUserById();
  }

  @override
  Widget build(BuildContext context) {
    bool isAdmin = ref.read(currentUserProvider).isAdmin;
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('${local?.loan}'),
        actions: [
          isAdmin
              ? IconButton(
                  onPressed: () async {
                    await MybottonSheet(
                      () {
                        records.LoanRecord loanRecord = records.LoanRecord(
                            amount: doubleParse(amountController.text),
                            reason: reasonController.text,
                            date: pickStart);
                        createOne(widget.id, loanRecord);
                      },
                      context,
                      isEnglish,
                      local,
                    );
                    amountController.text = '';
                    dateController.text = '';
                    reasonController.text = '';
                  },
                  icon: const Icon(Icons.add),
                )
              : Container(),
        ],
      ),
      body: _isLoading || _loadingUser
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
          : loanList.isEmpty
              ? Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 90,
                      ),
                      Text(
                        'No loan has been recorded yet!',
                        style: kHeadingTwo,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        '🤷🏼',
                        style: kHeadingTwo.copyWith(fontSize: 50),
                      )
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
                          name: userDisplay[0].name!,
                          id: userDisplay[0].id.toString(),
                          image: userDisplay[0].image.toString()),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Row(
                        children: [
                          Text(
                            '${local?.loanRecord}',
                            style: isEnglish ? kHeadingTwo : kHeadingFour,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        physics: const ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (contexxt, index) {
                          records.LoanRecord record = loanList[index];
                          return _buildResult(record, context, isAdmin);
                        },
                        itemCount: loanList.length,
                      ),
                    ),
                  ],
                ),
    );
  }

  Future<dynamic> MybottonSheet(
    Function function,
    BuildContext context,
    bool isEnglish,
    AppLocalizations? local,
  ) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (_) {
          return Form(
            key: _key,
            child: Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                height: 500,
                decoration: const BoxDecoration(
                  color: kBlue,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 25, right: 15, bottom: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${local?.payrollDate} ',
                            style: kParagraph.copyWith(
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: isEnglish ? 36 : 29,
                          ),
                          Container(
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.6),
                            child: Flex(
                              direction: Axis.horizontal,
                              children: [
                                Flexible(
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return '${local?.plsEnterDate}';
                                      }
                                      return null;
                                    },
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      hintText: '${local?.enterDate}',
                                      suffixIcon: IconButton(
                                          onPressed: () {
                                            _startDatePicker();
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
                                    controller: dateController,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 25, right: 15, bottom: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${local?.amount}',
                            style: kParagraph.copyWith(
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: isEnglish ? 52 : 35,
                          ),
                          Container(
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.6),
                            child: Flex(
                              direction: Axis.horizontal,
                              children: [
                                Flexible(
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return '${local?.plsEnterAmount}';
                                      }
                                      if (!RegExp(r'[0-9]').hasMatch(value)) {
                                        return '${local?.enterNumber}';
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      hintText: '${local?.enterAmount}',
                                      errorStyle: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    controller: amountController,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(0),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 25, right: 15, bottom: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${local?.reason}',
                              style: kParagraph.copyWith(
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: isEnglish ? 52 : 48,
                            ),
                            Container(
                              constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.6),
                              child: Flex(
                                direction: Axis.horizontal,
                                children: [
                                  Flexible(
                                    child: TextFormField(
                                      textInputAction: TextInputAction.done,
                                      maxLines: 5,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(
                                          left: 10,
                                          top: 20,
                                        ),
                                        hintText: '${local?.enterReason}',
                                        errorStyle: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      controller: reasonController,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          RaisedButton(
                            onPressed: () async {
                              if (_key.currentState!.validate()) {
                                await function();
                                loanList = [];
                                await fetchLoanById();
                                Navigator.pop(context);
                              }
                            },
                            color: Theme.of(context).primaryColor,
                            child: Text(
                              '${local?.save}',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          RaisedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            color: Colors.red,
                            child: Text(
                              '${local?.cancel}',
                              style: const TextStyle(
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
              ),
            ),
          );
        });
  }

  Widget _buildResult(
      records.LoanRecord record, BuildContext context, bool isAdmin) {
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);
    return ExpansionTile(
      collapsedBackgroundColor: const Color(0xff254973),
      backgroundColor: const Color(0xff254973),
      textColor: Colors.white,
      iconColor: Colors.white,
      initiallyExpanded: false,
      title: Text(
        getDateStringFromDateTime(DateTime.parse(record.date.toString())),
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
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
                    Text(
                      '${local?.id}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(record.id.toString()),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${local?.amount}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('\$${record.amount}'),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${local?.reason}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 150,
                      child: Text(
                        record.reason.toString(),
                        textAlign: TextAlign.end,
                        style: const TextStyle(height: 1.5),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                isAdmin
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          RaisedButton(
                            elevation: 10,
                            color: Colors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            onPressed: () async {
                              int loanId = record.id!;
                              amountController.text = record.amount.toString();
                              dateController.text = DateFormat('dd-MM-yyyy')
                                  .format(DateTime.tryParse(
                                      record.date.toString())!);
                              reasonController.text = record.reason.toString();
                              pickStart =
                                  DateTime.tryParse(record.date!.toString());

                              await MybottonSheet(() {
                                records.LoanRecord loanRecord =
                                    records.LoanRecord(
                                        amount:
                                            doubleParse(amountController.text),
                                        reason: reasonController.text,
                                        date: pickStart,
                                        id: loanId);
                                updateONe(loanRecord);
                              }, context, isEnglish, local);
                              amountController.text = '';
                              dateController.text = '';
                              reasonController.text = '';
                              fetchLoanById();
                            },
                            child: Text('${local?.edit}'),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          RaisedButton(
                            elevation: 10,
                            color: Colors.red,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Text('${local?.delete}'),
                            onPressed: () async {
                              int loanId = record.id!;
                              await showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text('${local?.areYouSure}'),
                                  content: Text('${local?.cannotUndone}'),
                                  actions: [
                                    OutlineButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        deleteData(loanId, context);
                                      },
                                      child: Text('${local?.yes}'),
                                      borderSide:
                                          const BorderSide(color: Colors.green),
                                    ),
                                    OutlineButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      borderSide:
                                          const BorderSide(color: Colors.red),
                                      child: Text('${local?.no}'),
                                    )
                                  ],
                                ),
                              );
                              fetchLoanById();
                            },
                          ),
                        ],
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void showInSnackBar(String value, context) {
    _scaffoldKey.currentState!.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 2000),
        backgroundColor: kBlueBackground,
        content: Text(
          value,
          style: kHeadingFour.copyWith(color: Colors.black),
        ),
      ),
    );
  }

  // delete position from api
  Future deleteData(int id, context) async {
    AppLocalizations? local = AppLocalizations.of(context);
    final response = await http.delete(Uri.parse(
        "http://rest-api-laravel-flutter.herokuapp.com/api/loan/$id"));
    showInSnackBar('${local?.deletingPosition}', context);
    if (response.statusCode == 200) {
      fetchLoanById();
      showInSnackBar('${local?.deletedPosition}', context);
    } else {
      return false;
    }
  }

  updateONe(loanRecord.LoanRecord record) async {
    await _loanService.updateOneRecord(record);
  }

  createOne(String id, loanRecord.LoanRecord record) async {
    await _loanService.createOneRecord(id, record);
  }
}
