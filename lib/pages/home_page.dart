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
             return Column(
               children: <Widget>[
                 SwiperDiy(swiperDateList: swiper,)
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
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
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