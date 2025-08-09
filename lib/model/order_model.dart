import 'package:myprojectshop/model/orderitem_model.dart';

class Order {
  final int? id;
  final int userId;
  final String orderDate;
  final double totalAmount;
  final String status;
  final List<OrderItem> items;

  Order({
    this.id,
    required this.userId,
    required this.orderDate,
    required this.totalAmount,
    required this.items,
    this.status = 'Pending',
  });

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'],
      userId: map['userId'],
      orderDate: map['orderDate'],
      totalAmount: map['totalAmount'],
      status: map['status'],
      items:
          map['items'] != null
              ? List<OrderItem>.from(
                map['items'].map((item) => OrderItem.fromMap(item)),
              )
              : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'orderDate': orderDate,
      'totalAmount': totalAmount,
      'status': status,
    };
  }
}
// class OrderModel {
//   final List<CartItem> items;
//   final double subtotal;
//   final double shipping;
//   final double tax;
//   final double total;
//   final DateTime orderDate;
//   final int userId;

//   OrderModel({
//     required this.items,
//     required this.subtotal,
//     required this.shipping,
//     required this.tax,
//     required this.total,
//     required this.orderDate,
//     required this.userId,
//   });
// }
