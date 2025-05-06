import 'dart:convert';

class CartListResponse {
  final List<CartItemsModel> carts;

  CartListResponse({required this.carts});

  factory CartListResponse.fromJson(List<dynamic> json) {
    return CartListResponse(
      carts: json.map((cartJson) => CartItemsModel.fromJson(cartJson)).toList(),
    );
  }

  factory CartListResponse.fromRawJson(String str) =>
      CartListResponse.fromJson(json.decode(str));

  String toRawJson() =>
      json.encode(carts.map((cart) => cart.toJson()).toList());
}

class CartItemsModel {
  String id;
  List<Item> items;
  String user;
  String cartId;
  DateTime cartDate;
  String cartTime;
  DateTime timestamp;
  int v;

  CartItemsModel({
    required this.id,
    required this.items,
    required this.user,
    required this.cartId,
    required this.cartDate,
    required this.cartTime,
    required this.timestamp,
    required this.v,
  });

  factory CartItemsModel.fromRawJson(String str) =>
      CartItemsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CartItemsModel.fromJson(Map<String, dynamic> json) => CartItemsModel(
        id: json["_id"],
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
        user: json["user"],
        cartId: json["cartId"],
        cartDate: DateTime.parse(json["cartDate"]),
        cartTime: json["cartTime"],
        timestamp: DateTime.parse(json["timestamp"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
        "user": user,
        "cartId": cartId,
        "cartDate":
            "${cartDate.year.toString().padLeft(4, '0')}-${cartDate.month.toString().padLeft(2, '0')}-${cartDate.day.toString().padLeft(2, '0')}",
        "cartTime": cartTime,
        "timestamp": timestamp.toIso8601String(),
        "__v": v,
      };
}

class Item {
  String productName;
  int quantity;
  String amount;
  String id;

  Item({
    required this.productName,
    required this.quantity,
    required this.amount,
    required this.id,
  });

  factory Item.fromRawJson(String str) => Item.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        productName: json["productName"],
        quantity: json["quantity"],
        amount: json["amount"].toString(),
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "productName": productName,
        "quantity": quantity,
        "amount": amount,
        "_id": id,
      };
}
