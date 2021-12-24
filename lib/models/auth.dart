import 'package:ems/models/user.dart';

class AuthData {
  User user;
  String token;

  AuthData({required this.user, required this.token});

  factory AuthData.fromJson(Map<String, dynamic> json) {
    return AuthData(user: User.fromJson(json['user']), token: json['token']);
  }
}
