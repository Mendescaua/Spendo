class TransactionModel {
  final int? id;
  final String? uuid;
  final String type; // 'r' ou 'd'
  final double value;
  final String title;
  final String? description;
  final String category;
  final DateTime date;
  final DateTime? createdAt;
  final int? repeat;

  // Campos opcionais da categoria, podem ser null se não vierem da junção
  final String? categoryName;
  final String? categoryType;
  final String? categoryColor;

  TransactionModel({
    this.id,
    this.uuid,
    required this.type,
    required this.value,
    required this.title,
    this.description,
    required this.category,
    required this.date,
    this.createdAt,
    this.repeat,
    this.categoryName,
    this.categoryType,
    this.categoryColor,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as int?,
      uuid: json['uuid'] as String?,
      type: json['type'] as String,
      value: (json['value'] as num).toDouble(),
      title: json['title'] as String,
      description: json['description'] as String?,
      category: json['category'] as String,
      date: DateTime.parse(json['date'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      repeat: json['repeat'] as int?,
      categoryName: json['category_name'] as String?,
      categoryType: json['category_type'] as String?,
      categoryColor: json['category_color'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'type': type,
      'value': value,
      'title': title,
      'description': description,
      'category': category,
      'date': date.toIso8601String(),
      'repeat': repeat,
    };
  }

  TransactionModel copyWith({
    int? id,
    String? uuid,
    String? type,
    double? value,
    String? title,
    String? description,
    String? category,
    DateTime? date,
    DateTime? createdAt,
    int? repeat,
    String? categoryName,
    String? categoryType,
    String? categoryColor,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      type: type ?? this.type,
      value: value ?? this.value,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
      repeat: repeat ?? this.repeat,
      categoryName: categoryName ?? this.categoryName,
      categoryType: categoryType ?? this.categoryType,
      categoryColor: categoryColor ?? this.categoryColor,
    );
  }
}
