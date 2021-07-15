import 'dart:convert';
import 'dart:math';

import 'package:cartapp/models/orders.dart';
import 'package:cartapp/models/products.dart';
import 'package:cartapp/screens/manage_order.dart';
import 'package:cartapp/screens/order_history.dart';
import 'package:cartapp/screens/product_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:localstorage/localstorage.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();
final LocalStorage storage = new LocalStorage('restaurant');

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
  bool orderPlaced = false;
  Order currentOrder;
  List<Order> orderHistory = [];
  bool orderSaved = false;
  DateTime date;
  int _selectedIndex = 0;
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
    onOrderSave(false);
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

  void onProductUpdate(OrderedProduct prod, int quantity) {
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
    var quan = categories[catIndex].products[pIndex].quantity - quantity;
    categories[catIndex].products[pIndex].quantity = quan >= 0 ? quan : 0;

    onOrderSave(false);
    int prodIndex = currentOrder.orderedProduct
        .indexWhere((element) => element.id == prod.id);
    currentOrder.orderedProduct[prodIndex].quantity += quan >= 0 ? quantity : 0;
    if (prodIndex >= 0 &&
        currentOrder.orderedProduct[prodIndex].quantity <= 0) {
      currentOrder.orderedProduct.removeAt(prodIndex);
    }
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

  getHistoryFromLocalStorage() async {
    print('sdfsd');
    await storage.ready;
    String history = storage.getItem('history');
    if (history != null) {
      print(history);
      var historyJsonData = jsonDecode(history);
      historyJsonData.forEach((his) {
        print(DateTime.parse(his['orderDate']).toString());
        Order order = new Order(
            orderDate: DateTime.parse(his['orderDate']),
            orderId: his['orderId'],
            orderedProduct: []);
        his['orderedProduct'].forEach((prod) {
          order.orderedProduct.add(new OrderedProduct(
              id: prod['id'],
              name: prod['name'],
              price: prod['price'],
              quantity: prod['quantity']));
        });
        orderHistory.add(order);
        print('+++++++++++++++++++++++++++++++++++++');
      });
    }
    setState(() {
      orderHistory = orderHistory;
    });
  }

  void initState() {
    super.initState();

    getHistoryFromLocalStorage();

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
      // print(jsonEncode(categories));
    });

    currentOrder = new Order(
        orderDate: DateTime.now(), orderId: uuid.v4(), orderedProduct: []);
  }

  void _onItemTapped(int index) {
    setState(() {
      date = DateTime.now();
      _selectedIndex = index;
    });
  }

  void onPlaceOrderClick(int ind) {
    onOrderSave(true);
    setState(() {
      orderPlaced = true;
      date = DateTime.now();
      _selectedIndex = ind;
      orderPlaced = true;
    });
    if (ind == 1) {
      setState(() {
        orderSaved = true;
      });
    }
  }

  onOrderSave(bool state) {
    setState(() {
      orderSaved = state;
    });
    if (state) {
      var ind = orderHistory
          .indexWhere((element) => element.orderId == currentOrder.orderId);
      if (ind >= 0) {
        orderHistory[ind] = currentOrder;
      } else {
        orderHistory.add(currentOrder);
      }
      setState(() {
        orderHistory = orderHistory;
      });
    }
    saveToLocalStorage();
  }

  void onPlaceNewOrder() {
    setState(() {
      orderSaved = false;
      orderPlaced = false;
    });

    currentOrder = new Order(
        orderDate: DateTime.now(), orderId: uuid.v4(), orderedProduct: []);
  }

  void saveToLocalStorage() {
    if (orderHistory.length > 0) {
      String history =
          jsonEncode(List<dynamic>.from(orderHistory.map((x) => x.toJson())))
              .toString();
      storage.setItem('history', history);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _selectedIndex == 0
            ? ProductScreen(
                categories,
                this.currentOrder,
                onProductAddRemove,
                this.onExpansionChange,
                this.onPlaceOrderClick,
                this.orderPlaced,
                this.orderSaved,
                this.onPlaceNewOrder)
            : _selectedIndex == 1
                ? ManageOrder(
                    categories,
                    this.currentOrder,
                    onProductAddRemove,
                    this.onExpansionChange,
                    this.onPlaceOrderClick,
                    this.orderSaved,
                    this.onOrderSave,
                    key: Key(date.toString()),
                    onProductUpdate: onProductUpdate,
                  )
                : OrderHistory(this.orderHistory),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Place Order'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.backpack),
              title: Text('Manage Order'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              title: Text('Order History'),
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ));
  }
}
