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
  double? subtotal;
  double? repay;
  double? loanTotal;
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
    this.subtotal,
    this.repay,
    this.loanTotal,
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
    double? subtotal,
    double? repay,
    double? loanTotal,
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
        subtotal: subtotal ?? this.subtotal,
        repay: repay ?? this.repay,
        loanTotal: loanTotal ?? this.loanTotal,
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
        subtotal: doubleParse(json?['subtotal']),
        repay: doubleParse(json?['repay']),
        loanTotal: doubleParse(json?['loan_total']),
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
      "subtotal": subtotal,
      "repay": repay,
      "loan_total": loanTotal,
      "netsalary": netSalary,
    };
  }
}
