import 'package:dio/dio.dart';
import 'package:ems/services/base.dart';
import 'package:ems/services/models/loan.dart';
import 'package:ems/services/models/loan_record.dart';

class LoanService extends BaseService {
  findManyRecords(String userId) async {
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

  findOneRecord(int recordId) async {
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

  deleteOneRecord(int recordId) async {
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

  createOneRecord(String userId, LoanRecord record) async {
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

  updateOneRecord(LoanRecord record) async {
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

  findOneLoanByUserId(int userId) async {
    try {
      Response res = await dio.get(
        'users/$userId/loan-employees',
        options: Options(validateStatus: (status) => status == 200),
      );
      var data = res.data;
      var loan = Loan.fromJson(data[0]);
      print(loan.user?.name);
      return loan;
    } catch (err) {
      if (err is DioError) {
        throw Exception(err.response?.data['message']);
      }
      throw Exception(err.toString());
    }
  }

  findOneLoan(int loanId) async {
    try {
      Response res = await dio.get(
        'loan-employees/$loanId',
        options: Options(validateStatus: (status) => status == 200),
      );
      var data = res.data[0];
      var loan = Loan.fromJson(data);
      print(loan.user?.name);
      return loan;
    } catch (err) {
      if (err is DioError) {
        throw Exception(err.response?.data['message']);
      }
      throw Exception(err.toString());
    }
  }

  findManyLoans() async {
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
