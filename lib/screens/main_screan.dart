import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myprojectshop/controller/ProductController.dart';
import 'package:myprojectshop/controller/cart_controller.dart';
import 'package:myprojectshop/model/cart_item_model.dart';
import 'package:myprojectshop/model/product_model.dart';
import 'package:myprojectshop/screens/cart_screen.dart';
import 'package:myprojectshop/screens/chat_list_screen.dart';
import 'package:myprojectshop/screens/home_screen.dart';
import 'package:myprojectshop/screens/profile_screen.dart';
import 'package:myprojectshop/theme/theme.dart';

class MainScrean extends StatefulWidget {
  final ProductController productcontroller = Get.find<ProductController>();
  final CartController cartcontroller = Get.find<CartController>();

  final Product? product;
  final CartItem? cartItem;

  MainScrean({Key? key, this.product, this.cartItem}) : super(key: key);

  @override
  State<MainScrean> createState() => _MainScreanState();
}

class _MainScreanState extends State<MainScrean> {
  int _currentIndex = 0;
  bool _showCartBadge = false;

  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [HomeScreen(), ChatListScreen(), CartScreen(), ProfileScreen()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildNavItem(0, Icons.home_outlined, Icons.home, "Home"),
                _buildNavItem(1, Icons.chat_outlined, Icons.chat, "Chat"),
                _buildCartNavItem(),
                _buildNavItem(
                  3,
                  Icons.person_2_outlined,
                  Icons.person,
                  "Profile",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Expanded _buildNavItem(
    int index,
    IconData outlinedIcon,
    IconData filledIcon,
    String label,
  ) {
    bool isSelected = _currentIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _currentIndex = index;
            _showCartBadge = false;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            gradient:
                isSelected
                    ? LinearGradient(
                      colors: AppTheme.primaryGradient,
                      begin: Alignment.topRight,
                      end: Alignment.bottomRight,
                    )
                    : null,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSelected ? filledIcon : outlinedIcon,
                color: isSelected ? Colors.white : AppTheme.primaryColor,
              ),
              SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? Colors.white : AppTheme.textsecandery,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCartNavItem() {
    bool isSelected = _currentIndex == 2;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _currentIndex = 2;
            _showCartBadge = true;
          });
        },
        child: Container(
          decoration:
              isSelected
                  ? BoxDecoration(
                    gradient: LinearGradient(
                      colors: AppTheme.primaryGradient,
                      begin: Alignment.topRight,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  )
                  : null,
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Icon(
                      isSelected
                          ? Icons.shopping_cart
                          : Icons.shopping_cart_outlined,
                      color: isSelected ? Colors.white : AppTheme.textsecandery,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Cart",
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? Colors.white : AppTheme.textsecandery,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
              if (_showCartBadge)
                Positioned(
                  top: -8,
                  right: -8,
                  child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppTheme.error,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      widget.cartcontroller.itemCount.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
