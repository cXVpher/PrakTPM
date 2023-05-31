import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:responsi/desc.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  late Future<List<Category>> categories;

  @override
  void initState() {
    super.initState();
    categories = fetchCategories();
  }

  Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse('https://www.themealdb.com/api/json/v1/1/categories.php'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final categoryList = jsonData['categories'] as List<dynamic>;
      final categories = categoryList.map((category) => Category.fromJson(category)).toList();
      return categories;
    } else {
      throw Exception('Failed to fetch categories');
    }
  }

  void navigateToDescription(Category category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DescTab(category: category),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
      ),
      body: FutureBuilder<List<Category>>(
        future: categories,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final categoryList = snapshot.data!;
            return GridView.count(
              crossAxisCount: 2,
              children: categoryList
                  .map(
                    (category) => GestureDetector(
                      onTap: () => navigateToDescription(category),
                      child: Card(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(category.name),
                            SizedBox(height: 8),
                            Image.network(category.image),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class Category {
  final String name;
  final String image;

  Category({required this.name, required this.image});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      name: json['strCategory'],
      image: json['strCategoryThumb'],
    );
  }
}
