import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:myprojectshop/screens/welcome_screen.dart';
import 'package:myprojectshop/theme/theme.dart';
import 'package:myprojectshop/widgets/gradint_bottom.dart';

class Onboardscreen extends StatefulWidget {
  const Onboardscreen({super.key});

  @override
  State<Onboardscreen> createState() => _OnboardscreenState();
}

class _OnboardscreenState extends State<Onboardscreen> {
  final PageController _pageController = PageController();

  int _currentPage = 0;

  final List<Onboardingdata> _pages = [
    Onboardingdata(
      // لعرض صورة من نوع JSON (ملف Lottie)، استخدم Lottie.asset بدلاً من Image.asset في OnboardingPage
      image: Lottie.asset('assets/icons/sh1.json'),
      title: 'Welcome to ShopEase',
      description: 'Discover the best products at  prices.',
    ),
    Onboardingdata(
      image: Lottie.asset('assets/icons/sh2.json'),
      title: 'Shop Anytime, Anywhere',
      description: 'Your favorite products are just a tap away.',
    ),
    Onboardingdata(
      image: Lottie.asset('assets/icons/successful-food-delivery.json'),
      title: 'Fast and Secure Checkout',
      description: 'Experience a shopping experience with us.',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return OnboardingPage(data: _pages[index]);
            },
          ),
          Positioned(
            top: 48,
            right: 24,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WelcomeScreen()),
                );
              },
              child: Text(
                "Skip",
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 48,
            left: 24,
            right: 24,

            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                    (index) => AnimatedContainer(
                      margin: EdgeInsets.symmetric(),
                      duration: const Duration(microseconds: 300),
                      height: 8,
                      width: _currentPage == index ? 24 : 8,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(
                          _currentPage == index ? 1 : 0.3,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 32),
                Row(
                  children: [
                    if (_currentPage > 0)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            _pageController.previousPage(
                              duration: Duration(microseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(color: AppTheme.primaryColor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            "Previous",
                            style: TextStyle(
                              color: AppTheme.primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    if (_currentPage > 0) const SizedBox(width: 16),
                    Expanded(
                      child: GradintBottom(
                        text:
                            _currentPage == _pages.length - 1
                                ? "Get Started"
                                : "Nexte",
                        gradint: [
                          AppTheme.primaryColor,
                          AppTheme.primaryColor.withOpacity(0.8),
                        ],
                        onPressed: () {
                          if (_currentPage < _pages.length - 1) {
                            _pageController.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WelcomeScreen(),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Onboardingdata {
  final Widget image;
  final String title;
  final String description;

  Onboardingdata({
    required this.image,
    required this.title,
    required this.description,
  });
}

class OnboardingPage extends StatelessWidget {
  final Onboardingdata data;

  const OnboardingPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: data.image, // <-- اعرض الصورة أو Lottie هنا
          ),
          const SizedBox(height: 48.0),
          Text(
            data.title,
            style: TextStyle(
              color: AppTheme.primaryColor,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16.0),
          Text(
            data.description,
            style: TextStyle(
              color: AppTheme.textsecandery,
              fontSize: 16,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
