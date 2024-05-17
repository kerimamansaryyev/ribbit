class User {
  const User({
    this.id,
    this.email,
    this.name,
  });

  factory User.fromJson(Map json) => User(
        id: json['id'],
        email: json['email'],
        name: json['name'],
      );

  final int? id;

  final String? email;

  final String? name;

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'name': name,
      };
}
