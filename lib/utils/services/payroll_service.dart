import 'dart:convert';

import 'package:ems/models/loan.dart';
import 'package:ems/models/payroll.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:ems/utils/services/base_service.dart';

class PayrollService extends BaseService {
  static PayrollService get instance => PayrollService();
  int _code = 0;

  Future<List<Payment>> findManyPayrollById(int id) async {
    try {
      Response response = await get(Uri.parse('$baseUrl/users/$id/payment'));

      if (response.statusCode != 200) {
        _code = response.statusCode;
        throw 'error';
      }
      var jsondata = json.decode(response.body);
      var payment = payrollFromJson(jsondata['payments']);
      return payment;
    } catch (e) {
      rethrow;
    }
  }

  Future<Payroll> findOnePayroll({required int paymentId}) async {
    try {
      Response response =
          await get(Uri.parse('$baseUrl/payment/$paymentId/payroll'));

      if (response.statusCode != 200) {
        _code = response.statusCode;
        throw 'error';
      }
      var jsondata = json.decode(response.body);
      var payroll = Payroll.fromJson(jsondata);
      return payroll;
    } catch (err) {
      rethrow;
    }
  }

  Future updateStatus(int id) async {
    try {
      Response response =
          await get(Uri.parse('$baseUrl/payment/$id/change-status'));
      _code = response.statusCode;
      var jsondata = json.decode(response.body);
      return jsondata;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Loan>> findManyLoanById(int id) async {
    try {
      Response response = await get(Uri.parse('$baseUrl/users/$id/loan'));
      var jsondata = json.decode(response.body);
      var loan = loanFromJson(jsondata['loans']);
      return loan;
    } catch (err) {
      rethrow;
    }
  }
}
