import 'package:cartapp/models/orders.dart';
import 'package:cartapp/models/products.dart';
import 'package:cartapp/widgets/add_more_item.dart';
import 'package:cartapp/widgets/category_list.dart';
import 'package:cartapp/widgets/update_order_button.dart';
import 'package:flutter/material.dart';

class ManageOrder extends StatefulWidget {
  List<ProductCategory> categories;
  Order currentOrder;
  Function(bool isExpanded, int indexE) onExpansionChange;
  Function(Product prod, int quantity) onProductAdd;
  Function(OrderedProduct prod, int quantity) onProductUpdate;
  Function(int ind) onPlaceOrderClick;
  Key key;
  bool orderSaved;
  Function onOrderSave;
  ManageOrder(
      this.categories,
      this.currentOrder,
      this.onProductAdd,
      this.onExpansionChange,
      this.onPlaceOrderClick,
      this.orderSaved,
      this.onOrderSave,
      {this.key,
      this.onProductUpdate})
      : super(key: key);

  @override
  _ManageOrderState createState() => _ManageOrderState();
}

class _ManageOrderState extends State<ManageOrder> {
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
              isManageOrder: true,
              onProductUpdate: widget.onProductUpdate,
            )),
            widget.currentOrder.orderedProduct.length <= 0
                ? Expanded(child: Text('No Items Ordered'))
                : Text(''),
            AddMoreItem(widget.onPlaceOrderClick),
            UpdateOrderButton(
                widget.currentOrder, widget.orderSaved, widget.onOrderSave),
          ],
        ),
      ),
    );
  }
}
