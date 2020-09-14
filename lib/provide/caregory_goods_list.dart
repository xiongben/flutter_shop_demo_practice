import 'package:flutter/material.dart';
import '../model/categoryGoodsList.dart';



class CategoryGoodsListProvide with ChangeNotifier{
  List<CategoryListData> goodsList = [];

  getGoodsList(List<CategoryListData> list){
    goodsList = list;
    notifyListeners();
  }

  getMoreGoodsList(List<CategoryListData> list){
    goodsList.addAll(list);
    notifyListeners();
  }
}