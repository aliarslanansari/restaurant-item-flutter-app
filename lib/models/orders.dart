// To parse this JSON data, do
//
//     final order = orderFromJson(jsonString);

import 'dart:convert';

Order orderFromJson(String str) => Order.fromJson(json.decode(str));

String orderToJson(Order data) => json.encode(data.toJson());

class Order {
  Order({
    this.orderedProduct,
    this.orderDate,
    this.orderId,
  });

  List<OrderedProduct> orderedProduct;
  DateTime orderDate;
  String orderId;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        orderedProduct: List<OrderedProduct>.from(
            json["orderedProduct"].map((x) => OrderedProduct.fromJson(x))),
        orderDate: json["orderDate"],
        orderId: json["orderId"],
      );

  Map<String, dynamic> toJson() => {
        "orderedProduct":
            List<dynamic>.from(orderedProduct.map((x) => x.toJson())),
        "orderDate": orderDate,
        "orderId": orderId,
      };
}

class OrderedProduct {
  OrderedProduct({
    this.id,
    this.name,
    this.quantity,
    this.price,
  });

  String id;
  String name;
  int quantity;
  int price;

  factory OrderedProduct.fromJson(Map<String, dynamic> json) => OrderedProduct(
        id: json["id"],
        name: json["name"],
        quantity: json["quantity"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "quantity": quantity,
        "price": price,
      };
}
