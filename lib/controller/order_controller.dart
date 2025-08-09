
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myprojectshop/DB/database_helper.dart';
import 'package:myprojectshop/controller/auth_controller.dart';
import 'package:myprojectshop/model/order_model.dart';
import 'package:myprojectshop/model/orderitem_model.dart';
import 'package:myprojectshop/model/product_model.dart';

class OrderController extends GetxController {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final RxList<Order> orders = <Order>[].obs;
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;

  final AuthController user = Get.find<AuthController>();
  late final int userId;
  @override
  Future<void> onInit() async {
    super.onInit();
    // userId = user.currentUserId;
    final userId = Get.find<AuthController>().currentUser;
    // fetchOrders();
  }

  Future<void> fetchOrders() async {
    await _handleDatabaseCall(
      action: () async {
        final ordersData = await _dbHelper.getAllorders1();
        orders.assignAll(
          ordersData.map((data) => Order.fromMap(data)).toList(),
        );
      },
      successMessage: 'تم تحميل الطلبات بنجاح',
      errorPrefix: 'فشل تحميل الطلبات',
    );
  }

  Future<void> fetchOrdersWithItems(int userId) async {
    await _handleDatabaseCall(
      action: () async {
        final orderData = await _dbHelper.getOrdersByUserId(userId);
        final List<Order> tempOrders = [];

        for (var order in orderData) {
          final orderId = _parseToInt(order['id']);
          final itemsData = await _dbHelper.getOrderItemsWithProduct(orderId);
          final items =
              itemsData
                  .map<OrderItem>((item) => _mapToOrderItem(item))
                  .toList();

          tempOrders.add(
            Order(
              id: orderId,
              userId: _parseToInt(order['userId']),
              totalAmount: _parseToDouble(order['totalAmount']),
              items: items,
              orderDate: order['order_date']?.toString() ?? '',
              status: order['status']?.toString() ?? 'Pending',
            ),
          );
          final items1 = await _dbHelper.getOrderItemsByOrderId(orderId);
          if (items1.isEmpty) {
            print('لا توجد عناصر لهذا الطلب');
          }
        }

        orders.value = tempOrders;
      },
      successMessage: 'تم تحميل الطلبات مع العناصر بنجاح',
      errorPrefix: 'فشل تحميل تفاصيل الطلبات',
    );
  }

  Future<void> fetchOrdersForUser(int userId) async {
    await _handleDatabaseCall(
      action: () async {
        final ordersData = await _dbHelper.getAllordersForUser(userId);
        orders.assignAll(
          ordersData.map((data) => Order.fromMap(data)).toList(),
        );
      },
      successMessage: 'تم تحميل طلبات المستخدم بنجاح',
      errorPrefix: 'فشل تحميل طلبات المستخدم',
    );
  }

  Future<Order?> fetchOrderById(int orderId) async {
    try {
      isLoading(true);
      final result = await _dbHelper.getAllOrders();
      final order = result.firstWhere(
        (order) => order.id == orderId,
        orElse: () => throw Exception('الطلب غير موجود'),
      );
      return order;
    } catch (e) {
      _showError('فشل تحميل الطلب', e.toString());
      return null;
    } finally {
      isLoading(false);
    }
  }

  Future<int?> insertOrder(Order order) async {
    return await _handleDatabaseCall<int>(
      action: () async {
        final orderId = await _dbHelper.insertOrder(order);
        // await fetchOrders();
        return orderId;
      },
      successMessage: 'تم إضافة الطلب بنجاح',
      errorPrefix: 'فشل إضافة الطلب',
    );
  }

  Future<void> updateOrder(Order order) async {
    await _handleDatabaseCall(
      action: () async {
        await _dbHelper.updateOrder(order);
        await fetchOrders();
      },
      successMessage: 'تم تحديث الطلب بنجاح',
      errorPrefix: 'فشل تحديث الطلب',
    );
  }

