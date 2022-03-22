import 'package:dio/dio.dart';
import 'package:ems/models/bank.dart';
import 'package:ems/services/base.dart';

class BankService extends BaseService {
  static BankService get instance => BankService();

  Future<List<Bank>> findAllByUserId(int userId) async {
    try {
      Response res = await dio.get(
        '/users/$userId/bank',
        options: Options(validateStatus: (status) => status == 200),
      );
      return banksFromJson(res.data['banks']);
    } catch (err) {
      if (err is DioError) {
        throw Exception(err.response?.data['message']);
      }
      throw Exception(err.toString());
    }
  }

  Future<Bank> findOne(int bankId) async {
    try {
      Response res = await dio.get(
        'bank/$bankId',
        options: Options(validateStatus: (status) => status == 200),
      );
      return Bank.fromJson(res.data);
    } catch (err) {
      if (err is DioError) {
        throw Exception(err.response?.data['message']);
      }
      throw Exception(err.toString());
    }
  }

  Future<Bank> createOne(Bank bank) async {
    var payload = bank.createBankJson();
    try {
      Response res = await dio.post(
        '/users/${bank.userId}/bank',
        data: payload,
        options: Options(validateStatus: (status) => status == 201),
      );
      return Bank.fromJson(res.data);
    } catch (err) {
      if (err is DioError) {
        throw Exception(err.response?.data['message']);
      }
      throw Exception(err.toString());
    }
  }

  Future<Bank> updateOne(Bank bank) async {
    // throw an error
    if (bank.id == null) throw Exception("Data provided is corrupted.");

    var payload = bank.createBankJson();
    payload.removeWhere((key, value) {
      if (key == 'id' || key == 'user_id' || value == null) {
        return true;
      }
      return false;
    });
    try {
      Response res = await dio.put(
        'bank/${bank.id}',
        data: payload,
        options: Options(validateStatus: (status) => status == 200),
      );
      return Bank.fromJson(res.data);
    } catch (err) {
      if (err is DioError) {
        throw Exception(err.response?.data['message']);
      }
      throw Exception(err.toString());
    }
  }

  Future<void> deleteOne(int bankId) async {
    try {
      await dio.delete(
        'bank/$bankId',
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
