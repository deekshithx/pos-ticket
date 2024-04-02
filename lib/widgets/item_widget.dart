import 'package:pos_ticket/model/item_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ItemWidget extends StatelessWidget {
  const ItemWidget(
      {super.key, required this.item, this.onTap, this.selectedCount = 0});
  final ItemModel item;
  final int selectedCount;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 3),
          decoration: BoxDecoration(
              color: selectedCount > 0 ? Colors.green : Colors.green[50],
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                  color: Colors.green[200]!, width: selectedCount > 0 ? 3 : 1)),
          child: Stack(alignment: Alignment.topCenter, children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  foregroundDecoration: selectedCount > 0
                      ? BoxDecoration(color: Color.fromARGB(117, 151, 151, 151))
                      : null,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.memory(
                      item.imageBytes,
                      width: 180,
                      height: 120,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                SizedBox(
                  width: 180,
                  child: Text(
                    item.nameInLocale + '',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                Text(item.name),
              ],
            ),
            if (selectedCount > 0)
              Stack(
                children: <Widget>[
                  // Stroked text as border.
                  Text(
                    selectedCount.toString(),
                    style: TextStyle(
                      fontSize: 45,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 3
                        ..color = Colors.white,
                    ),
                  ),
                  // Solid text as fill.
                  Text(
                    selectedCount.toString(),
                    style: TextStyle(
                      fontSize: 45,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
          ]),
        ));
  }
}
