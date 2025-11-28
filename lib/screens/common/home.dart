import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../config/app_constants.dart';
import '../../providers/user.dart';
import '../farmer/dashboard.dart';
import '../distributor/dashboard.dart';
import '../vasp/dashboard.dart';
import '../admin/dashboard.dart';
import '../auth/login.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        if (userProvider.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: AppTheme.primaryGreen),
            ),
          );
        }

        final user = userProvider.user;
        if (user == null) {
          return const LoginScreen();
        }

        // Route to appropriate dashboard based on role
        switch (user.role) {
          case AppConstants.roleFarmer:
            return const FarmerDashboard();
          case AppConstants.roleDistributor:
            return const DistributorDashboard();
          case AppConstants.roleVasp:
            return const VaspDashboard();
          case AppConstants.roleAdmin:
            return const AdminDashboard();
          default:
            return _buildErrorScreen(context, userProvider);
        }
      },
    );
  }

  Widget _buildErrorScreen(BuildContext context, UserProvider userProvider) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline,
                  size: 80, color: AppTheme.errorRed),
              const SizedBox(height: 24),
              Text(
                'Invalid User Role',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 16),
              Text(
                'Your account has an invalid role. Please contact support.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () async {
                  await userProvider.signOut();
                  if (context.mounted) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  }
                },
                child: const Text('Sign Out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
