class MoneyCardModel {
  final int? id;
  final String? uuid;
  final double number;
  final String name;
  final String flag;
  final DateTime? validity;
  final DateTime? createdAt;
  final int? order;

  MoneyCardModel({
    this.id,
    this.uuid,
    required this.number,
    required this.name,
    required this.flag,
    required this.validity,
    this.createdAt,
    this.order,
  });

  factory MoneyCardModel.fromJson(Map<String, dynamic> json) {
    return MoneyCardModel(
      id: json['id'],
      uuid: json['uuid'],
      number: (json['number'] as num).toDouble(),
      name: json['name'],
      flag: json['flag'],
      validity: json['validity'] != null
          ? DateTime.parse(json['validity'])
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      order: json['order'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'number': number,
      'name': name,
      'flag': flag,
      'validity': validity?.toIso8601String(),
    };
  }
}
