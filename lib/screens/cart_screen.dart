import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myprojectshop/controller/auth_controller.dart';
import 'package:myprojectshop/controller/cart_controller.dart';
import 'package:myprojectshop/screens/checkout_screen.dart';
import 'package:myprojectshop/screens/login_screen.dart';
import 'package:myprojectshop/theme/theme.dart';
// Ensure the correct import for GradientButton. If the widget is named 'GradientButton' in gradint_bottom.dart, this import is correct.
// If the widget is named differently (e.g., 'GradientBottomButton'), update the usage below accordingly.

class CartScreen extends StatelessWidget {
  // استخدام GetX للوصول إلى متحكم السلة
  final CartController cartController = Get.find<CartController>();

  // final OrderController ordercontroller = Get.find<OrderController>();
  // final Product? product;

  CartScreen({Key? key}) : super(key: key);
  // CartScreen({Key? key, Product}) : super(key: key);

  Widget _buildCartItem(int index) {
    final item = cartController.cartItems[index];

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(12),
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
      child: Row(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child:
                item.product.imageUrl != null &&
                        item.product.imageUrl!.isNotEmpty
                    ? Image.file(
                      File(item.product.imageUrl!),
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) =>
                              Icon(Icons.image_not_supported, size: 50),
                    )
                    : Icon(Icons.inventory_2_outlined, size: 50),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.product.name ?? 'منتج',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete_outline, color: AppTheme.error),
                      onPressed: () {
                        cartController.removeItem(index);
                      },
                    ),
                  ],
                ),
                SizedBox(height: 2),
                Text(
                  // "المقاس: ${item.selectedSize ?? 'غير محدد'} | اللون: ${item.selectedColor ?? 'غير محدد'}"
                  'Fall',
                  style: TextStyle(fontSize: 12, color: AppTheme.textsecandery),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "\$${item.product.price.toStringAsFixed(2) ?? '0.00'}",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppTheme.textsecandery.withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          _buildQuantityButton(
                            icon: Icons.remove,
                            onPressed: () {
                              cartController.decreaseQuantity(index);
                            },
                          ),
                          SizedBox(
                            width: 40,
                            child: Center(
                              child: Text(
                                "${item.quantity}",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          _buildQuantityButton(
                            icon: Icons.add,
                            onPressed: () {
                              cartController.increaseQuantity(index);
                            },
                          ),
                        ],
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

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? AppTheme.textPrimary : AppTheme.textsecandery,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? AppTheme.primaryColor : AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(icon, size: 16, color: AppTheme.primaryColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double subtotel = cartController.totalPrice;
    final double shipping = 10.0;
    final double tax = subtotel * 0.05;
    final double total = subtotel + shipping + tax;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Obx(() {
        return CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: 120,
              backgroundColor: Colors.transparent,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: AppTheme.primaryGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: FlexibleSpaceBar(
                  title: Text(
                    "Cart Shopping (${cartController.itemCount})",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  centerTitle: true,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child:
                  cartController.cartItems.isEmpty
                      ? _buildEmptyCart()
                      : Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // عناصر السلة
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: cartController.cartItems.length,
                              itemBuilder: (context, index) {
                                return _buildCartItem(index);
                              },
                            ),
                            SizedBox(height: 24),

                            // ملخص السلة
                            Container(
                              padding: EdgeInsets.all(16),
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
                                  _buildSummaryRow(
                                    " Subtotal ",
                                    "\$${cartController.totalPrice.toStringAsFixed(2)}",
                                  ),
                                  _buildSummaryRow("Shopping", "\$10.00"),
                                  _buildSummaryRow(
                                    "Tax",
                                    "\$${(cartController.totalPrice * 0.05).toStringAsFixed(2)}",
                                  ),
                                  Divider(height: 24),
                                  _buildSummaryRow(
                                    "Total",
                                    "\$${(cartController.totalPrice + shipping + (cartController.totalPrice * 0.05)).toStringAsFixed(2)}",
                                    isTotal: true,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 24),

                            // زر الدفع
                            GradientButton(
                              text: "  countim checkout ",

                              onPressed: () {
                                final AuthController authController =
                                    Get.find<AuthController>();
                                final userId =
                                    authController.currentUser.value?.id;

                                if (userId == null) {
                                  Get.snackbar(
                                    "تنبيه",
                                    "يجب تسجيل الدخول أولاً",
                                    colorText: Colors.white,
                                    backgroundColor: Colors.red,
                                  );
                                  Get.to(() => LoginScreen());
                                } else {
                                  // cartController.addToCart(product);
                                  final cartItems = cartController.cartItems;
                                  final subtotal = cartController.totalPrice;

                                  Get.to(
                                    () => CheckoutScreen(
                                      cartItems: cartItems,
                                      subtotel: subtotal,
                                    ),
                                  );
                                  Get.snackbar(
                                    "تمت الإضافة",
                                    "تمت إضافة المنتج إلى السلة",
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 100,
              color: AppTheme.textsecandery.withOpacity(0.5),
            ),
            SizedBox(height: 24),
            Text(
              "سلة التسوق فارغة",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "يبدو أنك لم تضف أي منتجات إلى سلة التسوق بعد",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: AppTheme.textsecandery),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Get.back(); // العودة إلى الشاشة السابقة
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "استمر في التسوق",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const GradientButton({Key? key, required this.text, required this.onPressed})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        onPressed: onPressed,
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: AppTheme.primaryGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
