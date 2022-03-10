import 'dart:core';

import 'package:ems/models/user.dart';

import '../../utils/utils.dart';

List<Loan> loansFromJson(List<dynamic>? list) {
  if (list == null) return [];

  return list.map((json) => Loan.fromJson(json)).toList();
}

class Loan {
  int? id;
  int? userId;
  double? amountTotal;
  double? repay;
  double? remain;
  User? user;

  Loan({
    this.id,
    this.userId,
    this.amountTotal,
    this.repay,
    this.remain,
    this.user,
  });

  factory Loan.fromJson(Map<String, dynamic>? json) => Loan(
        id: intParse(json?['id']),
        userId: intParse(json?['user_id']),
        amountTotal: doubleParse(json?['amount_total']),
        repay: doubleParse(json?['repay']),
        remain: doubleParse(json?['remain']),
        user: User.fromJson(json?['users']),
      );
}
