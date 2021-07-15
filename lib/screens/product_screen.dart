import 'package:cartapp/models/orders.dart';
import 'package:cartapp/models/products.dart';
import 'package:cartapp/widgets/category_list.dart';
import 'package:cartapp/widgets/place_order_button_main.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatefulWidget {
  List<ProductCategory> categories;
  Order currentOrder;
  Function(bool isExpanded, int indexE) onExpansionChange;
  Function(Product prod, int quantity) onProductAdd;

  ProductScreen(this.categories, this.currentOrder, this.onProductAdd,
      this.onExpansionChange);

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
                child: CategoryList(
              widget.categories,
              widget.currentOrder,
              widget.onProductAdd,
              widget.onExpansionChange,
            )),
            PlaceOrderButtonMain(widget.currentOrder)
          ],
        ),
      ),
    );
  }
}
