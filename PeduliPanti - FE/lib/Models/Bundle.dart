import 'Product.dart';

class Bundle {
  final int id;
  final String name;
  final String description;
  final int price;
  // final String? image;
  final List<Product> products;

  Bundle({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    // required this.image,
    required this.products,
  });

  factory Bundle.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      throw Exception('Null JSON provided to Bundle.fromJson');
    }

    return Bundle(
      id: json['id'] ?? 0, // Gunakan nilai default jika null
      name: json['name'] ?? 'Unnamed Bundle', // Default value untuk name
      description: json['description'] ??
          'No description available', // Default description
      price: json['price'] ?? 0, // Default harga
      products: (json['products'] as List?)
              ?.map((item) => Product.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [], // Jika products null, gunakan list kosong
    );
  }
}
