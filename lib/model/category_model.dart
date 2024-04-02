import 'dart:convert';

class Category {
  const Category({
    required this.name,
    required this.nameInLocale,
    required this.priority,
  });

  final String name;
  final String nameInLocale;
  final int priority;

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      name: json['name'] as String,
      nameInLocale: json['nameInLocale'] as String,
      priority: json['priority'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'nameInLocale': nameInLocale,
      'priority': priority,
    };
  }

  @override
  String toString() {
    return 'Category(name: $name, nameInLocale: $nameInLocale, priority: $priority)';
  }
}
