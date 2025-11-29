import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../config/app_constants.dart';
import '../../providers/user.dart';
import '../../services/farmer_service.dart';
import '../../model/farmer.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/input_field.dart';
import '../farmer/dashboard.dart';
import 'login.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _idController = TextEditingController();
  final _villageController = TextEditingController();
  final _districtController = TextEditingController();
  final _taController = TextEditingController();
  final _farmSizeController = TextEditingController();
  final _cropTypeController = TextEditingController();
  final _dobController = TextEditingController(); // New
  final _occupationController = TextEditingController(); // New
  final _aeController = TextEditingController(); // New (Agricultural Extension)

  final _farmerService = FarmerService();
  bool _isLoading = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _idController.dispose();
    _villageController.dispose();
    _districtController.dispose();
    _taController.dispose();
    _farmSizeController.dispose();
    _cropTypeController.dispose();
    _dobController.dispose();
    _occupationController.dispose();
    _aeController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final userProvider = Provider.of<UserProvider>(context, listen: false);

        // Create user account with Firebase Auth
        final authSuccess = await userProvider.signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          role: AppConstants.roleFarmer,
          phoneNumber: _phoneController.text.trim(),
        );

        if (authSuccess && userProvider.user != null) {
          // Parse date of birth
          DateTime? dob;
          if (_dobController.text.isNotEmpty) {
            try {
              dob = DateTime.parse(_dobController.text);
            } catch (e) {
              // Removed print statement to fix lint warning
            }
          }

          // Create farmer profile in Firestore
          final farmer = FarmerModel(
            uid: userProvider.user!.uid,
            email: _emailController.text.trim(),
            phoneNumber: _phoneController.text.trim(),
            fullName: _fullNameController.text.trim(),
            idNumber: _idController.text.trim(),
            village: _villageController.text.trim(),
            district: _districtController.text.trim(),
            traditionalAuthority: _taController.text.trim(),
            farmSize: double.tryParse(_farmSizeController.text) ?? 0.0,
            cropType: _cropTypeController.text.trim(),
            dateOfBirth: dob, // New field
            occupation: _occupationController.text.trim(), // New field
            agriculturalExtension: _aeController.text.trim(), // New field
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

          final profileCreated =
              await _farmerService.createFarmerProfile(farmer);

          if (profileCreated && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Account created successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const FarmerDashboard()),
            );
          } else if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to create farmer profile'),
                backgroundColor: AppTheme.errorRed,
              ),
            );
          }
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(userProvider.errorMessage ?? 'Sign up failed'),
              backgroundColor: AppTheme.errorRed,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: AppTheme.errorRed,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  // Date picker for DOB
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dobController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
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
                const SizedBox(height: 24),
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
                    Column(
                      children: [
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
                        Container(
                          height: 3,
                          width: 60,
                          color: AppTheme.primaryGreen,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'Farmer Registration',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: AppTheme.primaryGreen,
                      ),
                ),
                const SizedBox(height: 24),

                // Personal Information
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Personal Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryGreen,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                InputField(
                  label: 'Full Name *',
                  hint: 'John Banda',
                  controller: _fullNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                InputField(
                  label: 'ID Number *',
                  hint: 'National ID',
                  controller: _idController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your ID number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Date of Birth with picker - FIXED: wrapped icon in Icon widget
                GestureDetector(
                  onTap: _selectDate,
                  child: AbsorbPointer(
                    child: InputField(
                      label: 'Date of Birth (YYYY-MM-DD)',
                      hint: 'Tap to select date',
                      controller: _dobController,
                      suffixIcon: const Icon(Icons
                          .calendar_today), // FIXED: wrapped in Icon widget
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                InputField(
                  label: 'Occupation',
                  hint: 'Farmer, Teacher, etc.',
                  controller: _occupationController,
                ),
                const SizedBox(height: 16),

                InputField(
                  label: 'Phone Number *',
                  hint: '+265000000000',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                InputField(
                  label: 'Email (Optional)',
                  hint: 'contact@gmail.com',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),

                InputField(
                  label: 'Password *',
                  controller: _passwordController,
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Location Information
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Location Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryGreen,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                InputField(
                  label: 'Village *',
                  hint: 'Your village name',
                  controller: _villageController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your village';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                InputField(
                  label: 'District *',
                  hint: 'Your district',
                  controller: _districtController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your district';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                InputField(
                  label: 'Traditional Authority *',
                  hint: 'T/A Name',
                  controller: _taController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Traditional Authority';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                InputField(
                  label: 'Agricultural Extension (AE)',
                  hint: 'AE Area Name',
                  controller: _aeController,
                ),
                const SizedBox(height: 24),

                // Farm Information
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Farm Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryGreen,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                InputField(
                  label: 'Land Size (in hectares) *',
                  hint: '2.5',
                  controller: _farmSizeController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your farm size';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                InputField(
                  label: 'Crop Type *',
                  hint: 'Maize, Tobacco, etc.',
                  controller: _cropTypeController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your crop type';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                CustomButton(
                  text: 'Signup',
                  onPressed: _handleSignUp,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 24),

                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: TextStyle(color: AppTheme.textGrey),
                      ),
                      Text(
                        'Log in',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
