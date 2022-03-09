import 'dart:convert';

import 'package:ems/models/rate.dart';
import 'package:ems/utils/services/base_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'exceptions/user.dart';

class RateServices extends BaseService {
  static RateServices get instance => RateServices();
  int _code = 0;

  Future<List<Rate>> findOne(int id) async {
    try {
      Response response = await get(Uri.parse('$baseUrl/users/$id/rating'));

      if (response.statusCode != 200) {
        _code = response.statusCode;
        throw 'error';
      }
      Map<String, dynamic> jsondata = json.decode(response.body);
      List data = jsondata['rating'];
      return data.map((e) => Rate.fromJson(e)).toList();
    } catch (e) {
      throw e;
    }
  }
}
