import 'package:blue_thermal_printer_example/model/item_model.dart';
import 'package:blue_thermal_printer_example/printerenum.dart';
import 'package:blue_thermal_printer_example/utils/shared_preferences_helper.dart';
import 'package:blue_thermal_printer_example/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

///Test printing
class PosPrint {
  Future<bool> sample(BuildContext context,
      {required BlueThermalPrinter bluetooth,
      required Map<ItemModel, int> selectedItems}) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd-MMM-yy HH:mm').format(now);
    int prevInvoiceNumber =
        await SharedPreferencesHelper.getInt('invoice_number') ?? 0;
    await SharedPreferencesHelper.setInt(
        'invoice_number', prevInvoiceNumber + 1);

    // int total
    await SharedPreferencesHelper.setInt(
        'invoice_number', prevInvoiceNumber + 1);

    void divider() {
      bluetooth.printCustom('-----------------------------------------',
          PrintSize.medium.val, PrintAlign.center.val);
    }

    List<Future<dynamic>> itemsList() {
      return selectedItems.entries
          .map((e) => bluetooth.printLeftRight(
                e.key.name,
                '(${e.value} x ${e.key.price.toInt()}) = ${(e.value * e.key.price).toInt()}',
                PrintSize.bold.val,
              ))
          .toList();
    }

    return bluetooth.isConnected.then((isConnected) {
      if (isConnected == true) {
        // bluetooth.printNewLine();
        bluetooth.printCustom(
          "Ganesh Darshini",
          PrintSize.boldMedium.val,
          PrintAlign.center.val,
        );
        divider();
        bluetooth.printLeftRight(
          "No: ${prevInvoiceNumber + 1}",
          formattedDate,
          PrintSize.bold.val,
        );
        divider();
        itemsList();

        divider();
        bluetooth.printCustom("Total Qty: ${getTotalQty(selectedItems)}",
            PrintSize.bold.val, PrintAlign.left.val);
        divider();
        bluetooth.printCustom("Total  ${getTotal(selectedItems)}",
            PrintSize.extraLarge.val, PrintAlign.right.val);
        divider();
        bluetooth.printCustom(
          "Thank you for ordering!",
          PrintSize.bold.val,
          PrintAlign.center.val,
        );
        bluetooth.printNewLine();
        bluetooth.printNewLine();
        bluetooth.printNewLine();
        return true;
      } else {
        showSnack(context, 'Printer not connected');
        return false;
      }
    });
  }
}

//image max 300px X 300px

///image from File path
// String filename = 'yourlogo.png';
// ByteData bytesData = await rootBundle.load("assets/images/yourlogo.png");
// String dir = (await getApplicationDocumentsDirectory()).path;
// File file = await File('$dir/$filename').writeAsBytes(bytesData.buffer
//     .asUint8List(bytesData.offsetInBytes, bytesData.lengthInBytes));

// ///image from Asset
// ByteData bytesAsset = await rootBundle.load("assets/images/yourlogo.png");
// Uint8List imageBytesFromAsset = bytesAsset.buffer
//     .asUint8List(bytesAsset.offsetInBytes, bytesAsset.lengthInBytes);

// ///image from Network
// var response = await http.get(Uri.parse(
//     "https://raw.githubusercontent.com/kakzaki/blue_thermal_printer/master/example/assets/images/yourlogo.png"));
// Uint8List bytesNetwork = response.bodyBytes;
// Uint8List imageBytesFromNetwork = bytesNetwork.buffer
//     .asUint8List(bytesNetwork.offsetInBytes, bytesNetwork.lengthInBytes);
