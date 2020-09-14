import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../service/service_method.dart';
import '../model/category.dart';

import '../provide/child_category.dart';
import '../provide/caregory_goods_list.dart';
import '../model/categoryGoodsList.dart';


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
            LeftCategoryNav(),
            Column(
              children: <Widget>[
                RightCategoryNavState(),
                CategoryGoodsList(),
              ],
            ),
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
  var listIndex = 0;

  @override
  void initState() {
    _getCategory();
    _getGoodsList();
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
    bool isClick = false;
    isClick = (index == listIndex)?true:false;
    return InkWell(
      onTap: (){
        setState(() {
          listIndex = index;
        });
        var childList = list[index].bxMallSubDto;
        var categoryid= list[index].mallCategoryId;
        Provide.value<ChildCategory>(context).getChildCategory(childList, categoryid);
        _getGoodsList(categoryId: categoryid);
      },
      child: Container(
        height: ScreenUtil().setHeight(100),
        padding: EdgeInsets.only(left: 10.0, top: 20.0),
        decoration: BoxDecoration(
          color: isClick?Colors.black12 : Colors.white,
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
      Provide.value<ChildCategory>(context).getChildCategory(list[0].bxMallSubDto, list[0].mallCategoryId);
      // list.data.forEach((item)=>print(item.mallCategoryName));
    });
  }

  void _getGoodsList({String categoryId})async{
    var data = {
      'categoryId': categoryId==null?'4':categoryId,
      'CategorySubId': "",
      'page': 1
    };
    await request('getMallGoods',formData: data).then((val){
      var data = json.decode(val.toString());
      CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);
      Provide.value<CategoryGoodsListProvide>(context).getGoodsList(goodsList.data);
    });
  }
}

//二级导航，右边头部
class RightCategoryNavState extends StatefulWidget {
  @override
  _RightCategoryNavStateState createState() => _RightCategoryNavStateState();
}

class _RightCategoryNavStateState extends State<RightCategoryNavState> {

  // List list = ["二锅头","二锅头","二锅头","二锅头","二锅头","二锅头","二锅头","二锅头","二锅头"];


  @override
  Widget build(BuildContext context) {
    return Provide<ChildCategory>(
      builder: (context, child, childCategory){
        return Container(
          height: ScreenUtil().setHeight(80),
          width: ScreenUtil().setWidth(570),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  bottom: BorderSide(width: 1,color: Colors.black12)
              )
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: childCategory.childCategoryList.length,
            itemBuilder: (context, index){
              return _rightInkWell(index,childCategory.childCategoryList[index]);
            },
          ),
        );
      },
    );

  }

  Widget _rightInkWell(int index,BxMallSubDto item){
    bool isClick = false;
    isClick = (index==Provide.value<ChildCategory>(context).childIndex)?true:false;
    return InkWell(
      onTap: (){
        Provide.value<ChildCategory>(context).changeChildIndex(index,item.mallSubId);
        _getGoodsList(item.mallSubId);
      },
      child: Container(
         padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
         child: Text(
           item.mallSubName,
           style: TextStyle(
               fontSize: ScreenUtil().setSp(28),
               color: isClick?Colors.pink:Colors.black
           ),
         ),
      ),
    );
  }

  void _getGoodsList(String categorySubId)async{
    String categoryId = Provide.value<ChildCategory>(context).categoryId;
    var data = {
      'categoryId': categoryId,
      'CategorySubId': categorySubId,
      'page': 1
    };
    await request('getMallGoods',formData: data).then((val){
      var data = json.decode(val.toString());
      CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);
      if(goodsList.data == null){
        Provide.value<CategoryGoodsListProvide>(context).getGoodsList([]);
      }else{
        Provide.value<CategoryGoodsListProvide>(context).getGoodsList(goodsList.data);
      }
    });
  }
}

//商品列表
class CategoryGoodsList extends StatefulWidget {
  @override
  _CategoryGoodsListState createState() => _CategoryGoodsListState();
}

class _CategoryGoodsListState extends State<CategoryGoodsList> {

  GlobalKey<RefreshFooterState> _footerkey = new GlobalKey<RefreshFooterState>();
  var scrollController = new ScrollController();

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Provide<CategoryGoodsListProvide>(
      builder: (context,child,data){
        try{
          if(Provide.value<ChildCategory>(context).page == 1){
            //列表位置回到滑动顶部
            scrollController.jumpTo(0.0);
          }
        }catch(e){
          print("进入页面第一次初始化：${e}");
        }
        if(data.goodsList.length > 0){
          return Expanded(
            child: Container(
              width: ScreenUtil().setWidth(570),
              child: EasyRefresh(
                refreshFooter: ClassicsFooter(
                  key: _footerkey,
                  textColor: Colors.pink,
                  bgColor: Colors.white,
                  moreInfoColor: Colors.pink,
                  showMore: true,
                  noMoreText: Provide.value<ChildCategory>(context).noMoreText,
                  moreInfo: "加载中",
                  loadReadyText: "上拉加载",
                ),
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: data.goodsList.length,
                  itemBuilder: (context,index){
                    return _listWidget(data.goodsList,index);
                  },
                ),
                loadMore: (){
                  _getMoreGoodsList();
                },
              ),

            ),
          );
        }else{
          return Text("暂时没有数据");
        }
      },
    );
  }

  void _getMoreGoodsList()async{
    Provide.value<ChildCategory>(context).addPage();
    var data = {
      'categoryId': Provide.value<ChildCategory>(context).categoryId,
      'CategorySubId': Provide.value<ChildCategory>(context).subId,
      'page': Provide.value<ChildCategory>(context).page,
    };
    await request('getMallGoods',formData: data).then((val){
      var data = json.decode(val.toString());
      CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);
      if(goodsList.data == null){
        Fluttertoast.showToast(
          msg: "已经到底了",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.pink,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Provide.value<ChildCategory>(context).changeNoMore("没有更多的数据了");
      }else{
        Provide.value<CategoryGoodsListProvide>(context).getMoreGoodsList(goodsList.data);
      }
    });
  }



  Widget _goodsImage(List newList,index){
    return Container(
      width: ScreenUtil().setWidth(200.0),
      child: Image.network(newList[index].image),
    );
  }

  Widget _goodsName(List newList,index){
    return Container(
      padding: EdgeInsets.all(5.0),
      width: ScreenUtil().setWidth(200.0),
      child: Text(
        newList[index].goodsName,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: ScreenUtil().setSp(28.0)),
      ),
    );
  }

  Widget _goodsPrice(List newList,index){
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      width: ScreenUtil().setWidth(300.0),
      child: Row(
        children: <Widget>[
          Text(
            'Price: \$ ${newList[index].presentPrice}',
            style: TextStyle(fontSize: ScreenUtil().setSp(20.0),color: Colors.pink),
          ),
          Text(
            'Price: \$ ${newList[index].oriPrice}',
            style: TextStyle(fontSize: ScreenUtil().setSp(20.0),color: Colors.black26,decoration: TextDecoration.lineThrough),
          ),
        ],
      )
    );
  }

  Widget _listWidget(List newList,index){
    return InkWell(
      onTap: (){},
      child: Container(
        padding: EdgeInsets.only(top:5.0, bottom: 5.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom:  BorderSide(width: 1.0,color: Colors.black12),
          )
        ),
        child: Row(
          children: <Widget>[
            _goodsImage(newList,index),
            Column(
              children: <Widget>[
                _goodsName(newList,index),
                _goodsPrice(newList,index),
              ],
            )
          ],
        ),
      ),
    );
  }


}
