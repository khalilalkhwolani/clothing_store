import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:myprojectshop/screens/home_screen.dart';
import 'package:myprojectshop/screens/login_screen.dart';
import 'package:myprojectshop/theme/theme.dart';
import 'package:myprojectshop/widgets/gradint_bottom.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 12, 9, 9),
            ),
          ),
          Lottie.asset('assets/icons/global-delivery.json'),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Spacer(),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.shopping_bag_outlined,
                          size: 32,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'ShopEase',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Discover \nYour style',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 48,
                      height: 1.2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 12),
                  Text(
                    'The best way to shop your favourite products and discover new ones',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 24),
                  GradintBottom(
                    text: "Get Started",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    },
                  ),
                  Text(
                    "I already have an account",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),

                  SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ),

                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Log in',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
