import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


class CurrentIndexProvide with ChangeNotifier{
  int currentIndex = 0;

  changeIndex(int newIndex){
    currentIndex = newIndex;
    notifyListeners();
  }
}