class Rate {
  String rateName;
  int score;
  int id;
  int userId;
  DateTime? createdAt;
  DateTime? updatedAt;
  Rate({
    required this.rateName,
    required this.score,
    required this.id,
    required this.userId,
    this.createdAt,
    this.updatedAt,
  });

  factory Rate.fromJson(Map<String, dynamic> json) => Rate(
        rateName: json["skill_name"],
        score: json["score"],
        id: json["id"],
        userId: json["user_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() {
    // user object is not necessary.

    return {
      "skill_name": rateName,
      "score": score,
      "id": id,
      "user_id": userId,
      "created_at": createdAt?.toIso8601String(),
      "updated_at": updatedAt?.toIso8601String(),
    };
  }
}
