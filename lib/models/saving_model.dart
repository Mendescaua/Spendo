class SavingModel {
  final int? id;
  final String? uuid;
  final String? title;
  final double? value;
  final double? goalValue;
  final String? picture;
  final DateTime? createdAt;

  SavingModel(
      {this.id,
      this.uuid,
      this.title,
      this.value,
      this.goalValue,
      this.createdAt,
      this.picture});

  factory SavingModel.fromJson(Map<String, dynamic> json) {
    return SavingModel(
      id: json['id'],
      uuid: json['uuid'],
      title: json['title'],
      value: json['value'] != null ? (json['value'] as num).toDouble() : 0.0,
      goalValue: json['goal_value'] != null
          ? (json['goal_value'] as num).toDouble()
          : 0.0,
      picture: json['picture'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'title': title,
      'value': value,
      'goal_value': goalValue,
      'picture': picture,
    };
  }

  SavingModel copyWith({
  int? id,
  String? uuid,
  String? title,
  double? value,
  double? goalValue,
  final String? picture,
  DateTime? createdAt,
}) {
  return SavingModel(
    id: id ?? this.id,
    uuid: uuid ?? this.uuid,
    title: title ?? this.title,
    value: value ?? this.value,
    goalValue: goalValue ?? this.goalValue,
    picture: picture ?? this.picture,
    createdAt: createdAt ?? this.createdAt,
  );
}

}
