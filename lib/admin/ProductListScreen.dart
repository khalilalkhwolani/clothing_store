// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:myprojectshop/controller/ProductController.dart';
// import 'package:myprojectshop/admin/AddProducts_screen.dart';
// import 'package:myprojectshop/theme/theme.dart';

// class ProductListScreen extends StatelessWidget {
//   final controller = Get.put(ProductController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppTheme.backgroundColor,
//       appBar: AppBar(
//         backgroundColor: AppTheme.primaryColor,
//         title: Text("Products", style: TextStyle(color: Colors.white)),
//         centerTitle: true,
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: AppTheme.primaryColor,
//         onPressed: () {
//           Get.to(() => AddProducts()); // فتح شاشة إضافة منتج
//         },
//         child: Icon(Icons.add, color: Colors.white),
//       ),
//       body: Obx(() {
//         return ListView.builder(
//           padding: EdgeInsets.all(16),
//           itemCount: controller.products.length,
//           itemBuilder: (context, index) {
//             final product = controller.products[index];
//             return Container(
//               margin: EdgeInsets.only(bottom: 12),
//               padding: EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.05),
//                     blurRadius: 10,
//                     offset: Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   ListTile(
//                     contentPadding: EdgeInsets.zero,
//                     leading: ClipRRect(
//                       borderRadius: BorderRadius.circular(8),
//                       child: Image.asset(
//                         product.image,
//                         width: 60,
//                         height: 60,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                     title: Text(
//                       product.name,
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     subtitle: Text("\$${product.price.toStringAsFixed(2)}"),
//                     onTap: () {
//                       Get.to(() => AddProducts(product: product, index: index));
//                     },
//                   ),
//                   SizedBox(height: 8),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       SizedBox(
//                         width: 100,
//                         child: ElevatedButton.icon(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.blue,
//                             padding: EdgeInsets.symmetric(vertical: 8),
//                           ),
//                           onPressed: () {
//                             Get.to(
//                               () => AddProducts(product: product, index: index),
//                             );
//                           },
//                           icon: Icon(Icons.edit, size: 18),
//                           label: Text("", style: TextStyle(fontSize: 14)),
//                         ),
//                       ),
//                       SizedBox(width: 10),
//                       SizedBox(
//                         width: 100,
//                         child: ElevatedButton.icon(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.red,
//                             padding: EdgeInsets.symmetric(vertical: 8),
//                           ),
//                           onPressed: () {
//                             controller.products.removeAt(index);
//                           },
//                           icon: Icon(Icons.delete, size: 18),
//                           label: Text("Delete", style: TextStyle(fontSize: 14)),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       }),
//     );
//   }
// }
