import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

import 'desc.dart';

class MoreDesc extends StatefulWidget {
  final Meal meal;

  const MoreDesc({Key? key, required this.meal}) : super(key: key);

  @override
  _MoreDescState createState() => _MoreDescState();
}

class _MoreDescState extends State<MoreDesc> {
  late Future<MealDetails> mealDetails;

  void launchYoutubeVideo(String youtubeLink) async {
  if (await canLaunch(youtubeLink)) {
    await launch(youtubeLink);
  } else {
    throw 'Could not launch $youtubeLink';
  }
}

  @override
  void initState() {
    super.initState();
    mealDetails = fetchMealDetails();
  }

  Future<MealDetails> fetchMealDetails() async {
    final response = await http.get(Uri.parse('https://www.themealdb.com/api/json/v1/1/lookup.php?i=${widget.meal.id}'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final mealDetails = MealDetails.fromJson(jsonData['meals'][0]);
      return mealDetails;
    } else {
      throw Exception('Failed to fetch meal details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meal Details'),
      ),
      body: FutureBuilder<MealDetails>(
        future: mealDetails,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final mealDetails = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                children: [
                  Image.network(mealDetails.image),
                  SizedBox(height: 16),
                  Text(
                    mealDetails.name,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('Category: ${mealDetails.category}'),
                  SizedBox(height: 8),
                  Text('Area: ${mealDetails.area}'),
                  SizedBox(height: 16),
                  Text(
                    'Instructions:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      mealDetails.instructions,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        launchYoutubeVideo(mealDetails.youtubeLink),
                    child: Text('Lihat Youtube'),
                  ),
                ],
              ),
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

class MealDetails {
  final String id;
  final String name;
  final String image;
  final String category;
  final String area;
  final String instructions;
  final String youtubeLink;

  MealDetails({
    required this.id,
    required this.name,
    required this.image,
    required this.category,
    required this.area,
    required this.instructions,
    required this.youtubeLink,
  });

  factory MealDetails.fromJson(Map<String, dynamic> json) {
    return MealDetails(
      id: json['idMeal'],
      name: json['strMeal'],
      image: json['strMealThumb'],
      category: json['strCategory'],
      area: json['strArea'],
      instructions: json['strInstructions'],
      youtubeLink: json['strYoutube'],
    );
  }
}
