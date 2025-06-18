class SavingModel {
  final int? id;
  final String? uuid;
  final String title;
  final double value;
  final double goalValue;
  final String colorCard;
  final DateTime? createAt;

  SavingModel({this.id, this.uuid, required this.title, required this.value, required this.goalValue, required this.colorCard, this.createAt});

   factory SavingModel.fromJson(Map<String, dynamic> json) {
    return SavingModel(
      id: json['id'],
      uuid: json['uuid'],
      title: json['title'],
      value: json['value'],
      goalValue: json['goal_value'],
      colorCard: json['color_card'],
      createAt: json['create_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uuid': uuid,
      'title': title,
      'value': value,
      'goal_value': goalValue,
      'color_card': colorCard,
      'create_at': createAt,
    };
  }
}