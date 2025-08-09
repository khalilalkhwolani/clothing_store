import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:myprojectshop/model/product_model.dart';
import 'package:myprojectshop/model/cart_item_model.dart';
import 'package:myprojectshop/theme/theme.dart';

// كنترولر السلة باستخدام GetX
class CartController extends GetxController {
  // final CartService _cartService = CartService();

  final RxList<CartItem> cartItems = <CartItem>[].obs;

  final RxDouble _totalPrice = 0.0.obs;

  final RxInt _itemCount = 0.obs;

  double get totalPrice => _totalPrice.value;
  int get itemCount => _itemCount.value;

  @override
  void onInit() {
    super.onInit();
    ever(cartItems, (_) => _calculateTotals());
  }

  void _calculateTotals() {
    double total = 0.0;
    int count = 0;
    for (var item in cartItems) {
      total += item.totalPrice;
      count += item.quantity;
    }
    _totalPrice.value = total;
    _itemCount.value = count;
  }

  void addToCart(
    Product product, {
    int quantity = 1,
    String? selectedSize,
    String? selectedColor,
  }) {
    int existingIndex = cartItems.indexWhere(
      (item) => item.product.id == product.id,
      // item.selectedSize == selectedSize &&
      // item.selectedColor == selectedColor,
    );

    if (existingIndex >= 0) {
      CartItem existingItem = cartItems[existingIndex];
      cartItems[existingIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + quantity,
      );
    } else {
      cartItems.add(
        CartItem(
          userId:
              product
                  .id!, // Make sure Product has userId, otherwise provide the correct userId
          productId: product.id!,
          product: product,
          quantity: quantity,
          // selectedSize: selectedSize,
          // selectedColor: selectedColor,
        ),
      );
    }

    Get.snackbar(
      'تمت الإضافة إلى السلة',
      'تمت إضافة ${product.name} إلى سلة التسوق',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppTheme.primaryColor.withOpacity(0.8),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void increaseQuantity(int index) {
    if (index >= 0 && index < cartItems.length) {
      CartItem item = cartItems[index];
      cartItems[index] = item.copyWith(quantity: item.quantity + 1);
    }
  }

  void decreaseQuantity(int index) {
    if (index >= 0 && index < cartItems.length) {
      CartItem item = cartItems[index];
      if (item.quantity > 1) {
        cartItems[index] = item.copyWith(quantity: item.quantity - 1);
      } else {
        removeItem(index);
      }
    }
  }

  void removeItem(int index) {
    if (index >= 0 && index < cartItems.length) {
      cartItems.removeAt(index);
    }
  }

  void clearCart() {
    cartItems.clear();
  }

  bool isInCart(int productId) {
    return cartItems.any((item) => item.product.id == productId);
  }

  int getQuantityForProduct(int productId) {
    int quantity = 0;
    for (var item in cartItems) {
      if (item.product.id == productId) {
        quantity += item.quantity;
      }
    }
    return quantity;
  }
}
