import 'package:flutter/material.dart';

class CatDetailPage extends StatelessWidget {
  final Map<String, dynamic> catDetails;

  CatDetailPage({this.catDetails});

  Widget _rowDetail(String text, String key) {
    String value = catDetails[key];
    bool isUnconfirmed = value == "Unconfirmed";
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          text + ':',
          style: TextStyle(fontSize: 18),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            color: isUnconfirmed ? Colors.red : null,
          ),
        ),
      ],
    );
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
          catDetails[key] + ' Years',
          style: TextStyle(fontSize: 18),
        )
      ],
    );
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
          catDetails[key] + ' lbs',
          style: TextStyle(fontSize: 18),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text("Cat Details"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
              tag: 'catImage_${catDetails['name']}',
              child: Image.network(
                catDetails['imageLink'],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              color: Colors.brown[100],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Text(catDetails['name'],
                        style: TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(height: 10),
                  _rowDetail('Hair length', 'length'),
                  SizedBox(height: 5),
                  _rowDetail('Country of Origin', 'origin'),
                  SizedBox(height: 5),
                  _rowDetail('General Health', 'generalHealth'),
                  SizedBox(height: 5),
                  _rowDetail('Children Friendly', 'childrenFriendly'),
                  SizedBox(height: 5),
                  _rowDetail('Other Pets Friendly', 'otherPetsFriendly'),
                  SizedBox(height: 5),
                  _rowDetail('Stranger Friendly', 'strangerFriendly'),
                  SizedBox(height: 5),
                  _rowDetail('Meowing', 'meowing'),
                  SizedBox(height: 5),
                  _rowDetail('Shedding', 'shedding'),
                  SizedBox(height: 5),
                  _rowDetail('Playfulness', 'playfulness'),
                  SizedBox(height: 5),
                  _rowDetail('Grooming', 'grooming'),
                  SizedBox(height: 5),
                  _rowDetail('Intelligence', 'intelligence'),
                  SizedBox(height: 5),
                  _rowDetailWeight('Minimum Weight', 'minWeight'),
                  SizedBox(height: 5),
                  _rowDetailWeight('Maximum Weight', 'maxWeight'),
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
    );
  }
}
