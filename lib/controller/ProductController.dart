import 'package:get/get.dart';
import 'package:myprojectshop/DB/database_helper.dart';
import 'package:myprojectshop/model/product_model.dart';

class ProductController extends GetxController {
  // Instance of the database helper
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // Observable list to hold products fetched from the database
  var products = <Product>[].obs;
  // Observable flag for loading state
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts(); // Fetch products when the controller is initialized
  }

  // Fetch products from the database
  Future<void> fetchProducts() async {
    try {
      isLoading(true);
      final List<Map<String, dynamic>> productMaps =
          await _dbHelper.getAllProducts();
      // Convert map list to Product list using the factory constructor
      products.assignAll(
        productMaps.map((data) => Product.fromMap(data)).toList(),
      );
    } catch (e) {
      print("Error fetching products: $e");
      // Handle error appropriately, maybe show a snackbar
      Get.snackbar('Error', 'Failed to load products: $e');
    } finally {
      isLoading(false);
    }
  }

  // Add a new product to the database
  Future<void> addProduct(Product product) async {
    try {
      // Convert Product object to Map for database insertion
      // The database helper's insertProduct already handles createdAt/updatedAt
      int id = await _dbHelper.insertProduct(product.toMap());
      if (id > 0) {
        // Successfully inserted, refresh the list
        // Option 1: Fetch all again (simpler)
        await fetchProducts();
        // Option 2: Add locally (more efficient but needs the full object with ID)
        // product.id = id; // Assuming id is returned correctly
        // products.add(product);
        Get.snackbar(
          'Success',
          'Product added successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar('Error', 'Failed to add product');
      }
    } catch (e) {
      print("Error adding product: $e");
      Get.snackbar('Error', 'Failed to add product: $e');
    }
  }

  // Update an existing product in the database
  Future<void> updateProduct(Product product) async {
    if (product.id == null) {
      print("Error: Cannot update product with null ID.");
      Get.snackbar('Error', 'Cannot update product without an ID.');
      return;
    }
    try {
      // Convert Product object to Map for database update
      // The database helper's updateProduct already handles updatedAt
      int count = await _dbHelper.updateProduct(product.toMap());
      if (count > 0) {
        // Successfully updated, refresh the list
        // Option 1: Fetch all again (simpler)
        await fetchProducts();
        // Option 2: Update locally (more efficient)
        // int index = products.indexWhere((p) => p.id == product.id);
        // if (index != -1) {
        //   products[index] = product;
        // }
        Get.snackbar('Success', 'Product updated successfully');
      } else {
        Get.snackbar('Error', 'Failed to update product or product not found');
      }
    } catch (e) {
      print("Error updating product: $e");
      Get.snackbar('Error', 'Failed to update product: $e');
    }
  }

  // Delete a product from the database
  Future<void> deleteProduct(int id) async {
    try {
      int count = await _dbHelper.deleteProduct(id);
      if (count > 0) {
        // Successfully deleted, refresh the list
        // Option 1: Fetch all again (simpler)
        await fetchProducts();
        // Option 2: Remove locally (more efficient)
        // products.removeWhere((p) => p.id == id);
        Get.snackbar('Success', 'Product deleted successfully');
      } else {
        Get.snackbar('Error', 'Failed to delete product or product not found');
      }
    } catch (e) {
      print("Error deleting product: $e");
      Get.snackbar('Error', 'Failed to delete product: $e');
    }
  }
}
