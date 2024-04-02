import 'dart:ffi';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:pos_ticket/model/category_model.dart';
import 'package:pos_ticket/model/item_model.dart';
import 'package:pos_ticket/testprint.dart';
import 'package:pos_ticket/utils/shared_preferences_helper.dart';
import 'package:pos_ticket/utils/utils.dart';
import 'package:pos_ticket/widgets/item_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PosScreen extends StatefulWidget {
  const PosScreen({Key? key}) : super(key: key);

  @override
  State<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends State<PosScreen> {
  List<ItemModel> _itemList = [];
//  List<ItemModel> _selectedItemList = [];
  List<Category> _categoryList = [];
  Category selectedCategory = Category(name: '', nameInLocale: '', priority: 0);
  Map<ItemModel, int> _selectedItems = {};

  @override
  void initState() {
    setExistingItems();
    super.initState();
  }

  setExistingItems() async {
    List<ItemModel> retrievedItemList =
        await SharedPreferencesHelper.getItemList();
    List<Category> retrievedCategoryList =
        await SharedPreferencesHelper.getCategoryList();
    setState(() {
      _itemList.addAll(retrievedItemList);
      _categoryList.addAll(retrievedCategoryList);
      if (_categoryList.isNotEmpty) {
        selectedCategory = _categoryList.first;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey,
        body: SafeArea(
            child: Row(
          children: [
            Expanded(
                flex: 8,
                child: Scaffold(
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        width: double.infinity,
                        color: Colors.white,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: _categoryList
                                .map((category) => _itemTab(category: category))
                                .toList(),
                          ),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Wrap(
                              children: _itemList
                                  .map((e) => ItemWidget(
                                        item: e,
                                        selectedCount: _selectedItems[e] ?? 0,
                                        onTap: () {
                                          setState(() {
                                            _selectedItems[e] = _selectedItems
                                                    .containsKey(e)
                                                ? (_selectedItems[e] ?? 0) + 1
                                                : 1;
                                          });
                                        },
                                      ))
                                  .toList()),
                        ),
                      ),
                    ],
                  ),
                )),
            SizedBox(
              width: 5,
            ),
            Expanded(
                flex: 3,
                child: Scaffold(
                  body: _selectedItems.isEmpty
                      ? Center(
                          child: Text('No item selected'),
                        )
                      : SingleChildScrollView(
                          child: Column(
                              children: _selectedItems.entries.map((e) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 3),
                              child: ListTile(
                                onLongPress: () {
                                  setState(() {
                                    _selectedItems.remove(e.key);
                                  });
                                },
                                tileColor: Colors.green[50],
                                dense: true,
                                title: Text(
                                  e.key.nameInLocale,
                                  style: TextStyle(fontSize: 15),
                                ),
                                trailing: Text(
                                  'x ' + e.value.toString(),
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            );
                          }).toList()),
                        ),
                  bottomNavigationBar: GestureDetector(
                    onTap: () async {
                      if (_selectedItems.isEmpty) {
                        showSnack(context, 'Select item');
                        return;
                      }
                      bool result = await PosPrint().sample(context,
                          bluetooth: BlueThermalPrinter.instance,
                          selectedItems: _selectedItems);

                      if (result) {
                        setState(() {
                          _selectedItems.clear();
                        });
                      } else {}
                    },
                    child: Container(
                      height: 70,
                      color: _selectedItems.isEmpty
                          ? Colors.green[100]
                          : Colors.green,
                      child: Center(
                          child: RichText(
                        text: new TextSpan(
                          style: new TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            // new TextSpan(
                            //   text: 'Total ',
                            //   style: TextStyle(
                            //       color: Colors.white,
                            //       fontWeight: FontWeight.w700,
                            //       fontSize: 30),
                            // ),
                            new TextSpan(
                              text: getTotal(_selectedItems),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 40),
                            ),
                          ],
                        ),
                      )),
                    ),
                  ),
                ))
          ],
        )

            //   Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 8.0),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.start,
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Expanded(
            //           flex: 14,
            //           child: Column(
            //             children: [
            //               Container(
            //                 height: 80,
            //                 child: ListView(
            //                   scrollDirection: Axis.horizontal,
            //                   children: _categoryList
            //                       .map((category) => _itemTab(
            //                             category: category,
            //                           ))
            //                       .toList(),
            //                 ),
            //               ),
            //               Expanded(
            //                 child: GridView.count(
            //                   crossAxisCount: 4,
            //                   childAspectRatio: (1 / 1.2),
            //                   children: [
            //                     _item(
            //                       image: 'items/1.png',
            //                       title: 'Original Burger',
            //                       price: '\$5.99',
            //                       item: '11 item',
            //                     ),
            //                     _item(
            //                       image: 'items/2.png',
            //                       title: 'Double Burger',
            //                       price: '\$10.99',
            //                       item: '10 item',
            //                     ),
            //                     _item(
            //                       image: 'items/3.png',
            //                       title: 'Cheese Burger',
            //                       price: '\$6.99',
            //                       item: '7 item',
            //                     ),
            //                     _item(
            //                       image: 'items/4.png',
            //                       title: 'Double Cheese Burger',
            //                       price: '\$12.99',
            //                       item: '20 item',
            //                     ),
            //                     _item(
            //                       image: 'items/5.png',
            //                       title: 'Spicy Burger',
            //                       price: '\$7.39',
            //                       item: '12 item',
            //                     ),
            //                     _item(
            //                       image: 'items/6.png',
            //                       title: 'Special Black Burger',
            //                       price: '\$7.39',
            //                       item: '39 item',
            //                     ),
            //                     _item(
            //                       image: 'items/7.png',
            //                       title: 'Special Cheese Burger',
            //                       price: '\$8.00',
            //                       item: '2 item',
            //                     ),
            //                     _item(
            //                       image: 'items/8.png',
            //                       title: 'Jumbo Cheese Burger',
            //                       price: '\$15.99',
            //                       item: '2 item',
            //                     ),
            //                     _item(
            //                       image: 'items/9.png',
            //                       title: 'Spicy Burger',
            //                       price: '\$7.39',
            //                       item: '12 item',
            //                     ),
            //                     _item(
            //                       image: 'items/10.png',
            //                       title: 'Special Black Burger',
            //                       price: '\$7.39',
            //                       item: '39 item',
            //                     ),
            //                     _item(
            //                       image: 'items/11.png',
            //                       title: 'Special Cheese Burger',
            //                       price: '\$8.00',
            //                       item: '2 item',
            //                     ),
            //                     _item(
            //                       image: 'items/12.png',
            //                       title: 'Jumbo Cheese Burger',
            //                       price: '\$15.99',
            //                       item: '2 item',
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //         Expanded(flex: 1, child: Container()),
            //         Expanded(
            //           flex: 5,
            //           child: Column(
            //             children: [
            //               const SizedBox(height: 20),
            //               Expanded(
            //                 child: ListView(
            //                   children: [
            //                     _itemOrder(
            //                       image: 'items/1.png',
            //                       title: 'Orginal Burger',
            //                       qty: '2',
            //                       price: '\$5.99',
            //                     ),
            //                     _itemOrder(
            //                       image: 'items/2.png',
            //                       title: 'Double Burger',
            //                       qty: '3',
            //                       price: '\$10.99',
            //                     ),
            //                     _itemOrder(
            //                       image: 'items/6.png',
            //                       title: 'Special Black Burger',
            //                       qty: '2',
            //                       price: '\$8.00',
            //                     ),
            //                     _itemOrder(
            //                       image: 'items/4.png',
            //                       title: 'Special Cheese Burger',
            //                       qty: '2',
            //                       price: '\$12.99',
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //               Expanded(
            //                 child: Container(
            //                   padding: const EdgeInsets.all(20),
            //                   margin: const EdgeInsets.symmetric(vertical: 10),
            //                   decoration: BoxDecoration(
            //                     borderRadius: BorderRadius.circular(14),
            //                     color: const Color(0xff1f2029),
            //                   ),
            //                   child: Column(
            //                     children: [
            //                       Row(
            //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                         children: const [
            //                           Text(
            //                             'Sub Total',
            //                             style: TextStyle(
            //                                 fontWeight: FontWeight.bold,
            //                                 color: Colors.white),
            //                           ),
            //                           Text(
            //                             '\$40.32',
            //                             style: TextStyle(
            //                                 fontWeight: FontWeight.bold,
            //                                 color: Colors.white),
            //                           ),
            //                         ],
            //                       ),
            //                       const SizedBox(height: 20),
            //                       Row(
            //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                         children: const [
            //                           Text(
            //                             'Tax',
            //                             style: TextStyle(
            //                                 fontWeight: FontWeight.bold,
            //                                 color: Colors.white),
            //                           ),
            //                           Text(
            //                             '\$4.32',
            //                             style: TextStyle(
            //                                 fontWeight: FontWeight.bold,
            //                                 color: Colors.white),
            //                           ),
            //                         ],
            //                       ),
            //                       Container(
            //                         margin: const EdgeInsets.symmetric(vertical: 20),
            //                         height: 2,
            //                         width: double.infinity,
            //                         color: Colors.white,
            //                       ),
            //                       Row(
            //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                         children: const [
            //                           Text(
            //                             'Total',
            //                             style: TextStyle(
            //                                 fontWeight: FontWeight.bold,
            //                                 color: Colors.white),
            //                           ),
            //                           Text(
            //                             '\$44.64',
            //                             style: TextStyle(
            //                                 fontWeight: FontWeight.bold,
            //                                 color: Colors.white),
            //                           ),
            //                         ],
            //                       ),
            //                       const SizedBox(height: 30),
            //                       ElevatedButton(
            //                         style: ElevatedButton.styleFrom(
            //                           // backgroundColor: Colors.white,
            //                           backgroundColor: Colors.deepOrange,
            //                           padding:
            //                               const EdgeInsets.symmetric(vertical: 8),
            //                           shape: RoundedRectangleBorder(
            //                             borderRadius: BorderRadius.circular(8),
            //                           ),
            //                         ),
            //                         onPressed: () {},
            //                         child: Row(
            //                           mainAxisAlignment: MainAxisAlignment.center,
            //                           children: const [
            //                             Icon(Icons.print, size: 16),
            //                             SizedBox(width: 6),
            //                             Text('Print Bills')
            //                           ],
            //                         ),
            //                       ),
            //                     ],
            //                   ),
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),

            // ),
            ));
  }

  Widget _itemTab({
    required Category category,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = category;
        });
      },
      child: Container(
          margin: EdgeInsets.only(left: 7),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xff1f2029),
            border: selectedCategory == category
                ? Border.all(color: Colors.deepOrangeAccent, width: 3)
                : Border.all(color: Colors.white, width: 3),
          ),
          child: Text(
            category.name,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          )),
    );
  }
}
