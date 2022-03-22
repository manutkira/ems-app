import 'package:dio/dio.dart';
import 'package:ems/models/position.dart';
import 'package:ems/services/base.dart';

class PositionService extends BaseService {
  static PositionService get instance => PositionService();

  Future<List<Position>> findAllByUserId(int userId) async {
    try {
      Response res = await dio.get(
        '/users/$userId/position',
        options: Options(validateStatus: (status) => status == 200),
      );
      return positionsFromJson(res.data['positions']);
    } catch (err) {
      if (err is DioError) {
        throw Exception(err.response?.data['message']);
      }
      throw Exception(err.toString());
    }
  }

  Future<Position> createOne(Position position) async {
    var payload = position.toJson();
    payload.removeWhere((key, value) {
      if ((key == "position_name" || key == "start_date") && value == null) {
        return true;
      }
      return false;
    });
    try {
      Response res = await dio.post(
        '/users/${position.userId}/position',
        data: payload,
        options: Options(validateStatus: (status) => status == 201),
      );
      return Position.fromJson(res.data);
    } catch (err) {
      if (err is DioError) {
        throw Exception(err.response?.data['message']);
      }
      throw Exception(err.toString());
    }
  }

  Future<Position> updateOne(Position position) async {
    if (position.id == null) throw Exception("Data provided is corrupted.");
    var payload = position.toJson();
    payload.removeWhere((key, value) {
      if ((key == "position_name" || key == "start_date") && value == null) {
        return true;
      }
      return false;
    });
    try {
      Response res = await dio.put(
        'position/${position.id}',
        data: payload,
        options: Options(validateStatus: (status) => status == 200),
      );
      return Position.fromJson(res.data);
    } catch (err) {
      if (err is DioError) {
        throw Exception(err.response?.data['message']);
      }
      throw Exception(err.toString());
    }
  }

  Future<void> deleteOne(int positionId) async {
    try {
      await dio.delete(
        'position/$positionId',
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
