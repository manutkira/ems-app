import 'dart:convert';

import 'package:ems/models/user.dart';
import 'package:ems/persistence/current_user.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart';

import 'base_service.dart';
import 'exceptions/auth.dart';

class AuthService extends BaseService {
  static AuthService get instance => AuthService();
  int _code = 0;

  Future<User> login({required String phone, required String password}) async {
    if (phone.isEmpty || password.isEmpty) {
      throw AuthException(code: 2);
    }

    try {
      Response response = await post(
        Uri.parse(
          '$baseUrl/login',
        ),
        headers: headers,
        body: json.encode({
          "phone": phone,
          "password": password,
        }),
      );
      print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)["user"];
        var user = User.fromJson(data);
        return user;
      } else {
        _code = response.statusCode;
        throw Exception("error from auth service");
      }
    } catch (err) {
      throw AuthException(code: _code);
    }
  }

  Future<bool> logout() async {
    final box = Hive.box<User>(currentUserBoxName);
    var currentUserId = box.get(currentUserBoxName)?.id;
    try {
      Response response = await post(
        Uri.parse(
          '$baseUrl/logout/$currentUserId',
        ),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        _code = response.statusCode;
        print(_code);
        throw AuthException(code: _code);
      }
    } catch (err) {
      throw AuthException(code: _code);
    }
  }

  Future<bool> verifyPassword(
      {required int id, required String password}) async {
    try {
      Response response = await get(
        Uri.parse(
          "$baseUrl/verify/${id.toString()}?password=$password",
        ),
        headers: headers,
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        _code = response.statusCode;
        throw AuthException(code: _code);
      }
    } catch (err) {
      throw AuthException(code: _code);
    }
  }
}
