import 'dart:convert';

import 'package:ems/models/user.dart';
import 'package:ems/utils/services/base_api.dart';
import 'package:http/http.dart' as http;

class UserService extends BaseService {
  // Future<UserDummy> getUser() async {
  //   // var url = "https://laravel-rest-api-app.herokuapp.com/api/users";
  //   var url = "https://jsonplaceholder.typicode.com/users/1";
  //   var response = await http.get(Uri.parse(url));
  //
  //   return UserDummy.fromJson(json.decode(response.body));
  // }
  //
  // Future<List<UserDummy>> getAllUsers() async {
  //   // var url = "https://jsonplaceholder.typicode.com/users2";
  //   var url = "https://laravel-rest-api-app.herokuapp.com/api/users";
  //   var response = await http.get(Uri.parse(url));
  //   var data = jsonDecode(response.body);
  //   return usersFromJson(data);
  // }
  Future<User> getUser(int id) async {
    var url = "https://laravel-rest-api-app.herokuapp.com/api/users/$id";
    // var url = "https://jsonplaceholder.typicode.com/users/1";
    var response = await http.get(Uri.parse(url));

    return User.fromJson(json.decode(response.body));
  }

  Future<List<User>> getAllUsers() async {
    // var url = "https://jsonplaceholder.typicode.com/users2";
    var url = "https://laravel-rest-api-app.herokuapp.com/api/users";
    var response = await http.get(Uri.parse(url));
    var data = jsonDecode(response.body);
    return usersFromJson(data);
  }
}
