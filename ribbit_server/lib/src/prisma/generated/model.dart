class User {
  const User({
    this.id,
    this.email,
    this.firstName,
  });

  factory User.fromJson(Map json) => User(
        id: json['id'],
        email: json['email'],
        firstName: json['firstName'],
      );

  final int? id;

  final String? email;

  final String? firstName;

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'firstName': firstName,
      };
}
