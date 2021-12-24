import 'package:ems/persistence/current_user.dart';
import 'package:hive/hive.dart';

abstract class BaseService {
  String baseUrl = "https://rest-api-laravel-flutter.herokuapp.com/api";
  var tokenBox = Hive.box<String>(tokenBoxName);
  late String? token;
  BaseService() {
    token = tokenBox.get('token');
  }

  Map<String, String> headers() {
    if (token == null || token!.isEmpty) {
      return {
        "Content-Type": "application/json",
        "Accept": "application/json",
      };
    } else {
      return {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token"
      };
    }
  }
  //
  // Map<String, String> headers = {
  //   "Content-Type": "application/json",
  //   "Accept": "application/json",
  //   "Authorization": "Bearer ",
  // };
}
