class Panti {
  final int id;
  final String name;
  final String address;
  final int childNumber;
  final String foundingDate;
  final int donationTotal;
  final double priorityValue;
  final String description;
  final List<RequestList> requestLists;

  Panti({
    required this.id,
    required this.name,
    required this.address,
    required this.childNumber,
    required this.foundingDate,
    required this.donationTotal,
    required this.priorityValue,
    required this.description,
    required this.requestLists,
  });

  factory Panti.fromJson(Map<String, dynamic> json) {
    return Panti(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      childNumber: json['childNumber'],
      foundingDate: json['foundingDate'],
      donationTotal: json['donationTotal'],
      priorityValue: (json['priorityValue'] as num).toDouble(),
      description: json['description'],
      requestLists: (json['requestLists'] as List)
          .map((item) => RequestList.fromJson(item))
          .toList(),
    );
  }
}

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
      id: json['id'],
      pantiID: json['pantiID'],
      productID: json['productID'],
      requestedQty: json['requested_qty'],
      donatedQty: json['donated_qty'],
      statusApproval: json['status_approval'],
    );
  }
}
