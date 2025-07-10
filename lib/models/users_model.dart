class UsersModel {
  final String? uuid;
  final String name;
  final String email;
  final String? picture;

  UsersModel({
    this.uuid,
    required this.name,
    required this.email,
    this.picture,
  });

  factory UsersModel.fromJson(Map<String, dynamic> json) {
    return UsersModel(
      uuid: json['uuid'],
      name: json['name'],
      email: json['email'],
      picture: json['picture'],
    );
  }

  Map<String, dynamic> toJson() => {
        'uuid': uuid,
        'name': name,
        'email': email,
        'picture': picture,
  };

  UsersModel copyWith({
    String? uuid,
    String? name,
    String? email,
    String? picture,
  }) {
    return UsersModel(
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      email: email ?? this.email,
      picture: picture ?? this.picture,
    );
  }
}