  Future<bool> deleteOrder(int id) async {
    return await _handleDatabaseCall<bool>(
          action: () async {
            final db = await _dbHelper.database;

            final count = await db.delete(
              'orders',
              where: 'id = ?',
              whereArgs: [id],
            );
            print("  deleted sucssfully : $count");

            // تحديث قائمة الطلبات في الذاكرة

            await fetchOrdersForUser(userId);
            if (count > 0) {
              // إذا كنت تستخدم GetX في واجهتك (Obx)، ستتحدث الصفحة تلقائياً عند تحديث orders
              return true;
            }
            throw Exception('لم يتم العثور على الطلب');
          },
          successMessage: 'تم حذف الطلب بنجاح',
          // errorPrefix: 'فشل حذف الطلب',
        ) ??
        false;
  }

  // --- دوال مساعدة ---

  OrderItem _mapToOrderItem(Map<String, dynamic> item) {
    return OrderItem(
      productId: _parseToInt(item['product_id']),
      quantity: _parseToInt(item['quantity']),
      orderId: _parseToInt(item['order_id']),
      price: _parseToDouble(item['price']),
      product: Product(
        id: _parseToInt(item['product_id']),
        name: item['name']?.toString() ?? 'غير معروف',
        price: _parseToDouble(item['price']),
        imageUrl: item['imageUrl']?.toString() ?? '',
        description: item['description']?.toString(),
        categoryId: _parseToInt(item['categoryId']),
        stock: _parseToInt(item['stock']),
        // attributes: item['attributes']?.toString(),
        createdAt:
            item['createdAt'] != null
                ? DateTime.tryParse(item['createdAt'].toString())
                : null,
      ),
    );
  }

  int _parseToInt(dynamic value) {
    if (value == null) return 0;
    return int.tryParse(value.toString()) ?? 0;
  }

  double _parseToDouble(dynamic value) {
    if (value == null) return 0.0;
    return double.tryParse(value.toString()) ?? 0.0;
  }

