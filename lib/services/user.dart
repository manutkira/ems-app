import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ems/models/user.dart';
import 'package:path/path.dart';

import 'base.dart';

class UserService extends BaseService {
  static UserService get instance => UserService();

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
      print(users);
      return users;
    } catch (err) {
      if (err is DioError) {
        print(err.response?.data);
      }
      print(err);
    }
  }

  createOne(User user, {File? image, File? imageId}) async {
    var data = user.toCleanJson();
    var upload = {};
    if (image != null) {
      upload['image'] = await MultipartFile.fromFile(
        image.path,
        filename: basename(image.path),
      );
    }

    if (imageId != null) {
      upload['image_id'] = await MultipartFile.fromFile(
        imageId.path,
        filename: basename(imageId.path),
      );
    }

    var payload = FormData.fromMap({
      ...data,
      ...upload,
    });
    try {
      Response res = await dio.post(
        'users',
        data: payload,
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

  updateOne(User user, {File? image, File? imageId}) async {
    var data = user.toCleanJson();
    var upload = {};
    if (image != null) {
      upload['image'] = await MultipartFile.fromFile(
        image.path,
        filename: basename(image.path),
      );
    }

    if (imageId != null) {
      upload['image_id'] = await MultipartFile.fromFile(
        imageId.path,
        filename: basename(imageId.path),
      );
    }

    var payload = FormData.fromMap({
      ...data,
      ...upload,
    });
    try {
      Response res = await dio.post(
        'users/${user.id}?_method=put',
        data: payload,
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

  deleteOne(int id) async {
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
