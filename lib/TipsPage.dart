import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Car {
  final String name;
  final String color;
  final double price;
  final double costOfFuel;
  final String description;

  Car(this.name, this.color, this.price, this.costOfFuel, this.description);
}

class TipsPage extends StatefulWidget {
  @override
  _TipsPageState createState() => _TipsPageState();
}

class _TipsPageState extends State<TipsPage> {
  List<String> tips = [];
  String carName = '';
  Car? carDetails;

  @override
  void initState() {
    super.initState();
    fetchTips();
  }

  Future<void> fetchTips() async {
    final response = await http.get(Uri.parse('http://fuelcalc.atwebpages.com/tips.php'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        tips = data.map((tip) => tip['tip'] as String).toList();
      });
    } else {
      throw Exception('Failed to load tips');
    }
  }

  Future<void> fetchCarDetails() async {
    print("Searching for car: $carName"); // Debug statement
    try {
      final response = await http.get(Uri.parse('http://fuelcalc.atwebpages.com/cars.php?name=$carName'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        print("Response data: $data");
        if (data.isNotEmpty) {
          final car = data[0];
          setState(() {
            carDetails = Car(
              car['name'],
              car['color'],
              double.parse(car['price']),
              double.parse(car['cost_of_fuel']),
              car['description'],
            );
          });
        } else {
          print("No car found for name: $carName"); // Debug statement
          setState(() {
            carDetails = null;
          });
        }
      } else {
        throw Exception('Failed to load car details; Status code: ${response.statusCode}');
      }
    } catch (error) {
      print("Error fetching car details: $error");
      setState(() {
        carDetails = null;
      });
    }
  }

  void showCarDetails() {
    fetchCarDetails().then((_) {
      showDialog(
        context: context,
        builder: (context) {
          if (carDetails != null) {
            return AlertDialog(
              title: Text(carDetails!.name),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Color: ${carDetails!.color}'),
                  Text('Price: \$${carDetails!.price}'),
                  Text('Cost of Fuel: \$${carDetails!.costOfFuel}'),
                  Text('Description: ${carDetails!.description}'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Close'),
                ),
              ],
            );
          } else {
            return AlertDialog(
              title: Text('Car Not Found'),
              content: Text('No details found for "$carName".'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Close'),
                ),
              ],
            );
          }
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3F4F6),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: tips.isEmpty
            ? Center(child: CircularProgressIndicator())
            : Column(
          children: [
            // Display tips
            Expanded(
              child: ListView.builder(
                itemCount: tips.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    color: Color(0xFF54567A),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        tips[index],
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ),

            //  available cars
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'There are four cars in our stock: Mercedes, BMW, Kia, Honda.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),

            // Search
            TextField(
              onChanged: (value) {
                setState(() {
                  carName = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Enter car name',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(12.0), // Added padding
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: showCarDetails,
              child: Text('Get Car Details'),
            ),
          ],
        ),
      ),
    );
  }
}