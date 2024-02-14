import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RecipeDetailPage extends StatefulWidget {
  final String recipeId;

  RecipeDetailPage({@required this.recipeId});

  @override
  _RecipeDetailPageState createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  final String apiUrl = 'https://www.themealdb.com/api/json/v1/1/lookup.php?i=';

  Map<String, dynamic> recipeDetails = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRecipeDetails();
  }

  Future<void> fetchRecipeDetails() async {
    print(widget.recipeId);
    final response = await http.get(Uri.parse('$apiUrl${widget.recipeId}'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> meals = data['meals'];

      setState(() {
        recipeDetails = meals[0];
        isLoading = false;
      });
    } else {
      print('Error: ${response.statusCode} ${response.body}');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> ingredientWidgets = [];

    for (int i = 1; i <= 20; i++) {
      final ingredient = recipeDetails['strIngredient$i'];
      final measure = recipeDetails['strMeasure$i'];

      if (ingredient != null && ingredient.isNotEmpty) {
        ingredientWidgets.add(Text('$ingredient: $measure'));
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: isLoading ? Text('Loading...') : Text(recipeDetails['strMeal']),
        backgroundColor: Colors.brown,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display recipe image
                  Image.network(
                    recipeDetails['strMealThumb'],
                    height: 200.0,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 16.0),
                  // Display recipe details
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Category: ${recipeDetails['strCategory']}',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Instructions: ${recipeDetails['strInstructions']}',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Ingredients:',
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8.0),
                        // Display recipe ingredients
                        ...ingredientWidgets,
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
