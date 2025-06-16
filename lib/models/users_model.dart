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
}