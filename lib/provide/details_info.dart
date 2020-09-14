import 'package:flutter/material.dart';
import 'dart:convert';
import '../model/details.dart';
import '../service/service_method.dart';



class DetailsInfoProvide with ChangeNotifier{
  DetailsModel goodsInfo = null;

  //从后台获取商品数据
  getGoodsInfo(String id){
    var formData = {'goodId': id};
    request('getGoodDetailById',formData: formData).then((val){
      var resData = json.decode(val.toString());
      goodsInfo = DetailsModel.fromJson(resData);
      notifyListeners();
    });
  }


}