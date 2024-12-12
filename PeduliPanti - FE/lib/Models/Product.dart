class Product {
  final int id;
  final String name;
  final int price;
  final String description;
  final bool requestable;
  final String? image;
  final String categoryName;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.requestable,
    this.image,
    required this.categoryName,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      description: json['description'],
      requestable: json['requestable'] == 1,
      image: json['image'],
      categoryName: json['category']['name'],
    );
  }
}
