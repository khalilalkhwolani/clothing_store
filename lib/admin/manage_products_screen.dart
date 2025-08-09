import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myprojectshop/admin/add_products_screen.dart';
import 'package:myprojectshop/controller/ProductController.dart';
import 'package:myprojectshop/model/product_model.dart';
import 'package:myprojectshop/theme/theme.dart';

class ManageProductsScreen extends StatelessWidget {
  // Get the ProductController instance
  final ProductController controller = Get.find<ProductController>();

  ManageProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,

        title: Text(
          "Manage Products",
          style: TextStyle(color: Colors.white),
        ), // Use theme if available
        centerTitle: true,
        actions: [
          // Optional: Add a refresh button if needed
          IconButton(
            icon: Icon(Icons.refresh),
            color: Colors.white,
            onPressed: () => controller.fetchProducts(),
          ),
        ],
      ),
      body: Obx(() {
        // Use Obx to listen to changes in the controller's observables
        if (controller.isLoading.value) {
          // Show a loading indicator while fetching data
          return Center(child: CircularProgressIndicator());
        }

        if (controller.products.isEmpty) {
          // Show a message if there are no products
          return Center(child: Text("No products found. Add some!"));
        }

        // Display the list of products
        return ListView.builder(
          itemCount: controller.products.length,
          itemBuilder: (context, index) {
            final Product product = controller.products[index];
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                // Display product image if available
                leading:
                    product.imageUrl != null && product.imageUrl!.isNotEmpty
                        ? Image.file(
                          File(product.imageUrl!),
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) =>
                                  Icon(Icons.image_not_supported, size: 50),
                        )
                        : Icon(
                          Icons.inventory_2_outlined,
                          size: 50,
                        ), // Use a default icon if no image is available
                // Placeholder icon
                title: Text(product.name),
                subtitle: Text(
                  "Price: \$${product.price.toStringAsFixed(2)}\nStock: ${product.stock}",
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        // Navigate to the Add/Edit screen with the product
                        Get.to(() => AddProductsScreen(product: product));
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        // Show confirmation dialog before deleting
                        Get.defaultDialog(
                          title: "Delete Product",
                          middleText:
                              "Are you sure you want to delete ${product.name}?",
                          onConfirm: () {
                            controller.deleteProduct(product.id!);
                            Get.back(); // Close the dialog
                          },
                          onCancel: () => Get.back(), // Close the dialog
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the Add/Edit screen with no product
          Get.to(() => AddProductsScreen());
        },
        child: Icon(Icons.add),
        tooltip: "Add Product",
      ),
    );
  }
}
