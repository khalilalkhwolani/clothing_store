class UserModel {
  final int? id;
  final String username;
  final String email;
  final String password;
  final String? role;

  UserModel({
    this.id,
    required this.username,
    required this.email,
    required this.password,
    this.role,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
      "role": role,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      role: map['role'] ?? '',
    );
  }

  // Optional: Override toString for easy printing/debugging
  @override
  String toString() {
    return 'UserModel{id: $id, username: ${username ?? ''}, email: ${email ?? ''},role":$role??'
        '}';
  }
}
