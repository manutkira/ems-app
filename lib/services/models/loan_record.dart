
import '../../utils/utils.dart';

List<LoanRecord> loanRecordsFromJson(List<dynamic>? list) {
  if (list == null) return [];

  return list.map((json) => LoanRecord.fromJson(json)).toList();
}

class LoanRecord {
  int? id;
  int? userId;
  DateTime? date;
  String? amount;
  String? reason;
  String? remain;

  LoanRecord({
    this.id,
    this.userId,
    this.date,
    this.amount,
    this.reason,
    this.remain,
  });

  factory LoanRecord.fromJson(Map<String, dynamic>? json) => LoanRecord(
        id: int.tryParse("${json?['id']}"),
        userId: int.tryParse("${json?['user_id']}"),
        date: convertStringToDateTime(json?['date']),
        amount: json?['amount'],
        reason: json?['reasons'],
        remain: json?['remain'],
      );

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "user_id": userId,
      "date": convertDateTimeToString(date),
      "amount": amount,
      "reasons": reason,
      "remain": remain,
    };
  }

  LoanRecord copyWith(
    int? id,
    int? userId,
    DateTime? date,
    String? amount,
    String? reason,
    String? remain,
  ) =>
      LoanRecord(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        date: date ?? this.date,
        amount: amount ?? this.amount,
        reason: reason ?? this.reason,
        remain: remain ?? this.remain,
      );
}
