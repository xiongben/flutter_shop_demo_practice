import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../service/service_method.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {

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
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("human life+"),),
      body: FutureBuilder(
        future: getHomePageContent(),
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
             
             return SingleChildScrollView(
               child: Column(
                 children: <Widget>[
                 SwiperDiy(swiperDateList: swiper,),
                 TopNavigator(navigatorList: navgatorList,),
                 AdBanner(adPicture: adPicture,),
                 LeaderPhone(leaderImage: leaderImage, leaderPhone: leaderPhone),
                 Recommend(recommendList: recommendList),
               ],
               ),
             );
          }else{
            return Center(child: Text("loading...",),);
          }
        },
      ),
    );

  }
}

class SwiperDiy extends StatelessWidget {
  final List swiperDateList;
  const SwiperDiy({Key key,this.swiperDateList}) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    print('设备像素密度:${ScreenUtil.pixelRatio}');
    print('设备高:${ScreenUtil.screenHeight}');
    print('设备宽:${ScreenUtil.screenWidth}');
    return Container(
      height: ScreenUtil().setHeight(333),
      width: ScreenUtil().setWidth(750),
      child: Swiper(
        itemBuilder: (BuildContext context, int index){
          return Image.network("${swiperDateList[index]['image']}",fit: BoxFit.fill,);
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
      height: ScreenUtil().setHeight(270),
      padding: EdgeInsets.all(3.0),
      child: GridView.count(
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
      onTap: (){},
      child: Container(
        height: ScreenUtil().setHeight(330),
        width: ScreenUtil().setWidth(250),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
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
      height: ScreenUtil().setHeight(330),
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
      height: ScreenUtil().setHeight(380),
      margin: EdgeInsets.only(top:10.0),
      child: Column(  
        children: <Widget>[
          _titleWidget(context),
          _recommendList(context)
        ],
      ),
    );
  }
}




