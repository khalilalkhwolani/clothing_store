import 'package:myprojectshop/model/product_model.dart';

class CartItem {
  final int? id;
  final int userId;
  final int productId;
  final int quantity;
  final Product product;

  CartItem({
    this.id,
    required this.userId,
    required this.productId,
    required this.quantity,
    required this.product,
  });

  // دالة لحساب إجمالي السعر لهذا العنصر في السلة
  double get totalPrice => product.price * quantity;
  // تحويل CartItem إلى Map لتخزينه محلياً إذا لزم الأمر
  Map<String, dynamic> toMap() => {
    'id': id,
    'userId': userId,
    'productId': productId,
    'quantity': quantity,
    'product': product.toMap(),
  };
  factory CartItem.fromMap(Map<String, dynamic> json) => CartItem(
    id: json['id'],
    userId: json['userId'],
    productId: json['productId'],
    quantity: json['quantity'],
    product: Product.fromMap(json['product']),
  );

  // إنشاء نسخة جديدة من CartItem مع تحديث الكمية
  CartItem copyWith({
    int? quantity,
    String? selectedSize,
    String? selectedColor,
  }) {
    return CartItem(
      id: this.id,
      userId: this.userId,
      productId: this.productId,
      product: this.product,
      quantity: quantity ?? this.quantity,
    );
  }
}
