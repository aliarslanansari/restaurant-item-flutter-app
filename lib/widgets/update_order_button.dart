import 'package:cartapp/models/orders.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UpdateOrderButton extends StatefulWidget {
  Order currentOrder;
  bool orderSaved;
  Function onOrderSave;
  UpdateOrderButton(this.currentOrder, this.orderSaved, this.onOrderSave,
      {Key key})
      : super(key: Key(DateTime.now().toString()));

  @override
  _UpdateOrderButtonState createState() => _UpdateOrderButtonState();
}

class _UpdateOrderButtonState extends State<UpdateOrderButton> {
  int totalPrice = 0;
  OrderedProduct orderedProduct;

  @override
  void initState() {
    super.initState();
    orderedProduct = null;
    totalPrice = 0;
    if (widget.currentOrder != null &&
        widget.currentOrder.orderedProduct.length > 0) {
      widget.currentOrder.orderedProduct.forEach((element) {
        totalPrice += (element.price * element.quantity);
      });
      setState(() {
        totalPrice = totalPrice;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
        child: FlatButton(
          height: 50,
          onPressed: () {
            widget.onOrderSave(true);
          },
          child: Row(
            children: [
              Expanded(child: Text('')),
              Expanded(
                  child:
                      Text(widget.orderSaved ? "Order Saved" : 'Update Order')),
              Text("\$" + totalPrice.toString())
            ],
          ),
          textColor: Colors.white,
          color: widget.orderSaved ? Colors.green : Colors.orange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    );
  }
}
