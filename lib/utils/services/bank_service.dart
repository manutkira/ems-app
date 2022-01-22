import 'dart:convert';

import 'package:ems/models/bank.dart';
import 'package:ems/utils/services/base_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class BankService extends BaseService {
  static BankService get instance => BankService();
  int _code = 0;

  Future<List<Bank>> findOne(int id) async {
    try {
      Response response = await get(Uri.parse('$baseUrl/users/$id/bank'));

      if (response.statusCode != 200) {
        _code = response.statusCode;
        throw 'error';
      }
      Map<String, dynamic> jsondata = json.decode(response.body);
      List data = jsondata['banks'];
      return data.map((e) => Bank.fromJson(e)).toList();
    } catch (e) {
      throw e;
    }
  }
}
