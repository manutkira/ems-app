import 'package:dio/dio.dart';
import 'package:ems/services/models/user.dart';

import 'base.dart';

class UserService extends BaseService {
  findOne(int id) async {
    try {
      Response res = await dio.get(
        'users/$id',
        options: Options(validateStatus: (status) => status == 200),
      );
      User user = User.fromJson(res.data);
      print(user.toCleanJson());
      return user;
    } catch (err) {
      if (err is DioError) {
        print(err.response?.data);
      }
      print(err);
    }
  }
  findMany() async {
    try {
      Response res = await dio.get(
        'users',
        options: Options(validateStatus: (status) => status == 200),
      );
      List<User> users = usersFromJson(res.data);
      print(users.first.name);
      return users;
    } catch (err) {
      if (err is DioError) {
        print(err.response?.data);
      }
      print(err);
    }
  }
  createOne(User user) async {
    var data = user.toCleanJson();
    try {
      Response res = await dio.post(
        'users',
        data: data,
        options: Options(validateStatus: (status) => status == 201),
      );
      User user = User.fromJson(res.data);
      return user;
    } catch (err) {
      if (err is DioError) {
        print(err.response?.data);
      }
      print(err);
    }
  }
  updateOne(User user) async {
    var data = user.toCleanJson();
    try {
      Response res = await dio.put(
        'users/${user.id}',
        data: data,
        options: Options(validateStatus: (status) => status == 200),
      );
      print(res.data);
      User newUser = User.fromJson(res.data);
      return newUser;
    } catch (err) {
      if (err is DioError) {
        print(err.response?.data);
      }
      print(err);
    }
  }
  deleteOne(int id)async {
    try {
      Response res = await dio.delete(
        'users/$id',
        options: Options(validateStatus: (status) => status == 200),
      );
      print(res.data);
    } catch (err) {
      if (err is DioError) {
        print(err.response?.data);
      }
      print(err);
    }
  }
}
