import 'package:ems/services/models/bank.dart';
import 'package:ems/services/models/loan_record.dart';
import 'package:ems/services/models/position.dart';

import '../../utils/utils.dart';
import 'loan.dart';

List<User> usersFromJson(List<dynamic>? list) {
  if (list == null) return [];

  return list.map((json) => User.fromJson(json)).toList();
}

class User {
  int? id;
  String? name;
  String? khmer;
  String? phone;
  String? password;
  String? email;
  String? address;
  String? role;
  String? status;
  String? background;
  double? salary;
  String? image;
  String? imageId;
  List<Position>? positions;
  List<Bank>? banks;
  List<LoanRecord>? loans;

  User({
    this.id,
    this.name,
    this.khmer,
    this.phone,
    this.email,
    this.password,
    this.salary,
    this.status,
    this.address,
    this.background,
    this.positions,
    this.role,
    this.image,
    this.imageId,
    this.banks,
    this.loans,
  });

  factory User.fromJson(Map<String, dynamic>? json) {
    return User(
      id: intParse(json?['id']),
      name: json?['name'],
      khmer: json?['khmer'],
      email: json?['email'],
      phone: json?['phone'],
      salary: doubleParse(json?['salary']),
      password: json?['password'],
      address: json?['address'],
      background: json?['background'],
      role: json?['role'],
      status: json?['status'],
      image: json?['image'],
      imageId: json?['image_id'],
      positions: positionsFromJson(json?['positions']),
      banks: banksFromJson(json?['bank']),
      loans: loanRecordsFromJson(json?['loan_records']),
    );
  }

  User copyWith({
    int? id,
    String? name,
    String? khmer,
    String? phone,
    String? password,
    String? email,
    String? address,
    String? role,
    String? status,
    String? background,
    double? salary,
    String? image,
    String? imageId,
    List<Position>? positions,
    List<Bank>? banks,
    List<LoanRecord>? loans,
  }) =>
      User(
        id: id ?? this.id,
        name: name ?? this.name,
        khmer: khmer ?? this.khmer,
        phone: phone ?? this.phone,
        password: password ?? this.password,
        email: email ?? this.email,
        address: address ?? this.address,
        role: role ?? this.role,
        status: status ?? this.status,
        background: background ?? this.background,
        salary: salary ?? this.salary,
        image: image ?? this.image,
        imageId: imageId ?? this.imageId,
        positions: positions ?? this.positions,
        banks: banks ?? this.banks,
        loans: loans ?? this.loans,
      );

  Map<String, dynamic> toCleanJson() {
    var obj = toJson();
    obj.removeWhere((key, value) {
      if ((key == "id" ||
              key == 'name' ||
              key == 'phone' ||
              key == 'email' ||
              key == 'password' ||
              key == 'role') &&
          (value == null || value == 'null' || value.toString().isEmpty)) {
        return true;
      }
      return false;
    });
    return obj;
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "khmer": khmer,
      "phone": phone,
      "email": email,
      "password": password,
      "address": address,
      "background": background,
      "role": role,
      "status": status,
      "image": image,
      "image_id": imageId,
    };
  }

  bool get isEmpty {
    return id == null ||
        id == 0 ||
        id!.isNaN ||
        id!.isNegative ||
        name!.isEmpty ||
        phone!.isEmpty;
  }

  bool get isNotEmpty {
    return !isEmpty;
  }
}
