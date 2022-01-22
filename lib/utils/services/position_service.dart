import 'dart:convert';

import 'package:ems/models/position.dart';
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

  Future findPosition(int id) async {
    try {
      Response response = await get(Uri.parse('$baseUrl/users/$id'));
      int _code = 0;

      if (response.statusCode != 200) {
        _code = response.statusCode;
        throw 'error';
      }
      Map<String, dynamic> jsondata = json.decode(response.body);
      var data = jsondata['positions'][0];
      return data;
    } catch (e) {
      throw e;
    }
  }
}

class PositionServices extends BaseService {
  static PositionServices get instance => PositionServices();
  int _code = 0;

  Future<List<Position>> findOne(int id) async {
    try {
      Response response = await get(Uri.parse('$baseUrl/users/$id/position'));

      if (response.statusCode != 200) {
        _code = response.statusCode;
        throw 'error';
      }
      Map<String, dynamic> jsondata = json.decode(response.body);
      List data = jsondata['positions'];
      return data.map((e) => Position.fromJson(e)).toList();
    } catch (e) {
      throw e;
    }
  }
}
