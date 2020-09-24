import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import '../service/service_method.dart';
import '../routers/application.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  int page = 1;
  List<Map> hotGoodsList = [];

  GlobalKey<RefreshFooterState> _footerkey = new GlobalKey<RefreshFooterState>();

  @override
  bool get wantKeepAlive => true;

  

  String homePageContent = "getting data now...";
  @override
  void initState() { 
    // getHomePageContent().then((val){
    //   setState((){
    //     homePageContent = val.toString();
    //   });
    // });
    
    super.initState();
    print("===homepage===");
    // _getHotGoods();
  }
  @override
  Widget build(BuildContext context) {
    var formDataParams = {'lon':'115.02932','lat':'35.76189'};
    return Scaffold(
      appBar: AppBar(title: Text("human life+"),),
      body: FutureBuilder(
        future: request('homePageContent',formData: formDataParams),
        // initialData: InitialData,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
             var data = json.decode(snapshot.data.toString());
             List<Map> swiper = (data['data']['slides'] as List).cast();
             List<Map> navgatorList = (data['data']['category'] as List).cast();
             String adPicture = data['data']['advertesPicture']['PICTURE_ADDRESS'];
             String leaderImage = data['data']['shopInfo']['leaderImage'];
             String leaderPhone = data['data']['shopInfo']['leaderPhone'];
             List<Map> recommendList = (data['data']['recommend'] as List).cast();
            String floor1Title = data['data']['floor1Pic']['PICTURE_ADDRESS'];
            String floor2Title = data['data']['floor2Pic']['PICTURE_ADDRESS'];
            String floor3Title = data['data']['floor3Pic']['PICTURE_ADDRESS'];
             List<Map> floorGoodsList1 = (data['data']['floor1'] as List).cast();
             List<Map> floorGoodsList2 = (data['data']['floor2'] as List).cast();
             List<Map> floorGoodsList3 = (data['data']['floor3'] as List).cast();
             
             return EasyRefresh(
               refreshFooter: ClassicsFooter(
                 key: _footerkey,
                 textColor: Colors.pink,
                 bgColor: Colors.white,
                 moreInfoColor: Colors.pink,
                 showMore: true,
                 noMoreText: "",
                 moreInfo: "加载中",
                 loadReadyText: "上拉加载",
               ),
               child: ListView(
                   children: <Widget>[
                     SwiperDiy(swiperDateList: swiper,),
                     TopNavigator(navigatorList: navgatorList,),
                     AdBanner(adPicture: adPicture,),
                     LeaderPhone(leaderImage: leaderImage, leaderPhone: leaderPhone),
                     Recommend(recommendList: recommendList),
                     FloorTitle(picture_address: floor1Title,),
                     FloorContent(floorGoodsList: floorGoodsList1,),
                     FloorTitle(picture_address: floor2Title,),
                     FloorContent(floorGoodsList: floorGoodsList2,),
                     FloorTitle(picture_address: floor3Title,),
                     FloorContent(floorGoodsList: floorGoodsList3,),
                     _hotGoods(),
                   ],
                 ),
               loadMore: ()async{
                 print("加载更多");
                 var formData = {'page': page};
                 await request('homePageBelowConten',formData: formData).then((val){
                   var data = json.decode(val.toString());
                   if(data['data'] != null){
                     List<Map> newGoodsList = (data['data'] as List).cast();
                     setState(() {
                       hotGoodsList.addAll(newGoodsList);
                       page++;
                     });
                   }
                 });
               },
             );
          }else{
            return Center(child: Text("loading...",),);
          }
        },
      ),
    );

  }
  
  void _getHotGoods(){
    var formData = {'page': page};
    request('homePageBelowConten',formData: formData).then((val){
      var data = json.decode(val.toString());
      List<Map> newGoodsList = (data['data'] as List).cast();
      setState(() {
        hotGoodsList.addAll(newGoodsList);
        page++;
      });
    });
  }

  Widget hotTitle = Container(
    margin: EdgeInsets.only(top: 10.0),
    padding: EdgeInsets.all(5.0),
    alignment: Alignment.center,
    color: Colors.transparent,
    child: Text('火爆专区'),
  );

  Widget _wrapList(){
    if(hotGoodsList.length != 0){
      List<Widget> listWidget = hotGoodsList.map((val){
        return InkWell(
          onTap: (){
            Application.router.navigateTo(context, '/detail?id=${val['goodsId']}');
          },
          child: Container(
            width: ScreenUtil().setWidth(372),
            color: Colors.white,
            padding: EdgeInsets.all(5.0),
            margin: EdgeInsets.only(bottom: 3.0),
            child: Column(
              children: <Widget>[
                Image.network(val['image'],width: ScreenUtil().setWidth(370),),
                Text(
                  val['name'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.pink,fontSize: ScreenUtil().setSp(26.0)),
                ),
                Row(
                  children: <Widget>[
                    Text('\$ ${val['mallPrice']}'),
                    Text(
                        '\$ ${val['price']}',
                        style: TextStyle(color: Colors.black26,decoration: TextDecoration.lineThrough),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      }).toList();

      return Wrap(
        spacing: 2,
        children: listWidget,
      );
    }else{
      return Text("");
    }
  }

  Widget _hotGoods(){
    return Container(
      child: Column(
        children: <Widget>[
          hotTitle,
          _wrapList()
        ],
      ),
    );
  }
  
}

class SwiperDiy extends StatelessWidget {
  final List swiperDateList;
  const SwiperDiy({Key key,this.swiperDateList}) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    // print('设备像素密度:${ScreenUtil.pixelRatio}');
    // print('设备高:${ScreenUtil.screenHeight}');
    // print('设备宽:${ScreenUtil.screenWidth}');
    return Container(
      height: ScreenUtil().setHeight(333),
      width: ScreenUtil().setWidth(750),
      child: Swiper(
        itemBuilder: (BuildContext context, int index){
          return InkWell(
            onTap: (){
                Application.router.navigateTo(context, "/detail?id=${swiperDateList[index]['goodsId']}");
            },
            child: Image.network("${swiperDateList[index]['image']}",fit: BoxFit.fill,),
          );
        },
        itemCount: swiperDateList.length,
        pagination: SwiperPagination(),
        autoplay: true,
      ),
    );
  }
}

class TopNavigator extends StatelessWidget {
  final List navigatorList;
  const TopNavigator({Key key, this.navigatorList}) : super(key: key);

 
  Widget _gridViewItemUI(BuildContext context, item) {
    return InkWell( 
      onTap: (){print("click the nav");},
      child: Column(
        children: <Widget>[
          Image.network(item['image'],width: ScreenUtil().setWidth(95),),
          Text(item["mallCategoryName"]),
        ],
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (this.navigatorList.length > 10){
      this.navigatorList.removeRange(10, this.navigatorList.length);
    }
    return Container(
      height: ScreenUtil().setHeight(320),
      padding: EdgeInsets.all(3.0),
      child: GridView.count(
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 5,
        padding: EdgeInsets.all(5.0),
        children: navigatorList.map((item){
           return _gridViewItemUI(context, item);
        }).toList(),
      ),
    );
  }
}

class AdBanner extends StatelessWidget {
  final String adPicture;
  const AdBanner({Key key, this.adPicture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(adPicture),
    );
  }
}

class LeaderPhone extends StatelessWidget {
  final String leaderImage;
  final String leaderPhone;
  const LeaderPhone({Key key,this.leaderImage, this.leaderPhone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell( 
        onTap: _launchURL,
        child: Image.network(leaderImage),
      ),
    );
  }

  void _launchURL() async{
    String url = "https://flutter.dev";
    if (await canLaunch(url)){
      await launch(url);
    }else {
      throw 'url can not load';
    }
  }
}


class Recommend extends StatelessWidget {
  final List recommendList;
  const Recommend({Key key, this.recommendList}) : super(key: key);

  
  Widget _titleWidget(BuildContext context) {
    return Container( 
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(10.0, 2.0, 0, 5.0),
      decoration: BoxDecoration( 
        color: Colors.white,
        border: Border( 
          bottom: BorderSide(width: 0.5,color: Colors.black12)
        ),
      ),
      child: Text(
        '商品推荐',
        style: TextStyle(color: Colors.pink)
      ),
    );
  }

  
  Widget _item(BuildContext context, index) {
    return InkWell(
      onTap: (){
        Application.router.navigateTo(context, "/detail?id=${recommendList[index]['goodsId']}");
      },
      child: Container(
        height: ScreenUtil().setHeight(330),
        width: ScreenUtil().setWidth(250),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.pink,
          border: Border( 
            left: BorderSide(width: 1, color: Colors.black12)
          )
        ),
        child: Column(
          children: <Widget>[
            Image.network(recommendList[index]['image']),
            Text(
              '\$ ${recommendList[index]['price']}',
              style: TextStyle(
                decoration: TextDecoration.lineThrough,
                color: Colors.grey,
              ),
            ),
            Text(
              '\$ ${recommendList[index]['mallPrice']}',
              style: TextStyle(
                color: Colors.grey,
              ),
            )
          ],
          ),
      ),
    );
  }

  //横向列表
  Widget _recommendList(BuildContext context) {
    
    return Container(  
      height: ScreenUtil().setHeight(370),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recommendList.length,
        itemBuilder: (context, index){
          return _item(context, index);
        }
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(440),
      margin: EdgeInsets.only(top:10.0),
      decoration: BoxDecoration(
        color: Colors.yellow,
      ),
      child: Column(  
        children: <Widget>[
          _titleWidget(context),
          _recommendList(context)
        ],
      ),
    );
  }
}

class FloorTitle extends StatelessWidget {
  final String picture_address;
  const FloorTitle({Key key, this.picture_address}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Image.network(picture_address),
    );
  }
}

//楼层商品列表
class FloorContent extends StatelessWidget {
  final List floorGoodsList;
  const FloorContent({Key key, this.floorGoodsList}) : super(key: key);

  Widget _goodsRow(BuildContext context) {
    return Row(  
      children: <Widget>[
        _goodsItem(context,floorGoodsList[0]),
        Column(  
          children: <Widget>[
            _goodsItem(context,floorGoodsList[1]),
            _goodsItem(context,floorGoodsList[2]),
          ],
        )
      ],
    );
  }
  


  Widget _goodsItem(BuildContext context,Map goods) {
    return Container(  
      width: ScreenUtil().setWidth(375),
      // height: ScreenUtil().setHeight(200),
      // decoration: BoxDecoration(  
      //   color: Colors.blue,
      // ),
      child: InkWell(  
        onTap: (){
          Application.router.navigateTo(context, "/detail?id=${goods['goodsId']}");
        },
        child: Image.network(goods['image']),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(  
      //   color: Colors.yellow,
      // ),
      child: _goodsRow(context),
      margin: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
    );
  }
}



class HotGoods extends StatefulWidget {
  HotGoods({Key key}) : super(key: key);

  @override
  _HotGoodsState createState() => _HotGoodsState();
}

class _HotGoodsState extends State<HotGoods> {
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var page = 1;
    request('homePageBelowConten',formData: page).then((val){
      print(val);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
       child: Text("666666"),
    );
  }
}



























