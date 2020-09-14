import 'package:flutter/material.dart';
import '../model/category.dart';



class ChildCategory with ChangeNotifier{
  List<BxMallSubDto> childCategoryList = [];
  int childIndex = 0; //子类高亮索引
  String categoryId = '4'; //大类的id
  String subId = ''; //小类
  int page = 1;
  String noMoreText = ''; //显示没有数据的

  getChildCategory(List<BxMallSubDto> list, String id){
    page = 1;
    noMoreText = "";
    childIndex = 0;
    categoryId = id;
    BxMallSubDto all = BxMallSubDto();
    all.mallSubId = "00";
    all.mallCategoryId = "00";
    all.comments = 'null';
    all.mallSubName= "全部";
    childCategoryList = [all];
    childCategoryList.addAll(list);
    notifyListeners();
  }

  changeChildIndex(index, String id){
    page = 1;
    noMoreText = "";
    childIndex = index;
    subId = id;
    notifyListeners();
  }

  addPage(){
    page++;
  }

  changeNoMore(String text){
    noMoreText = text;
    notifyListeners();
  }
}