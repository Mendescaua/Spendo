class CategoryTransactionModel {
  final String? uuid;
  final String name;
  final String type;

  CategoryTransactionModel({
    this.uuid,
    required this.name,
    required this.type,
  });

  factory CategoryTransactionModel.fromJson(Map<String, dynamic> json) {
    return CategoryTransactionModel(
      uuid: json['uuid'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'name': name,
      'type': type,
    };
  }
}