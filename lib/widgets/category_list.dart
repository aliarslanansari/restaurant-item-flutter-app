import 'package:cartapp/models/orders.dart';
import 'package:cartapp/models/products.dart';
import 'package:cartapp/widgets/item_row.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryList extends StatefulWidget {
  List<ProductCategory> categories;
  Order currentOrder;

  Function(bool isExpanded, int indexE) onExpansionChange;

  Function(Product prod, int quantity) onProductAdd;

  CategoryList(
    this.categories,
    this.currentOrder,
    this.onProductAdd,
    this.onExpansionChange,
  );

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  List<Widget> _getChildren(int count, String name, int catIndex) =>
      List<Widget>.generate(count, (i) {
        OrderedProduct currentOrderProduct;
        if (widget.currentOrder != null ||
            widget.currentOrder.orderedProduct.length > 0) {
          currentOrderProduct =
              widget.currentOrder.orderedProduct.firstWhere((prod) {
            return prod.id == widget.categories[catIndex].products[i].id;
          }, orElse: () {
            return null;
          });
        }

        return ItemRow(
            widget.categories[catIndex].products[i],
            widget.currentOrder,
            widget.onProductAdd,
            currentOrderProduct != null ? currentOrderProduct.quantity : 0);
      });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.categories.length,
        itemBuilder: (BuildContext context, int index) {
          return ExpansionTile(
            title: Row(
              children: [
                Text(
                  widget.categories[index].name,
                  style: TextStyle(color: Colors.black),
                ),
                Container(child: Expanded(child: Text(" "))),
                Text(
                  widget.categories[index].products.length.toString(),
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            children: _getChildren(widget.categories[index].products.length,
                widget.categories[index].name, index),
          );
        });
  }
}
