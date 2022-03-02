// box.write('quote', 'GetX is the best');

import 'package:dio/dio.dart';
import 'package:ems/services/base.dart';

class AuthService extends BaseService {
  // login(String phone, String password) async {
  login() async {
    try {
      print('hey');
      Response res = await dio.post(
        'login',
        data: {
          "phone": "123456789", // phone,
          "password": "123456789", // password,
        },
        options: Options(validateStatus: (status) => status == 200),
      );
      // TODO: SAVE TOKEN AND USER TO LOCAL STORAGE
      // await box.write(tokenBoxName, res.data['token']);
      //
      // print(box.read(tokenBoxName));
      //
      // print(res.data);
    } catch (err) {
      if (err is DioError) {
        print(err.response?.data);
      }
      print(err);
    }
  }

  logout() async {
    try {
      await dio.post(
        'logout',
        options: Options(validateStatus: (status) => status == 200),
      );
      // TODO: REMOVE TOKEN FROM LOCAL STORAGE
      // await box.remove(tokenBoxName);
    } catch (err) {
      if (err is DioError) {
        print(err.response?.data);
      }

      print(err);
    }
  }

  Future<bool> verify(int id, String password) async {
    try {
      await dio.get(
        'verify/$id?password=$password',
        options: Options(validateStatus: (status) => status == 200),
      );
      print('hey');
      return true;
    } catch (err) {
      if (err is DioError) {
        print(err.response?.data);
        return false;
      }
      print(err);
      return false;
    }
  }
}
