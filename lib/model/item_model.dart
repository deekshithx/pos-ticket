import 'dart:convert';
import 'dart:typed_data';

import 'package:pos_ticket/model/category_model.dart';

class ItemModel {
  const ItemModel({
    required this.name,
    required this.nameInLocale,
    required this.price,
    required this.imageBytes,
    this.category,
  });

  final String name;
  final String nameInLocale;
  final double price;
  final Uint8List imageBytes;
  final Category? category;

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    Uint8List bytes = base64.decode(json['image'] as String);
    return ItemModel(
      name: json['name'] as String,
      nameInLocale: json['nameInLocale'] as String,
      price: (json['price'] as num).toDouble(),
      imageBytes: bytes,
      category: json['category'] != null
          ? Category.fromJson(json['category'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    String base64Image = base64Encode(imageBytes);
    return {
      'name': name,
      'nameInLocale': nameInLocale,
      'price': price,
      'image': base64Image,
      'category': category?.toJson(),
    };
  }

  @override
  String toString() {
    return 'ItemModel(name: $name, nameInLocale: $nameInLocale, price: $price, imageBytes: $imageBytes, category: $category)';
  }
}
