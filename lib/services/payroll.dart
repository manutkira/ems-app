import 'package:dio/dio.dart';
import 'package:ems/services/base.dart';
import 'package:ems/services/models/payment.dart';
import 'package:ems/services/models/payroll.dart';

class PayrollService extends BaseService {
  findOne(int paymentId) async {
    try {
      Response res = await dio.get(
        'payment/$paymentId/payroll',
        options: Options(validateStatus: (status) => status == 200),
      );
      var data = res.data;
      var payroll = Payroll.fromJson(data);
      return payroll;
    } catch (err) {
       if (err is DioError) {
        throw Exception(err.response?.data['message']);
      }
      throw Exception(err.toString());
    }
  }

  markAsPaid(int paymentId) async {
    try {
      Response res = await dio.get(
        'payment/$paymentId/change-status',
        options: Options(validateStatus: (status) => status == 200),
      );
      var data = res.data;

      var payment = Payment.fromJson(data['payment']);
      return payment;
    } catch (err) {
       if (err is DioError) {
        throw Exception(err.response?.data['message']);
      }
      throw Exception(err.toString());
    }
  }

  createOnePayment(
    int userId, {
    required DateTime dateFrom,
    required DateTime dateTo,
  }) async {
    try {
      Response res = await dio.post(
        'users/$userId/payment',
        data: {
          "date_from": dateFrom.toIso8601String(),
          "date_to": dateTo.toIso8601String(),
        },
        options: Options(validateStatus: (status) => status == 201),
      );
      return Payment.fromJson(res.data);
    } catch (err) {
       if (err is DioError) {
        throw Exception(err.response?.data['message']);
      }
      throw Exception(err.toString());
    }
  }

  findManyPayments() async {
    try {
      Response res = await dio.get(
        'payments',
        options: Options(validateStatus: (status) => status == 200),
      );
      return paymentsFromJson(res.data);
    } catch (err) {
       if (err is DioError) {
        throw Exception(err.response?.data['message']);
      }
      throw Exception(err.toString());
    }
  }

  updateOnePayment(Payment payment) async {
    // payment object clean
    var payload = payment.toJson();
    payload.removeWhere((key, value) {
      if (key == 'id' || key == "user_id" || key == 'status') {
        return true;
      }
      return false;
    });
    try {
      Response res = await dio.put(
        'payment/${payment.id}',
        data: payload,
        options: Options(validateStatus: (status) => status == 200),
      );
      return Payment.fromJson(res.data);
    } catch (err) {
       if (err is DioError) {
        throw Exception(err.response?.data['message']);
      }
      throw Exception(err.toString());
    }
  }

  deleteOnePayment(int paymentId) async {
    try {
      Response res = await dio.delete(
        'payment/$paymentId',
        options: Options(validateStatus: (status) => status == 200),
      );
      print(res.data);
    } catch (err) {
       if (err is DioError) {
        throw Exception(err.response?.data['message']);
      }
      throw Exception(err.toString());
    }
  }

  findManyPaymentsByUserId(int userId) async {
    try {
      Response res = await dio.get(
        'users/$userId/payment',
        options: Options(validateStatus: (status) => status == 200),
      );
      var data = res.data;
      var payments = paymentsFromJson(data['payments']);
      return payments;
    } catch (err) {
       if (err is DioError) {
        throw Exception(err.response?.data['message']);
      }
      throw Exception(err.toString());
    }
  }
}
