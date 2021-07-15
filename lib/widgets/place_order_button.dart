import 'package:cartapp/models/products.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlaceOrderButton extends StatefulWidget {
  Function(String itemId, String itemCategory) onCountChange;
  int itemCount;
  bool isDisabled = false;
  Function(int quantity) onItemSelect;

  PlaceOrderButton(
      this.onCountChange, this.itemCount, this.isDisabled, this.onItemSelect);

  @override
  _PlaceOrderButtonState createState() => _PlaceOrderButtonState();
}

class _PlaceOrderButtonState extends State<PlaceOrderButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.itemCount != 0
          ? ButtonTheme(
              disabledColor: Colors.orange[100],
              child: Container(
                height: 30,
                width: 130,
                margin: const EdgeInsets.all(15.0),
                padding: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(width: 2, color: Colors.orange)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                        color: Colors.orange,
                        icon: Icon(
                          Icons.remove,
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                        iconSize: 15,
                        onPressed: () {
                          widget.onItemSelect(-1);
                        }),
                    Padding(
                      padding: const EdgeInsets.all(0),
                      child: CircleAvatar(
                        backgroundColor: Colors.orange,
                        child: Text(
                          '${widget.itemCount}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      color: Colors.orange,
                      icon: Icon(
                        Icons.add,
                      ),
                      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                      iconSize: 15,
                      onPressed: widget.isDisabled
                          ? null
                          : () {
                              widget.onItemSelect(1);
                            },
                    ),
                  ],
                ),
              ),
            )
          : OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                side: BorderSide(width: 2, color: Colors.orange),
              ),
              onPressed: widget.isDisabled
                  ? null
                  : () {
                      widget.onItemSelect(1);
                    },
              child: Text(
                'Add',
                style: TextStyle(color: Colors.orange),
              ),
            ),
    );
  }
}
