class ProductCategory {
  List<Product> products;

  String name;
  ProductCategory(this.products, this.name);

  Map<String, dynamic> toJson() => {
        name: List<dynamic>.from(products.map((x) => x.toJson())),
      };
}

class Product {
  Product({this.id, this.name, this.price, this.inStock, this.quantity});

  String name;
  String id;
  int price;
  bool inStock;
  int quantity;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        price: json["price"],
        inStock: json["inStock"],
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "inStock": inStock,
        "quantity": quantity
      };
}
