import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../model/cartInfo.dart';
import 'package:provide/provide.dart';
import '../../provide/cart.dart';


class CartCount extends StatelessWidget {
  var item;
  CartCount(this.item);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(165.0),
      margin: EdgeInsets.only(top: 5.0),
      decoration: BoxDecoration(
        border: Border.all(width: 1,color: Colors.black12)
      ),
      child: Row(
        children: <Widget>[
           _reduceBtn(context),
          _countArea(context),
          _addBtn(context)
        ],
      ),
    );
  }


  Widget _reduceBtn(BuildContext context){
    return InkWell(
      onTap: (){
        Provide.value<CartProvide>(context).changeGoodsCount(item, "del");
      },
      child: Container(
        width: ScreenUtil().setWidth(45.0),
        height: ScreenUtil().setHeight(45.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: item.count>1? Colors.white : Colors.black12,
          border: Border(
            right: BorderSide(width: 1,color: Colors.black12)
          )
        ),
        child: item.count>1?Text('-'):Text(' '),
      ),
    );
  }

  Widget _addBtn(BuildContext context){
    return InkWell(
      onTap: (){
        Provide.value<CartProvide>(context).changeGoodsCount(item, "add");
      },
      child: Container(
        width: ScreenUtil().setWidth(45.0),
        height: ScreenUtil().setHeight(45.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                left: BorderSide(width: 1,color: Colors.black12)
            )
        ),
        child: Text('+'),
      ),
    );
  }

  Widget _countArea(BuildContext context){
    return Container(
      width: ScreenUtil().setWidth(70.0),
      height: ScreenUtil().setHeight(45.0),
      alignment: Alignment.center,
      color: Colors.white,
      child: Text('${item.count}'),
    );
  }


}
