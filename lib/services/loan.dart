import 'package:dio/dio.dart';
import 'package:ems/models/loan.dart';
import 'package:ems/models/loan_record.dart';
import 'package:ems/services/base.dart';

class LoanService extends BaseService {
  Future<List<LoanRecord>> findManyRecords(String userId) async {
    try {
      Response res = await dio.get(
        'users/$userId/loan',
        options: Options(validateStatus: (status) => status == 200),
      );
      var data = res.data;
      var loans = loanRecordsFromJson(data['loan_records']);
      return loans;
    } catch (err) {
      if (err is DioError) {
        throw Exception(err.response?.data['message']);
      }
      throw Exception(err.toString());
    }
  }

  Future<Loan> findOneRecord(int recordId) async {
    try {
      Response res = await dio.get(
        'loan/$recordId',
        options: Options(validateStatus: (status) => status == 200),
      );
      var data = res.data;
      return Loan.fromJson(data);
    } catch (err) {
      if (err is DioError) {
        throw Exception(err.response?.data['message']);
      }
      throw Exception(err.toString());
    }
  }

  Future<void> deleteOneRecord(int recordId) async {
    try {
      await dio.delete(
        'loan/$recordId',
        options: Options(validateStatus: (status) => status == 200),
      );
    } catch (err) {
      if (err is DioError) {
        throw Exception(err.response?.data['message']);
      }
      throw Exception(err.toString());
    }
  }

  Future<Loan> createOneRecord(String userId, LoanRecord record) async {
    var payload = record.toJson();
    // removes unnecessary things
    payload.removeWhere((key, value) {
      if (key == 'id' || key == 'user_id' || value == null) {
        return true;
      }
      return false;
    });
    try {
      Response res = await dio.post(
        'users/$userId/loan',
        data: payload,
        options: Options(validateStatus: (status) => status == 201),
      );
      var data = res.data;
      return Loan.fromJson(data);
    } catch (err) {
      if (err is DioError) {
        throw Exception(err.response?.data['message']);
      }
      throw Exception(err.toString());
    }
  }

  Future<Loan> updateOneRecord(LoanRecord record) async {
    var payload = record.toJson();
    // removes unnecessary things
    payload.removeWhere((key, value) {
      if (key == 'id' || key == 'user_id' || value == null) {
        return true;
      }
      return false;
    });
    try {
      Response res = await dio.put(
        'loan/${record.id}',
        data: payload,
        options: Options(validateStatus: (status) => status == 200),
      );
      var data = res.data;
      return Loan.fromJson(data);
    } catch (err) {
      if (err is DioError) {
        throw Exception(err.response?.data['message']);
      }
      throw Exception(err.toString());
    }
  }

  Future<Loan> findOneLoanByUserId(int userId) async {
    try {
      Response res = await dio.get(
        'users/$userId/loan-employees',
        options: Options(validateStatus: (status) => status == 200),
      );
      List<dynamic> data = res.data;
      if (data.isEmpty) {
        throw Exception('user has no loan');
      }
      var loan = Loan.fromJson(data[0]);
      return loan;
    } catch (err) {
      if (err is DioError) {
        throw Exception(err.response?.data['message']);
      }
      throw Exception(err.toString());
    }
  }

  Future<Loan> findOneLoan(int loanId) async {
    try {
      Response res = await dio.get(
        'loan-employees/$loanId',
        options: Options(validateStatus: (status) => status == 200),
      );
      var data = res.data[0];
      var loan = Loan.fromJson(data);
      return loan;
    } catch (err) {
      if (err is DioError) {
        throw Exception(err.response?.data['message']);
      }
      throw Exception(err.toString());
    }
  }

  Future<List<Loan>> findManyLoans() async {
    try {
      Response res = await dio.get(
        'loan-employees',
        options: Options(validateStatus: (status) => status == 200),
      );
      var data = res.data;
      var loans = loansFromJson(data);
      return loans;
    } catch (err) {
      if (err is DioError) {
        throw Exception(err.response?.data['message']);
      }
      throw Exception(err.toString());
    }
  }
}
