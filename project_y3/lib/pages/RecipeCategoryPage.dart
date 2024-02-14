import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'RecipePage.dart';

class RecipeCategoryPage extends StatefulWidget {
  @override
  _RecipeCategoryPageState createState() => _RecipeCategoryPageState();
}

class _RecipeCategoryPageState extends State<RecipeCategoryPage> {
  final String categoryUrl =
      'https://www.themealdb.com/api/json/v1/1/list.php?c=list';

  List<Map<String, dynamic>> recipes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final response = await http.get(Uri.parse(categoryUrl));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> categories = data['meals'];

      setState(() {
        recipes.addAll(categories.map((category) {
          return {
            'category': category['strCategory'].toString(),
            'imageLink':
                'https://www.themealdb.com/images/category/${category['strCategory'].toLowerCase()}.png',
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

  void navigateToRecipePage(String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipePage(category: category),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      color: Colors.brown[100],
      child: Stack(
        children: [
          isLoading
              ? Center(child: CircularProgressIndicator())
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
                        navigateToRecipePage(recipes[index]['category']);
                      },
                      child: Card(
                        color: Colors.brown[50],
                        elevation: 4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network(
                              recipes[index]['imageLink'],
                              height: 100.0,
                            ),
                            SizedBox(height: 8.0),
                            Text(recipes[index]['category']),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
