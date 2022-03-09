import 'package:ems/utils/utils.dart';

List<Rating> ratingsFromJson(List<dynamic>? list) {
  if (list == null) return [];

  return list.map((json) => Rating.fromJson(json)).toList();
}

class Rating {
  int? id;
  int? userId;
  String? skillName;
  int? score;

  Rating({this.id, this.userId, this.score, this.skillName});

  factory Rating.fromJson(Map<String, dynamic>? json) => Rating(
        id: intParse(json?['id']),
        userId: intParse(json?['user_id']),
        skillName: json?['skill_name'],
        score: intParse(json?['score']),
      );

  Rating copyWith({
    int? id,
    int? userId,
    String? skillName,
    int? score,
  }) =>
      Rating(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        skillName: skillName ?? this.skillName,
        score: score ?? this.score,
      );

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "user_id": userId,
      "skill_name": skillName,
      "score": score,
    };
  }
}
