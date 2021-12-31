import 'dart:convert';

import 'package:ems/models/auth.dart';
import 'package:ems/models/user.dart';
import 'package:ems/persistence/current_user.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';

import 'base_service.dart';
import 'exceptions/auth.dart';
import 'exceptions/user.dart';

class AuthService extends BaseService {
  static AuthService get instance => AuthService();
  int _code = 0;

  Future<AuthData> login(
      {required String phone, required String password}) async {
    if (phone.isEmpty || password.isEmpty) {
      throw AuthException(code: 2);
    }

    try {
      Response response = await post(
        Uri.parse(
          '$baseUrl/login',
        ),
        headers: headers(),
        body: json.encode({
          "phone": phone,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        var authData = AuthData.fromJson(jsonDecode(response.body));

        var tokenBox = Hive.box<String>(tokenBoxName);
        var userBox = Hive.box<User>(currentUserBoxName);

        User? _user = authData.user.isNotEmpty ? authData.user : null;

        if (_user == null) {
          throw Exception("error from auth service");
        }

        await userBox.put(
          currentUserBoxName,
          _user.copyWith(
            image: _user.image.runtimeType != String ? null : _user.image,
            role: _user.role ?? "Employee",
            status: _user.status ?? "Active",
          ),
        );
        await tokenBox.put('token', authData.token);
        return authData;
      } else {
        _code = response.statusCode;
        throw Exception("error from auth service");
      }
    } catch (err) {
      throw AuthException(code: _code);
    }
  }

  Future<User> findMe() async {
    try {
      Response response = await get(
        Uri.parse('$baseUrl/me'),
        headers: headers(),
      );
      if (response.statusCode != 200) {
        _code = response.statusCode;
        throw UserException(code: _code);
      }
      var jsondata = json.decode(response.body);
      var user = User.fromJson(jsondata);
      return user;
    } catch (err) {
      throw AuthException(code: _code);
    }
  }

  Future<bool> logout() async {
    final userBox = Hive.box<User>(currentUserBoxName);
    var tokenBox = Hive.box<String>(tokenBoxName);
    var currentUserId = userBox.get(currentUserBoxName)?.id;
    try {
      Response response = await post(
        Uri.parse(
          '$baseUrl/logout',
        ),
        headers: headers(),
      );

      if (response.statusCode == 200) {
        await tokenBox.delete('token');
        return true;
      } else {
        _code = response.statusCode;
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
        headers: headers(),
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
