import '../../utils/utils.dart';

class Payroll {
  int? paymentId;
  int? userId;
  String? name;
  DateTime? dateFrom;
  DateTime? dateTo;
  bool? status;
  double? dayOfWork;
  Duration? overtime;
  double? salary;
  double? loan;
  double? netSalary;

  Payroll({
    this.paymentId,
    this.userId,
    this.name,
    this.dateFrom,
    this.dateTo,
    this.status,
    this.dayOfWork,
    this.overtime,
    this.salary,
    this.loan,
    this.netSalary,
  });

  Payroll copyWith({
    int? paymentId,
    int? userId,
    String? name,
    DateTime? dateFrom,
    DateTime? dateTo,
    bool? status,
    double? dayOfWork,
    Duration? overtime,
    double? salary,
    double? loan,
    double? netSalary,
  }) =>
      Payroll(
        paymentId: paymentId ?? this.paymentId,
        userId: userId ?? this.userId,
        name: name ?? this.name,
        dateFrom: dateFrom ?? this.dateFrom,
        dateTo: dateTo ?? this.dateTo,
        status: status ?? this.status,
        dayOfWork: dayOfWork ?? this.dayOfWork,
        overtime: overtime ?? this.overtime,
        salary: salary ?? this.salary,
        loan: loan ?? this.loan,
        netSalary: netSalary ?? this.netSalary,
      );

  factory Payroll.fromJson(Map<String, dynamic>? json) => Payroll(
        paymentId: int.tryParse("${json?['payment_id']}"),
        userId: int.tryParse("${json?['user_id']}"),
        name: json?['name'],
        dateFrom: convertStringToDateTime(json?['date_from']),
        dateTo: convertStringToDateTime(json?['date_to']),
        status: json?['status'],
        dayOfWork: doubleParse(json?['day_of_work']),
        overtime: convertStringToDuration(json?['overtime']),
        salary: doubleParse(json?['salary']),
        loan: doubleParse(json?['loan']),
        netSalary: doubleParse(json?['netsalary']),
      );

  Map<String, dynamic> toJson() {
    return {
      "payment_id": paymentId,
      "user_id": userId,
      "name": name,
      "date_from": dateFrom,
      "date_to": dateTo,
      "status": status,
      "day_of_work": dayOfWork,
      "overtime": convertDurationToString(overtime),
      "salary": salary,
      "loan": loan,
      "netsalary": netSalary,
    };
  }
}
