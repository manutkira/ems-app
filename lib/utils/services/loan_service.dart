import 'dart:convert';

import 'package:ems/models/loan.dart';
import 'package:ems/screens/payroll/loan/loan_all.dart';
import 'package:ems/utils/services/base_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class LoanService extends BaseService {
  static LoanService get instance => LoanService();
  int _code = 0;

  Future<List<LoanALl>> findManyLoan() async {
    try {
      Response response = await get(Uri.parse('$baseUrl/loan-employees'));

      if (response.statusCode != 200) {
        _code = response.statusCode;
        throw 'error';
      }
      var jsondata = json.decode(response.body);
      // print(jsondata);
      var payment = loanAllFromJson(jsondata);
      return payment;
    } catch (e) {
      rethrow;
    }
  }

  Future<LoanALl> findOneLoan({required int userId}) async {
    try {
      Response response =
          await get(Uri.parse('$baseUrl/users/$userId/loan-employees'));

      if (response.statusCode != 200) {
        _code = response.statusCode;
        throw 'error';
      }
      var jsondata = json.decode(response.body);
      var loan = LoanALl.fromJson(jsondata[0]);
      return loan;
    } catch (err) {
      rethrow;
    }
  }
}
