import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:myprojectshop/controller/CategoryCotroller.dart';
import 'package:myprojectshop/controller/ProductController.dart';
import 'package:myprojectshop/controller/auth_controller.dart';
import 'package:myprojectshop/controller/cart_controller.dart';
import 'package:myprojectshop/controller/order_controller.dart';
import 'package:myprojectshop/controller/order_item_controller.dart';
import 'package:myprojectshop/screens/SplashScreen.dart';
import 'package:myprojectshop/theme/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // ⬅️ هذا يربط Flutter بالنظام قبل تشغيل التطبيق

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );
  Get.put(AuthController());
  Get.put(ProductController());
  Get.put(Categorycotroller());
  Get.put(CartController());
  Get.put(OrderController());
  Get.put(OrderItemController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.

  // Future<void> insertAdminIfNeeded() async {
  //   final db = await openDatabase(
  //     'clothing_store.db',
  //   ); // Replace with your actual database path or helper

  //   final existingAdmin = await db.query(
  //     'users',
  //     where: 'username = ?',
  //     whereArgs: ['admin'],
  //   );

  //   if (existingAdmin.isEmpty) {
  //     final hashedPassword = BCrypt.hashpw('adminn', BCrypt.gensalt());

  //     await db.insert('users', {
  //       'username': 'admin',
  //       'email': 'admin@gmail.com',
  //       'password': hashedPassword,
  //       'role': 'admin', // 👈 هذا يحدد إنه مشرف
  //     });
  //     print("Admin user inserted.");
  //   } else {
  //     print("Admin already exists.");
  //   }
  // }

  // void main() async {
  //   WidgetsFlutterBinding.ensureInitialized();
  //   await insertAdminIfNeeded();
  //   runApp(MyApp());
  // }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "ShopEase",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: SplashScreen(),
      // home: MainScrean(),
      // home: AdminDashboard(),
      // home: WelcomeScreen(),
    );
  }
}
