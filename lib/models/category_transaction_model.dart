class CategoryTransactionModel {
  final int? id;
  final String? uuid;
  final String name;
  final String type;
  final String color;

  CategoryTransactionModel({
    this.id,
    this.uuid,
    required this.name,
    required this.type,
    required this.color,
  });

  factory CategoryTransactionModel.fromJson(Map<String, dynamic> json) {
    return CategoryTransactionModel(
      id: json['id'],
      uuid: json['uuid'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      color: json['color'] as String? ?? '#FFFFFF',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'name': name,
      'type': type,
      'color': color,
    };
  }
}
