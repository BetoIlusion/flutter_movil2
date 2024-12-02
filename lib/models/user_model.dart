class User {
  final String id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});

  // Método para convertir de JSON a User
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }

  // Método para convertir de User a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}
