import 'package:get/get.dart';
import 'package:myprojectshop/DB/database_helper.dart';
import 'package:myprojectshop/model/category_modle.dart';

class Categorycotroller extends GetxController {
  final DatabaseHelper _db = DatabaseHelper.instance;

  var catgory = <Category>[].obs;

  RxBool isLoading = true.obs;
  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      isLoading(true);
      final List<Map<String, dynamic>> categoryMaps =
          await _db.getAllCategories();
      // Convert map list to Product list using the factory constructor
      catgory.assignAll(
        categoryMaps.map((data) => Category.fromMap(data)).toList(),
      );
    } catch (e) {
      print("Error fetching Category : $e");
      // Handle error appropriately, maybe show a snackbar
      Get.snackbar('Error', 'Failed to load Category: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> addCategory(Category category) async {
    try {
      // Convert Product object to Map for database insertion
      // The database helper's insertProduct already handles createdAt/updatedAt
      int id = await _db.insertCategory(category.toMap());
      if (id > 0) {
        // Successfully inserted, refresh the list
        // Option 1: Fetch all again (simpler)
        await fetchCategories();
        // Option 2: Add locally (more efficient but needs the full object with ID)
        // product.id = id; // Assuming id is returned correctly
        // products.add(product);
        Get.snackbar(
          'Success',
          'Category  added successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar('Error', 'Failed to add Category');
      }
    } catch (e) {
      print("Error adding Category: $e");
      Get.snackbar('Error', 'Failed to add Category: $e');
    }
  }

  Future<void> updateCategory(Category category) async {
    if (category.id == null) {
      print("Error: Cannot update category with null ID.");
      Get.snackbar('Error', 'Cannot update category without an ID.');
      return;
    }
    try {
      // Convert Product object to Map for database update
      // The database helper's updateProduct already handles updatedAt
      int count = await _db.updateCategory(category.toMap());
      if (count > 0) {
        // Successfully updated, refresh the list
        // Option 1: Fetch all again (simpler)
        await fetchCategories();
        // Option 2: Update locally (more efficient)
        // int index = products.indexWhere((p) => p.id == product.id);
        // if (index != -1) {
        //   products[index] = product;
        // }
        Get.snackbar('Success', 'category updated successfully');
      } else {
        Get.snackbar(
          'Error',
          'Failed to update category or category not found',
        );
      }
    } catch (e) {
      print("Error updating category: $e");
      Get.snackbar('Error', 'Failed to update category: $e');
    }
  }

  Future<void> deleteCategory(int id) async {
    try {
      int count = await _db.deleteCategory(id);
      if (count > 0) {
        // Successfully deleted, refresh the list
        // Option 1: Fetch all again (simpler)
        await fetchCategories();
        // Option 2: Remove locally (more efficient)
        // products.removeWhere((p) => p.id == id);
        Get.snackbar('Success', 'category deleted successfully');
      } else {
        Get.snackbar(
          'Error',
          'Failed to delete category or category not found',
        );
      }
    } catch (e) {
      print("Error deleting category: $e");
      Get.snackbar('Error', 'Failed to delete category: $e');
    }
  }
}
