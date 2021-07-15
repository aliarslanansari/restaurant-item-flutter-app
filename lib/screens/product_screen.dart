import 'package:cartapp/models/orders.dart';
import 'package:cartapp/models/products.dart';
import 'package:cartapp/widgets/category_list.dart';
import 'package:cartapp/widgets/place_order_button_main.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatefulWidget {
  List<ProductCategory> categories;
  Order currentOrder;
  bool orderPlaced;
  Function(bool isExpanded, int indexE) onExpansionChange;
  Function(Product prod, int quantity) onProductAdd;
  Function onPlaceOrderClick;
  bool orderSaved = false;
  Function onPlaceNewOrder;

  ProductScreen(
      this.categories,
      this.currentOrder,
      this.onProductAdd,
      this.onExpansionChange,
      this.onPlaceOrderClick,
      this.orderPlaced,
      this.orderSaved,
      this.onPlaceNewOrder);

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Expanded(
                child: CategoryList(widget.categories, widget.currentOrder,
                    widget.onProductAdd, widget.onExpansionChange,
                    isManageOrder: false)),
            PlaceOrderButtonMain(widget.currentOrder, widget.onPlaceOrderClick,
                widget.orderPlaced, widget.orderSaved),
            widget.orderSaved
                ? (Container(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                      child: FlatButton(
                        height: 50,
                        onPressed: () {
                          widget.onPlaceNewOrder();
                        },
                        child: Row(
                          children: [
                            Expanded(
                                child: Align(
                                    alignment: Alignment.center,
                                    child: Text('Place New Order'))),
                          ],
                        ),
                        textColor: Colors.white,
                        color: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ))
                : Text('')
          ],
        ),
      ),
    );
  }
}
