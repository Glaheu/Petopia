import 'package:flutter/material.dart';

class DogDetailPage extends StatelessWidget {
  final Map<String, dynamic> dogDetails;

  DogDetailPage({this.dogDetails});

  Widget _rowDetail(String text, String key) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            text + ':',
            style: TextStyle(fontSize: 18),
          ),
          Text(
            dogDetails[key],
            style: TextStyle(fontSize: 18),
          )
        ]);
  }

  Widget _rowDetailLife(String text, String key) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            text + ':',
            style: TextStyle(fontSize: 18),
          ),
          Text(
            dogDetails[key] + ' Years',
            style: TextStyle(fontSize: 18),
          )
        ]);
  }

  Widget _rowDetailHeight(String text, String key) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            text + ':',
            style: TextStyle(fontSize: 18),
          ),
          Text(
            dogDetails[key] + ' Inches',
            style: TextStyle(fontSize: 18),
          )
        ]);
  }

  Widget _rowDetailWeight(String text, String key) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            text + ':',
            style: TextStyle(fontSize: 18),
          ),
          Text(
            dogDetails[key] + ' lbs',
            style: TextStyle(fontSize: 18),
          )
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.brown,
              title: Text("Dog Details"),
              bottom: TabBar(
                indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(width: 5, color: Colors.brown[300]),
                    insets: EdgeInsets.symmetric(horizontal: 30.0)),
                tabs: [
                  Tab(
                    icon: Icon(Icons.fiber_manual_record),
                    text: "Male",
                  ),
                  Tab(
                    icon: Icon(Icons.ac_unit_rounded),
                    text: "Female",
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: <Widget>[
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Hero(
                        tag: 'dogImage_${dogDetails['name']}',
                        child: Image.network(
                          dogDetails['imageLink'],
                          // Adjust the height as needed
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        color: Colors.brown[100],
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                                child: Text(dogDetails['name'],
                                    style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold))),
                            SizedBox(height: 10),
                            _rowDetail(
                                'Good with children', 'goodWithChildren'),
                            SizedBox(height: 5),
                            _rowDetail(
                                'Good with other Dogs', 'goodWithOtherDogs'),
                            SizedBox(height: 5),
                            _rowDetail('Shedding', 'shedding'),
                            SizedBox(height: 5),
                            _rowDetail('Grooming', 'grooming'),
                            SizedBox(height: 5),
                            _rowDetail('Drooling', 'drooling'),
                            SizedBox(height: 5),
                            _rowDetail('Coat Length', 'coatLength'),
                            SizedBox(height: 5),
                            _rowDetail(
                                'Good with Strangers', 'goodWithStrangers'),
                            SizedBox(height: 5),
                            _rowDetail('Playfulness', 'playfulness'),
                            SizedBox(height: 5),
                            _rowDetail('Protectiveness', 'protectiveness'),
                            SizedBox(height: 5),
                            _rowDetail('Trainability', 'trainability'),
                            SizedBox(height: 5),
                            _rowDetail('Energy', 'energy'),
                            SizedBox(height: 5),
                            _rowDetail('Barking', 'barking'),
                            SizedBox(height: 5),
                            _rowDetailHeight('Minimum Height', 'minHeightMale'),
                            SizedBox(height: 5),
                            _rowDetailHeight('Maximum Height', 'maxHeightMale'),
                            SizedBox(height: 5),
                            _rowDetailWeight('Minumum Weight', 'minWeightMale'),
                            SizedBox(height: 5),
                            _rowDetailWeight('Maximum Weight', 'maxWeightMale'),
                            SizedBox(height: 5),
                            _rowDetailLife(
                                'Minimum Life Expectancy', 'minLifeExpectancy'),
                            SizedBox(height: 5),
                            _rowDetailLife(
                                'Maximum Life Expectancy', 'maxLifeExpectancy'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Hero(
                        tag: 'dogImage_${dogDetails['name']}',
                        child: Image.network(
                          dogDetails['imageLink'],
                          // Adjust the height as needed
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        color: Colors.brown[100],
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                                child: Text(dogDetails['name'],
                                    style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold))),
                            SizedBox(height: 10),
                            _rowDetail(
                                'Good with children', 'goodWithChildren'),
                            SizedBox(height: 5),
                            _rowDetail(
                                'Good with other Dogs', 'goodWithOtherDogs'),
                            SizedBox(height: 5),
                            _rowDetail('Shedding', 'shedding'),
                            SizedBox(height: 5),
                            _rowDetail('Grooming', 'grooming'),
                            SizedBox(height: 5),
                            _rowDetail('Drooling', 'drooling'),
                            SizedBox(height: 5),
                            _rowDetail('Coat Length', 'coatLength'),
                            SizedBox(height: 5),
                            _rowDetail(
                                'Good with Strangers', 'goodWithStrangers'),
                            SizedBox(height: 5),
                            _rowDetail('Playfulness', 'playfulness'),
                            SizedBox(height: 5),
                            _rowDetail('Protectiveness', 'protectiveness'),
                            SizedBox(height: 5),
                            _rowDetail('Trainability', 'trainability'),
                            SizedBox(height: 5),
                            _rowDetail('Energy', 'energy'),
                            SizedBox(height: 5),
                            _rowDetail('Barking', 'barking'),
                            SizedBox(height: 5),
                            _rowDetailHeight(
                                'Minimum Height', 'minHeightFemale'),
                            SizedBox(height: 5),
                            _rowDetailHeight(
                                'Maximum Height', 'maxHeightFemale'),
                            SizedBox(height: 5),
                            _rowDetailWeight(
                                'Minumum Weight', 'minWeightFemale'),
                            SizedBox(height: 5),
                            _rowDetailWeight(
                                'Maximum Weight', 'maxWeightFemale'),
                            SizedBox(height: 5),
                            _rowDetailLife(
                                'Minimum Life Expectancy', 'minLifeExpectancy'),
                            SizedBox(height: 5),
                            _rowDetailLife(
                                'Maximum Life Expectancy', 'maxLifeExpectancy'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )));
  }
}
