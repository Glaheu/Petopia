import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'RecipeDetailPage.dart';

class RecipePage extends StatefulWidget {
  final String category;

  RecipePage({@required this.category});

  @override
  _RecipePageState createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  final String apiUrl = 'https://www.themealdb.com/api/json/v1/1/filter.php?c=';

  List<Map<String, dynamic>> recipes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRecipes();
  }

  Future<void> fetchRecipes() async {
    final response = await http.get(Uri.parse('$apiUrl${widget.category}'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> meals = data['meals'];

      setState(() {
        recipes.addAll(meals.map((meal) {
          return {
            'idMeal': meal['idMeal'].toString(),
            'mealName': meal['strMeal'].toString(),
            'imageLink': meal['strMealThumb'].toString(),
          };
        }).toList());
        isLoading = false;
      });
    } else {
      print('Error: ${response.statusCode} ${response.body}');
      setState(() {
        isLoading = false;
      });
    }
  }

  void navigateToRecipeDetailPage(String id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeDetailPage(recipeId: id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
        backgroundColor: Colors.brown,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : recipes.isEmpty
              ? Center(child: Text('No recipes available'))
              : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: recipes.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: () {
                          navigateToRecipeDetailPage(recipes[index]['idMeal']);
                        },
                        child: Card(
                          color: Colors.brown[50],
                          elevation: 4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Display recipe image
                              Image.network(
                                recipes[index]['imageLink'],
                                height: 100.0,
                              ),
                              SizedBox(height: 8.0),
                              // Display recipe name
                              Text(recipes[index]['mealName']),
                            ],
                          ),
                        ));
                  },
                ),
    );
  }
}
