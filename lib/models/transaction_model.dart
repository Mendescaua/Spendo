class TransactionModel {
  final String? uuid;
  final String type; // 'r' or 'd' (receita ou despesa)
  final double value;
  final String title;
  final String? description;
  final String category;
  final DateTime date;

  TransactionModel({
    this.uuid,
    required this.type,
    required this.value,
    required this.title,
    this.description,
    required this.category,
    required this.date,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      uuid: json['uuid'] as String,
      type: json['type'] as String,
      value: (json['value'] as num).toDouble(),
      title: json['title'] as String,
      description: json['description'] as String?,
      category: json['category'] as String,
      date: DateTime.parse(json['date'] as String),
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
    };
  }
}
