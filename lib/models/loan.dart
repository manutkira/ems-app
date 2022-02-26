import 'package:ems/screens/payroll/loan/loan_all.dart';
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
  // String? repay;
  // String? remain;
  User? user;
  Loan({
    required this.id,
    required this.userId,
    required this.date,
    required this.amount,
    required this.reason,
    // this.repay,
    // this.remain,
    this.user,
  });

  factory Loan.fromJson(Map<String, dynamic> json) => Loan(
        id: json["id"],
        userId: json["user_id"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        amount: json["amount"],
        reason: json["reasons"] == null ? 'null' : json["reasons"],
        user: json["user"],
      );

  Loan copyWith({
    int? id,
    int? userId,
    DateTime? date,
    String? amount,
    String? reason,
    // String? repay,
    // String? remain,
    User? user,
  }) {
    return Loan(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      reason: reason ?? this.reason,
      // repay: repay ?? this.repay,
      // remain: remain ?? this.remain,
      user: user == null ? this.user : user.copyWith(),
    );
  }
}

List<LoanALl> loanAllFromJson(List<dynamic> list) {
  return List<LoanALl>.from(list.map((x) => LoanALl.fromJson(x)));
}

class LoanALl {
  int id;
  int userId;
  String amountTotal;
  String repay;
  String remain;
  Users? user;

  LoanALl({
    required this.id,
    required this.userId,
    required this.amountTotal,
    required this.repay,
    required this.remain,
    this.user,
  });

  factory LoanALl.fromJson(Map<String, dynamic> json) => LoanALl(
      id: json["id"],
      userId: json["user_id"],
      amountTotal: json["amount_total"],
      repay: json["repay"],
      remain: json["remain"],
      user: Users.ufromJson(json["users"]));
}

class Users {
  int? id;
  String? name;
  String? phone;
  String? email;
  DateTime? emailVerifiedAt;
  String? address;
  String? password;
  String? salary;
  String? role;
  String? background;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? image;
  String? imageId;
  Users({
    this.id,
    this.name,
    this.phone,
    this.email,
    this.emailVerifiedAt,
    this.address,
    this.password,
    this.salary,
    this.role,
    this.background,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.image,
    this.imageId,
  });

  factory Users.ufromJson(Map<String, dynamic> json) => Users(
        id: json["id"],
        name: json["name"],
        phone: json["phone"],
        email: json["email"],
        emailVerifiedAt: json["email_verified_at"] == null
            ? null
            : DateTime.parse(json["email_verified_at"]),
        address: json["address"],
        image: json["image"],
        imageId: json["image_id"],
        salary: json["salary"],
        role: json["role"],
        background: json["background"],
        status: json["status"],
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
      "name": name,
      "phone": phone,
      "email": email,
      "email_verified_at": emailVerifiedAt?.toIso8601String(),
      "password": password,
      "address": address,
      "salary": salary,
      "role": role,
      "background": background,
      "status": status,
      "image": image,
      "image_id": imageId,
      "created_at": createdAt?.toIso8601String(),
      "updated_at": updatedAt?.toIso8601String(),
    };
  }
}
