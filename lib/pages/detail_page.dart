import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:provide/provide.dart';
import '../provide/details_info.dart';

import './detail_page/detail_top_area.dart';
import './detail_page/detail_explain.dart';
import './detail_page/details_tabbar.dart';
import './detail_page/details_web.dart';


class DetailsPage extends StatelessWidget {
  final String goodsId;

  DetailsPage(this.goodsId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: Text("商品详情页"),
      ),
      body: FutureBuilder(
        future: _getBackInfo(context),
        builder: (context, snapshot){
          if (snapshot.hasData){
            return Container(
              child: ListView(
                children: <Widget>[
                  DetailsTopArea(),
                  DetailsExplain(),
                  DetailsTabbar(),
                  DetailsWeb(),
                ],
              ),
            );
          }else{
            return Text("加载中，，，，");
          }
        },
      ),
    );
  }

  Future _getBackInfo(BuildContext context) async{
    await Provide.value<DetailsInfoProvide>(context).getGoodsInfo(goodsId);
    return "加载完成";
  }
}
