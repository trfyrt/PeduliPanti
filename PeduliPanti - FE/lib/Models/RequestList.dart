class RequestList {
  final int id;
  final int pantiID;
  final int productID;
  final int requestedQty;
  final int donatedQty;
  final String statusApproval;

  RequestList({
    required this.id,
    required this.pantiID,
    required this.productID,
    required this.requestedQty,
    required this.donatedQty,
    required this.statusApproval,
  });

  factory RequestList.fromJson(Map<String, dynamic> json) {
    return RequestList(
      id: json['id'] ?? 0,
      pantiID: json['pantiID'] ?? 0,
      productID: json['productID'] ?? 0,
      requestedQty: json['requested_qty'] ?? 0,
      donatedQty: json['donated_qty'] ?? 0,
      statusApproval: json['status_approval'] ?? 'rejected',
    );
  }

  RequestList copyWith({
    int? id,
    int? pantiID,
    int? productID,
    int? requestedQty,
    int? donatedQty,
    String? statusApproval,
  }) {
    return RequestList(
      id: id ?? this.id,
      pantiID: pantiID ?? this.pantiID,
      productID: productID ?? this.productID,
      requestedQty: requestedQty ?? this.requestedQty,
      donatedQty: donatedQty ?? this.donatedQty,
      statusApproval: statusApproval ?? this.statusApproval,
    );
  }
}
