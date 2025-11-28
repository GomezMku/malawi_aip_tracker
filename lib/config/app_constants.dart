class AppConstants {
  static const String appName = 'The Malawi AIP Tracker';
  static const String appTagline = 'Building A Nation Of Self-Reliant Farmers';

  // User Roles
  static const String roleFarmer = 'farmer';
  static const String roleDistributor = 'distributor';
  static const String roleVasp = 'vasp';
  static const String roleAdmin = 'admin';

  // Collections
  static const String usersCollection = 'users';
  static const String farmersCollection = 'farmers';
  static const String distributorsCollection = 'distributors';
  static const String vaspsCollection = 'vasps';
  static const String adminsCollection = 'admins';
  static const String transactionsCollection = 'transactions';
  static const String allocationsCollection = 'allocations';
  static const String auditLogsCollection = 'audit_logs';

  // Validation
  static const int minPasswordLength = 6;
  static const int phoneNumberLength = 13;

  // Durations
  static const Duration splashDuration = Duration(seconds: 3);
}
