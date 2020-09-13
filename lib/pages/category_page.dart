import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../service/service_method.dart';
import '../model/category.dart';


class CategoryPage extends StatefulWidget {
  CategoryPage({Key key}) : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text('商品分类'),),
      body: Container(
        child: Row(
          children: <Widget>[
            LeftCategoryNav()
          ],
        ),
      ),
    );
  }


}


class LeftCategoryNav extends StatefulWidget {
  @override
  _LeftCategoryNavState createState() => _LeftCategoryNavState();
}

class _LeftCategoryNavState extends State<LeftCategoryNav> {

  List list= [];

  @override
  void initState() {
    _getCategory();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(180),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(width: 1,color: Colors.black12)
        )
      ),
      child: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index){
          return _leftInkWell(index);
        },
      ),
    );
  }
  
  Widget _leftInkWell(int index){
    return InkWell(
      onTap: (){},
      child: Container(
        height: ScreenUtil().setHeight(100),
        padding: EdgeInsets.only(left: 10.0, top: 20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(width: 1, color: Colors.black12)
          )
        ),
        child: Text(list[index].mallCategoryName),
      ),
    );
  }

  void _getCategory() async {
    await request('getCategory').then((val){
      var data = json.decode(val.toString());
      CategoryBigListModel reslist = CategoryBigListModel.fromJson(data['data']);
      setState(() {
        list = reslist.data;
      });
      // list.data.forEach((item)=>print(item.mallCategoryName));
    });
  }
}
