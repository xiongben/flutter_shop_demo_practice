import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../service/service_method.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String homePageContent = "getting data now...";
  @override
  void initState() { 
    getHomePageContent().then((val){
      setState((){
        homePageContent = val.toString();
      });
    });
    super.initState();
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
             return Column(
               children: <Widget>[
                 SwiperDiy(swiperDateList: swiper,),
                 TopNavigator(navigatorList: navgatorList,),
               ],
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
      height: ScreenUtil().setHeight(320),
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