import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import '../../provide/details_info.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailsTabbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provide<DetailsInfoProvide>(
      builder: (context,child,val) {
        var isLeft = Provide
            .value<DetailsInfoProvide>(context)
            .isLeft;
        var isRight = Provide
            .value<DetailsInfoProvide>(context)
            .isRight;

        return Container(
          margin: EdgeInsets.only(top: 15.0),
          child: _MyTabBar(context),
        );
      }
    );
  }


  Widget _MyTabBar(BuildContext context){
     return Row(
       children: <Widget>[
         _myTabBarLeft(context, true, '详情'),
         _myTabBarLeft(context, false, "评论"),
       ],
     );
  }

  Widget _myTabBarLeft(BuildContext context,bool isLeft,String descText){
    return InkWell(
      onTap: (){
        Provide.value<DetailsInfoProvide>(context).changeTab(isLeft);
      },
      child: Provide<DetailsInfoProvide>(
        builder: (context, child, data){
          var chooseItemIsLeft = Provide.value<DetailsInfoProvide>(context).isLeft;
          return Container(
            padding: EdgeInsets.all(10.0),
            alignment: Alignment.center,
            width: ScreenUtil().setWidth(375.0),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                    bottom: BorderSide(
                      width: 1.0,
                      color: isLeft == chooseItemIsLeft?Colors.pink:Colors.black12,
                    )
                )
            ),
            child: Text(
              descText,
              style: TextStyle(
                color: isLeft == chooseItemIsLeft?Colors.pink:Colors.black12,
              ),
            ),
          );
        },
      )

    );
  }
}
