class UserModel {
  final String uid;
  final String email;
  final String role;
  final String? phoneNumber;
  final String? displayName;
  final DateTime createdAt;
  final bool isActive;

  UserModel({
    required this.uid,
    required this.email,
    required this.role,
    this.phoneNumber,
    this.displayName,
    required this.createdAt,
    this.isActive = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'role': role,
      'phoneNumber': phoneNumber,
      'displayName': displayName,
      'createdAt': createdAt.toIso8601String(),
      'isActive': isActive,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? '',
      phoneNumber: map['phoneNumber'],
      displayName: map['displayName'],
      createdAt: DateTime.parse(map['createdAt']),
      isActive: map['isActive'] ?? true,
    );
  }

  UserModel copyWith({
    String? uid,
    String? email,
    String? role,
    String? phoneNumber,
    String? displayName,
    DateTime? createdAt,
    bool? isActive,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      role: role ?? this.role,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      displayName: displayName ?? this.displayName,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }
}
