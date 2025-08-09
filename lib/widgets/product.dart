class Product {
  int? id;
  String name;
  double price;
  String image;

  Product({this.id, required this.name, required this.price, required this.image});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'image': image,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      image: map['image'],
    );
  }
}
