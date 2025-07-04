class CategoryTransactionModel {
  final int? id;
  final String? uuid;
  final String name;
  final String type;
  final String color;
  final bool? isArchived;

  CategoryTransactionModel({
    this.id,
    this.uuid,
    required this.name,
    required this.type,
    required this.color,
    this.isArchived,
  });

  factory CategoryTransactionModel.fromJson(Map<String, dynamic> json) {
    return CategoryTransactionModel(
      id: json['id'],
      uuid: json['uuid'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      color: json['color'] as String? ?? '#FFFFFF',
      isArchived: json['is_archived'] ?? false,
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

  CategoryTransactionModel copyWith({
    int? id,
    String? uuid,
    String? name,
    String? type,
    String? color,
    bool? isArchived,
  }) {
    return CategoryTransactionModel(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      type: type ?? this.type,
      color: color ?? this.color,
      isArchived: isArchived ?? this.isArchived,
    );
  }
}
