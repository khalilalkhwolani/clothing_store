import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myprojectshop/controller/CategoryCotroller.dart';
import 'package:myprojectshop/model/category_modle.dart';
import 'package:myprojectshop/theme/theme.dart';

class AddCatagoryScreen extends StatefulWidget {
  final Category? category;

  AddCatagoryScreen({this.category, Key? key}) : super(key: key);

  @override
  State<AddCatagoryScreen> createState() => _AddCatagoryScreenState();
}

class _AddCatagoryScreenState extends State<AddCatagoryScreen> {
  final Categorycotroller controller = Get.find<Categorycotroller>();

  final _nameController = TextEditingController();

  final _descriptionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  // final RxString _selectedImagePath = ''.obs;
  @override
  Widget build(BuildContext context) {
    // if (widget.category != null) {
    //   _nameController.text = widget.category.name!;
    //   _descriptionController.text = category.description ?? '';

    // }

    bool isEditing = widget.category != null;

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
                  middleText: "Are you sure you want to delete ?",
                  textConfirm: "Delete",
                  textCancel: "Cancel",
                  confirmTextColor: Colors.white,
                  onConfirm: () {
                    // controller.deleteCategory(category.id!);
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
                // Obx(
                //   () => GestureDetector(
                //     onTap: _pickImage,
                //     child: Container(
                //       width: 150,
                //       height: 150,
                //       decoration: BoxDecoration(
                //         border: Border.all(color: Colors.grey),
                //         borderRadius: BorderRadius.circular(8),
                //         color: Colors.grey[200],
                //       ),
                //       child:
                //           _selectedImagePath.value.isEmpty
                //               ? Column(
                //                 mainAxisAlignment: MainAxisAlignment.center,
                //                 children: [
                //                   Icon(
                //                     Icons.add_a_photo,
                //                     size: 50,
                //                     color: Colors.grey[600],
                //                   ),
                //                   const SizedBox(height: 8),
                //                   Text(
                //                     "Select Image",
                //                     style: TextStyle(color: Colors.grey[600]),
                //                   ),
                //                 ],
                //               )
                //               : Image.file(
                //                 File(_selectedImagePath.value),
                //                 fit: BoxFit.cover,
                //                 errorBuilder: (context, error, stackTrace) {
                //                   _selectedImagePath.value = '';
                //                   return Center(
                //                     child: Icon(
                //                       Icons.broken_image,
                //                       color: Colors.grey[600],
                //                       size: 50,
                //                     ),
                //                   );
                //                 },
                //               ),
                //     ),
                //   ),
                // ),
                // const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "Category Name *",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a Category name';
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

                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final newCatgory = Category(
                        // id: isEditing ? category.id : null,
                        name: _nameController.text,
                        description: _descriptionController.text,
                      );

                      if (isEditing) {
                        controller.updateCategory(newCatgory);
                      } else {
                        controller.addCategory(newCatgory);
                      }

                      Get.back();
                    }
                  },
                  child: Text(
                    isEditing ? "  Update Category  " : "  Add Category  ",
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
