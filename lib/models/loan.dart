import 'package:flutter/material.dart';

import 'package:ems/models/user.dart';

List<Loan> loanFromJson(List<dynamic> list) {
  return List<Loan>.from(list.map((x) => Loan.fromJson(x)));
}

class Loan {
  int id;
  int userId;
  DateTime? date;
  String amount;
  String reason;
  String? repay;
  String? remain;
  User? user;
  Loan({
    required this.id,
    required this.userId,
    required this.date,
    required this.amount,
    required this.reason,
    this.repay,
    this.remain,
    this.user,
  });

  factory Loan.fromJson(Map<String, dynamic> json) => Loan(
        id: json["id"],
        userId: json["user_id"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        amount: json["amount"],
        reason: json["reason"] == null ? 'null' : json["reason"],
        repay: json["repay"] ?? json["repay"],
        remain: json["remain"] ?? json["remain"],
      );

  Loan copyWith({
    int? id,
    int? userId,
    DateTime? date,
    String? amount,
    String? reason,
    String? repay,
    String? remain,
    User? user,
  }) {
    return Loan(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      reason: reason ?? this.reason,
      repay: repay ?? this.repay,
      remain: remain ?? this.remain,
      user: user == null ? this.user : user.copyWith(),
    );
  }
}
