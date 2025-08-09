import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myprojectshop/controller/auth_controller.dart';
import 'package:myprojectshop/screens/login_screen.dart';
import 'package:myprojectshop/screens/order_details.dart';
import 'package:myprojectshop/screens/user_details_screen.dart';
import 'package:myprojectshop/theme/theme.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthController usercontroller = Get.find<AuthController>();

  // int? get user => null;
  final int user = 1;

  // get map => null;

  // Widget for the cart navigation item with a badge
  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                color: AppTheme.textsecandery,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required List<Widget> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textsecandery,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                // blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              ...items,
              SizedBox(height: 16), // Add some space at the bottom
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),

        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color:
                    isDestructive
                        ? AppTheme.error.withOpacity(0.1)
                        : color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isDestructive ? AppTheme.error : color,
                size: 24,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color:
                          isDestructive ? AppTheme.error : AppTheme.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textsecandery,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: AppTheme.textsecandery, size: 24),
          ],
        ),
      ),
    );
  }

  void initState() {
    super.initState();
    // usercontroller.loadUser();

    usercontroller.loadUser(); // تأكد أن فيه بيانات
    // print('User: ${usercontroller.currentUser.value}');
    // print('User name: ${usercontroller.currentUser.value?.username}');
    // print('User email: ${usercontroller.currentUser.value?.email}');
    // // print('User Map: $map');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.3,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: AppTheme.primaryGradient,

                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                // color: AppTheme.primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(35),
                  bottomRight: Radius.circular(35),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Profile',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.more_vert, color: Colors.white),
                          onPressed: () {
                            // Handle settings action
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.15,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 1.5,
                      margin: EdgeInsets.symmetric(horizontal: 24),
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.asset(
                                'assets/images/iphon.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Obx(() {
                            print(
                              "First Name: ${usercontroller.currentUser.value?.username.split(' ').first ?? ''}",
                            );
                            print(
                              "Current User: ${usercontroller.currentUser.value}",
                            );
                            print(
                              "Username: ${usercontroller.currentUser.value?.username}",
                            );
                            return Column(
                              children: [
                                Text(
                                  usercontroller.currentUser.value?.username ??
                                      'اسم المستخدم',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                                Text(
                                  usercontroller.currentUser.value?.email ??
                                      'البريد الإلكتروني',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [
                          _buildActionCard(
                            icon: Icons.shopping_cart,
                            title: 'Orders',
                            value: '12',
                            color: AppTheme.primaryColor,
                          ),
                          SizedBox(width: 16),
                          _buildActionCard(
                            icon: Icons.favorite,
                            title: 'favorite',
                            value: '5',
                            color: AppTheme.secondaryColor,
                          ),
                          SizedBox(width: 16),
                          _buildActionCard(
                            icon: Icons.delivery_dining_sharp,
                            title: 'Shopping ',
                            value: '5',
                            color: AppTheme.tertiaryColor,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: _buildSection(
                        title: 'Account Settings',
                        items: [
                          _buildMenuItem(
                            icon: Icons.person,
                            title: 'Profile Details',
                            subtitle: 'Edit your profile information',
                            color: AppTheme.primaryColor,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserDetailsScreen(),
                                ),
                              );
                            },
                          ),
                          _buildMenuItem(
                            icon: Icons.lock,
                            title: 'Security',
                            subtitle: 'Change your password',
                            color: AppTheme.primaryColor,
                            onTap: () {
                              // Handle security tap
                            },
                          ),
                          _buildMenuItem(
                            icon: Icons.notifications,
                            title: 'Notifications',
                            subtitle: 'Manage notification settings',
                            color: AppTheme.primaryColor,
                            onTap: () {
                              // Handle notifications tap
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: _buildSection(
                        title: 'Shopping  Preferences',
                        items: [
                          _buildMenuItem(
                            icon: Icons.shopping_bag_outlined,
                            title: 'My Orders',
                            subtitle: 'View your order history',
                            color: AppTheme.secondaryColor,
                            onTap: () {
                              Get.to(OrderDetailsScreen());
                            },
                          ),
                          _buildMenuItem(
                            icon: Icons.location_on_outlined,
                            title: 'location',
                            subtitle: 'Manage your delivery address',

                            color: AppTheme.secondaryColor,
                            onTap: () {
                              // Handle language tap
                            },
                          ),
                          _buildMenuItem(
                            icon: Icons.payment_outlined,
                            title: 'Payment Methods',
                            subtitle: 'Manage your payment options',
                            color: AppTheme.secondaryColor,
                            onTap: () {
                              // Handle currency tap
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: _buildSection(
                        title: 'More Options',
                        items: [
                          _buildMenuItem(
                            icon: Icons.settings_outlined,
                            title: 'Settings',
                            subtitle: 'App settings and preferences',
                            color: AppTheme.tertiaryColor,
                            onTap: () {
                              // Handle help center tap
                            },
                          ),
                          _buildMenuItem(
                            icon: Icons.help_outline,
                            title: 'Help Center',
                            subtitle: 'Get help and support',
                            color: AppTheme.tertiaryColor,
                            onTap: () {
                              // Handle feedback tap
                            },
                          ),
                          _buildMenuItem(
                            icon: Icons.logout,
                            title: 'Logout',
                            subtitle: 'Sign out of your account',
                            color: AppTheme.secondaryColor,
                            onTap: () {
                              final authController = Get.find<AuthController>();
                              authController.logout();
                              Get.off(LoginScreen());
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// extension on String? {
//   get value => null;
// }
