import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'package:ems/models/attendances.dart';
import 'package:ems/utils/services/attendance_service.dart';

class PayrollScreen extends StatefulWidget {
  int id;
  PayrollScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  _PayrollScreenState createState() => _PayrollScreenState();
}

class _PayrollScreenState extends State<PayrollScreen> {
  // services
  final AttendanceService _attendanceService = AttendanceService.instance;

  // lists attendance
  List<AttendancesWithDate> attendanceList = [];

  // datetime
  final DateRangePickerController _datePickerController =
      DateRangePickerController();
  DateTime? startDate = DateTime.now();
  DateTime? endDate = DateTime.now();

  // int
  double total = 0;
  int loan = 10;
  int salary = 0;

  // boolean
  bool _isLoading = true;
  bool isPicked = true;
  bool pending = true;

  // fetch data from api
  fetchAttendanceById() async {
    try {
      _isLoading = true;
      List<AttendancesWithDate> attendanceDisplay =
          await _attendanceService.findManyAttendancesById(
        userId: widget.id,
        start: startDate,
        end: endDate,
      );
      if (mounted) {
        setState(() {
          attendanceList = attendanceDisplay;
          salary = int.parse(attendanceList[0].list[0].user!.salary!);
          double sum = 0;
          attendanceList.map((element) {
            sum += double.parse(element.list[0].t);
          }).toList();
          total = sum;
        });
      }
      _isLoading = false;
    } catch (err) {
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAttendanceById();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? local = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payroll'),
      ),
      body: attendanceList.isEmpty
          ? Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 140),
                  // ignore: deprecated_member_use
                  child: RaisedButton(
                    child: const Text('Picker date'),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                                content: SizedBox(
                                  width: 700.0,
                                  height: 400.0,
                                  child: SfDateRangePicker(
                                    startRangeSelectionColor: Colors.green,
                                    endRangeSelectionColor: Colors.green,
                                    rangeSelectionColor: Colors.redAccent,
                                    view: DateRangePickerView.month,
                                    selectionMode: DateRangePickerSelectionMode
                                        .extendableRange,
                                    showActionButtons: true,
                                    controller: _datePickerController,
                                    onSubmit: (p0) {
                                      setState(() {
                                        startDate = _datePickerController
                                            .selectedRange?.startDate;
                                        endDate = _datePickerController
                                            .selectedRange?.endDate;
                                        fetchAttendanceById();
                                        isPicked = false;
                                        Navigator.pop(context);
                                      });
                                    },
                                    onCancel: () {
                                      _datePickerController.selectedRange =
                                          null;
                                    },
                                  ),
                                ),
                              ));
                    },
                  ),
                ),
              ],
            )
          : _isLoading
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
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      // ignore: deprecated_member_use
                      child: RaisedButton(
                        child: const Text('Picker date'),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                    content: SizedBox(
                                      width: 700.0,
                                      height: 400.0,
                                      child: SfDateRangePicker(
                                        startRangeSelectionColor: Colors.green,
                                        endRangeSelectionColor: Colors.green,
                                        rangeSelectionColor: Colors.redAccent,
                                        view: DateRangePickerView.month,
                                        selectionMode:
                                            DateRangePickerSelectionMode
                                                .extendableRange,
                                        showActionButtons: true,
                                        controller: _datePickerController,
                                        onSubmit: (p0) {
                                          setState(() {
                                            startDate = _datePickerController
                                                .selectedRange?.startDate;
                                            endDate = _datePickerController
                                                .selectedRange?.endDate;
                                            fetchAttendanceById();
                                            isPicked = false;
                                            pending = true;
                                            Navigator.pop(context);
                                          });
                                        },
                                        onCancel: () {
                                          _datePickerController.selectedRange =
                                              null;
                                        },
                                      ),
                                    ),
                                  ));
                        },
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 18, right: 25, top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Date',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'From ${DateFormat('dd-MM-yyyy').format(startDate!)}',
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                'To ${DateFormat('dd-MM-yyyy').format(endDate!)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 18, right: 25, top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Status',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            pending ? 'Pending' : 'Paid',
                            style: TextStyle(
                              color: pending ? Colors.orange : Colors.green,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 18, right: 25, top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Day of works',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${total.toString()} days',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 18, right: 25, top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Basic salary',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '\$$salary/day',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 18, right: 25, top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Loan',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '- \$$loan',
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 18, right: 25, top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Net Salary',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '\$${(total * salary - loan).toString()}',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // ignore: deprecated_member_use
                          RaisedButton(
                            onPressed: () {
                              setState(() {
                                pending = false;
                              });
                            },
                            child: const Text('Pay'),
                          )
                        ],
                      ),
                    )
                  ],
                ),
    );
  }
}
