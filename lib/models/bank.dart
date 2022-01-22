class Bank {
  int id;
  int userId;
  String bankName;
  String accoutNumber;
  DateTime? createdAt;
  DateTime? updatedAt;
  Bank({
    required this.bankName,
    required this.accoutNumber,
    required this.id,
    required this.userId,
    this.createdAt,
    this.updatedAt,
  });

  factory Bank.fromJson(Map<String, dynamic> json) => Bank(
        bankName: json["bank_name"],
        accoutNumber: json["account_number"],
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
      "skill_name": bankName,
      "score": accoutNumber,
      "id": id,
      "user_id": userId,
      "created_at": createdAt?.toIso8601String(),
      "updated_at": updatedAt?.toIso8601String(),
    };
  }
}