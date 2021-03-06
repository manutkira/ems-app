import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../persistence/current_user.dart';

class BaseService {
  Dio dio = Dio();
  final String _baseUrl = "http://rest-api-laravel-flutter.herokuapp.com/api/";

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

      return handler.next(options);
    }, onResponse: (response, handler) {
      return handler.next(response);
    }, onError: (DioError e, handler) {
      return handler.next(e);
    }));
  }
}
