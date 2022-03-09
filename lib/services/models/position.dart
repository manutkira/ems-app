import '../../utils/utils.dart';

List<Position> positionsFromJson(List<dynamic>? list) {
  if (list == null) return [];

  return list.map((json) => Position.fromJson(json)).toList();
}

class Position {
  int? id;
  int? userId;
  String? name; // title
  DateTime? startDate;
  DateTime? endDate;

  Position({
    this.id,
    this.userId,
    this.name,
    this.startDate,
    this.endDate,
  });

  factory Position.fromJson(Map<String, dynamic>? json) => Position(
        id: intParse(json?['id']),
        userId: intParse(json?['user_id']),
        name: json?['position_name'],
        startDate: convertStringToDateTime(json?['start_date']),
        endDate: convertStringToDateTime(json?['end_date']),
      );

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "user_id": userId,
      "position_name": name,
      "start_date": startDate?.toIso8601String(),
      "end_date": endDate?.toIso8601String(),
    };
  }

  Position copyWith({
    int? id,
    int? userId,
    String? name, // title
    DateTime? startDate,
    DateTime? endDate,
  }) =>
      Position(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        name: name ?? this.name,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
      );
}
