import 'package:flutter/material.dart';
import 'dart:convert';
import '../model/details.dart';
import '../service/service_method.dart';



class DetailsInfoProvide with ChangeNotifier{
  DetailsModel goodsInfo = null;
  bool isLeft = true;
  bool isRight = false;

  //从后台获取商品数据
  getGoodsInfo(String id) async{
    var formData = {'goodId': id};
    await request('getGoodDetailById',formData: formData).then((val){
      var resData = json.decode(val.toString());
      goodsInfo = DetailsModel.fromJson(resData);
      notifyListeners();
    });
  }

  changeTab(bool isLeftBtn){
    print(isLeftBtn);
    if(isLeftBtn){
      isLeft = true;
      isRight = false;
    }else{
      isLeft = false;
      isRight = true;
    }
    notifyListeners();
  }


}