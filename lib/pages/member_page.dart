import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MemberPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Member page"),
      ),
      body: Container(
        width: ScreenUtil().setWidth(750),
        decoration: BoxDecoration(
          color: Colors.yellow,
        ),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: ScreenUtil().setWidth(100),
              height: ScreenUtil().setHeight(100),
              decoration: BoxDecoration(
                color: Colors.red,
              ),
              child: CircleAvatar(
                backgroundImage: NetworkImage("https://avatars1.githubusercontent.com/u/20514794?s=400&u=c10939ae57149de301bbca7c86744106fa8b44ee&v=4"),
              ),
            ),
            Container(
              width: ScreenUtil().setWidth(200),
              height: ScreenUtil().setHeight(200),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            Container(
              width: ScreenUtil().setWidth(500),
              height: ScreenUtil().setHeight(500),
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Colors.red,
                      width: ScreenUtil().setWidth(50),
                      height: ScreenUtil().setHeight(50),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      color: Colors.blue,
                      width: ScreenUtil().setWidth(50),
                      height: ScreenUtil().setHeight(50),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )

    );
  }
}