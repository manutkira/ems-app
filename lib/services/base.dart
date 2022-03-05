import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../persistence/current_user.dart';
// import 'package:get_storage/get_storage.dart';

class BaseService {
  Dio dio = Dio();
  final String _baseUrl = "http://rest-api-laravel-flutter.herokuapp.com/api/";

  // final box = GetStorage();
  final tokenBox = Hive.box<String>(tokenBoxName);

  BaseService() {
    dio.options.baseUrl = _baseUrl;
    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {

      String? token = tokenBox.get(tokenBoxName);
      if (token != null) {
        options.headers['Authorization'] = "Bearer $token";
      }
      options.headers["Content-Type"] = 'application/json';
      options.headers["Accept"] = 'application/json';

      return handler.next(options); //continue
    }, onResponse: (response, handler) {
      return handler.next(response); // continue
    }, onError: (DioError e, handler) {
      return handler.next(e); //continue
    }));
  }
}
