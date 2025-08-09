import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myprojectshop/controller/cart_controller.dart';
import 'package:myprojectshop/controller/order_controller.dart';
import 'package:myprojectshop/model/cart_item_model.dart';
import 'package:myprojectshop/screens/payment_screen.dart';
import 'package:myprojectshop/theme/theme.dart';
import 'package:myprojectshop/widgets/gradint_bottom.dart';

class CheckoutScreen extends StatefulWidget {
  // final UserModel? userModel;
  final OrderController ordercontroller = Get.find<OrderController>();

  final CartController cartController = Get.find<CartController>();

  final List<CartItem> cartItems;
  final double subtotel;

  CheckoutScreen({required this.cartItems, required this.subtotel});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _selectedAdressIndex = 0;
  int _selectedDelavryIndex = 0;
  // bool _isLoading = false;
  final deliveryMethods = [
    {
      'title': 'Standard Delivery',
      'durtion': '1-5 business days',
      'price': '\$5.00',
      'icon': Icons.local_shipping_outlined,
    },
    {
      'title': 'Express Delivery',
      'durtion': '1-2 business days',
      'price': '\$10.00',
      'icon': Icons.delivery_dining_outlined,
    },
    {
      'title': 'Next Day Delivery',
      'durtion': '1 business day',
      'price': '\$20.00',
      'icon': Icons.next_plan_outlined,
    },
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
          SizedBox(height: 8),
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

  Widget _buildStepConnector(bool step) {
    return Expanded(
      child: Container(
        height: 2,
        color:
            step == 3
                ? Colors.transparent
                : AppTheme.textsecandery.withOpacity(0.5),
      ),
    );
  }

  Widget _buildAddressCard(int index) {
    final isSelected = _selectedAdressIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedAdressIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : AppTheme.textsecandery,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Radio(
              value: index,
              groupValue: _selectedAdressIndex,
              onChanged:
                  (value) => {
                    setState(() {
                      _selectedAdressIndex = value as int;
                    }),
                  },
              activeColor: AppTheme.primaryColor,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        // widget.usercontroller.currentUser?.string ??
                        'اسم المستخدم',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      SizedBox(width: 4),
                      if (index == 0)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Default ',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    '123 Main St, Springfield, IL 62701',
                    style: TextStyle(
                      // fontSize: 14,
                      color: AppTheme.textsecandery,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Phone: (123) 456-7890',
                    style: TextStyle(
                      // fontSize: 14,
                      color: AppTheme.textsecandery,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.edit_outlined, color: AppTheme.primaryColor),
                ),
                if (index != 0)
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.delete_outline, color: AppTheme.error),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMethodCard(int index, Map<String, dynamic> method) {
    final method = deliveryMethods[index];
    final isSelected = _selectedDelavryIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDelavryIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          // borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : AppTheme.textsecandery,
            width: 2,
          ),
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
            Radio(
              value: index,
              groupValue: _selectedDelavryIndex,
              onChanged:
                  (value) => {
                    setState(() {
                      _selectedDelavryIndex = value as int;
                    }),
                  },
              activeColor: AppTheme.primaryColor,
            ),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                // shape: BoxShape.circle,
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                method['icon'] as IconData,
                size: 24,
                color: AppTheme.primaryColor,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method['title'] as String,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    method['durtion'] as String,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textsecandery,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16),
            Text(
              method['price'] as String,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
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
      padding: EdgeInsets.symmetric(vertical: 4),
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
    // Define and calculate order summary values
    final double subtotel = widget.cartController.totalPrice;
    final double shipping =
        _selectedDelavryIndex == 0
            ? 5.0
            : _selectedDelavryIndex == 1
            ? 10.0
            : 20.0;
    final double tax = subtotel * 0.05;
    final double total = subtotel + shipping + tax;

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
                'Checkout',
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
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      _buildStep(1, "Shopping", true),
                      _buildStepConnector(false),
                      _buildStep(2, "Payment", false),
                      _buildStepConnector(false),
                      _buildStep(3, "Confirm", false),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Shopping Address',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.add),
                            label: Text(
                              'Add New ',
                              style: TextStyle(
                                color: AppTheme.primaryColor,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      ...List.generate(3, (index) => _buildAddressCard(index)),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Delivery Method',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      SizedBox(height: 16),
                      ...List.generate(
                        2,
                        (index) =>
                            _buildMethodCard(index, deliveryMethods[index]),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  margin: EdgeInsets.all(16),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order Summary',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      SizedBox(height: 16),
                      Divider(),
                      _buildOrderSummary(
                        'Subtotal',
                        '\$${subtotel.toStringAsFixed(2)}',
                      ),
                      _buildOrderSummary(
                        'Shipping',
                        '\$${shipping.toStringAsFixed(2)}',
                      ),
                      _buildOrderSummary('Tax', '\$${tax.toStringAsFixed(2)}'),
                      Divider(),
                      _buildOrderSummary(
                        'Total',
                        '\$${total.toStringAsFixed(2)}',
                        isTotal: true,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 100),
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
            text: "Continue   to Payment",
            onPressed: () {
              final cartItems = widget.cartController.cartItems;
              final subtotal =
                  widget.cartController.totalPrice; // بدون شحن أو ضرائب

              Get.to(
                () => PaymentScreen(cartItems: cartItems, subtotel: subtotal),
              );
              SizedBox(height: 100);
              // widget.cartcontroller.clearCart();
            },
          ),
        ),
      ),
    );
  }
}
