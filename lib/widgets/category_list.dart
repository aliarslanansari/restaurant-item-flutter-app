import 'package:cartapp/models/orders.dart';
import 'package:cartapp/models/products.dart';
import 'package:cartapp/widgets/item_row.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryList extends StatefulWidget {
  List<ProductCategory> categories;
  Order currentOrder;
  Function(OrderedProduct prod, int quantity) onProductUpdate;

  Function(bool isExpanded, int indexE) onExpansionChange;
  bool isManageOrder = false;

  Function(Product prod, int quantity) onProductAdd;

  CategoryList(this.categories, this.currentOrder, this.onProductAdd,
      this.onExpansionChange,
      {this.isManageOrder, this.onProductUpdate});

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
            currentOrderProduct != null ? currentOrderProduct.quantity : 0,
            false,
            0,
            widget.onProductUpdate);
      });

  List<Widget> _getOrderedChildren(int count) =>
      List<Widget>.generate(count, (i) {
        return ItemRow(new Product(), widget.currentOrder, widget.onProductAdd,
            0, true, i, widget.onProductUpdate);
      });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.isManageOrder ? 1 : widget.categories.length,
        itemBuilder: (BuildContext context, int index) {
          return ExpansionTile(
            initiallyExpanded: index == 0,
            title: Row(
              children: [
                Text(
                  widget.isManageOrder
                      ? "Items Ordered"
                      : widget.categories[index].name,
                  style: TextStyle(color: Colors.black),
                ),
                Container(child: Expanded(child: Text(" "))),
                Text(
                  widget.isManageOrder
                      ? widget.currentOrder.orderedProduct.length.toString()
                      : widget.categories[index].products.length.toString(),
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            children: widget.isManageOrder
                ? _getOrderedChildren(widget.currentOrder.orderedProduct.length)
                : _getChildren(widget.categories[index].products.length,
                    widget.categories[index].name, index),
          );
        });
  }
}
