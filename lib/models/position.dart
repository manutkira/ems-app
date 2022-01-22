class Position {
  int id;
  int userId;
  String positionName;
  String startDate;
  String? endDate;
  DateTime? createdAt;
  DateTime? updatedAt;
  Position({
    required this.id,
    required this.userId,
    required this.positionName,
    required this.startDate,
    required this.endDate,
    this.createdAt,
    this.updatedAt,
  });

  factory Position.fromJson(Map<String, dynamic> json) => Position(
        positionName: json["position_name"],
        startDate: json["start_date"],
        endDate: json["end_date"],
        id: json["id"],
        userId: json["user_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );
}
