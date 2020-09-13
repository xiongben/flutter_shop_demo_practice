import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:provide/provide.dart';
import '../provide/count.dart';


class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Number(),
            Mybutton(),
          ],
        ),
        ),
    );
  }
}


class Number extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 200.0),
      child: Provide<Counter>(
        builder: (context, child, counter){

          return Text('${counter.value}');
        },
      ),
    );
  }
}

class Mybutton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: RaisedButton(
        onPressed: (){
          Provide.value<Counter>(context).increment();
        },
        child: Text("add"),
      ),
    );
  }
}
