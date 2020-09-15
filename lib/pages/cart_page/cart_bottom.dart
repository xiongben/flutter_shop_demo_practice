import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../model/cartInfo.dart';
import 'package:provide/provide.dart';
import '../../provide/cart.dart';

class CartBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.all(5.0),
      color: Colors.white,
      child: Provide<CartProvide>(
          builder: (context,child,val){
            return Row(
              children: <Widget>[
                _selectAllBottom(context),
                _allPriceArea(context),
                _goBottom(context),
              ],
            );
          }
      ),
    );
  }

  Widget _selectAllBottom(BuildContext context){
    bool isAllCheck = Provide.value<CartProvide>(context).isAllCheck;
    return Container(
      child: Row(
        children: <Widget>[
          Checkbox(
            value: isAllCheck,
            activeColor: Colors.pink,
            onChanged: (bool val){
              Provide.value<CartProvide>(context).changeAllCheckBtnStatus(val);
            },
          ),
          Text(
            "全选"
          )
        ],
      ),
    );
  }

  Widget _allPriceArea(BuildContext context){
    double totalprice = Provide.value<CartProvide>(context).allPrice;
    return Container(
      width: ScreenUtil().setWidth(430.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                alignment: Alignment.centerRight,
                width: ScreenUtil().setWidth(280),
                child: Text(
                  "合计: ",
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(36.0)
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                width: ScreenUtil().setWidth(150),
                child: Text(
                  "\$ ${totalprice}",
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(36.0),
                    color: Colors.pink,
                  ),
                ),
              ),
            ],
          ),
          Container(
            width: ScreenUtil().setWidth(430.0),
            alignment: Alignment.centerRight,
            child: Text(
              '满10元免配送费，预购免配送费',
              style: TextStyle(
                color: Colors.black38,
                fontSize: ScreenUtil().setSp(22),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _goBottom(BuildContext context){
    int  allGoodsCount = Provide.value<CartProvide>(context).allGoodsCount;
    return Container(
      width: ScreenUtil().setWidth(160.0),
      padding: EdgeInsets.only(left: 10.0),
      child: InkWell(
        onTap: (){},
        child: Container(
          padding: EdgeInsets.all(10.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(3.0),
          ),
          child: Text(
            '结算(${allGoodsCount})',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
