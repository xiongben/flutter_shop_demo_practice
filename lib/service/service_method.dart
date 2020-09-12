import 'package:dio/dio.dart';
import 'dart:async';
import 'dart:io';
import '../config/service_url.dart';



Future getHomePageContent()async {
  try{
    Response response;
    Dio dio = new Dio();
    dio.options.contentType = ContentType.parse("application/x-www-form-urlencoded");
    var formData = {'lon':'115.02932','lat':'35.76189'};
    response = await dio.post(servicePath['homePageContent'],data: formData);
    if(response.statusCode == 200){
      return response.data;
    }else{
      throw Exception("wow,server have some error");
    }
  }
  catch(e){
    return print(e);
  }
  
}