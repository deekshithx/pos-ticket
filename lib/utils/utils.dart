import 'package:pos_ticket/model/item_model.dart';
import 'package:flutter/material.dart';

Future showSnack(
  BuildContext context,
  String message, {
  Duration duration = const Duration(seconds: 3),
}) async {
  await new Future.delayed(new Duration(milliseconds: 100));
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      duration: duration,
    ),
  );
}

String getTotalQty(Map<ItemModel, int> selectedItems) {
  double total = 0;

  selectedItems.forEach((key, value) {
    total = total + value;
  });
  return total.toInt().toString();
}

String getTotal(Map<ItemModel, int> selectedItems) {
  double total = 0;

  selectedItems.forEach((key, value) {
    total = total + (key.price * value);
  });
  return total.toInt().toString();
}
