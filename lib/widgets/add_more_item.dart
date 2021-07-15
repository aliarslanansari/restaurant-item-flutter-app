import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddMoreItem extends StatelessWidget {
  Function(int ind) onPlaceOrderClick;
  AddMoreItem(this.onPlaceOrderClick, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
        child: FlatButton(
          height: 50,
          onPressed: () {
            onPlaceOrderClick(0);
          },
          child: Row(
            children: [
              Expanded(
                  child: Align(
                      alignment: Alignment.center,
                      child: Text('Add More Items'))),
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
