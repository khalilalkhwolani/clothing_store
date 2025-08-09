import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myprojectshop/admin/dashbord_screen.dart';
import 'package:myprojectshop/controller/auth_controller.dart';
import 'package:myprojectshop/screens/main_screan.dart';
import 'package:myprojectshop/screens/signup_screen.dart';
import 'package:myprojectshop/theme/theme.dart';
import 'package:myprojectshop/widgets/custom_text_field.dart';
import 'package:myprojectshop/widgets/gradint_bottom.dart';
import 'package:myprojectshop/widgets/social_login_button.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final _formkey = GlobalKey<FormState>();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    void _login() async {
      final success = await authController.loginUser(
        usernameOrEmail: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (success) {
        if (authController.isAdmin) {
          Get.offAll(() => AdminDashboard()); // ✅ تسجيل ناجح
        } else {
          Get.offAll(() => MainScrean());
        } // ✅ تسجيل ناجح
      } else {
        if (authController.errorMessage.value == 'User not found') {
          Get.defaultDialog(
            title: 'Account not found',
            middleText: 'This email is not registered. Do you want to sign up?',
            textCancel: 'Cancel',
            textConfirm: 'Sign Up',
            onConfirm: () {
              Get.off(() => SignupScreen());
            },
          );
        } else {
          Get.snackbar(
            'Login Failed',
            authController.errorMessage.value,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Stack(
                children: [
                  // الخلفية الزرقاء
                  Container(
                    height: constraints.maxHeight * 0.5,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: AppTheme.primaryGradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: -50,
                          right: -50,
                          child: Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.1),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 48,
                          left: 16,
                          right: 16,
                          child: Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                                onPressed: () => Navigator.pop(context),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    "Welcome Back",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 40),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // الفورم الأبيض
                  Padding(
                    padding: EdgeInsets.only(top: constraints.maxHeight * 0.2),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 24),
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(30),
                          bottom: Radius.circular(30),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formkey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Login to your account",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Login to your credentials to shopping",
                              style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.textsecandery,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 24),
                            CustomTextField(
                              label: "Email",
                              prefixIcon: Icons.email,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter your email";
                                }
                                if (!value.contains('@')) {
                                  return "Please enter a valid email";
                                }
                                return null;
                              },
                              controller: emailController,
                            ),
                            SizedBox(height: 16),
                            CustomTextField(
                              label: "Password",
                              prefixIcon: Icons.lock,
                              keyboardType: TextInputType.visiblePassword,
                              isPassword: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter your password";
                                }
                                if (value.length < 6) {
                                  return "Password must be at least 6 characters";
                                }
                                return null;
                              },
                              controller: passwordController,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  // Forgot password
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: AppTheme.primaryColor,
                                ),
                                child: Text("Forgot password?"),
                              ),
                            ),
                            SizedBox(height: 24),
                            GradintBottom(
                              text: "Login",
                              onPressed: () {
                                if (_formkey.currentState!.validate()) {
                                  // final email = emailController;
                                  // final password = passwordController;
                                  // if (authController.isAdmin) {}
                                  // authController.loginUser(
                                  //   usernameOrEmail: email.text,
                                  //   password: password.text,
                                  // );
                                  _login();
                                  // Get.to(MainScrean());
                                }
                              },
                            ),
                            SizedBox(height: 24),
                            Center(
                              child: Text(
                                "Or continue with",
                                style: TextStyle(
                                  color: AppTheme.textsecandery,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                  child: SocialLoginButton(
                                    iconPath: "assets/icons/google.png",
                                    text: "Google",
                                    image: "assets/icons/google.png",
                                    onPressed: () {},
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: SocialLoginButton(
                                    iconPath: "assets/icons/iphon.png",
                                    text: "Apple",
                                    image: "assets/icons/iphon.png",
                                    onPressed: () {},
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 24),
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Don't have an account? ",
                                    style: TextStyle(
                                      color: AppTheme.textsecandery,
                                      fontSize: 14,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SignupScreen(),
                                        ),
                                      );
                                    },
                                    style: TextButton.styleFrom(
                                      foregroundColor: AppTheme.primaryColor,
                                    ),
                                    child: Text("Sign Up"),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
