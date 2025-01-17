class Product {
  final int id;
  final String name;
  final int price;
  final String description;
  final bool requestable;
  final String? image;
  final Category? category;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.requestable,
    this.image,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unnamed Product',
      price: json['price'] ?? 0,
      description: json['description'] ?? 'No description available',
      requestable: (json['requestable'] == 1),
      image: json['image'], // Bisa null
      category: json['category'] != null
          ? Category.fromJson(json['category'])
          : Category(id: 0, name: 'Uncategorized'),
    );
  }
}

class Category {
  final int id;
  final String name;

  Category({
    required this.id,
    required this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
    );
  }
}
