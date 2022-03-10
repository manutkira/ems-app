import '../../utils/utils.dart';

List<Payment> paymentsFromJson(List<dynamic>? list) {
  if (list == null) return [];

  return list.map((json) => Payment.fromJson(json)).toList();
}

class Payment {
  int? id;
  int? userId;
  String? refNo;
  DateTime? dateFrom;
  DateTime? dateTo;
  bool? status;
  DateTime? datePaid;

  Payment({
    this.id,
    this.userId,
    this.refNo,
    this.dateFrom,
    this.dateTo,
    this.status,
    this.datePaid,
  });

  factory Payment.fromJson(Map<String, dynamic>? json) {
    return Payment(
      id: int.tryParse("${json?['id']}"),
      userId: int.tryParse("${json?['user_id']}"),
      refNo: json?['ref_no'],
      dateFrom: convertStringToDateTime(json?['date_from']),
      dateTo: convertStringToDateTime(json?['date_to']),
      status: json?['status'],
      datePaid: convertStringToDateTime(json?['date_paid']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "user_id": userId,
      "ref_no": refNo,
      "status": status,
      "date_from": convertDateTimeToString(dateFrom),
      "date_to": convertDateTimeToString(dateTo),
      "date_paid": convertDateTimeToString(datePaid),
    };
  }

  Payment copyWith({
    int? id,
    int? userId,
    String? refNo,
    DateTime? dateFrom,
    DateTime? dateTo,
    bool? status,
    DateTime? datePaid,
  }) =>
      Payment(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        refNo: refNo ?? this.refNo,
        dateFrom: dateFrom ?? this.dateFrom,
        dateTo: dateTo ?? this.dateTo,
        status: status ?? this.status,
        datePaid: datePaid ?? this.datePaid,
      );
}
