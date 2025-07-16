class AppUser {
  final String id;
  final String name;
  final String email;
  final String role; // 'reader', 'clerk', or 'manager'
  final DateTime? joinDate;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.joinDate,
  });

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? 'reader',
      joinDate: map['joinDate'], // Don't call toDate() here, pass the DateTime directly
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'joinDate': joinDate,
    };
  }
}