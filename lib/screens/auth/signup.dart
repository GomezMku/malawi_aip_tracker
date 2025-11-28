import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../config/app_constants.dart';
import '../../providers/user.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/input_field.dart';
import 'login.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _idController = TextEditingController();
  final _farmSizeController = TextEditingController();
  final _locationController = TextEditingController();

  String _selectedRole = AppConstants.roleFarmer;

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _idController.dispose();
    _farmSizeController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      final success = await userProvider.signUp(
        email: _emailController.text.trim(),
        password: '123456', // Default password, should be changed
        role: _selectedRole,
        phoneNumber: _phoneController.text.trim(),
      );

      if (success && mounted) {
        // TODO: Replace with appropriate dashboard based on role
        // For now, navigate to login screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(userProvider.errorMessage ?? 'Sign up failed'),
            backgroundColor: AppTheme.errorRed,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textDark),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.primaryGreen, width: 3),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Icon(
                      Icons.eco,
                      size: 50,
                      color: AppTheme.primaryGreen,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (_) => const LoginScreen()),
                        );
                      },
                      child: const Text(
                        'Log in',
                        style: TextStyle(
                          color: AppTheme.textGrey,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 32),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Sign up',
                        style: TextStyle(
                          color: AppTheme.primaryGreen,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 2,
                  width: 80,
                  color: AppTheme.primaryGreen,
                  margin: const EdgeInsets.only(left: 120, right: 0),
                ),
                const SizedBox(height: 32),
                Text(
                  'Select Your Role',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildRoleButton(AppConstants.roleFarmer, 'Farmer'),
                const SizedBox(height: 12),
                _buildRoleButton(AppConstants.roleDistributor, 'Distributor'),
                const SizedBox(height: 12),
                _buildRoleButton(AppConstants.roleVasp, 'Vasp'),
                const SizedBox(height: 32),
                Text(
                  _selectedRole,
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: AppTheme.primaryGreen,
                      ),
                ),
                const SizedBox(height: 24),
                InputField(
                  label: 'Email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                InputField(
                  label: 'Phone Number',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),
                if (_selectedRole == AppConstants.roleFarmer) ...[
                  const SizedBox(height: 16),
                  InputField(
                    label: 'ID number',
                    controller: _idController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your ID number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  InputField(
                    label: 'Farm size',
                    controller: _farmSizeController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your farm size';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  InputField(
                    label: 'Location',
                    controller: _locationController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your location';
                      }
                      return null;
                    },
                  ),
                ],
                const SizedBox(height: 32),
                Consumer<UserProvider>(
                  builder: (context, userProvider, child) {
                    return CustomButton(
                      text: 'Signup',
                      onPressed: _handleSignUp,
                      isLoading: userProvider.isLoading,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleButton(String role, String label) {
    final isSelected = _selectedRole == role;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRole = role;
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryGreen : AppTheme.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.primaryGreen : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? AppTheme.white : AppTheme.textDark,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
