import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ems/models/user.dart';
import 'package:path/path.dart';

import 'base.dart';

class UserService extends BaseService {
  static UserService get instance => UserService();

  Future<User> findOne(int id) async {
    try {
      Response res = await dio.get(
        'users/$id',
        options: Options(validateStatus: (status) => status == 200),
      );
      User user = User.fromJson(res.data);
      return user;
    } catch (err) {
      if (err is DioError) {
        throw Exception(err.response?.data['message']);
      }
      throw Exception(err.toString());
    }
  }

  Future<List<User>> findMany() async {
    try {
      Response res = await dio.get(
        'users',
        options: Options(validateStatus: (status) => status == 200),
      );
      List<User> users = usersFromJson(res.data);
      return users;
    } catch (err) {
      if (err is DioError) {
        throw Exception(err.response?.data['message']);
      }
      throw Exception(err.toString());
    }
  }

  Future<User> createOne(User user, {File? image, File? imageId}) async {
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
        throw Exception(err.response?.data['message']);
      }
      throw Exception(err.toString());
    }
  }

  Future<User> updateOne(User user, {File? image, File? imageId}) async {
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
      User newUser = User.fromJson(res.data);
      return newUser;
    } catch (err) {
      if (err is DioError) {
        throw Exception(err.response?.data['message']);
      }
      throw Exception(err.toString());
    }
  }

  Future<void> deleteOne(int id) async {
    try {
      await dio.delete(
        'users/$id',
        options: Options(validateStatus: (status) => status == 200),
      );
    } catch (err) {
      if (err is DioError) {
        throw Exception(err.response?.data['message']);
      }
      throw Exception(err.toString());
    }
  }
}
