import 'package:myprojectshop/model/product_model.dart';

class OrderItem {
  final int? id;
  final int orderId;
  final int productId;
  final double price;
  final int quantity;
  final Product product; // الكائن المرتبط

  OrderItem({
    this.id,
    required this.orderId,
    required this.productId,
    required this.price,
    required this.quantity,
    required this.product,
  });

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      id: map['id'],
      orderId: map['orderId'],
      productId: map['productId'],
      price: map['price'],
      quantity: map['quantity'],
      product: Product.fromMap(map['product']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'orderId': orderId,
      'productId': productId,
      'price': price,
      'quantity': quantity,
    };
  }

  OrderItem copyWith({
    int? orderId,
    int? productId,
    int? quantity,
    double? price,
    Product? product,
  }) {
    return OrderItem(
      orderId: orderId ?? this.orderId,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      product: product ?? this.product,
    );
  }
}