  Future<T?> _handleDatabaseCall<T>({
    required Future<T?> Function() action,
    String? successMessage,
    String? errorPrefix,
  }) async {
    try {
      isLoading(true);
      errorMessage('');
      final result = await action();

      if (successMessage != null) {
        Get.snackbar(
          'نجاح',
          successMessage,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }

      return result;
    } catch (e) {
      final errorMsg = '$errorPrefix: ${e.toString()}';
      errorMessage(errorMsg);
      _showError(errorPrefix!, e.toString());
      return null;
    } finally {
      isLoading(false);
    }
  }

  void _showError(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}

// class OrderController extends GetxController {
//   final DatabaseHelper _dbHelper = DatabaseHelper.instance;

//   // var orders = <Order>[].obs;

//   RxList<Order> orders = <Order>[].obs;

//   // Observable flag for loading state
//   var isLoading = true.obs;

//   @override
//   Future<void> onInit() async {
//     super.onInit();
//     fetchorders();
//     fetchOrderById(3);
//     fetchOrdersWithItems(3);
//     fetchOrdersForUser(3);
//     // final orders = await get(123);
//     // print(orders); // اعرض النتائج في الكونسول
//     // Fetch products when the controller is initialized
//   }

//   // RxBool isLoading = false.obs;

//   Future<void> fetchOrdersWithItems(int userId) async {
//     isLoading.value = true;

//     // 1. جلب الطلبات الخاصة بالمستخدم
//     final orderData = await _dbHelper.getOrdersByUserId(userId);

//     List<Order> tempOrders = [];

//     for (var order in orderData) {
//       final orderId = int.parse(order['id'].toString());

//       // 2. جلب عناصر الطلب (المنتجات في هذا الطلب)
//       final itemsData = await _dbHelper.getOrderItemsWithProduct(orderId);

//       List<OrderItem> items =
//           itemsData.map<OrderItem>((item) {
//             return OrderItem(
//               productId: int.parse(item['product_id'].toString()),
//               quantity: int.parse(item['quantity'].toString()),
//               orderId: int.parse(item['order_id'].toString()),
//               price: double.parse(item['price'].toString()),
//               product: Product(
//                 id: int.parse(item['product_id'].toString()),
//                 name: item['name'] ?? '',
//                 price: double.parse(item['price'].toString()),
//                 imageUrl: item['imageUrl'] ?? '',
//                 description: item['description'],
//                 categoryId: item['categoryId'],
//                 stock:
//                     item['stock'] != null
//                         ? int.parse(item['stock'].toString())
//                         : 0,
//                 attributes: item['attributes'],
//                 createdAt:
//                     item['createdAt'] != null
//                         ? DateTime.parse(item['createdAt'].toString())
//                         : null,
//               ),
//             );
//           }).toList();

//       tempOrders.add(
//         Order(
//           id: orderId,
//           userId: int.parse(order['userId'].toString()),
//           totalAmount: double.parse(order['totalAmount'].toString()),
//           // date: DateTime.parse(order['order_date']), // إذا عندك التاريخ
//           items: items,
//           orderDate:
//               order['order_date'] != null ? order['order_date'].toString() : '',
//           status:
//               order['status'] != null ? order['status'].toString() : 'Pending',
//         ),
//       );
//     }

//     orders.value = tempOrders;
//     isLoading.value = false;
//   }

//   Future<void> fetchorders() async {
//     try {
//       isLoading(true);
//       final List<Map<String, dynamic>> productMaps =
//           await _dbHelper.getAllorders1();
//       // Convert map list to Product list using the factory constructor
//       orders.assignAll(productMaps.map((data) => Order.fromMap(data)).toList());
//     } catch (e) {
//       print("Error fetching orders: $e");
//       // Handle error appropriately, maybe show a snackbar
//       Get.snackbar('Error', 'Failed to load orders: $e');
//     } finally {
//       isLoading(false);
//     }
//   }

//   void fetchOrdersByUser(int userId) async {
//     isLoading.value = true;
//     try {
//       final allOrders = await _dbHelper.getAllOrders(); // جلب كل الطلبات
//       orders.value =
//           allOrders.where((order) => order.userId == userId).toList();
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<Order> fetchOrderById(int orderId) async {
//     try {
//       final List<Order> result = await _dbHelper.getAllOrders();

//       final order = result.firstWhere(
//         (order) => order.id == orderId,
//         orElse: () => throw Exception('Order not found'),
//       );

//       return order;
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to load order: $e');
//       rethrow;
//     }
//   }

//   Future<void> fetchOrdersForUser(int userId) async {
//     try {
//       isLoading(true);

//       final ordersData = await _dbHelper.getAllordersForUser(userId);

//       orders.assignAll(ordersData.map((data) => Order.fromMap(data)).toList());
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to load orders: $e');
//     } finally {
//       isLoading(false);
//     }
//     print("Fetched orders: ${orders.value}");
//   }

//   Future<int> insertOrder(Order order) async {
//     final orderId = await _dbHelper.insertOrder(order);
//     fetchOrderById(orderId);
//     fetchorders();

//     Get.snackbar(
//       'Added',
//       'Order added successfully',
//       snackPosition: SnackPosition.BOTTOM,
//       duration: Duration(seconds: 2),
//       backgroundColor: const Color(0xFF2196F3),
//       colorText: Colors.white,
//     );
//     return orderId;
//   }

//   Future<void> updateOrder(Order order) async {
//     await _dbHelper.updateOrder(order);
//     fetchOrderById(order.id!);
//     fetchorders();
//   }

//   Future<void> deleteOrder(int id) async {
//     try {
//       int count = await _dbHelper.deleteOrder(id);
//       if (count > 0) {
//         // Successfully deleted, refresh the list
//         // Option 1: Fetch all again (simpler)
//         await fetchorders();
//         // Option 2: Remove locally (more efficient)
//         // products.removeWhere((p) => p.id == id);
//         Get.snackbar('Success', 'order deleted successfully');
//       } else {
//         Get.snackbar('Error', 'Failed to delete order or product not found');
//       }
//     } catch (e) {
//       print("Error deleting order: $e");
//       Get.snackbar('Error', 'Failed to delete order: $e');
//     }
//   }
// }
