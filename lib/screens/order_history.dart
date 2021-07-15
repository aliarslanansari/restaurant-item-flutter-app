import 'package:cartapp/models/orders.dart';
import 'package:flutter/material.dart';

class OrderHistory extends StatefulWidget {
  List<Order> orderHistory = [];
  OrderHistory(this.orderHistory);
  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  List<Widget> _getOrderedChildren(int count, int index) =>
      List<Widget>.generate(count, (i) {
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
                      widget.orderHistory[index].orderedProduct[i].name,
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                      child: Text(
                        "\$" +
                            widget.orderHistory[index].orderedProduct[i].price
                                .toString() +
                            " | Quantity Ordered: " +
                            widget
                                .orderHistory[index].orderedProduct[i].quantity
                                .toString(),
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      });

  // return Container(
  //   child: ListTile(
  //       title: Row(
  //     children: [Text(widget.orderHistory[index].orderedProduct[i].name)],
  //   )),
  // );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            widget.orderHistory.length > 0
                ? Expanded(
                    child: ListView.builder(
                        itemCount: widget.orderHistory.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ExpansionTile(
                              initiallyExpanded: index == 0,
                              title: Text('Order Date: ' +
                                  widget.orderHistory[index].orderDate
                                      .toLocal()
                                      .toString()),
                              children: _getOrderedChildren(
                                  widget.orderHistory[index].orderedProduct
                                      .length,
                                  index));
                        }),
                  )
                : Center(child: Expanded(child: Text('No Order History'))),
          ],
        ),
      ),
    );
  }
}
