import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:myprojectshop/model/cart_item_model.dart';

// خدمة السلة للتعامل مع SQLite
class CartService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'my_shop.db');
    return await openDatabase(path);
  }

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
}
