import 'package:get/get.dart';
import 'package:myprojectshop/DB/database_helper.dart';
import 'package:myprojectshop/model/orderitem_model.dart';

class OrderItemController extends GetxController {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  var orderItems = <OrderItem>[].obs;

  var orders = <OrderItem>[].obs;

  // Observable flag for loading state
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    // fetchOrderItems();
    // fetchOrderById(1);

    // Fetch products when the controller is initialized
  }

  // Fetch products from the database
  Future<void> fetchOrderItems() async {
    try {
      isLoading(true);
      final List<Map<String, dynamic>> productMaps =
          await _dbHelper.getAllorderitem();
      // Convert map list to Product list using the factory constructor
      orders.assignAll(
        productMaps.map((data) => OrderItem.fromMap(data)).toList(),
      );
    } catch (e) {
      print("Error fetching orders: $e");
      // Handle error appropriately, maybe show a snackbar
      Get.snackbar('Error', 'Failed to load orders: $e');
    } finally {
      isLoading(false);
    }
  }

  /// Add item to the order
  // Future<void> addOrderItem(OrderItem item) async {
  //   try {
  //     await _dbHelper.insertOrderItem(item);
  //     fetchOrderItemsByOrderId(item.orderId);
  //     Get.snackbar('Success', 'Item added to the order successfully');
  //   } catch (e) {
  //     Get.snackbar('Error', 'Failed to add item to the order: $e');
  //   }
  // }
  Future<OrderItem?> addOrderItem(OrderItem item) async {
    try {
      await _dbHelper.insertOrderItem(item);
      fetchOrderItemsByOrderId(item.orderId);
      Get.snackbar('Success', 'Item added to the order successfully');
      return item; // نجحت العملية
    } catch (e) {
      Get.snackbar('Error', 'Failed to add item to the order: $e');

      return null; // فشلت العملية
    }
  }

  /// Fetch items by orderId
  Future<List<OrderItem>> fetchOrderItemsByOrderId(int orderId) async {
    try {
      final items = await _dbHelper.getOrderItemsByOrderId(orderId);
      return items;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load order items: $e');
      rethrow;
    }
  }

  /// Delete an item from the order
  Future<void> deleteOrderItem(int id, int orderId) async {
    try {
      await _dbHelper.deleteOrderItem(id);

      // أعد تحميل الطلب من قاعدة البيانات
      final updatedItems = await fetchOrderItemsByOrderId(orderId);
      orderItems.assignAll(
        updatedItems,
      ); // أو orders.assignAll إذا كنت تستخدمها

      Get.snackbar('Deleted', 'Order item deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete order item: $e');
    }
  }
}
