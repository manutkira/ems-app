import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../models/m_user.dart';

List<User> parseUsers(String resopnseBody) {
  var parsed = json.decode(resopnseBody) as List<dynamic>;
  var users = parsed.map((model) => User.fromJson(model)).toList();
  return users;
}

Future<List<User>> fetchPost() async {
  final response = await http.get(
      Uri.parse('http://rest-api-laravel-flutter.herokuapp.com/api/users'));
  if (response.statusCode == 200) {
    return compute(parseUsers, response.body);
  } else {
    throw Exception("Request API Error");
  }
}

// class Services {
//   static const String url =
//       'http://rest-api-laravel-flutter.herokuapp.com/api/users';

//   static Future<List<User>> getUsers() async {
//     try {
//       final response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         List<User> list = parseUsers(response.body);
//         return list;
//       } else {
//         throw Exception('Error');
//       }
//     } catch (e) {
//       throw Exception(e.toString());
//     }
//   }
// }
