import 'dart:convert';

import 'package:ems/models/user.dart';
import 'package:ems/utils/services/base_api.dart';
import 'package:http/http.dart' as http;

class UserService extends BaseService {
  Future<User> getUser(int id) async {
    var url = "https://laravel-rest-api-app.herokuapp.com/api/users/$id";
    var response = await http.get(Uri.parse(url));
    var data = json.decode(response.body);
    return User.fromJson(data);
  }

  Future<List<User>> getAllUsers() async {
    var url = "https://laravel-rest-api-app.herokuapp.com/api/users";
    var response = await http.get(Uri.parse(url));
    var data = jsonDecode(response.body);
    return usersFromJson(data['data']);
  }
}
