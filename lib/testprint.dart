import 'package:pos_ticket/model/item_model.dart';
import 'package:pos_ticket/printerenum.dart';
import 'package:pos_ticket/utils/shared_preferences_helper.dart';
import 'package:pos_ticket/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';

///Test printing
class PosPrint {
  Future<bool> sample(BuildContext context,
      {required BlueThermalPrinter bluetooth,
      required Map<ItemModel, int> selectedItems}) async {
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

    return bluetooth.isConnected.then((isConnected) async {
      if (isConnected == true) {
        String formattedDate =
            DateFormat('dd-MMM-yy HH:mm').format(DateTime.now());
        int prevInvoiceNumber =
            await SharedPreferencesHelper.getInt('invoice_number') ?? 0;
        await SharedPreferencesHelper.setInt(
            'invoice_number_$formattedDate', prevInvoiceNumber + 1);
        await SharedPreferencesHelper.setInt(
            'invoice_number_$formattedDate', prevInvoiceNumber + 1);
        String todayDate = DateFormat('dd-MMM-yy').format(DateTime.now());
        int totalIncome = await SharedPreferencesHelper.getInt(todayDate) ?? 0;
        await SharedPreferencesHelper.setInt(
            todayDate, totalIncome + int.parse(getTotal(selectedItems)));
        await SharedPreferencesHelper.setInt(
            'last_ticket_$todayDate', int.parse(getTotal(selectedItems)));

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
        bluetooth.printNewLine();
        itemsList();
        bluetooth.printNewLine();

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
        // FirebaseHelper().set();
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
