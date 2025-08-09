import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myprojectshop/controller/auth_controller.dart';
import 'package:myprojectshop/controller/cart_controller.dart';
import 'package:myprojectshop/controller/order_controller.dart';
import 'package:myprojectshop/controller/order_item_controller.dart';
import 'package:myprojectshop/model/cart_item_model.dart';
import 'package:myprojectshop/model/order_model.dart';
import 'package:myprojectshop/model/orderitem_model.dart';
import 'package:myprojectshop/screens/order_confirmation_screen.dart';
import 'package:myprojectshop/theme/theme.dart';
import 'package:myprojectshop/widgets/gradint_bottom.dart';

class PaymentScreen extends StatefulWidget {
  final List<CartItem> cartItems;
  final double subtotel;

  PaymentScreen({required this.cartItems, required this.subtotel});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final CartController cartController = Get.find<CartController>();
  final OrderController orderController = Get.find<OrderController>();

  final OrderItemController orderItemController =
      Get.find<OrderItemController>();
  final AuthController userController = Get.find<AuthController>();

  int _selectedPaymentMethod = 0;
  int _selectedCards = 0;

  final List<Map<String, dynamic>> paymentMethods = [
    {'title': 'Credit Card', 'icon': Icons.credit_card_outlined},
    {'title': 'Paypal', 'icon': Icons.account_balance_wallet_outlined},
    {'title': 'Apple Pay', 'icon': Icons.apple},
    {'title': 'Google Pay', 'icon': Icons.payment},
  ];

