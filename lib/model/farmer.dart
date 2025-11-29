class FarmerModel {
  final String uid;
  final String? email; // Made optional
  final String phoneNumber;
  final String fullName;
  final String idNumber;
  final String village;
  final String district;
  final String traditionalAuthority;
  final double farmSize; // Changed to double for land size
  final String cropType;
  final DateTime? dateOfBirth; // New field
  final String? occupation; // New field
  final String? agriculturalExtension; // New field (AE)
  final bool isVerified;
  final DateTime createdAt;
  final DateTime updatedAt; // New field

  FarmerModel({
    required this.uid,
    this.email, // Made optional
    required this.phoneNumber,
    required this.fullName,
    required this.idNumber,
    required this.village,
    required this.district,
    required this.traditionalAuthority,
    required this.farmSize, // Changed to double
    required this.cropType,
    this.dateOfBirth, // New optional field
    this.occupation, // New optional field
    this.agriculturalExtension, // New optional field
    this.isVerified = false,
    required this.createdAt,
    required this.updatedAt, // New field
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'phoneNumber': phoneNumber,
      'fullName': fullName,
      'idNumber': idNumber,
      'village': village,
      'district': district,
      'traditionalAuthority': traditionalAuthority,
      'farmSize': farmSize, // Now stored as number
      'cropType': cropType,
      'dateOfBirth': dateOfBirth?.toIso8601String(), // New field
      'occupation': occupation, // New field
      'agriculturalExtension': agriculturalExtension, // New field
      'isVerified': isVerified,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(), // New field
    };
  }

  factory FarmerModel.fromMap(Map<String, dynamic> map) {
    return FarmerModel(
      uid: map['uid'] ?? '',
      email: map['email'], // Can be null
      phoneNumber: map['phoneNumber'] ?? '',
      fullName: map['fullName'] ?? '',
      idNumber: map['idNumber'] ?? '',
      village: map['village'] ?? '',
      district: map['district'] ?? '',
      traditionalAuthority: map['traditionalAuthority'] ?? '',
      farmSize: (map['farmSize'] is String)
          ? double.tryParse(map['farmSize']) ?? 0.0
          : (map['farmSize'] ?? 0.0)
              .toDouble(), // Handle both string and number
      cropType: map['cropType'] ?? '',
      dateOfBirth: map['dateOfBirth'] != null
          ? DateTime.tryParse(map['dateOfBirth'])
          : null, // New field
      occupation: map['occupation'], // New field
      agriculturalExtension: map['agriculturalExtension'], // New field
      isVerified: map['isVerified'] ?? false,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'])
          : DateTime.now(), // New field
    );
  }
}
