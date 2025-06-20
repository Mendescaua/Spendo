class SavingModel {
  final int? id;
  final String? uuid;
  final String? title;
  final double? value;
  final double? goalValue;
  final String? colorCard;
  final DateTime? createdAt;

  SavingModel(
      {this.id,
      this.uuid,
      this.title,
      this.value,
      this.goalValue,
      this.colorCard,
      this.createdAt});

  factory SavingModel.fromJson(Map<String, dynamic> json) {
    return SavingModel(
      id: json['id'],
      uuid: json['uuid'],
      title: json['title'],
      value: json['value'] != null ? (json['value'] as num).toDouble() : 0.0,
      goalValue: json['goal_value'] != null
          ? (json['goal_value'] as num).toDouble()
          : 0.0,
      colorCard: json['color_card'],
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
      'color_card': colorCard,
    };
  }

  SavingModel copyWith({
  int? id,
  String? uuid,
  String? title,
  double? value,
  double? goalValue,
  String? colorCard,
  DateTime? createdAt,
}) {
  return SavingModel(
    id: id ?? this.id,
    uuid: uuid ?? this.uuid,
    title: title ?? this.title,
    value: value ?? this.value,
    goalValue: goalValue ?? this.goalValue,
    colorCard: colorCard ?? this.colorCard,
    createdAt: createdAt ?? this.createdAt,
  );
}

}
