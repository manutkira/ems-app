

import '../../utils/utils.dart';

List<Bank> banksFromJson(List<dynamic>? list) {
  if (list == null) return [];

  return list.map((json) => Bank.fromJson(json)).toList();
}

class Bank {
  int? id;
  int? userId;
  String? name;
  String? accountNumber;
  String? accountName;

  Bank({
    this.id,
    this.userId,
    this.name,
    this.accountName,
    this.accountNumber,
  });

  factory Bank.fromJson(Map<String, dynamic>? json) => Bank(
        id: intParse(json?['id']),
        userId: intParse(json?['user_id']),
        name: json?['bank_name'],
        accountName: json?['account_name'],
        accountNumber: json?['account_number'],
      );

  Map<String, dynamic> createBankJson() {
    return {
      "user_id": userId,
      "bank_name": name,
      "account_name": accountName,
      "account_number": accountNumber,
    };
  }
}
