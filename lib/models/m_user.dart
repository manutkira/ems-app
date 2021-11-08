class User {
  int id;
  String name;
  String phone;
  String? email;
  DateTime? emailVerifiedAt;
  String? address;
  String? position;
  String? skill;
  String? salary;
  String? background;
  String? status;
  String? rate;
  String? role;
  String createdAt;
  String updatedAt;

  User(
    this.id,
    this.name,
    this.phone,
    this.email,
    this.emailVerifiedAt,
    this.address,
    this.position,
    this.skill,
    this.salary,
    this.background,
    this.status,
    this.rate,
    this.role,
    this.createdAt,
    this.updatedAt,
  );

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        json["id"] as int,
        json["name"] as String,
        json["phone"] as String,
        json["email"] as String?,
        json["email_verified_at"] as DateTime?,
        json["address"] as String?,
        json["position"] as String?,
        json["skill"] as String?,
        json["salary"] as String?,
        json["background"] as String?,
        json["status"] as String?,
        json["rate"] as String?,
        json["role"] as String?,
        json["created_at"] as String,
        json["updated_at"] as String);
  }
}
