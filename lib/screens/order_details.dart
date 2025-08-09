import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myprojectshop/controller/auth_controller.dart';
import 'package:myprojectshop/controller/order_item_controller.dart';
import 'package:myprojectshop/model/orderitem_model.dart';
import 'package:myprojectshop/screens/login_screen.dart';
import '../controller/order_controller.dart';
import '../model/order_model.dart';
import '../model/product_model.dart';
// import '../model/order_item_model.dart'; // Make sure this import points to where OrderItem is defined

class OrderDetailsScreen extends StatefulWidget {
  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final AuthController userId = Get.find<AuthController>();
  final OrderItemController ordertitemcontroller =
      Get.find<OrderItemController>();
  final OrderController controller = Get.find<OrderController>();

  OrderItem? orderItem;
  // setState(context) {
  //   controller.orders.value = [
  //     Order(
  //       id: 1,
  //       userId: 2, // Add the required userId
  //       orderDate:
  //           DateTime.now()
  //               .toIso8601String(), // Add the required orderDate as String
  //       totalAmount: 29.99,
  //       items: [
  //         OrderItem(
  //           orderId: 1,
  //           productId: 1,
  //           price: 29.99,
  //           product: Product(name: "Test Product", price: 29.99, imageUrl: ""),
  //           quantity: 1,
  //         ),
  //       ],
  //     ),
  //   ];
  // }
  int? userid;

  @override
  void initState() {
    super.initState();

    userid = userId.currentUserId;

    if (userid == null) {
      // المستخدم غير مسجل الدخول
      // نعيد توجيهه إلى صفحة تسجيل الدخول
      Future.microtask(() {
        Get.offAll(LoginScreen()); // تأكد أن لديك هذا الراوت
      });
      return;
    }

    controller.fetchOrdersWithItems(userid!);
  }

  @override
  Widget build(BuildContext context) {
    // if (controller.orders.isEmpty || controller.isLoading == false) {
    //   return Scaffold(body: Text(("No orders found.")));
    // }
    return Scaffold(
      appBar: AppBar(title: Text("User Orders")),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        // if (controller.orders.isEmpty || controller.isLoading == false) {
        //   return Center(child: Text("No orders found."));
        // }

        int currentUserId = userid!;
        final userOrders =
            controller.orders
                .where((order) => order.userId == currentUserId)
                .toList();

        if (userOrders.isEmpty) {
          return Center(child: Text("No orders found for this user."));
        }

        return ListView.builder(
          itemCount: userOrders.length,
          itemBuilder: (context, index) {
            final Order order = userOrders[index];

            return Card(
              margin: EdgeInsets.all(10),
              child: ExpansionTile(
                title: Row(
                  children: [
                    Text(
                      "Order #${order.id} - \$${order.totalAmount.toStringAsFixed(2)}",
                    ),
                    SizedBox(width: 10),
                    IconButton(
                      onPressed: () {
                        // ordertitemcontroller.deleteOrderItem(
                        //   orderItem!.id!,
                        //   order.id!,
                        // );
                        controller.deleteOrder(order.id!);
                        // controller.fetchOrderById(order.id!);
                        //  controller.deleteOrderItem(orderItem.id!, order.id);
                        controller.fetchOrdersWithItems(currentUserId).then((
                          _,
                        ) {
                          print("after deleted orders: ${controller.orders}");
                        });
                      },
                      icon: Icon(Icons.delete),
                    ),
                  ],
                ),

                subtitle: Text("Items: ${order.items.length}"),
                children:
                    order.items.map((item) {
                      if (item.product.name.isEmpty) {
                        return ListTile(title: Text("منتج غير فارغ"));
                      }

                      final Product product = item.product;

                      // print("item.product.name");
                      return ListTile(
                        leading:
                            (product.imageUrl != null &&
                                    product.imageUrl!.isNotEmpty)
                                ? (product.imageUrl!.startsWith('http')
                                    ? Image.network(
                                      product.imageUrl!,
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    )
                                    : Image.file(
                                      File(product.imageUrl!),
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    ))
                                : Container(
                                  width: 50,
                                  height: 50,
                                  color: Colors.grey[300],
                                  child: Icon(
                                    Icons.image,
                                    color: Colors.grey[700],
                                  ),
                                ),
                        title: Text(product.name),
                        subtitle: Text("Quantity: ${item.quantity}"),
                        trailing: Text("\$${product.price.toStringAsFixed(2)}"),
                      );
                    }).toList(),
              ),
            );
          },
        );
      }),
    );
  }
}
