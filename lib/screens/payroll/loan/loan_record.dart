// ignore_for_file: deprecated_member_use, unused_field

import 'package:ems/models/user.dart';
import 'package:ems/persistence/current_user.dart';
import 'package:ems/screens/attendances_api/widgets/attendance_info/attendance_info_name_id.dart';
import 'package:ems/services/models/loan.dart';
import 'package:ems/services/models/payment.dart';
import 'package:ems/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:http/http.dart' as http;
import '../../../services/loan.dart';
import '../../../services/models/loan_record.dart' as loan_record;
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

class _LoanRecordState extends ConsumerState<LoanRecord>
    with SingleTickerProviderStateMixin {
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
  bool loanRecords = true;
  bool _isloading = true;
  bool _isloadingOne = true;

  bool isFilterExpanded = false;

  // datetime
  DateTime? pickStart;

  // url
  String urlUser = "http://rest-api-laravel-flutter.herokuapp.com/api/users";

  // text controller
  TextEditingController amountController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController reasonController = TextEditingController();

  final color = const Color(0xff05445E);

  // tab view
  late TabController _tabController;

  // loan
  Loan? loan;
  List<Payment> loans = [];

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
    } catch (err) {
      rethrow;
    }
  }

  void toggleFilter() {
    setState(() {
      isFilterExpanded = !isFilterExpanded;
    });
  }

  // fetch loan from api
  fetchLoanById() async {
    try {
      // setState(() {
      _isLoading = true;
      // });
      List<records.LoanRecord> loanDisplay =
          await _loanService.findManyRecords(widget.id);
      if (mounted) {
        setState(() {
          loanList = loanDisplay;
          _isLoading = false;
        });
      }
    } catch (err) {
      rethrow;
    }
  }

  // fetch loan from api
  fetchOneLoan() async {
    setState(() {
      _isloadingOne = true;
    });
    try {
      Loan loanDIsplay =
          await _loanService.findOneLoanByUserId(intParse(widget.id));
      setState(() {
        loan = loanDIsplay;
        loans = loan!.user!.payment!
            .where((element) => element.loan != '0')
            .toList();
        _isloadingOne = false;
      });
    } catch (err) {
      rethrow;
    }
  }

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

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
    fetchOneLoan();
    _tabController = TabController(length: 2, vsync: this);
    // _tabController.addListener(_handleSelected);
  }

  // void _handleSelected() {
  //   setState(() {
  //     _handler = myTabs[_tabController.index];
  //   });
  // }

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
                    await mybottonSheet(
                      () async {
                        records.LoanRecord loanRecord = records.LoanRecord(
                            amount: doubleParse(amountController.text),
                            reason: reasonController.text,
                            date: pickStart);
                        await createOne(widget.id, loanRecord);
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
      body: _isLoading || _loadingUser || _isloadingOne
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
                      const SizedBox(
                        height: 190,
                      ),
                      Text(
                        '${local?.noLoanRecord}',
                        style: isEnglish ? kHeadingThree : kHeadingFour,
                      ),
                      const SizedBox(
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
                    Column(
                      children: [
                        Column(
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
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 10, bottom: 10),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      GestureDetector(
                                        onTap: toggleFilter,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${local?.loanDetail}',
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
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 25, right: 25),
                                              child: Column(
                                                children: [
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        '${local?.totalAmount}',
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700,
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
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        '${local?.repay}',
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700,
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
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        '${local?.remain}',
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700,
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
                                                ],
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
                          ],
                        ),
                        DefaultTabController(
                          length: 2,
                          child: SizedBox(
                            width: 350,
                            child: TabBar(
                              // ),
                              controller: _tabController,
                              tabs: [
                                Tab(
                                  text: '${local?.loan}',
                                ),
                                Tab(
                                  text: '${local?.repay}',
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                            height: !isFilterExpanded ? 513 : 353,
                            margin: const EdgeInsets.only(top: 0),
                            width: double.infinity,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                  gradient: LinearGradient(
                                    colors: [
                                      kDarkestBlue,
                                      color,
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  )),
                              child: SizedBox(
                                height: 100,
                                child: TabBarView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  controller: _tabController,
                                  children: [
                                    Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(18.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '${local?.loanRecord}',
                                                style: isEnglish
                                                    ? kHeadingTwo
                                                    : kHeadingFour,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: ListView.builder(
                                            physics:
                                                const ClampingScrollPhysics(),
                                            shrinkWrap: true,
                                            itemBuilder: (contexxt, index) {
                                              records.LoanRecord record =
                                                  loanList[index];
                                              return _buildResult(record,
                                                  context, isAdmin, index);
                                            },
                                            itemCount: loanList.length,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(18.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '${local?.repayRecord}',
                                                style: isEnglish
                                                    ? kHeadingTwo
                                                    : kHeadingFour,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                            child: ListView.builder(
                                          itemBuilder: (context, index) {
                                            return ExpansionTile(
                                              collapsedBackgroundColor:
                                                  const Color(0xff254973),
                                              backgroundColor:
                                                  const Color(0xff254973),
                                              textColor: Colors.white,
                                              iconColor: Colors.white,
                                              initiallyExpanded: index == 0,
                                              title: Text(
                                                DateFormat('dd/MM/yyyy').format(
                                                    loans[index].datePaid!),
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              children: [
                                                Container(
                                                  color: Colors.black38,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10,
                                                          left: 15,
                                                          right: 15,
                                                          bottom: 15),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          const Text('Ref no'),
                                                          Text(
                                                            loans[index]
                                                                .refNo
                                                                .toString(),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 15,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          const Text(
                                                              'Date Paid'),
                                                          Text(
                                                            DateFormat(
                                                                    'dd/MM/yyyy')
                                                                .format(loans[
                                                                        index]
                                                                    .datePaid!),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 15,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          const Text(
                                                              'Repaid Amount'),
                                                          Text(
                                                            '\$${loans[index].loan!}',
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            );
                                          },
                                          itemCount: loans.length,
                                        ))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ))
                      ],
                    ),
                  ],
                ),
    );
  }

  Future<dynamic> mybottonSheet(
    Function function,
    BuildContext context,
    bool isEnglish,
    AppLocalizations? local,
  ) {
    return showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          topLeft: Radius.circular(30),
        )),
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
                                      errorStyle: const TextStyle(
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
                                        contentPadding: const EdgeInsets.only(
                                          left: 10,
                                          top: 20,
                                        ),
                                        hintText: '${local?.enterReason}',
                                        errorStyle: const TextStyle(
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
      records.LoanRecord record, BuildContext context, bool isAdmin, indexx) {
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);
    return ExpansionTile(
      collapsedBackgroundColor: const Color(0xff254973),
      backgroundColor: const Color(0xff254973),
      textColor: Colors.white,
      iconColor: Colors.white,
      initiallyExpanded: indexx == 0,
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
                      style: const TextStyle(
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
                      style: const TextStyle(
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
                      style: const TextStyle(
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

                              await mybottonSheet(() {
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
                          const SizedBox(
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

  updateONe(loan_record.LoanRecord record) async {
    await _loanService.updateOneRecord(record);
  }

  createOne(String id, loan_record.LoanRecord record) async {
    AppLocalizations? local = AppLocalizations.of(context);
    try {
      Navigator.pop(context);
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text('${local?.adding}'),
                content: Flex(
                  direction: Axis.horizontal,
                  children: const [
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.only(left: 100),
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ));
      await _loanService.createOneRecord(id, record);
    } catch (err) {
      rethrow;
    }
  }
}