  Widget _buildStep(int number, String title, bool isActive) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  isActive
                      ? const Color.fromARGB(255, 18, 7, 234).withOpacity(0.8)
                      : Colors.white,
              border: Border.all(
                color:
                    isActive ? AppTheme.primaryColor : AppTheme.textsecandery,
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                number.toString(),
                style: TextStyle(
                  color:
                      isActive
                          ? Colors.white
                          : const Color.fromARGB(255, 11, 101, 210),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: isActive ? AppTheme.primaryColor : AppTheme.textsecandery,
              fontSize: 12,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepConnector(bool isActive) {
    return Expanded(
      child: Container(
        height: 2,
        color:
            isActive
                ? AppTheme.primaryColor
                : AppTheme.textsecandery.withOpacity(0.5),
      ),
    );
  }

  Widget _buildPaymentMethod(int index, Map<String, dynamic> method) {
    final isSelected = _selectedPaymentMethod == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : AppTheme.textsecandery,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Radio(
              value: index,
              groupValue: _selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value!;
                });
              },
              activeColor: AppTheme.primaryColor,
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                method['icon'] as IconData,
                size: 24,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              method['title'] as String,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary(
    String label,
    String value, {
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: isTotal ? AppTheme.textPrimary : AppTheme.textsecandery,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: isTotal ? AppTheme.primaryColor : AppTheme.textPrimary,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double subtotel = cartController.totalPrice;
    double shipping = 5.0;
    double tax = subtotel * 0.05;
    double total = subtotel + shipping + tax;
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: true, // هذا يجعل الـ AppBar يظهر عند السحب لأعلى
            expandedHeight: 120,
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                'Payminet',
                style: TextStyle(
                  color: AppTheme.backgroundColor,
                  fontSize: 24,
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
          ),

          SliverToBoxAdapter(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      _buildStep(1, "Shopping", true),
                      _buildStepConnector(true),
                      _buildStep(2, "Payment", true),
                      _buildStepConnector(false),
                      _buildStep(3, "Confirm", false),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),

                      const SizedBox(height: 8),
                      // _buildAddressCard(0),
                      // _buildAddressCard(1),
                      const SizedBox(height: 16),
                      const Text(
                        'Payment Method',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // عرض جميع طرق الدفع
                      for (int i = 0; i < paymentMethods.length; i++)
                        _buildPaymentMethod(i, paymentMethods[i]),
                      const SizedBox(height: 16),
                      _buildSaveCards(),

                      const Text(
                        'Order Summary',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      _buildOrderSummary(
                        " Subtotal",
                        "\$${subtotel.toStringAsFixed(2)}",
                      ),
                      _buildOrderSummary(
                        "Shopping",
                        shipping.toStringAsFixed(2),
                      ),
                      _buildOrderSummary("Tax", "\$${tax.toStringAsFixed(2)}"),
                      Divider(height: 24),
                      _buildOrderSummary(
                        "Total",
                        "\$${(total).toStringAsFixed(2)}",
                        isTotal: true,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 120),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  // child: GradientBottomButton(
                  //   text: 'Pay Now',
                  //   onPressed: () {
                  //     // هنا تضيف تنفيذ الدفع
                  //   },
                ),
              ],
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: GradintBottom(
            text: "Confirm orders",

            onPressed: () async {
              try {
                final cartItems = cartController.cartItems;
                final subtotal = cartController.totalPrice;

                if (cartItems.isEmpty) {
                  Get.snackbar(
                    'خطأ',
                    'السلة فارغة، لا يمكن تقديم الطلب.',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                  return;
                }

                // 1. إنشاء الطلب
                final newOrder = Order(
                  userId: userController.currentUser.value?.id ?? 0,
                  orderDate: DateTime.now().toString(),
                  totalAmount: subtotal,
                  items: [],
                  status: "Processing",
                );

                // 2. إدراج الطلب
                final orderId = await orderController.insertOrder(newOrder);
                if (orderId == null) {
                  Get.snackbar(
                    'خطأ',
                    'فشل إنشاء الطلب.',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                  return;
                }

                // 3. إدراج العناصر
                for (final item in cartItems) {
                  final orderItem = OrderItem(
                    orderId: orderId,
                    productId: item.product.id!,
                    quantity: item.quantity,
                    price: item.product.price,
                    product: item.product,
                  );
                  print('  add  items order sucssfully $orderId');

                  final success = await orderItemController.addOrderItem(
                    orderItem,
                  );
                  print('  add  items order sucssfully');
                  if (success == false) {
                    Get.snackbar(
                      'خطأ',
                      'فشل في إضافة عنصر إلى الطلب.',
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                    return;
                  }
                }

                // 4. تفريغ السلة
                cartController.clearCart();

                // 5. الانتقال لصفحة التأكيد
                Get.to(() => OrderConfirmationScreen(orderId: orderId));
              } catch (e) {
                // التعامل مع الخطأ العام
                Get.snackbar(
                  'خطأ غير متوقع',
                  e.toString(),
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }

              SizedBox(height: 100);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSaveCards() {
    if (_selectedPaymentMethod != 0) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Saved Cards',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: AppTheme.textPrimary,
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  // هنا تضيف تنفيذ إضافة بطاقة جديدة
                },
                icon: const Icon(Icons.add, color: AppTheme.primaryColor),
                label: Text(
                  'Add New Card',

                  style: TextStyle(color: AppTheme.primaryColor, fontSize: 16),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3, // عدد البطاقات المحفوظة
              itemBuilder: (context, index) {
                return _buildCreditCard(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreditCard(int index) {
    final isSelected = _selectedCards == index;
    final colors = [
      AppTheme.primaryGradient,
      [AppTheme.primaryColor, AppTheme.secondaryColor],
      [AppTheme.tertiaryColor, AppTheme.secondaryColor],
    ];

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCards = index;
        });
      },
      child: Container(
        width: 300,
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors[index % colors.length],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : AppTheme.textsecandery,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Credit Card ${index + 1}',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  Icons.credit_card,
                  color: Colors.white.withOpacity(0.8),
                  size: 30,
                ),
              ],
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '**** **** **** 1234',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Card Holder',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                        Text(
                          'John Doe',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Expiry Date',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                        Text(
                          '12/25',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
