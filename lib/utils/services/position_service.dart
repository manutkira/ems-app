import 'dart:convert';

import 'package:ems/utils/services/base_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class PositionService extends BaseService {
  static PositionService get instance => PositionService();

  Future findOne(int id) async {
    try {
      Response response = await get(Uri.parse('$baseUrl/users/$id/position'));
      int _code = 0;

      if (response.statusCode != 200) {
        _code = response.statusCode;
        throw 'error';
      }
      Map<String, dynamic> jsondata = json.decode(response.body);
      List data = jsondata['positions'];
      return data;
    } catch (e) {
      throw e;
    }
  }
}
