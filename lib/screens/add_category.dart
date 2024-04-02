import 'dart:io';

import 'package:pos_ticket/model/category_model.dart';
import 'package:pos_ticket/utils/shared_preferences_helper.dart';
import 'package:pos_ticket/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

class AddCategory extends StatefulWidget {
  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _categoryNameController = TextEditingController();
  final TextEditingController _categoryLocaleNameController =
      TextEditingController();
  final TextEditingController _categoryPriorityController =
      TextEditingController();

  List<Category> _categories = [];

  @override
  void initState() {
    setExistingCategory();
    super.initState();
  }

  setExistingCategory() async {
    List<Category> retrievedCategoryList =
        await SharedPreferencesHelper.getCategoryList();
    setState(() {
      _categories.addAll(retrievedCategoryList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Category'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _categoryNameController,
              decoration: InputDecoration(labelText: 'Category Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter category name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _categoryLocaleNameController,
              decoration: InputDecoration(labelText: 'Category Locale Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter category locale name';
                }
                return null;
              },
            ),
            TextFormField(
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp(r'[^0-9]')),
              ],
              controller: _categoryPriorityController,
              decoration: InputDecoration(labelText: 'Category Priority'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter priority';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _categories.add(Category(
                          name: _categoryNameController.text,
                          nameInLocale: _categoryLocaleNameController.text,
                          priority: int.parse(_categoryPriorityController.text),
                        ));
                      });
                      _categoryNameController.clear();
                      _categoryLocaleNameController.clear();
                      _categoryPriorityController.clear();
                    }
                  },
                  child: Text('Add Category'),
                ),
                if (_categories.isNotEmpty)
                  ElevatedButton(
                    onPressed: () async {
                      await SharedPreferencesHelper.setCategoryList(
                          _categories);
                      showSnack(context, 'Updated Category');
                      Navigator.of(context).pop();
                    },
                    child: Text('Save Category'),
                  ),
              ],
            ),
            SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _categories.map((category) {
                  return _buildItemThumbnail(category);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemThumbnail(Category category) {
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Column(
            children: [
              Text(category.name),
              Text(category.nameInLocale),
            ],
          ),
          IconButton(
              onPressed: () {
                _categories.remove(category);
              },
              icon: Icon(Icons.delete))
        ],
      ),
    );
  }

  @override
  void dispose() {
    _categoryNameController.dispose();
    _categoryPriorityController.dispose();
    super.dispose();
  }
}
