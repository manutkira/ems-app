import 'dart:convert';

import 'package:ems/models/user.dart';
import 'package:http/http.dart';

import 'base_service.dart';
import 'exceptions/user.dart';

class UserService extends BaseService {
  UserService get instance => this;

  int _code = 0;

  Future<int> count() async {
    try {
      Response response = await get(Uri.parse('$baseUrl/countUser'));

      if (response.statusCode != 200) {
        _code = response.statusCode;
        throw UserException(code: _code);
      }

      // var jsondata = json.decode(response.body);
      // var user = User.fromJson(jsondata);
      return int.parse(response.body);
    } catch (e) {
      throw UserException(code: _code);
    }
  }

  Future<User> findOne(int id) async {
    try {
      Response response = await get(Uri.parse('$baseUrl/users/$id'));

      if (response.statusCode != 200) {
        _code = response.statusCode;
        throw UserException(code: _code);
      }
      var jsondata = json.decode(response.body);
      var user = User.fromJson(jsondata);
      return user;
    } catch (e) {
      throw UserException(code: _code);
    }
  }

  Future<List<User>> findMany() async {
    try {
      Response response = await get(Uri.parse('$baseUrl/users'));
      if (response.statusCode != 200) {
        _code = response.statusCode;
        throw UserException(code: _code);
      }
      var jsondata = json.decode(response.body);
      var users = usersFromJson(jsondata);
      return users;
    } catch (e) {
      throw UserException(code: _code);
    }
  }

  Future<User> createOne({required User user}) async {
    try {
      Response response = await post(
        Uri.parse(
          '$baseUrl/users',
        ),
        headers: headers,
        body: json.encode(user.buildCleanJson()),
      );
      if (response.statusCode != 201) {
        _code = response.statusCode;
        throw UserException(code: _code);
      }
      var jsondata = json.decode(response.body);
      var newUser = User.fromJson(jsondata);
      return newUser;
    } catch (e) {
      throw UserException(code: _code);
    }
  }

  Future<User> updateOne({required User user}) async {
    int? userid = user.id;

    if (userid!.isNaN || userid.isNegative || userid == 0) {
      throw Exception("Incorrect id");
    }
    var jsons = user.toJson();
    try {
      Response response = await put(
        Uri.parse(
          '$baseUrl/users/${userid}',
        ),
        headers: headers,
        body: json.encode(jsons),
      );
      _code = response.statusCode;
      print(response.body);
      var jsondata = json.decode(response.body);
      var user = User.fromJson(jsondata['user']);
      return user;
    } catch (e) {
      throw UserException(code: _code);
    }
  }

  Future<void> deleteOne(int id) async {
    try {
      Response response = await delete(Uri.parse('$baseUrl/users/$id'));
      if (response.statusCode != 200) {
        _code = response.statusCode;
        throw UserException(code: _code);
      }
    } catch (e) {
      throw UserException(code: _code);
    }
  }
}
