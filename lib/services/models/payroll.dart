import 'package:flutter/material.dart';

import '../../utils/utils.dart';

class Payroll {
  int? paymentId;
  int? userId;
  String? name;
  DateTime? dateFrom;
  DateTime? dateTo;
  bool? status;
  double? dayOfWork;
  TimeOfDay? overtime;
  double? salary;
  double? loan;
  double? netSalary;

  Payroll({
    this.paymentId,
    this.userId,
    this.name,
    this.dateFrom,
    this.dateTo,
    this.status,
    this.dayOfWork,
    this.overtime,
    this.salary,
    this.loan,
    this.netSalary,
  });

  factory Payroll.fromJson(Map<String, dynamic>?  json)=>Payroll(
    paymentId: int.tryParse("${json?['payment_id']}"),
    userId: int.tryParse("${json?['user_id']}"),
    name: json?['name'],
    dateFrom: convertStringToDateTime(json?['date_from']),
    dateTo: convertStringToDateTime(json?['date_to']),
    status: json?['status'],
    dayOfWork: double.tryParse(json?['day_of_work']),
    overtime: convertStringToTime(json?['overtime']),
    salary: double.tryParse(json?['salary']),
    loan: double.tryParse(json?['loan']),
    netSalary: double.tryParse(json?['netsalary']),
  );

}
