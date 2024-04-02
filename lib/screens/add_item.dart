import 'dart:io';

import 'package:blue_thermal_printer_example/model/category_model.dart';
import 'package:blue_thermal_printer_example/model/item_model.dart';
import 'package:blue_thermal_printer_example/utils/shared_preferences_helper.dart';
import 'package:blue_thermal_printer_example/utils/utils.dart';
import 'package:blue_thermal_printer_example/widgets/item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

class AddItemPage extends StatefulWidget {
  @override
  _AddItemPageState createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _itemLocaleNameController =
      TextEditingController();
  final TextEditingController _itemPriceController = TextEditingController();
  Category? _itemCategory;
  String? _itemImageUrl;
  List<ItemModel> _itemList = [];
  List<Category> _categoryList = [];

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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Item'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _itemNameController,
              decoration: InputDecoration(labelText: 'Item Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter item name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _itemLocaleNameController,
              decoration: InputDecoration(labelText: 'Item Locale Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter item locale name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _itemPriceController,
              decoration: InputDecoration(labelText: 'Item Price'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter item price';
                }
                return null;
              },
            ),
            DropdownButtonFormField<Category>(
              value: _itemCategory,
              onChanged: (value) {
                setState(() {
                  _itemCategory = value;
                });
              },
              items: _categoryList
                  .map((category) => DropdownMenuItem<Category>(
                        value: category,
                        child: Text(category.name),
                      ))
                  .toList(),
              decoration: InputDecoration(labelText: 'Item Category'),
            ),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(
              onPressed: () async {
                final image =
                    await ImagePicker().pickImage(source: ImageSource.gallery);
                setState(() {
                  _itemImageUrl = image?.path;
                });
              },
              child: Text('Select Item Image'),
            ),
            if (_itemImageUrl != null)
              SizedBox(width: 100, child: Image.file(File(_itemImageUrl!))),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _itemList.add(ItemModel(
                            name: _itemNameController.text,
                            nameInLocale: _itemLocaleNameController.text,
                            price: double.parse(_itemPriceController.text),
                            imageBytes:
                                File(_itemImageUrl!).readAsBytesSync()));
                      });
                    }
                  },
                  child: Text('Add Another Item'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_itemList.isNotEmpty) {
                      await SharedPreferencesHelper.setItemList(_itemList);
                      showSnack(context, 'Updated items');
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text('Save Item'),
                ),
              ],
            ),
            SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _itemList
                    .map((item) =>
                        Stack(alignment: Alignment.topRight, children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ItemWidget(
                              item: item,
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  _itemList.remove(item);
                                });
                              },
                              icon: Container(
                                  color: Colors.grey,
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                  )))
                        ]))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _itemPriceController.dispose();
    super.dispose();
  }
}
