// import 'package:flutter/foundation.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myprojectshop/controller/CategoryCotroller.dart';
import 'package:myprojectshop/controller/ProductController.dart';
import 'package:myprojectshop/controller/cart_controller.dart';
import 'package:myprojectshop/model/product_model.dart';
import 'package:myprojectshop/screens/cart_screen.dart';
import 'package:myprojectshop/screens/product_details_screen.dart';
import 'package:myprojectshop/theme/theme.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final ProductController controller = Get.find<ProductController>();

  final CartController _cartcontroller = Get.find<CartController>();

  final Categorycotroller categoryController = Get.find<Categorycotroller>();

  final List<Map<String, dynamic>> categories = [
    {'icon': Icons.laptop_mac_outlined, 'name': "electrcal"},
    {'icon': Icons.chair_outlined, 'name': 'f'},
    {'icon': Icons.checkroom_outlined, 'name': 'd'},
    {'icon': Icons.sports_basketball_outlined, 'name': 's'},
    {'icon': Icons.watch_outlined, 'name': 'a'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Obx(() {
        // Use Obx to listen to changes in the controller's observables
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 100,
              floating: true,
              pinned: true,
              backgroundColor: Colors.black,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: AppTheme.primaryGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: FlexibleSpaceBar(
                  centerTitle: true,
                  titlePadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  title: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        child: Icon(
                          Icons.location_on_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 12),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Deliver to',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                          Text(
                            'Sanaa',
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                  background: Stack(
                    children: [
                      Positioned(
                        top: -50,
                        right: -50,
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.notifications_outlined,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: TextField(
                              onSubmitted: (value) {
                                // Navigator.push(context, MaterialPageRoute(builder:
                                // (context)=>SearchScreen()))
                              },
                              decoration: InputDecoration(
                                hintText: "Search Products ...",
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  color: AppTheme.textsecandery,
                                ),
                                prefixIcon: Icon(Icons.search),
                                suffixIcon: Icon(
                                  Icons.tune,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Categories
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Categories',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Navigator.push(context, MaterialPageRoute(builder:
                            // (context)=>ProductCategoriesScreen()));
                          },
                          child: Text(
                            "View All",
                            style: TextStyle(color: AppTheme.primaryColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      scrollDirection: Axis.horizontal,
                      itemCount: categoryController.catgory.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        final cat =
                            categoryController
                                .catgory[index]; // هذا هو الكائن الصحيح

                        return Container(
                          width: 90,
                          margin: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  category['icon'] as IconData,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                cat.name,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  // Featured Products
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Featured',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Navigator.push(context, MaterialPageRoute(builder:
                            // (context)=>ProductCategoriesScreen()));
                          },
                          child: Text(
                            "View All",
                            style: TextStyle(color: AppTheme.primaryColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //Featured Products List
                  SizedBox(
                    height: 250,

                    // width: 500,
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.products.length,
                      itemBuilder: (context, index) {
                        // final featuredList = controller.products.take(5).toList();
                        final Product product = controller.products[index];

                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => ProductDetailsScreen(
                                      product: controller.products[index],
                                    ),
                              ),
                            );
                          },
                          child: Container(
                            width: 150,
                            margin: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 20,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Get.to(
                                      () => ProductDetailsScreen(
                                        product: controller.products[index],
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 120,
                                    width:
                                        double
                                            .infinity, // Ensure container fills width
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(12),
                                      ),
                                      color:
                                          Colors.grey[200], // Placeholder color
                                    ),
                                    child: ClipRRect(
                                      // Clip image to rounded corners
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(12),
                                      ),
                                      child:
                                          product.imageUrl != null &&
                                                  product.imageUrl!.isNotEmpty
                                              ? (GetUtils.isURL(
                                                    product.imageUrl!,
                                                  )
                                                  ? Image.network(
                                                    product.imageUrl!,
                                                    fit: BoxFit.cover,
                                                    errorBuilder:
                                                        (c, e, s) => Icon(
                                                          Icons.error,
                                                          color: Colors.red,
                                                        ),
                                                  )
                                                  : Image.file(
                                                    File(product.imageUrl!),
                                                    fit: BoxFit.cover,
                                                    errorBuilder:
                                                        (c, e, s) => Icon(
                                                          Icons.broken_image,
                                                          color: Colors.grey,
                                                        ),
                                                  ))
                                              : Icon(
                                                Icons.image_not_supported,
                                                color: Colors.grey,
                                                size: 50,
                                              ), // Placeholder icon
                                    ),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product
                                            .name, // Use data from Product object
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      // You might need to fetch category name based on product.categoryId
                                      Text(
                                        'Category',
                                        style: TextStyle(
                                          color: AppTheme.textsecandery,
                                          fontSize: 12,
                                        ),
                                      ),
                                      SizedBox(height: 4),

                                      Text(
                                        "\$Price : ${product.price.toStringAsFixed(2)}", // Use data from Product object
                                        style: TextStyle(
                                          color: AppTheme.primaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                            size: 15,
                                          ),
                                          Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                            size: 15,
                                          ),
                                          Icon(
                                            Icons.star_half,
                                            color: Colors.amber,
                                            size: 15,
                                          ),

                                          SizedBox(width: 40),
                                          Icon(
                                            Icons.shopping_cart_outlined,
                                            color: AppTheme.textsecandery,
                                            size: 20,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  // New Arrivals
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'New Arrivals',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Navigator.push(context, MaterialPageRoute(builder:
                            // (context)=>ProductCategoriesScreen()));
                          },
                          child: Text(
                            "View All",
                            style: TextStyle(color: AppTheme.primaryColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // New Arrivals List
                  ListView.builder(
                    physics:
                        NeverScrollableScrollPhysics(), // To disable scrolling of this inner list
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    itemCount: controller.products.length,
                    itemBuilder: (context, index) {
                      // final product = newArrivals[index];
                      final Product product1 = controller.products[index];

                      return Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: InkWell(
                          onTap: () {
                            Get.to(
                              () => ProductDetailsScreen(
                                product: controller.products[index],
                              ),
                            );
                          },
                          child: ListTile(
                            leading:
                                product1.imageUrl != null &&
                                        product1.imageUrl!.isNotEmpty
                                    ? Image.file(
                                      File(product1.imageUrl!),
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) => Icon(
                                            Icons.image_not_supported,
                                            size: 50,
                                          ),
                                    )
                                    : Icon(
                                      Icons.inventory_2_outlined,
                                      size: 50,
                                    ),
                            title: Text(
                              product1.name,
                              style: TextStyle(fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product1.getCategoryName(
                                    categoryController.catgory,
                                  ),
                                  style: TextStyle(
                                    color: AppTheme.textsecandery,
                                    fontSize: 12,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      product1.price.toString(),
                                      style: TextStyle(
                                        color: AppTheme.primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 14,
                                    ),
                                    Text(
                                      product1.stock.toString(),
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.shopping_cart_outlined,
                                color: AppTheme.primaryColor,
                              ),

                              onPressed: () async {
                                int _selectedSize = 0;
                                int _selectedColor = 0;

                                try {
                                  _cartcontroller.addToCart(
                                    controller.products[index],
                                    quantity: 1,
                                    selectedSize: _selectedSize.toString(),
                                    selectedColor: _selectedColor.toString(),
                                  );
                                  Get.to(() => CartScreen());
                                  print("Product added to cart successfully");
                                } catch (e) {
                                  print("Error adding cart: $e");
                                }
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
