import 'package:dio/dio.dart';
import 'package:ems/services/base.dart';
import 'package:ems/services/models/rating.dart';

class RatingService extends BaseService {
  static RatingService get instance => RatingService();

  Future<List<Rating>> findAllByUserId(int userId) async {
    try {
      Response res = await dio.get(
        '/users/$userId/rating',
        options: Options(validateStatus: (status) => status == 200),
      );
      return ratingsFromJson(res.data['rateworks']);
    } catch (err) {
      if (err is DioError) {
        throw Exception(err.response?.data['message']);
      }
      throw Exception(err.toString());
    }
  }

  Future<Rating> createOne(Rating rating) async {
    var payload = rating.toJson();
    payload.removeWhere((key, value) {
      if (key == "id" || key == "user_id") {
        return true;
      }
      return false;
    });
    try {
      Response res = await dio.post(
        '/users/${rating.userId}/rating',
        data: payload,
        options: Options(validateStatus: (status) => status == 201),
      );
      return Rating.fromJson(res.data);
    } catch (err) {
      if (err is DioError) {
        throw Exception(err.response?.data['message']);
      }
      throw Exception(err.toString());
    }
  }

  Future<Rating> updateOne(Rating rating) async {
    if (rating.id == null) throw Exception("Data provided is corrupted.");
    var payload = rating.toJson();
    payload.removeWhere((key, value) {
      if ((key == "skill_name" || key == "score") && value == null) {
        return true;
      }
      return false;
    });
    try {
      Response res = await dio.put(
        'rating/${rating.id}',
        data: payload,
        options: Options(validateStatus: (status) => status == 200),
      );
      return Rating.fromJson(res.data);
    } catch (err) {
      if (err is DioError) {
        throw Exception(err.response?.data['message']);
      }
      throw Exception(err.toString());
    }
  }

  Future<void> deleteOne(int ratingId) async {
    try {
      await dio.delete(
        'rating/$ratingId',
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
