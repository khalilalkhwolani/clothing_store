import 'dart:convert';

import 'package:myprojectshop/model/category_modle.dart'; // For JSON encoding/decoding attributes

class Product {
  final int? id; // Nullable for new products before insertion
  String name;
  String? description;
  double price;
  String? imageUrl;
  int? categoryId; // Link to categories table
  int stock;
  Map<String, dynamic>?
  attributes; // Store as JSON string in DB, but handle as Map here
  DateTime? createdAt; // Store as ISO8601 string in DB
  DateTime? updatedAt; // Store as ISO8601 string in DB

  Product({
    this.id,
    required this.name,
    this.description,
    required this.price,
    this.imageUrl,
    this.categoryId,
    this.stock = 0,
    this.attributes,
    this.createdAt,
    this.updatedAt,
  });

  // Convert a Product object into a Map for database operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl ?? '',
      'categoryId': categoryId,
      'stock': stock,
      // Encode attributes Map to JSON string for storage
      'attributes': attributes == null ? null : jsonEncode(attributes),
      // Format DateTime to ISO8601 string for storage
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Create a Product object from a Map retrieved from the database
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: map['price'] ?? 0,
      imageUrl: map['imageUrl'],
      categoryId: map['categoryId'],
      stock: map['stock'] ?? 0,
      // Decode JSON string back to Map, handle null/errors
      attributes:
          map['attributes'] == null ? null : jsonDecode(map['attributes']),
      // Parse ISO8601 string back to DateTime, handle null
      createdAt:
          map['createdAt'] == null ? null : DateTime.parse(map['createdAt']),
      updatedAt:
          map['updatedAt'] == null ? null : DateTime.parse(map['updatedAt']),
    );
  }

  // Optional: Override toString for easy printing/debugging
  @override
  String toString() {
    return 'Product{id: $id, name: $name, price: $price, categoryId: $categoryId, stock: $stock}';
  }

  String getCategoryName(List<Category> categories) {
    if (categoryId == null) return 'فئة غير معروفة';

    try {
      final category = categories.firstWhere((cat) => cat.id == categoryId);
      return category.name;
    } catch (e) {
      return 'فئة غير معروفة';
    }
  }
}
