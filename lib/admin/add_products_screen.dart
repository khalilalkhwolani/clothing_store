import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myprojectshop/controller/CategoryCotroller.dart';
import 'package:myprojectshop/controller/ProductController.dart';
import 'package:myprojectshop/model/category_modle.dart';
import 'package:myprojectshop/model/product_model.dart';
import 'package:myprojectshop/theme/theme.dart';

class AddProductsScreen extends StatefulWidget {
  final Product? product;
  final Category? category;

  AddProductsScreen({this.product, this.category, Key? key}) : super(key: key);

  @override
  State<AddProductsScreen> createState() => _AddProductsScreenState();
}

class _AddProductsScreenState extends State<AddProductsScreen> {
  final ProductController controller = Get.find<ProductController>();

  final Categorycotroller categoryController = Get.find<Categorycotroller>();
  int? selectedCategoryId;
  @override
  void initState() {
    super.initState();

    // تحميل الفئات من قاعدة البيانات إذا لم تكن محملة بالفعل
    if (categoryController.catgory.isEmpty) {
      categoryController.fetchCategories();
    }

    // إذا كان هناك منتج للتعديل، قم بتعيين الفئة المختارة
    if (widget.product != null) {
      selectedCategoryId = widget.product!.categoryId;
    }
  }

  // Rx<Category?> selectedCategory = Rx<Category?>(null);

  final _nameController = TextEditingController();

  final _descriptionController = TextEditingController();

  final _priceController = TextEditingController();

  final _stockController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final RxString _selectedImagePath = ''.obs;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        _selectedImagePath.value = pickedFile.path;
        print("Image selected: ${pickedFile.path}");
      } else {
        print("Image selection cancelled.");
      }
    } catch (e) {
      print("Error picking image: $e");
      Get.snackbar("Error", "Failed to pick image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.product != null) {
      _nameController.text = widget.product!.name;
      _descriptionController.text = widget.product!.description ?? '';
      _priceController.text = widget.product!.price.toString();
      _stockController.text = widget.product!.stock.toString();
    }

    bool isEditing = widget.product != null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        title: Text(
          isEditing ? "Edit Product" : "Add Product",
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                Get.defaultDialog(
                  title: "Delete Product",
                  middleText:
                      "Are you sure you want to delete ${widget.product!.name}?",
                  textConfirm: "Delete",
                  textCancel: "Cancel",
                  confirmTextColor: Colors.white,
                  onConfirm: () {
                    controller.deleteProduct(widget.product!.id!);
                    Get.back();
                    Get.back();
                  },
                );
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Obx(
                  () => GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[200],
                      ),
                      child:
                          _selectedImagePath.value.isEmpty
                              ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_a_photo,
                                    size: 50,
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Select Image",
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ],
                              )
                              : Image.file(
                                File(_selectedImagePath.value),
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  _selectedImagePath.value = '';
                                  return Center(
                                    child: Icon(
                                      Icons.broken_image,
                                      color: Colors.grey[600],
                                      size: 50,
                                    ),
                                  );
                                },
                              ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "Product Name *",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a product name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: "Description",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: "Price *",
                    prefixText: "\$",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a price';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _stockController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Stock",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter stock quantity';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // استبدال TextFormField بـ DropdownButtonFormField
                DropdownButtonFormField<int>(
                  value: selectedCategoryId,
                  decoration: InputDecoration(
                    labelText: "Select category  ",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items:
                      categoryController.catgory.map((category) {
                        return DropdownMenuItem<int>(
                          value: category.id,
                          child: Text(category.name),
                        );
                      }).toList(),
                  onChanged: (int? newValue) {
                    setState(() {
                      selectedCategoryId = newValue;
                    });
                  },
                ),

                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final newProduct = Product(
                        id: isEditing ? widget.product!.id : null,
                        name: _nameController.text,
                        description: _descriptionController.text,
                        price: double.parse(_priceController.text),
                        imageUrl: _selectedImagePath.value,
                        stock: int.parse(_stockController.text),
                      );

                      if (isEditing) {
                        controller.updateProduct(newProduct);
                      } else {
                        controller.addProduct(newProduct);
                      }

                      Get.back();
                    }
                  },
                  child: Text(
                    isEditing ? "  Update Product  " : "  Add Product  ",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
