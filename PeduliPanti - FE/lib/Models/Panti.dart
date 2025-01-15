class Panti {
  final int id;
  final String name;
  final String address;
  final int childNumber;
  final String foundingDate;
  final int donationTotal;
  final double priorityValue;
  final String description;
  final Origin? origin;
  final List<RequestList> requestLists;
  final List<RAB> rabs;

  Panti({
    required this.id,
    required this.name,
    required this.address,
    required this.childNumber,
    required this.foundingDate,
    required this.donationTotal,
    required this.priorityValue,
    required this.description,
    required this.origin,
    required this.requestLists,
    required this.rabs,
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
      origin: Origin.fromJson(json['origin']),
      requestLists: (json['requestLists'] as List)
          .map((item) => RequestList.fromJson(item))
          .toList(),
      rabs: (json['rabs'] as List).map((item) => RAB.fromJson(item)).toList(),
    );
  }
}

class Origin {
  final double lat;
  final double lng;

  Origin({
    required this.lat,
    required this.lng,
  });

  factory Origin.fromJson(Map<String, dynamic> json) {
    return Origin(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
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

class RAB {
  final int id;
  final int pantiID;
  final String pdf;
  final String status;
  final String date;

  RAB({
    required this.id,
    required this.pantiID,
    required this.pdf,
    required this.status,
    required this.date,
  });

  // Factory constructor untuk memetakan JSON ke dalam objek RAB
  factory RAB.fromJson(Map<String, dynamic> json) {
    return RAB(
      id: json['id'],
      pantiID: json['pantiID'],
      pdf: json['pdf'],
      status: json['status'],
      date: json['date'],
    );
  }
}
