import 'package:cartapp/models/orders.dart';
import 'package:cartapp/models/products.dart';
import 'package:cartapp/widgets/place_order_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ItemRow extends StatefulWidget {
  Product product;
  Order currentOrder;
  Function(Product prod, int quantity) onProductAdd;
  int quantity;
  bool isManageOrder = false;
  int index;
  Function(OrderedProduct prod, int quantity) onProductUpdate;
  ItemRow(this.product, this.currentOrder, this.onProductAdd, this.quantity,
      [this.isManageOrder, this.index, this.onProductUpdate]);

  @override
  _ItemRowState createState() => _ItemRowState();
}

class _ItemRowState extends State<ItemRow> {
  int currentOrderQuantity;
  OrderedProduct currentOrderProduct;

  onItemSelect(int add) {
    if (!widget.isManageOrder) {
      widget.onProductAdd(widget.product, add);
    } else {
      widget.onProductUpdate(
          widget.currentOrder.orderedProduct[widget.index], 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.isManageOrder
                      ? widget.currentOrder.orderedProduct[widget.index].name
                      : widget.product.name,
                  style: TextStyle(
                      fontSize: 16,
                      color: !widget.isManageOrder && !widget.product.inStock
                          ? Colors.grey
                          : Colors.black),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                  child: Text(
                    widget.isManageOrder
                        ? "\$" +
                            widget
                                .currentOrder.orderedProduct[widget.index].price
                                .toString() +
                            " | Quantity Ordered: " +
                            widget.currentOrder.orderedProduct[widget.index]
                                .quantity
                                .toString()
                        : '\$' +
                            widget.product.price.toString() +
                            " | Quantity Available: " +
                            widget.product.quantity.toString(),
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              ],
            ),
            Expanded(child: Text('')),
            PlaceOrderButton(
                (String i, String l) => {},
                !widget.isManageOrder
                    ? widget.quantity
                    : widget.currentOrder.orderedProduct[widget.index].quantity,
                !widget.isManageOrder && !widget.product.inStock,
                onItemSelect,
                widget.isManageOrder),
          ],
        ),
      ),
    );
  }
}
