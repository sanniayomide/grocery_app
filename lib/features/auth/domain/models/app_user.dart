enum UserRole { customer, admin, delivery }

class AppUser {
  final String uid;
  final String email;
  final String? displayName;
  final UserRole role;
  final DateTime createdAt;

  const AppUser({
    required this.uid,
    required this.email,
    this.displayName,
    required this.role,
    required this.createdAt,
  });

  AppUser copyWith({
    String? uid,
    String? email,
    String? displayName,
    UserRole? role,
    DateTime? createdAt,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'role': role.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory AppUser.fromFirestore(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'] as String,
      email: map['email'] as String,
      displayName: map['displayName'] as String?,
      role: UserRole.values.firstWhere(
        (e) => e.name == (map['role'] as String? ?? 'customer'),
        orElse: () => UserRole.customer,
      ),
      createdAt: DateTime.parse(map['createdAt'] as String? ?? DateTime.now().toIso8601String()),
    );
  }
}
