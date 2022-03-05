// box.write('quote', 'GetX is the best');

import 'package:dio/dio.dart';
import 'package:ems/models/user.dart';
import 'package:ems/services/base.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../persistence/current_user.dart';

class AuthService extends BaseService {
  static AuthService get instance => AuthService();

  // login(String phone, String password) async {
  Future<void> login({
    required String phone,
    required String password,
  }) async {
    try {
      Response res = await dio.post(
        'login',
        data: {
          "phone": phone.toString(), // phone,
          "password": password.toString(), // password,
        },
        options: Options(validateStatus: (status) => status == 200),
      );

      var tokenBox = Hive.box<String>(tokenBoxName);
      var userBox = Hive.box<User>(currentUserBoxName);

      User _user = User.fromJson(res.data['user']);
      String _token = res.data['token'];

      await userBox.put(
        currentUserBoxName,
        _user.copyWith(
          image: _user.image.runtimeType != String ? null : _user.image,
          role: _user.role ?? "Employee",
          status: _user.status ?? "Active",
        ),
      );
      await tokenBox.put(tokenBoxName, _token);
    } catch (err) {
      if (err is DioError) {
        throw Exception(err.response?.data['message']);
      }
      throw Exception(err.toString());
    }
  }

  Future<User?> findMe() async {
    try {
      Response res = await dio.get(
        'me',
        options: Options(validateStatus: (status) => status == 200),
      );
      var user = User.fromJson(res.data);
      return user;
    } catch (err) {
      return null;
    }
  }

  Future<void> logout() async {
    try {
      await dio.post(
        'logout',
        options: Options(validateStatus: (status) => status == 200),
      );
      var tokenBox = Hive.box<String>(tokenBoxName);
      await tokenBox.delete(tokenBoxName);
    } catch (err) {
      if (err is DioError) {
        throw Exception(err.response?.data['message']);
      }
      throw Exception(err.toString());
    }
  }

  Future<bool> verify(int id, String password) async {
    try {
      await dio.get(
        'verify/$id?password=$password',
        options: Options(validateStatus: (status) => status == 200),
      );
      return true;
    } catch (err) {
      return false;
    }
  }
}
