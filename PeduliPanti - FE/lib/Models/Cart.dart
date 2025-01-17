import 'dart:convert';

class Cart {
  final int userID;
  final List<CartProduct> products;
  final List<CartBundle> bundles;
  final List<CartRequest> requestLists;

  Cart({
    required this.userID,
    required this.products,
    required this.bundles,
    required this.requestLists,
  });

  // Konversi ke JSON
  Map<String, dynamic> toJson() {
    return {
      'userID': userID,
      'products': products.map((product) => product.toJson()).toList(),
      'bundles': bundles.map((bundle) => bundle.toJson()).toList(),
      'requestLists': requestLists.map((request) => request.toJson()).toList(),
    };
  }
}

class CartProduct {
  final int productID;
  final int quantity;
  final int pantiID;

  CartProduct({
    required this.productID,
    required this.quantity,
    required this.pantiID,
  });

  Map<String, dynamic> toJson() {
    return {
      'productID': productID,
      'quantity': quantity,
      'pantiID': pantiID,
    };
  }
}

class CartBundle {
  final int bundleID;
  final int quantity;
  final int pantiID;

  CartBundle({
    required this.bundleID,
    required this.quantity,
    required this.pantiID,
  });

  Map<String, dynamic> toJson() {
    return {
      'bundleID': bundleID,
      'quantity': quantity,
      'pantiID': pantiID,
    };
  }
}

class CartRequest {
  final int requestID;
  final int quantity;

  CartRequest({
    required this.requestID,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'requestID': requestID,
      'quantity': quantity,
    };
  }
}
