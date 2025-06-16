class SubscriptionModel {
  final int? id;
  final String? uuid;
  final String name;
  final double value;
  final String time;
  final DateTime? createdAt;

  SubscriptionModel({
    this.id,
    this.uuid,
    required this.name,
    required this.value,
    required this.time,
    this.createdAt,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      id: json['id'],
      uuid: json['uuid'],
      name: json['name'],
      value: (json['value'] as num).toDouble(),
      time: json['time'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uuid': uuid,
      'name': name,
      'value': value,
      'time': time,
    };
  }
}