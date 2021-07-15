import 'package:cartapp/models/orders.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlaceOrderButtonMain extends StatefulWidget {
  Order currentOrder;
  PlaceOrderButtonMain(this.currentOrder, {Key key})
      : super(key: Key(DateTime.now().toString()));

  @override
  _PlaceOrderButtonMainState createState() => _PlaceOrderButtonMainState();
}

class _PlaceOrderButtonMainState extends State<PlaceOrderButtonMain> {
  int totalPrice = 0;
  OrderedProduct orderedProduct;

  @override
  void initState() {
    print('CALLED');
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
          onPressed: () {},
          child: Row(
            children: [
              Expanded(child: Text('')),
              Expanded(child: Text('Place Order')),
              Text("\$" + totalPrice.toString())
            ],
          ),
          textColor: Colors.white,
          color: Colors.orange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    );
  }
}
