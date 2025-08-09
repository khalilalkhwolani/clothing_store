import 'package:bcrypt/bcrypt.dart';
import 'package:myprojectshop/model/cart_item_model.dart';
import 'package:myprojectshop/model/order_model.dart';
import 'package:myprojectshop/model/orderitem_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class DatabaseHelper {
  // 1. إنشاء Singleton
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // 2. البناء الخاص
  DatabaseHelper._privateConstructor();

  // 3. قاعدة البيانات
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'clothing_store.db');
    print("Database path: $path");
    return await openDatabase(
      path,
      version: 1, // Keep version 1 for initial creation
      onCreate: _onCreate, // All tables created here
      onOpen: (db) async {
        // ✅ تفعيل دعم المفاتيح الأجنبية
        await db.execute("PRAGMA foreign_keys = ON");
      },
    );
  }

  // Create ALL tables on the very first database creation (version 1)
  Future<void> _onCreate(Database db, int version) async {
    print("Creating initial database schema version $version...");

    // Users table (with email)
    await db.execute("""
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE NOT NULL,
        email TEXT UNIQUE NOT NULL, 
        password TEXT NOT NULL, 
        role TEXT NOT NULL DEFAULT 'user' 
      )
    """);
    print("Table 'users' Created");

    // Categories table
    await db.execute("""
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE,
        description TEXT 
      )
    """);
    print("Table 'categories' Created");

    // Products table (Updated with categoryId and timestamps)
    await db.execute("""
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        price REAL NOT NULL,
        imageUrl TEXT,
        categoryId INTEGER, -- Added categoryId as FK
        stock INTEGER DEFAULT 0,
        attributes TEXT, 
        createdAt TEXT, -- Added timestamp
        updatedAt TEXT, -- Added timestamp
        FOREIGN KEY (categoryId) REFERENCES categories (id) ON DELETE SET NULL -- Or ON DELETE RESTRICT depending on desired behavior
      )
    """);
    print("Table 'products' Created (Updated Schema)");

    // Cart items table (with FK to users and products)
    await db.execute("""
      CREATE TABLE cart_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER NOT NULL, 
        productId INTEGER NOT NULL,
        quantity INTEGER NOT NULL DEFAULT 1,
        FOREIGN KEY (productId) REFERENCES products (id) ON DELETE CASCADE,
        FOREIGN KEY (userId) REFERENCES users (id) ON DELETE CASCADE 
      )
    """);
    print("Table 'cart_items' Created");

    // Orders table (with FK to users)
    await db.execute("""
      CREATE TABLE orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER NOT NULL, 
        orderDate TEXT NOT NULL, 
        totalAmount REAL NOT NULL,
        status TEXT NOT NULL DEFAULT 'Pending',
        FOREIGN KEY (userId) REFERENCES users (id) ON DELETE RESTRICT 
      )
    """);
    print("Table 'orders' Created");

    // Order items table (with FK to orders and products)
    await db.execute("""
      CREATE TABLE order_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        orderId INTEGER NOT NULL,
        productId INTEGER NOT NULL,
        quantity INTEGER NOT NULL,
        price REAL NOT NULL, 
        FOREIGN KEY (orderId) REFERENCES orders (id) ON DELETE CASCADE,
        FOREIGN KEY (productId) REFERENCES products (id) ON DELETE CASCADE 
      )
    """);
    print("Table 'order_items' Created");

    print("All tables created successfully for initial version $version!");

    // Insert a default admin user for testing (Updated with email)
    await _insertDefaultAdmin(db);
  }

  // Helper to insert a default admin user (call from _onCreate)

  Future<void> _insertDefaultAdmin(Database db) async {
    try {
      final hashedPassword = BCrypt.hashpw('adminn', BCrypt.gensalt());

      await db.insert('users', {
        'username': 'admin',
        'email': 'admin@gmail.com',
        'password': hashedPassword, // ✅ كلمة المرور الآن مشفّرة
        'role': 'admin',
      }, conflictAlgorithm: ConflictAlgorithm.ignore);

      print("Default admin user inserted or already exists.");
    } catch (e) {
      print("Error inserting default admin user: $e");
    }
  }

  // --- CRUD Operations for Products (Updated for timestamps) ---
  Future<int> insertProduct(Map<String, dynamic> productData) async {
    final db = await database;
    String now = DateTime.now().toIso8601String();
    productData['createdAt'] = now;
    productData['updatedAt'] = now;
    int id = await db.insert(
      'products',
      productData,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print("Inserted product with ID: $id");
    return id;
  }

  Future<List<Map<String, dynamic>>> getAllProducts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('products');
    print("Fetched ${maps.length} products");
    return maps;
  }

  Future<Map<String, dynamic>?> getProductById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      print("Fetched product with ID: $id");
      return maps.first;
    } else {
      print("Product with ID: $id not found");
      return null;
    }
  }

  Future<int> updateProduct(Map<String, dynamic> productData) async {
    final db = await database;
    int id = productData['id'];
    productData['updatedAt'] = DateTime.now().toIso8601String();
    int count = await db.update(
      'products',
      productData,
      where: 'id = ?',
      whereArgs: [id],
    );
    print("Updated $count product(s) with ID: $id");
    return count;
  }

  Future<int> deleteProduct(int id) async {
    final db = await database;
    int count = await db.delete('products', where: 'id = ?', whereArgs: [id]);
    print("Deleted $count product(s) with ID: $id");
    return count;
  }

  // --- CRUD Operations for Users (Existing - email added) ---

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    print("Fetched ${maps.length} users");
    return maps;
  }

  Future<int> insertUser(Map<String, dynamic> userData) async {
    final db = await database;
    if (userData['email'] == null) {
      print("Error: Email is required to insert user.");
      return -3;
    }
    try {
      int id = await db.insert(
        'users',
        userData,
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
      print("Inserted user with ID: $id");
      return id;
    } catch (e) {
      print("Error inserting user: $e");
      if (e.toString().contains('UNIQUE constraint failed')) {
        print("Username or Email already exists.");
        return -1;
      } else {
        return -2;
      }
    }
  }

  Future<Map<String, dynamic>?> getUserByUsername(String username) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
      limit: 1,
    );
    if (maps.isNotEmpty) {
      print("Fetched user: $username");
      return maps.first;
    } else {
      print("User not found: $username");
      return null;
    }
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );
    if (maps.isNotEmpty) {
      print("Fetched user by email: $email");
      return maps.first;
    } else {
      print("User not found with email: $email");
      return null;
    }
  }

  Future<Map<String, dynamic>?> getUserById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      print("Fetched user with ID: $id");
      return maps.first;
    } else {
      print("User with ID: $id not found");
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getOrdersByUserId(int userId) async {
    final db = await database;

    return await db.query('orders', where: 'userId = ?', whereArgs: [userId]);
  }

  Future<void> printAllUsers() async {
    final db = await database;
    final users = await db.query('users');
    print('All users: $users');
  }

  // --- CRUD operations for Categories (New) ---
  Future<int> insertCategory(Map<String, dynamic> categoryData) async {
    final db = await database;
    try {
      int id = await db.insert(
        'categories',
        categoryData, // Should contain 'name' and optionally 'description'
        conflictAlgorithm:
            ConflictAlgorithm.fail, // Fail if name already exists
      );
      print("Inserted category with ID: $id");
      return id;
    } catch (e) {
      print("Error inserting category: $e");
      if (e.toString().contains('UNIQUE constraint failed')) {
        print("Category name ${categoryData['name']} already exists.");
        return -1; // Indicate failure due to duplicate name
      } else {
        return -2; // Indicate other error
      }
    }
  }

  Future<List<Map<String, dynamic>>> getAllCategories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('categories');
    print("Fetched ${maps.length} categories");
    return maps;
  }

  Future<Map<String, dynamic>?> getCategoryById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'categories',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      print("Fetched category with ID: $id");
      return maps.first;
    } else {
      print("Category with ID: $id not found");
      return null;
    }
  }

  Future<int> updateCategory(Map<String, dynamic> categoryData) async {
    final db = await database;
    int id = categoryData['id'];
    try {
      int count = await db.update(
        'categories',
        categoryData,
        where: 'id = ?',
        whereArgs: [id],
        conflictAlgorithm:
            ConflictAlgorithm.fail, // Prevent updating to an existing name
      );
      print("Updated $count category(s) with ID: $id");
      return count;
    } catch (e) {
      print("Error updating category $id: $e");
      if (e.toString().contains('UNIQUE constraint failed')) {
        print(
          "Cannot update category: name ${categoryData['name']} already exists.",
        );
        return -1; // Indicate failure due to duplicate name
      } else {
        return -2; // Indicate other error
      }
    }
  }

  Future<int> deleteCategory(int id) async {
    final db = await database;
    // Consider how you want to handle products linked to this category.
    // The current schema uses ON DELETE SET NULL, so products' categoryId will become NULL.
    // You might want to prevent deletion if products are linked, or reassign them first.
    int count = await db.delete('categories', where: 'id = ?', whereArgs: [id]);
    print("Deleted $count category(s) with ID: $id");
    // Note: Products linked to this category will now have categoryId = NULL.
    return count;
  }

  // --- Add CRUD operations for cart_items, orders, order_items etc. here ---
  Future<void> addToCart(CartItem item) async {
    final db = await database;
    await db.insert(
      'cart_items',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<CartItem>> getCartItems(int userId) async {
    final db = await database;
    final maps = await db.query(
      'cart_items',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    return List.generate(maps.length, (i) => CartItem.fromMap(maps[i]));
  }

  Future<void> updateQuantity(int cartItemId, int newQuantity) async {
    final db = await database;
    await db.update(
      'cart_items',
      {'quantity': newQuantity},
      where: 'id = ?',
      whereArgs: [cartItemId],
    );
  }

  Future<void> removeFromCart(int cartItemId) async {
    final db = await database;
    await db.delete('cart_items', where: 'id = ?', whereArgs: [cartItemId]);
  }

  Future<void> clearCart(int userId) async {
    final db = await database;
    await db.delete('cart_items', where: 'userId = ?', whereArgs: [userId]);
  }

  Future<int> getTotalItems(int userId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT SUM(quantity) as total FROM cart_items WHERE userId = ?',
      [userId],
    );
    return result.first['total'] != null ? result.first['total'] as int : 0;
  }

  // CRUD to orders

  Future<int> insertOrder(Order order) async {
    final db = await database;
    return await db.insert('orders', order.toMap());
  }

  Future<List<Order>> getAllOrders() async {
    final db = await database;
    final result = await db.query('orders');

    if (result.isNotEmpty) {
      return result.map((e) => Order.fromMap(e)).toList();
    } else {
      return []; // ترجع قائمة فاضية بدل null لتفادي الأخطاء
    }
  }

  Future<List<Map<String, dynamic>>> getAllordersForUser(int userId) async {
    final db = await database;

    // 1. جلب الطلبات الخاصة بالمستخدم
    final List<Map<String, dynamic>> orderRows = await db.query(
      'orders',
      where: 'userId = ?',
      whereArgs: [userId],
    );

    List<Map<String, dynamic>> fullOrders = [];

    // 2. لكل طلب: جلب العناصر المرتبطة به + بيانات المنتج لكل عنصر
    for (var order in orderRows) {
      final List<Map<String, dynamic>> items = await db.query(
        'order_items',
        where: 'orderId = ?',
        whereArgs: [order['id']],
      );

      List<Map<String, dynamic>> enrichedItems = [];

      for (var item in items) {
        final product = await db.query(
          'products',
          where: 'id = ?',
          whereArgs: [item['productId']],
        );

        // دمج بيانات المنتج داخل العنصر
        item['product'] = product.isNotEmpty ? product.first : null;
        enrichedItems.add(item);
      }

      // دمج العناصر داخل الطلب
      order['items'] = enrichedItems;
      fullOrders.add(order);
    }

    return fullOrders;
  }

  Future<List<Map<String, dynamic>>> getAllorders1() async {
    final db = await database;

    final List<Map<String, dynamic>> orderRows = await db.query('orders');
    List<Map<String, dynamic>> fullOrders = [];

    for (var order in orderRows) {
      final List<Map<String, dynamic>> items = await db.query(
        'order_items',
        where: 'orderId = ?',
        whereArgs: [order['id']],
      );

      List<Map<String, dynamic>> enrichedItems = [];

      for (var item in items) {
        final product = await db.query(
          'products',
          where: 'id = ?',
          whereArgs: [item['productId']],
        );

        item['product'] = product.isNotEmpty ? product.first : null;
        enrichedItems.add(item);
      }

      order['items'] = enrichedItems;
      fullOrders.add(order);
    }

    return fullOrders;
  }

  Future<Order?> getOrderById(int id) async {
    final db = await database;
    final result = await db.query('orders', where: 'id = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      return Order.fromMap(result.first);
    }
    return null;
  }

  //   Future<List<Order>> getOrdersByUserId(int userId) async {
  //   final db = await database;
  //   final result = await db.query(
  //     'orders',
  //     where: 'user_id = ?',
  //     whereArgs: [userId],
  //   );

  //   return result.map((e) => Order.fromMap(e)).toList();
  // }

  Future<int> updateOrder(Order order) async {
    final db = await database;
    return await db.update(
      'orders',
      order.toMap(),
      where: 'id = ?',
      whereArgs: [order.id],
    );
  }

  Future<int> deleteOrder(int id) async {
    final db = await database;
    return await db.delete('orders', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getOrderItemsWithProduct(
    int orderId,
  ) async {
    final db = await database; // الاتصال بقاعدة البيانات

    return await db.rawQuery(
      '''
    SELECT order_items.*, products.name, products.price, products.imageUrl
    FROM order_items
    JOIN products ON order_items.productId = products.id
    WHERE order_items.orderId = ?
  ''',
      [orderId],
    );
  }

  //   CRUD orderitem

  Future<void> insertOrderItem(OrderItem item) async {
    final db = await DatabaseHelper.instance.database;
    await db.insert(
      'order_items',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Future<List<OrderItem>> getOrderItemsByOrderId(int orderId) async {
  //   final db = await DatabaseHelper.instance.database;
  //   final List<Map<String, dynamic>> result = await db.query(
  //     'order_items',
  //     where: 'orderId = ?',
  //     whereArgs: [orderId],
  //   );

  //   return result
  //       .map((map) => OrderItem.fromMap(map))
  //       .toList(); // ✅ التصحيح هنا

  //   // return result
  //   //     .where((map) => map != null) // تأكد أن map ليست null
  //   //     .map((map) => OrderItem.fromMap(result as Map<String, dynamic>))
  //   //     .toList();
  // }
  Future<List<OrderItem>> getOrderItemsByOrderId(int orderId) async {
    final db = await instance.database;
    final result = await db.rawQuery(
      '''
    SELECT order_items.*, products.id as product_id, products.name, products.price as product_price, products.imageUrl
    FROM order_items
    JOIN products ON order_items.productId = products.id
    WHERE order_items.orderId = ?
  ''',
      [orderId],
    );

    return result.map((map) {
      return OrderItem.fromMap({
        ...map,
        'product': {
          'id': map['product_id'],
          'name': map['name'],
          'price': map['product_price'],
          'imageUrl': map['imageUrl'],
        },
      });
    }).toList();
  }

  Future<void> updateOrderItem(OrderItem item) async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      'order_items',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<void> deleteOrderItem(int id) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete('order_items', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getAllorderitem() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('order_items');
    print("Fetched ${maps.length} order_items");
    return maps;
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
