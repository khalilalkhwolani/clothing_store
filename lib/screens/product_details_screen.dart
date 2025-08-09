import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myprojectshop/controller/ProductController.dart';
import 'package:myprojectshop/controller/cart_controller.dart';
import 'package:myprojectshop/model/product_model.dart';
import 'package:myprojectshop/screens/cart_screen.dart';
import 'package:myprojectshop/theme/theme.dart';
import 'package:myprojectshop/widgets/gradint_bottom.dart';

class ProductDetailsScreen extends StatefulWidget {
  // final int id;
  // final String name;
  // final String image;
  // final double price;

  // ProductDetailsScreen({
  //   required this.id,
  //   required this.name,
  //   required this.image,
  //   required this.price,
  //   Key? key,
  // }) : super(key: key);
  final Product product;

  ProductDetailsScreen({Key? key, required this.product}) : super(key: key);

  final ProductController controller = Get.find<ProductController>();

  final CartController _cartcontroller = Get.find<CartController>();

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _selectedImageIndex = 0;
  int _selectedSize = 0; // تغيير القيمة الافتراضية إلى 0
  int _selectedColor = 0;
  bool _isFavorite = false;

  final PageController _pageController = PageController();

  final _sizes = ['S', 'M', 'L', 'XL', 'XXL']; // تعريف قائمة المقاسات هنا
  final colors = [
    Colors.blueAccent,
    Colors.redAccent,
    Colors.amber,
    Colors.green,
  ];
  String _getColorName(int colorIndex) {
    switch (colorIndex) {
      case 0:
        return 'Blue';
      case 1:
        return 'Red';
      case 2:
        return 'Yellow';
      case 3:
        return 'Green';
      default:
        return 'Blue';
    }
  }

