import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'home.dart';
import 'more_desc.dart';

class DescTab extends StatefulWidget {
  final Category category;

  const DescTab({Key? key, required this.category}) : super(key: key);

  @override
  _DescTabState createState() => _DescTabState();
}

class _DescTabState extends State<DescTab> {
  late Future<List<Meal>> meals;

  @override
  void initState() {
    super.initState();
    meals = fetchMeals();
  }

  Future<List<Meal>> fetchMeals() async {
    final response = await http.get(Uri.parse('https://www.themealdb.com/api/json/v1/1/filter.php?c=${widget.category.name}'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final mealList = jsonData['meals'] as List<dynamic>;
      final meals = mealList.map((meal) => Meal.fromJson(meal)).toList();
      return meals;
    } else {
      throw Exception('Failed to fetch meals');
    }
  }

  void navigateToMoreDescription(Meal meal) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MoreDesc(meal: meal),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.name),
      ),
      body: FutureBuilder<List<Meal>>(
        future: meals,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final mealList = snapshot.data!;
            return GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 24,
              children: mealList
                  .map(
                    (meal) => GestureDetector(
                      onTap: () => navigateToMoreDescription(meal),
                      child: Card(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(meal.name),
                            SizedBox(height: 5),
                            Image.network(meal.image),
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

class Meal {
  final String name;
  final String image;
  final String id;

  Meal({required this.name, required this.image, required this.id});

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      name: json['strMeal'],
      image: json['strMealThumb'],
      id: json['idMeal'],
    );
  }
}
