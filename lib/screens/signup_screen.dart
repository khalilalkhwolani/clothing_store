import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myprojectshop/controller/auth_controller.dart';
import 'package:myprojectshop/screens/login_screen.dart';
import 'package:myprojectshop/theme/theme.dart';
import 'package:myprojectshop/widgets/custom_text_field.dart';
import 'package:myprojectshop/widgets/gradint_bottom.dart';
import 'package:myprojectshop/widgets/social_login_button.dart';

// Convert to StatefulWidget
class SignupScreen extends StatefulWidget {
  SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // Define the key here, once per state object lifecycle
  final _formkey = GlobalKey<FormState>();
  final AuthController authController = Get.find<AuthController>();

  // Define controllers here as well
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers in initState
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    // Dispose controllers in dispose
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Key and controllers are now accessed from the state object
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: true,
            expandedHeight: 120,
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                'Create Account',
                style: TextStyle(
                  color: AppTheme.backgroundColor,
                  fontSize: 20, // Adjusted size for AppBar
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: AppTheme.primaryGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            // Removed redundant back button and title from here if using AppBar's leading/title
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 32, // Increased vertical padding
              ),
              child: Form(
                key: _formkey, // Use the state's key instance
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Create your account",
                      style: TextStyle(
                        fontSize: 22, // Slightly larger
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Sign up to start your shopping journey!", // More engaging text
                      style: TextStyle(
                        fontSize: 15,
                        color: AppTheme.textsecandery,
                      ),
                    ),
                    const SizedBox(height: 32),
                    CustomTextField(
                      label: "Full name",
                      prefixIcon: Icons.person_outline,
                      keyboardType: TextInputType.name,
                      validator:
                          (value) =>
                              value == null || value.trim().isEmpty
                                  ? "Please enter your full name"
                                  : null,
                      controller: nameController,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: "Email",
                      prefixIcon: Icons.email_outlined, // Use outlined icon
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter your email address";
                        }
                        if (!GetUtils.isEmail(value.trim())) {
                          // Use GetUtils for validation
                          return "Please enter a valid email address";
                        }
                        return null;
                      },
                      controller: emailController,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: "Password",
                      prefixIcon: Icons.lock_outline, // Use outlined icon
                      keyboardType: TextInputType.visiblePassword,
                      isPassword: true,
                      validator:
                          (value) =>
                              value == null || value.length < 6
                                  ? "Password must be at least 6 characters"
                                  : null,
                      controller: passwordController,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: "Confirm Password",
                      prefixIcon: Icons.lock_outline, // Use outlined icon
                      keyboardType: TextInputType.visiblePassword,
                      isPassword: true,
                      validator:
                          (value) =>
                              value != passwordController.text
                                  ? "Passwords do not match"
                                  : null,
                      controller: confirmPasswordController,
                    ),
                    const SizedBox(height: 32),
                    GradintBottom(
                      text: "Create Account",
                      onPressed: () {
                        if (_formkey.currentState!.validate()) {
                          // Consider showing loading indicator here
                          authController.registerUser(
                            username: nameController.text.trim(),
                            email: emailController.text.trim(),
                            password: passwordController.text,
                          );
                          // Navigate only after successful registration confirmation
                          // Get.offAll(() => MainScrean()); // Maybe move this based on authController result
                        }
                      },
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: AppTheme.textsecandery.withOpacity(0.5),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            "Or continue with",
                            style: TextStyle(color: AppTheme.textsecandery),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: AppTheme.textsecandery.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: SocialLoginButton(
                            iconPath: "assets/icons/google.png",
                            text: "Google",
                            image:
                                "assets/icons/google.png", // Assuming image and iconPath are the same?
                            onPressed: () {
                              // Implement Google Sign-in logic
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: SocialLoginButton(
                            iconPath:
                                "assets/icons/iphon.png", // Assuming this is Apple?
                            text: "Apple",
                            image: "assets/icons/iphon.png",
                            onPressed: () {
                              // Implement Apple Sign-in logic
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account? "),
                        TextButton(
                          onPressed:
                              () => Get.off(
                                () => LoginScreen(),
                              ), // Use GetX navigation
                          child: Text(
                            "Login",
                            style: TextStyle(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24), // Add padding at the bottom
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
