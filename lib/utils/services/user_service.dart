import 'dart:convert';
import 'dart:io';

import 'package:ems/models/user.dart';
import 'package:http/http.dart';

import 'base_service.dart';
import 'exceptions/user.dart';

class UserService extends BaseService {
  static UserService get instance => UserService();

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

  Future<User> uploadImage({required File image, required User user}) async {
    User newUser = user;
    var request =
        MultipartRequest('POST', Uri.parse("$baseUrl/users/${user.id}"));
    request.headers.addAll({
      "Accept": "application/json",
      "Content": "charset-UTF-8",
    });
    print('hih');
    request.files.add(
      MultipartFile(
        'image',
        image.readAsBytes().asStream(),
        image.lengthSync(),
        filename: image.path.split('/').last,
      ),
    );
    //
    request.fields['name'] = user.name as String;
    request.fields['phone'] = user.phone as String;

    // to update
    request.fields['_method'] = "PUT";
    StreamedResponse res = await request.send();
    // print('hihi');
    // var result = await Response.fromStream(res);

    // print(result.body);
    // Map<String, dynamic> _user = {};
    //
    // var _user = user.toJson();
    // var keys = _user.keys.toList();
    // var values = _user.values.toList();
    // print(keys);
    // print(values);
    //
    // keys.map((e) {
    //   if (_user[e] != null) {
    //     if (e == 'image') {
    //       request.files.add(
    //         MultipartFile(
    //           'image',
    //           image.readAsBytes().asStream(),
    //           image.lengthSync(),
    //           filename: image.path.split('/').last,
    //         ),
    //       );
    //     } else if (e == 'id') {
    //       //
    //     } else {
    //       request.fields[e] = _user[e] as String;
    //     }
    //   }
    // }).toList();

    // print(request.fields['user']);
    // StreamedResponse res = await request.send();
    //
    // var result = await Response.fromStream(res);
    //
    // print(result.body);
    //

    res.stream.transform(utf8.decoder).listen((result) {
      print(result);
      var jsondata = json.decode(result);
      newUser = User.fromJson(jsondata['user']);
    });
    // print(newUser);
    return newUser;
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
    print(user.toRawJson());

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
      var jsondata = json.decode(response.body);

      _code = response.statusCode;
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
