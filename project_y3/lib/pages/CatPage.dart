import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'CatDetailPage.dart';

class CatPage extends StatefulWidget {
  @override
  _CatPageState createState() => _CatPageState();
}

class _CatPageState extends State<CatPage> {
  final String apiKey = 'SRsJcM8SqkkcYkayB4uvfnxyU9NkxuRY94uBYElX';
  List<Map<String, dynamic>> cats = [];
  int offset = 0;
  bool isLoading = false;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    fetchCats();
  }

  void _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      if (!isLoading) {
        fetchCats();
      }
    }
  }

  Future<List<Map<String, dynamic>>> fetchCats() async {
    setState(() {
      isLoading = true;
    });

    final apiURL = 'https://api.api-ninjas.com/v1/cats?name=e&offset=$offset';
    final response =
        await http.get(Uri.parse(apiURL), headers: {'X-Api-Key': apiKey});

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      cats.addAll(data.map((cat) {
        return {
          'name': cat['name'].toString(),
          'length': cat['length']?.toString() ?? 'Unconfirmed',
          'origin': cat['origin']?.toString() ?? 'Unconfirmed',
          'generalHealth': cat['general_health']?.toString() ?? 'Unconfirmed',
          'meowing': cat['meowing']?.toString() ?? 'Unconfirmed',
          'imageLink': cat['image_link']?.toString() ?? 'Unconfirmed',
          'childrenFriendly':
              cat['children_friendly']?.toString() ?? 'Unconfirmed',
          'strangerFriendly':
              cat['stranger_friendly']?.toString() ?? 'Unconfirmed',
          'otherPetsFriendly':
              cat['other_pets_friendly']?.toString() ?? 'Unconfirmed',
          'shedding': cat['shedding']?.toString() ?? 'Unconfirmed',
          'playfulness': cat['playfulness']?.toString() ?? 'Unconfirmed',
          'grooming': cat['grooming']?.toString() ?? 'Unconfirmed',
          'intelligence': cat['intelligence']?.toString() ?? 'Unconfirmed',
          'minWeight': cat['min_weight']?.toString() ?? 'Unconfirmed',
          'maxWeight': cat['max_weight']?.toString() ?? 'Unconfirmed',
          'minLifeExpectancy':
              cat['min_life_expectancy']?.toString() ?? 'Unconfirmed',
          'maxLifeExpectancy':
              cat['max_life_expectancy']?.toString() ?? 'Unconfirmed',
        };
      }).toList());
      offset += 20;
      setState(() {
        isLoading = false;
      });
      return cats;
    } else {
      print('Error: ${response.statusCode} ${response.body}');
      setState(() {
        isLoading = false;
      });
      // return an empty list when error
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text('Cats'),
      ),
      body: Container(
        padding: EdgeInsets.all(5),
        color: Colors.brown[100],
        child: Stack(
          children: [
            GridView.builder(
              controller: _scrollController,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: cats.length + 1,
              itemBuilder: (context, index) {
                if (index < cats.length) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CatDetailPage(
                            catDetails: cats[index],
                          ),
                        ),
                      );
                    },
                    child: Card(
                      color: Colors.brown[50],
                      elevation: 4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Hero(
                            tag: 'catImage_${cats[index]['name']}',
                            child: Image.network(
                              cats[index]['imageLink'],
                              height: 100.0,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(cats[index]['name']),
                        ],
                      ),
                    ),
                  );
                } else if (isLoading) {
                  // dont show loading indicator if there's no data yet
                  return Container();
                } else {
                  // reach the end of the list
                  return Container();
                }
              },
            ),
            Align(
              alignment: Alignment.center,
              child: isLoading
                  ? CircularProgressIndicator()
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
