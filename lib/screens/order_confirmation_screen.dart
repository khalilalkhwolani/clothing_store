import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myprojectshop/controller/auth_controller.dart';
import 'package:myprojectshop/controller/cart_controller.dart';
import 'package:myprojectshop/controller/order_controller.dart';
import 'package:myprojectshop/controller/order_item_controller.dart';
import 'package:myprojectshop/model/order_model.dart';
import 'package:myprojectshop/model/orderitem_model.dart';
import 'package:myprojectshop/screens/order_details.dart';
import 'package:myprojectshop/screens/order_tracking_screen.dart';
import 'package:myprojectshop/theme/theme.dart';
import 'package:myprojectshop/widgets/gradint_bottom.dart';

class OrderConfirmationScreen extends StatefulWidget {
  final int orderId;
  // late final Order? order;

  OrderConfirmationScreen({Key? key, required this.orderId}) : super(key: key);
  @override
  State<OrderConfirmationScreen> createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  // int _selectedPaymentMethod = 0;
  // int _selectedCards = 0;

  final CartController cartController = Get.find<CartController>();
  final OrderController orderController = Get.find<OrderController>();
  final OrderItemController orderItemController =
      Get.find<OrderItemController>();
  final AuthController userController = Get.find<AuthController>();

  Order? order;
  List<OrderItem>? orderItems;
  OrderItem? orderItem;

  @override
  void initState() {
    super.initState();
    fetchOrderDetails();
  }

  void fetchOrderDetails() async {
    try {
      order = await orderController.fetchOrderById(widget.orderId);

      if (order == null) {
        print("Order is null");
        return;
      }

      print("ORDER LOADED: ${order!.id} / items: ${order!.items.length}");

      if (orderItem != null) {
        print("Product name length: ${orderItem!.product.name.length}");
      } else {
        print("OrderItem is null");
      }

      setState(() {});
    } catch (e) {
      print("Error fetching order details: $e");
    }
  }

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

  Widget __buildDetailRow(
    String label,
    String value, {
    bool isBold = false,
    Color? valueColor,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: AppTheme.textsecandery,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: valueColor ?? AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double subtotel = order?.totalAmount ?? 0;
    final double shipping = 5.0;
    final double tax = subtotel * 0.05;
    final double total = subtotel + shipping + tax;

    if (order == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Order Confirmation")),
        body: Center(child: CircularProgressIndicator()),
      );
    } else if (order!.items.isEmpty) {
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
                  'Order Confirmation ',
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
                        _buildStep(3, "Confirm", true),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                            color: AppTheme.success.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check_circle,
                            size: 80,
                            color: AppTheme.success,
                          ),
                        ),
                        SizedBox(height: 24),
                        Text(
                          "Order Placed successfally ",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 24),
                        Text(
                          " Your order has been confirmed and will be delivered soon",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(16),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Order detials",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        SizedBox(height: 16),

                        __buildDetailRow(
                          "Order No ,",
                          order!.orderDate.toString(),
                        ),
                        __buildDetailRow(
                          "Order Date ,",
                          order!.orderDate.toString(),
                        ),
                        __buildDetailRow(
                          " Total Amount  ,",
                          order!.totalAmount.toString(),
                        ),
                        __buildDetailRow(
                          " Status   ",
                          order!.status.toString(),
                          valueColor: AppTheme.warning,
                          isBold: true,
                        ),
                      ],
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.all(16),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Delivary Details",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        SizedBox(width: 16),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              // SizedBox(height: 16,),
                              child: Icon(
                                Icons.location_on_outlined,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Delivary address",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppTheme.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    "123 Main Stree , Apt 48\nsanaa ,1001\nUnited states ",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppTheme.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Divider(),
                        SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              // SizedBox(height: 16,),
                              child: Icon(
                                Icons.local_shipping_outlined,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Delivary Method",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppTheme.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    "Express Delivery (1-2 businass days)",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppTheme.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.all(16),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          " payment Details ",

                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        SizedBox(width: 16),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              // SizedBox(height: 16,),
                              child: Icon(
                                Icons.credit_card,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Payment Method",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppTheme.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    "Credit card ******** 1234 ",

                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppTheme.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Divider(),
                        SizedBox(height: 16),
                        __buildDetailRow(
                          " Subtotal",
                          "\$${order!.totalAmount.toStringAsFixed(2)}",
                        ),
                        __buildDetailRow(
                          "Shopping",
                          shipping.toStringAsFixed(2),
                        ),
                        __buildDetailRow("Tax", "\$${tax.toStringAsFixed(2)}"),
                        Divider(height: 24),
                        __buildDetailRow(
                          "Total",
                          "\$${(total).toStringAsFixed(2)}",
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
        bottomSheet: SafeArea(
          child: Container(
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
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderTrackingScreen(),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: AppTheme.primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text("Track Order"),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: GradintBottom(
                    text: "Confirm orders",
                    onPressed: () async {
                      try {
                        //   final cartItems = cartController.cartItems;
                        //   final subtotal = cartController.totalPrice;

                        //   if (cartItems.isEmpty) {
                        //     Get.snackbar(
                        //       'خطأ',
                        //       'السلة فارغة، لا يمكن تقديم الطلب.',
                        //       backgroundColor: Colors.red,
                        //       colorText: Colors.white,
                        //     );
                        //     return;
                        //   }

                        //   // 1. إنشاء الطلب
                        //   final newOrder = Order(
                        //     userId: userController.currentUser.value?.id ?? 0,
                        //     orderDate: DateTime.now().toString(),
                        //     totalAmount: subtotal,
                        //     items: [],
                        //     status: "Processing",
                        //   );

                        //   // 2. إدراج الطلب
                        //   final orderId = await orderController.insertOrder(newOrder);
                        //   if (orderId == null) {
                        //     Get.snackbar(
                        //       'خطأ',
                        //       'فشل إنشاء الطلب.',
                        //       backgroundColor: Colors.red,
                        //       colorText: Colors.white,
                        //     );
                        //     return;
                        //   }

                        //   // 3. إدراج العناصر
                        //   for (final item in cartItems) {
                        //     final orderItem = OrderItem(
                        //       orderId: orderId,
                        //       productId: item.product.id!,
                        //       quantity: item.quantity,
                        //       price: item.product.price,
                        //       product: item.product,
                        //     );

                        //     final success = await orderItemController.addOrderItem(
                        //       orderItem,
                        //     );
                        //     if (success == false) {
                        //       Get.snackbar(
                        //         'خطأ',
                        //         'فشل في إضافة عنصر إلى الطلب.',
                        //         backgroundColor: Colors.red,
                        //         colorText: Colors.white,
                        //       );
                        //       return;
                        //     }
                        //   }

                        //   // 4. تفريغ السلة
                        //   cartController.clearCart();

                        // 5. الانتقال لصفحة التأكيد
                        // Get.to(() => OrderConfirmationScreen(orderId: 2));
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

                      Get.to(() => OrderDetailsScreen());
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    // Ensure a widget is always returned
    return SizedBox.shrink();
  }
}
