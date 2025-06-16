class SubscriptionModel {
  final String? uuid;
  final String name;
  final String? description;
  final double value;
  final String time;

  SubscriptionModel({
    this.uuid,
    required this.name,
    required this.value,
    required this.time,
    this.description
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      uuid: json['uuid'],
      name: json['name'],
      description: json['description'],
      value: json['value'],
      time: json['time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'name': name,
      'description': description,
      'value': value,
      'time': time,
    };
  }
}