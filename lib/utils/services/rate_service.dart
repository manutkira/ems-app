import 'dart:convert';

import 'package:ems/models/rate.dart';
import 'package:ems/utils/services/base_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'exceptions/user.dart';

class RateService extends BaseService {
  static RateService get instance => RateService();
  int _code = 0;

  Future findOne(int id) async {
    try {
      Response response = await get(Uri.parse('$baseUrl/users/$id/ratework'));

      if (response.statusCode != 200) {
        _code = response.statusCode;
        throw 'error';
      }
      Map<String, dynamic> jsondata = json.decode(response.body);
      List data = jsondata['rateworks'];
      // print(data[0]['id']);
      // var rate = Rate.fromJson(jsondata);
      return data;
    } catch (e) {
      throw e;
    }
  }
}
