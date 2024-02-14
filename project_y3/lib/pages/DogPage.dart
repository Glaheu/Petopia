import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'DogDetailPage.dart';

class DogPage extends StatefulWidget {
  @override
  _DogPageState createState() => _DogPageState();
}

class _DogPageState extends State<DogPage> {
  final String apiKey = 'SRsJcM8SqkkcYkayB4uvfnxyU9NkxuRY94uBYElX';
  List<Map<String, dynamic>> dogs = [];
  int offset = 0;
  bool isLoading = false;
  ScrollController _scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    fetchDogs();
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      if (!isLoading) {
        fetchDogs();
      }
    }
  }

  Future<List<Map<String, dynamic>>> fetchDogs(
      {String searchQuery = ''}) async {
    setState(() {
      isLoading = true;
    });

    String apiURL;
    if (searchQuery.isEmpty) {
      // Original URL for fetching all dogs with pagination
      apiURL = 'https://api.api-ninjas.com/v1/dogs?name=e&offset=$offset';
    } else {
      // Updated URL for fetching dogs based on search query
      apiURL =
          'https://api.api-ninjas.com/v1/dogs?name=$searchQuery&offset=$offset';
    }
    final response =
        await http.get(Uri.parse(apiURL), headers: {'X-Api-Key': apiKey});

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      dogs.addAll(data.map((dog) {
        return {
          'name': dog['name'].toString(),
          'imageLink': dog['image_link'].toString(),
          'goodWithChildren': dog['good_with_children'].toString(),
          'goodWithOtherDogs': dog['good_with_other_dogs'].toString(),
          'shedding': dog['shedding'].toString(),
          'grooming': dog['grooming'].toString(),
          'drooling': dog['drooling'].toString(),
          'coatLength': dog['coat_length'].toString(),
          'goodWithStrangers': dog['good_with_strangers'].toString(),
          'playfulness': dog['playfulness'].toString(),
          'protectiveness': dog['protectiveness'].toString(),
          'trainability': dog['trainability'].toString(),
          'energy': dog['energy'].toString(),
          'barking': dog['barking'].toString(),
          'minLifeExpectancy': dog['min_life_expectancy'].toString(),
          'maxLifeExpectancy': dog['max_life_expectancy'].toString(),
          'maxHeightMale': dog['max_height_male'].toString(),
          'maxHeightFemale': dog['max_height_female'].toString(),
          'maxWeightMale': dog['max_weight_male'].toString(),
          'maxWeightFemale': dog['max_weight_female'].toString(),
          'minHeightMale': dog['min_height_male'].toString(),
          'minHeightFemale': dog['min_height_female'].toString(),
          'minWeightMale': dog['min_weight_male'].toString(),
          'minWeightFemale': dog['min_weight_female'].toString(),
        };
      }).toList());
      offset += 20;
      setState(() {
        isLoading = false;
      });
      return dogs;
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
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Search for a dog breed...',
            hintStyle: TextStyle(color: Colors.white),
            border: InputBorder.none,
          ),
          style: TextStyle(color: Colors.white),
          onChanged: (value) {
            if (value.isEmpty) {
              dogs.clear();
              offset = 0;
              fetchDogs();
            }
          },
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              dogs.clear();
              offset = 0;
              fetchDogs(searchQuery: value); 
            }
          },
        ),
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
              itemCount: dogs.length + 1,
              itemBuilder: (context, index) {
                if (index < dogs.length) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DogDetailPage(
                            dogDetails: dogs[index],
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
                            tag: 'dogImage_${dogs[index]['name']}',
                            child: Image.network(
                              dogs[index]['imageLink'],
                              height: 100.0,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(dogs[index]['name']),
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
              child: isLoading ? CircularProgressIndicator() : Container(),
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
