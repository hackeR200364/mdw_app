import 'dart:convert';

class AllProductsListModel {
  List<AllProductsModel> data;

  AllProductsListModel({
    required this.data,
  });

  factory AllProductsListModel.fromRawJson(String str) =>
      AllProductsListModel.fromJson(json.decode(str));

  factory AllProductsListModel.fromJson(List<dynamic> jsonList) =>
      AllProductsListModel(
        data: jsonList.map((e) => AllProductsModel.fromJson(e)).toList(),
      );
}

class AllProductsModel {
  String id;
  String productId;
  String name;
  String description;
  String productImage;
  Status status;
  double amount;
  int quantity;
  Category category;
  DosageType dosageType;
  String expireAt;
  double ptr;
  double marginPercent;
  String hsnCode;
  String taxRate;
  String saltName;
  String location;
  String batchNumber;
  DateTime createdAt;
  DateTime updatedAt;

  AllProductsModel({
    required this.id,
    required this.productId,
    required this.name,
    required this.description,
    required this.productImage,
    required this.status,
    required this.amount,
    required this.quantity,
    required this.category,
    required this.dosageType,
    required this.expireAt,
    required this.ptr,
    required this.marginPercent,
    required this.hsnCode,
    required this.taxRate,
    required this.saltName,
    required this.location,
    required this.batchNumber,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AllProductsModel.fromRawJson(String str) =>
      AllProductsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AllProductsModel.fromJson(Map<String, dynamic> json) =>
      AllProductsModel(
        id: json["_id"],
        productId: json["productId"],
        name: json["name"],
        description: json["description"],
        productImage: json["productImage"],
        status: statusValues.map[json["status"]]!,
        amount: json["amount"]?.toDouble(),
        quantity: json["quantity"],
        category: categoryValues.map[json["category"]]!,
        dosageType: dosageTypeValues.map[json["dosageType"]]!,
        expireAt: json["expireAt"],
        ptr: json["ptr"]?.toDouble(),
        marginPercent: json["marginPercent"]?.toDouble(),
        hsnCode: json["hsnCode"],
        taxRate: json["taxRate"],
        saltName: json["saltName"],
        location: json["location"],
        batchNumber: json["batchNumber"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "productId": productId,
        "name": name,
        "description": description,
        "productImage": productImage,
        "status": statusValues.reverse[status],
        "amount": amount,
        "quantity": quantity,
        "category": categoryValues.reverse[category],
        "dosageType": dosageTypeValues.reverse[dosageType],
        "expireAt": expireAt,
        "ptr": ptr,
        "marginPercent": marginPercent,
        "hsnCode": hsnCode,
        "taxRate": taxRate,
        "saltName": saltName,
        "location": location,
        "batchNumber": batchNumber,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}

enum Category { AYURVEDIC, COSMETIC, DRUG, GENERIC, NONE, OTC }

final categoryValues = EnumValues({
  "Ayurvedic": Category.AYURVEDIC,
  "Cosmetic": Category.COSMETIC,
  "Drug": Category.DRUG,
  "Generic": Category.GENERIC,
  "None": Category.NONE,
  "OTC": Category.OTC
});

enum DosageType {
  CAPSULE,
  CREAM,
  DROP,
  GEL,
  INH,
  NONE,
  OINT,
  POWDER,
  SOAP,
  SYRUP,
  TABLET
}

final dosageTypeValues = EnumValues({
  "Capsule": DosageType.CAPSULE,
  "Cream": DosageType.CREAM,
  "Drop": DosageType.DROP,
  "Gel": DosageType.GEL,
  "INH": DosageType.INH,
  "None": DosageType.NONE,
  "Oint": DosageType.OINT,
  "Powder": DosageType.POWDER,
  "Soap": DosageType.SOAP,
  "Syrup": DosageType.SYRUP,
  "Tablet": DosageType.TABLET
});

enum Status { AVAILABLE }

final statusValues = EnumValues({"Available": Status.AVAILABLE});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
