import 'package:flutter/material.dart';

List<Payment> payrollFromJson(List<dynamic> list) {
  return List<Payment>.from(list.map((x) => Payment.fromJson(x)));
}

class Payment {
  int id;
  int userId;
  String refNo;
  DateTime dateFrom;
  DateTime dateTo;
  bool status;
  String? datePaid;
  DateTime? createdAt;
  DateTime? updatedAt;
  Payment({
    required this.id,
    required this.userId,
    required this.refNo,
    required this.dateFrom,
    required this.dateTo,
    required this.status,
    required this.datePaid,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        id: json["id"],
        userId: json["user_id"],
        refNo: json["ref_no"],
        dateFrom: DateTime.parse(json["date_from"]),
        dateTo: DateTime.parse(json["date_to"]),
        status: json["status"],
        datePaid: json["date_paid"] ?? json["date_paid"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() {
    // user object is not necessary.

    return {
      "id": id,
      "user_id": userId,
      "ref_no": refNo,
      "date_from": dateFrom,
      "date_to": dateTo,
      "status": status,
      "date_paid": datePaid,
      "created_at": createdAt?.toIso8601String(),
      "updated_at": updatedAt?.toIso8601String(),
    };
  }
}

class Payroll {
  int paymentId;
  int userId;
  String name;
  DateTime dateFrom;
  DateTime dateTo;
  bool status;
  double dayOfWork;
  String overtime;
  String salary;
  String loan;
  double netSalary;
  Payroll({
    required this.paymentId,
    required this.userId,
    required this.name,
    required this.dateFrom,
    required this.dateTo,
    required this.status,
    required this.dayOfWork,
    required this.overtime,
    required this.salary,
    required this.loan,
    required this.netSalary,
  });

  factory Payroll.fromJson(Map<String, dynamic> json) => Payroll(
        paymentId: json["payment_id"],
        userId: json["user_id"],
        name: json["name"],
        dateFrom: DateTime.parse(json["date_from"]),
        dateTo: DateTime.parse(json["date_to"]),
        status: json["status"],
        dayOfWork: json["day_of_work"],
        overtime: json["overtime"],
        salary: json["salary"],
        loan: json["loan"],
        netSalary: json["netsalary"],
      );

  Map<String, dynamic> toJson() {
    // user object is not necessary.

    return {
      "payment_id": paymentId,
      "user_id": userId,
      "name": name,
      "date_from": dateFrom,
      "date_to": dateTo,
      "status": status,
      "day_of_work": dayOfWork,
      "overtime": overtime,
      "salary": salary,
      "loan": loan,
      "netsalary": netSalary,
    };
  }
}