  Widget _buildSizeOption(int index) {
    final bool isSelected = _selectedSize == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSize = index;
        });
      },
      child: Container(
        margin: EdgeInsets.only(right: 12),
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : AppTheme.textsecandery,
          ),
        ),
        child: Center(
          child: Text(
            _sizes[index], // استخدام القائمة المحددة هنا
            style: TextStyle(
              color: isSelected ? Colors.white : AppTheme.textsecandery,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildColorOption(int index) {
    final bool isSelected = _selectedColor == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedColor = index;
        });
      },
      child: Container(
        margin: EdgeInsets.only(right: 12),
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colors[index],
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.transparent,
            width: 2,
          ),
        ),
        child:
            isSelected
                ? Icon(Icons.check, color: Colors.white, size: 18)
                : null,
      ),
    );
  }

  Widget _buildFeature(IconData icon, String text) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppTheme.primaryColor, size: 28),
          ),
          SizedBox(height: 8),
          Text(
            text,
            style: TextStyle(fontSize: 12, color: AppTheme.textPrimary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 0,
                floating: true,
                pinned: true,
                elevation: 0,
                backgroundColor: Colors.white,
                leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back, color: AppTheme.textPrimary),
                ),
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.share_outlined),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _isFavorite = !_isFavorite;
                      });
                    },
                    icon: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                      color:
                          _isFavorite ? AppTheme.error : AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        AspectRatio(
                          aspectRatio: 1,
                          child: PageView.builder(
                            controller: _pageController,

                            onPageChanged: (index) {
                              setState(() {
                                _selectedImageIndex = index;
                              });
                            },
                            itemCount: widget.controller.products.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(26),
                                    child: ClipRRect(
                                      // Clip image to rounded corners
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(12),
                                      ),
                                      child:
                                          widget.product.imageUrl != null &&
                                                  widget
                                                      .product
                                                      .imageUrl!
                                                      .isNotEmpty
                                              ? (GetUtils.isURL(
                                                    widget.product.imageUrl!,
                                                  )
                                                  ? Image.network(
                                                    widget.product.imageUrl!,
                                                    fit: BoxFit.cover,
                                                    errorBuilder:
                                                        (c, e, s) => Icon(
                                                          Icons.error,
                                                          color: Colors.red,
                                                        ),
                                                  )
                                                  : Image.file(
                                                    File(
                                                      widget.product.imageUrl!,
                                                    ),
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
                              );
                            },
                          ),
                        ),
                        Positioned(
                          bottom: 32,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              widget.controller.products.length,
                              (index) => Container(
                                width: 8,
                                height: 8,
                                margin: EdgeInsets.symmetric(horizontal: 4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      _selectedImageIndex == index
                                          ? AppTheme.primaryColor
                                          : AppTheme.textPrimary.withOpacity(
                                            0.3,
                                          ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.success.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.star, color: AppTheme.success),
                                    SizedBox(width: 4),
                                    Text(
                                      '4.8',
                                      style: TextStyle(
                                        color: AppTheme.success,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                "(245 Reviews)",
                                style: TextStyle(color: AppTheme.textPrimary),
                              ),
                              Spacer(),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.error.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  "20% OFF",
                                  style: TextStyle(
                                    color: AppTheme.error,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Text(
                            "${widget.product.name}",

                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            widget.product.description ?? '',

                            style: TextStyle(
                              fontSize: 16,
                              color: AppTheme.textsecandery,
                            ),
                          ),
                          SizedBox(height: 16),
                          Row(
                            children: [
                              Text(
                                "Price:\$ ${widget.product.price.toStringAsFixed(2)}", // Use data from Product object
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                "تخفيض:\$ ${widget.product.price * 2}", // Use data from Product object
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textsecandery.withOpacity(
                                    0.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Select Size",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          SizedBox(height: 12),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(
                                _sizes.length, // استخدام طول القائمة هنا
                                (index) => _buildSizeOption(index),
                              ),
                            ),
                          ),
                          SizedBox(height: 24),
                          Text(
                            "Select color",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          SizedBox(height: 12),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(
                                colors.length, // استخدام طول القائمة هنا
                                (index) => _buildColorOption(index),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Description",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            "Premium quality cotton T-shirt with a comfortable fit. Perfect for everyday wear. Made with 100% organic cotton and eco-friendly dyes.",
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.6,
                              color: AppTheme.textsecandery,
                            ),
                          ),
                          SizedBox(height: 16),
                          Row(
                            children: [
                              _buildFeature(Icons.eco, "Organic\nCotton"),
                              _buildFeature(
                                Icons.local_laundry_service,
                                "Machine\nWashable",
                              ),
                              _buildFeature(Icons.verified, "Quality\nAssured"),
                            ],
                          ),
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
                                "Reviews",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: Text("View All"),
                              ),
                            ],
                          ),
                          Container(
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
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundColor: AppTheme.primaryColor,
                                      child: Text(
                                        "JD",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "John Doe",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: AppTheme.textPrimary,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.star,
                                                size: 16,
                                                color: AppTheme.warning,
                                              ),
                                              Icon(
                                                Icons.star,
                                                size: 16,
                                                color: AppTheme.warning,
                                              ),
                                              Icon(
                                                Icons.star,
                                                size: 16,
                                                color: AppTheme.warning,
                                              ),
                                              Icon(
                                                Icons.star_half,
                                                size: 16,
                                                color: AppTheme.warning,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      "2 days ago",
                                      style: TextStyle(
                                        color: AppTheme.textsecandery,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12),
                                Text(
                                  'Great product! The quality is excellent and the fit is perfect. Highly recommended for anyone looking for a comfortable T-shirt.',
                                  style: TextStyle(
                                    height: 1.5,
                                    color: AppTheme.textsecandery,
                                  ),
                                ),
                              ],
                            ),
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
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 100,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.shopping_cart_outlined,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: GradintBottom(
                      text: "Add to Cart",
                      onPressed: () async {
                        try {
                          widget._cartcontroller.addToCart(
                            widget.product,
                            quantity: 1,
                            selectedSize: _sizes[_selectedSize],
                            selectedColor: _getColorName(_selectedColor),
                          );
                          Get.to(() => CartScreen());
                          print("Product added to cart successfully");
                        } catch (e) {
                          print("Error adding cart: $e"); // اطبع الخطأ نفسه
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
