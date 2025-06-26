class BanksModel {
  final String? uuid;
  final String name;
  final String type;

  BanksModel({
    this.uuid,
    required this.name,
    required this.type
  });

  factory BanksModel.fromJson(Map<String, dynamic> json) {
    return BanksModel(
      uuid: json['uuid'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'name': name,
      'type': type
    };
  }
}
