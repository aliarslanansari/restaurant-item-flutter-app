import 'dart:convert';
import 'dart:math';
import 'package:cartapp/models/orders.dart';
import 'package:uuid/uuid.dart';
import 'package:cartapp/models/products.dart';
import 'package:cartapp/screens/product_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

var uuid = Uuid();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Restaurant App',
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        home: CartApp());
  }
}

class CartApp extends StatefulWidget {
  @override
  _CartAppState createState() => _CartAppState();
}

class _CartAppState extends State<CartApp> {
  List<Product> products = [];
  Order currentOrder;
  int sum = 0;
  List<ProductCategory> categories = [];
  var myProductsData;
  int indexExpanded = 0;
  bool isExpanded = true;
  void onExpansionChange(bool expanded, int indexE) {
    setState(() {
      indexExpanded = indexE;
      isExpanded = expanded;
    });
  }

  Future<String> getProductDataFromJson() {
    return rootBundle.loadString('lib/assets/data.json');
  }

  void onProductAddRemove(Product prod, int quantity) {
    int prodIndex = currentOrder.orderedProduct
        .indexWhere((element) => element.id == prod.id);
    if (prodIndex < 0) {
      currentOrder.orderedProduct.add(OrderedProduct(
          name: prod.name, id: prod.id, price: prod.price, quantity: 1));
    } else {
      currentOrder.orderedProduct[prodIndex].quantity += quantity;
    }
    if (prodIndex >= 0 &&
        currentOrder.orderedProduct[prodIndex].quantity <= 0) {
      currentOrder.orderedProduct.removeAt(prodIndex);
    }
    int catIndex = -1;
    int pIndex;
    var i = categories.iterator;
    while (i.moveNext()) {
      var cat = i.current;
      catIndex += 1;
      int ind = cat.products.indexWhere((p) => prod.id == p.id);
      if (ind >= 0) {
        pIndex = ind;
        break;
      }
    }
    categories[catIndex].products[pIndex].quantity -= quantity;
    if (categories[catIndex].products[pIndex].quantity <= 0) {
      categories[catIndex].products[pIndex].inStock = false;
    } else {
      categories[catIndex].products[pIndex].inStock = true;
    }
    setState(() {
      currentOrder = currentOrder;
      categories = categories;
    });
  }

  void initState() {
    super.initState();
    getProductDataFromJson().then((jsonData) {
      myProductsData = json.decode(jsonData);
      myProductsData.forEach((String category, var products) {
        List<Product> newProducts = [];
        products.forEach((product) {
          int quantity = (new Random()).nextInt(5);
          newProducts.add(Product(
              id: uuid.v4(),
              inStock: quantity != 0,
              price: product['price'],
              name: product['name'],
              quantity: quantity));
        });
        categories.add(ProductCategory(newProducts, category));
      });
      setState(() {
        categories = categories;
      });
      print(jsonEncode(categories));
    });

    currentOrder = new Order(
        orderDate: DateTime.now(), orderId: uuid.v4(), orderedProduct: []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProductScreen(categories, this.currentOrder, onProductAddRemove,
          this.onExpansionChange),
    );
  }
}
