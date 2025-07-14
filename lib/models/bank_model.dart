class BanksModel {
  final int? id;
  final String? uuid;
  final String name;
  final String type;

  BanksModel({
    this.id,
    this.uuid,
    required this.name,
    required this.type
  });

  factory BanksModel.fromJson(Map<String, dynamic> json) {
    return BanksModel(
      id: json['id'] as int?,
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
