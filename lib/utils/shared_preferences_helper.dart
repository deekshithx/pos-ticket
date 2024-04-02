import 'dart:convert';

import 'package:pos_ticket/model/category_model.dart';
import 'package:pos_ticket/model/item_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static late SharedPreferences _prefs;
  static const String keyItemList = 'item_list';
  static const String keyCategoryList = 'category_list';

  static Future<bool> setCategoryList(List<Category> categoryList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> jsonList =
        categoryList.map((category) => jsonEncode(category.toJson())).toList();
    return await prefs.setStringList(keyCategoryList, jsonList);
  }

  static Future<List<Category>> getCategoryList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? jsonList = prefs.getStringList(keyCategoryList);
    if (jsonList != null) {
      return jsonList.map((jsonCategory) {
        Map<String, dynamic> map = jsonDecode(jsonCategory);
        return Category.fromJson(map);
      }).toList();
    } else {
      return [];
    }
  }

  static Future<bool> setItemList(List<ItemModel> itemList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> jsonList =
        itemList.map((item) => jsonEncode(item.toJson())).toList();
    return await prefs.setStringList(keyItemList, jsonList);
  }

  static Future<List<ItemModel>> getItemList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? jsonList = prefs.getStringList(keyItemList);
    if (jsonList != null) {
      return jsonList.map((jsonItem) {
        Map<String, dynamic> map = jsonDecode(jsonItem);
        return ItemModel.fromJson(map);
      }).toList();
    } else {
      return [];
    }
  }

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<bool> setString(String key, String value) async {
    return _prefs.setString(key, value);
  }

  static Future<String?> getString(String key) async {
    return _prefs.getString(key);
  }

  static Future<bool> setInt(String key, int value) async {
    return _prefs.setInt(key, value);
  }

  static Future<int?> getInt(String key) async {
    return _prefs.getInt(key);
  }

  static Future<bool> setDouble(String key, double value) async {
    return _prefs.setDouble(key, value);
  }

  static Future<double?> getDouble(String key) async {
    return _prefs.getDouble(key);
  }

  static Future<bool> setBool(String key, bool value) async {
    return _prefs.setBool(key, value);
  }

  static Future<bool?> getBool(String key) async {
    return _prefs.getBool(key);
  }

  static Future<bool> containsKey(String key) async {
    return _prefs.containsKey(key);
  }

  static Future<bool> remove(String key) async {
    return _prefs.remove(key);
  }

  static Future<bool> clear() async {
    return _prefs.clear();
  }
}
