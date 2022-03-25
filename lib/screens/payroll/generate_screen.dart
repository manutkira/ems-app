// ignore_for_file: deprecated_member_use

import 'package:ems/models/payroll.dart';
import 'package:ems/models/user.dart';
import 'package:ems/persistence/current_user.dart';
import 'package:ems/screens/attendances_api/widgets/attendance_info/attendance_info_name_id.dart';
import 'package:ems/screens/payroll/view_payroll.dart';
import 'package:ems/services/user.dart';
import 'package:ems/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../constants.dart';
import '../../models/payment.dart' as new_model;
import '../../services/payroll.dart' as new_service;

// ignore: must_be_immutable
class GeneratePaymentScreen extends ConsumerStatefulWidget {
  int id;
  GeneratePaymentScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  ConsumerState createState() => _GeneratePaymentScreenState();
}

class _GeneratePaymentScreenState extends ConsumerState<GeneratePaymentScreen>
    with SingleTickerProviderStateMixin {
  // service
  final new_service.PayrollService _payrollService =
      new_service.PayrollService();
  final UserService _userService = UserService();

  // list payroll
  List<new_model.Payment> payrollList = [];
  List<new_model.Payment> payrollPending = [];
  List<new_model.Payment> payrollPaid = [];
  List<User> user = [];
  List<User> userDisplay = [];
  Payroll? payroll;

  // datetime
  final DateRangePickerController _datePickerController =
      DateRangePickerController();
  DateTime? startDate = DateTime.now();
  DateTime? endDate = DateTime.now();

  // boolean
  bool _isLoading = true;
  bool _loadingUser = true;
  bool paid = false;

  // tab view
  late TabController _tabController;

  // string
  String dropDownValue = '';

  final color = const Color(0xff05445E);

  // variable
  String urlUser = "http://rest-api-laravel-flutter.herokuapp.com/api/users";

  // fetch user from api
  fetchUserById() async {
    try {
      _loadingUser = true;
      _userService.findOne(widget.id).then((usersFromServer) {
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

  // fetch payroll from api
  fetchPaymentById() async {
    try {
      _isLoading = true;
      // setState(() {
      // });
      List<new_model.Payment> payrollDisplay =
          await _payrollService.findManyPaymentsByUserId(widget.id);
      if (mounted) {
        setState(() {
          payrollList = payrollDisplay;
          payrollPaid =
              payrollList.where((element) => element.status == true).toList();
          payrollPending =
              payrollList.where((element) => element.status != true).toList();

          _isLoading = false;
        });
      }
    } catch (err) {
      rethrow;
    }
  }

  void showInSnackBar(String value, context) {
    Scaffold.of(context).showSnackBar(
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

  Future deleteData(int id, context) async {
    AppLocalizations? local = AppLocalizations.of(context);
    final response = await http.delete(Uri.parse(
        "http://rest-api-laravel-flutter.herokuapp.com/api/payment/$id"));
    showInSnackBar("${local?.deletingPayment}", context);
    if (response.statusCode == 200) {
      fetchPaymentById();
      showInSnackBar("${local?.deletedPayment}", context);
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserById();
    fetchPaymentById();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    bool isAdmin = ref.read(currentUserProvider).isAdmin;
    AppLocalizations? local = AppLocalizations.of(context);
    bool isEnglish = isInEnglish(context);
    setState(() {
      if (dropDownValue.isEmpty) {
        dropDownValue = local!.pending;
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: Text('${local?.payment}'),
        actions: [
          isAdmin
              ? Padding(
                  padding: const EdgeInsets.all(8),
                  child: IconButton(
                    icon: const Icon(Icons.add),
                    // elevation: 10,
                    // shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(10)),
                    // color: kBlack,
                    // child: Text(
                    //   '${local?.generateNew}',
                    //   style: TextStyle(),
                    // ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          content: SizedBox(
                            height: 400,
                            width: 400,
                            child: SfDateRangePicker(
                              todayHighlightColor: kBlueBackground,
                              startRangeSelectionColor: Colors.green,
                              endRangeSelectionColor: Colors.green,
                              rangeSelectionColor: Colors.redAccent,
                              view: DateRangePickerView.month,
                              selectionMode:
                                  DateRangePickerSelectionMode.extendableRange,
                              showActionButtons: true,
                              controller: _datePickerController,
                              onSubmit: (p0) async {
                                setState(() {
                                  startDate = _datePickerController
                                      .selectedRange?.startDate;
                                  endDate = _datePickerController
                                      .selectedRange?.endDate;
                                });
                                Navigator.of(context).pop();
                                if (startDate != null && endDate != null) {
                                  await createOne(
                                      widget.id,
                                      startDate as DateTime,
                                      endDate as DateTime);
                                }
                                fetchPaymentById();
                                _datePickerController.selectedRange = null;
                              },
                              onCancel: () {
                                Navigator.pop(context);
                                _datePickerController.selectedRange = null;
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              : Container(),
        ],
      ),
      body: _isLoading || _loadingUser
          ? Container(
              padding: const EdgeInsets.only(top: 320),
              alignment: Alignment.center,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('${local?.fetchData}'),
                    const SizedBox(
                      height: 10,
                    ),
                    Image.asset(
                      'assets/images/Gear-0.5s-200px.gif',
                      width: 60,
                    )
                  ],
                ),
              ),
            )
          : Builder(
              builder: (context) => Column(
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
                  const SizedBox(
                    height: 40,
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
                            text: '${local?.pending}',
                          ),
                          Tab(
                            text: '${local?.paid}',
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                      height: 530,
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
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(18.0),
                                        child: Text(
                                          '${local?.pendingList}',
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  payrollPending.isEmpty
                                      ? Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Column(
                                              children: [
                                                const SizedBox(
                                                  height: 90,
                                                ),
                                                Text(
                                                  '${local?.noPayment}',
                                                  style: isEnglish
                                                      ? kHeadingThree
                                                      : kHeadingFour,
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                Text(
                                                  '🤷🏼',
                                                  style: kHeadingTwo.copyWith(
                                                    fontSize: 50,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      : Expanded(
                                          child: ListView.builder(
                                          physics:
                                              const ClampingScrollPhysics(),
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            new_model.Payment record =
                                                payrollPending[index];
                                            return _buildPayment(context,
                                                record, isAdmin, index);
                                          },
                                          itemCount: payrollPending.length,
                                        )),
                                ],
                              ),
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          '${local?.paidList}',
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  payrollPaid.isEmpty
                                      ? Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Column(
                                              children: [
                                                const SizedBox(
                                                  height: 90,
                                                ),
                                                Text(
                                                  '${local?.noPaidPayment}',
                                                  style: isEnglish
                                                      ? kHeadingThree
                                                      : kHeadingFour,
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                Text(
                                                  '🤷🏼',
                                                  style: kHeadingTwo.copyWith(
                                                      fontSize: 50),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      : Expanded(
                                          child: ListView.builder(
                                          physics:
                                              const ClampingScrollPhysics(),
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            new_model.Payment record =
                                                payrollPaid[index];
                                            return _buildPayment(context,
                                                record, isAdmin, index);
                                          },
                                          itemCount: payrollPaid.length,
                                        )),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ))
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  // (payrollPaid.isEmpty && paid) ||
                  //         (payrollPending.isEmpty && !paid)
                  //     ? Center(
                  //         child: Padding(
                  //           padding: const EdgeInsets.all(12.0),
                  //           child: Column(
                  //             children: [
                  //               SizedBox(
                  //                 height: 90,
                  //               ),
                  //               Text(
                  //                 '${local?.noPayment}',
                  //                 style:
                  //                     isEnglish ? kHeadingThree : kHeadingFour,
                  //               ),
                  //               SizedBox(
                  //                 height: 20,
                  //               ),
                  //               Text(
                  //                 '🤷🏼',
                  //                 style: kHeadingTwo.copyWith(fontSize: 50),
                  //               )
                  //             ],
                  //           ),
                  //         ),
                  //       )
                  // : Expanded(
                  //     child: ListView.builder(
                  //     physics: const ClampingScrollPhysics(),
                  //     shrinkWrap: true,
                  //     itemBuilder: (context, index) {
                  //       new_model.Payment record = paid
                  //           ? payrollPaid[index]
                  //           : payrollPending[index];
                  //       return _buildPayment(context, record, isAdmin);
                  //     },
                  //     itemCount:
                  //         paid ? payrollPaid.length : payrollPending.length,
                  //   )),
                  // const SizedBox(
                  //   height: 30,
                  // )
                ],
              ),
            ),
    );
  }

  Widget _buildPayment(
      context, new_model.Payment record, bool isAdmin, indexx) {
    AppLocalizations? local = AppLocalizations.of(context);
    // bool isEnglish = isInEnglish(context);
    return ExpansionTile(
      collapsedBackgroundColor: const Color(0xff254973),
      backgroundColor: const Color(0xff254973),
      textColor: Colors.white,
      iconColor: Colors.white,
      initiallyExpanded: indexx == 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                getDateStringFromDateTime(
                    DateTime.parse(record.dateFrom.toString())),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                '- ${getDateStringFromDateTime(DateTime.parse(record.dateTo.toString()))}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: record.status == false ? Colors.orange : Colors.green,
            ),
            child: Padding(
              padding: const EdgeInsets.all(2.8),
              child: Text(
                record.status == false ? '${local?.pending}' : '${local?.paid}',
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
                    Text('${local?.id}'),
                    Text(record.id.toString()),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${local?.status}'),
                    Text(
                      record.status! ? '${local?.paid}' : '${local?.pending}',
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${local?.loan}'),
                    Text('\$${doubleParse(record.loan!)}'),
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
                      DateFormat('dd-MM-yyyy')
                          .format(record.dateFrom as DateTime),
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
                      DateFormat('dd-MM-yyyy')
                          .format(record.dateTo as DateTime),
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
                            builder: (_) =>
                                ViewPayrollScreen(paymentId: record.id!),
                          ),
                        );
                        payrollList = [];
                        fetchPaymentById();
                      },
                      child: Text(
                        '${local?.optionView}',
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    isAdmin
                        ? RaisedButton(
                            child: Text('${local?.delete}'),
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            color: Colors.red,
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text('${local?.areYouSure}'),
                                  content: Text('${local?.cannotUndone}'),
                                  actions: [
                                    OutlineButton(
                                      onPressed: () async {
                                        deleteData(record.id!, context);
                                        Navigator.of(context).pop();
                                        fetchPaymentById();
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
                            },
                          )
                        : Container(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  createOne(int id, DateTime dateFrom, DateTime dateTo) async {
    AppLocalizations? local = AppLocalizations.of(context);
    try {
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
      await _payrollService.createOnePayment(id,
          dateFrom: dateFrom, dateTo: dateTo);
      Navigator.pop(context);
    } catch (err) {
      rethrow;
    }
  }
}
