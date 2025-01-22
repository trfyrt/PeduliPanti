class PaymentMethod {
  final String id;
  final String name;
  final String imageUrl;
  final double balance;
  final String userId;  // Tambah field userId

  PaymentMethod({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.balance,
    required this.userId,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'],
      name: json['name'],
      imageUrl: json['image_url'],
      balance: json['balance'].toDouble(),
      userId: json['user_id'],
    );
  }
}