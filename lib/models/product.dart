class Product {
  final int id;
  final String name;
  final String seller;
  final double price;
  final String image;
  final String description;

  Product({
    required this.id,
    required this.name,
    required this.seller,
    required this.price,
    required this.image,
    required this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: int.parse(json['id']),
      name: json['name'],
      seller: json['seller'],
      price: double.parse(json['price']),
      image: json['image'],
      description: json['description'],
    );
  }
}
