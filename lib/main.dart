
import 'package:flutter/material.dart';
import 'TipsPage.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatefulWidget {
  @override
  _CalculatorAppState createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  int index = 0;
  final key = GlobalKey<FormState>();
  final controller = TextEditingController();
  final controllerCost = TextEditingController();
  int vehicles_num = 1;
  int numPass = 4;

  List<TripSegment> _segments = [TripSegment(name: 'Start')];
  double? _totalCost;

  final List<Widget> _pages = [
    Container(),
    TipsPage(),
  ];

  void tappedItem(int newIndex) {
    setState(() {
      index = newIndex;
    });
  }

  void calc() {
    if (key.currentState!.validate()) {
      final efficiency = double.parse(controller.text);
      final cost = double.parse(controllerCost.text);

      double totalCost = 0;
      setState(() {
        for (var segment in _segments) {
          segment.fuelNeeded = segment.distance / efficiency;
          segment.segmentCost = segment.fuelNeeded! * cost;
          totalCost += segment.segmentCost!;
        }
        _totalCost = totalCost * vehicles_num;
      });
    }
  }

  void restFields() {
    controller.clear();
    controllerCost.clear();
    setState(() {
      _segments = [TripSegment(name: 'Start')];
      _totalCost = null;
      vehicles_num = 1;
    });
  }

  void _addSegment() {
    setState(() {
      _segments.add(TripSegment(name: 'Segment ${_segments.length + 1}'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fuel Efficiency Tracker',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFFEE8374),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        ),
        primaryColor: Color(0xFFEE8374),
        scaffoldBackgroundColor: Color(0xFFF3F4F6),
        colorScheme: ColorScheme.light(primary: Color(0xFFEE8374)),
      ),
      home: Scaffold(
        appBar: AppBar(title: Text('Fuel Cost Calculator')),
        body: index == 0
            ? SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Enter your vehicle\'s fuel efficiency and the fuel cost to calculate the trip cost.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 8),
              Text(
                'Fuel efficiency is the amount of fuel consumed per distance traveled. Fuel cost is the price you pay per gallon or liter.',
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 20),
              Card(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                color: Color(0xFF54567A),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Example:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'If you have a vehicle with a fuel efficiency of 10 km per liter, and the cost of fuel is \$1.5 per liter, a 100 km trip will require 10 liters of fuel. The total cost for this segment would be \$15.',
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Form(
                key: key,
                child: Column(
                  children: [
                    TextFormField(
                      controller: controller,
                      decoration: InputDecoration(
                        labelText: 'Fuel efficiency (km)',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFEE8374)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Please enter fuel efficiency';
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: controllerCost,
                      decoration: InputDecoration(
                        labelText: 'Fuel cost per Liter',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFEE8374)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Please enter fuel cost';
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    DropdownButtonFormField<int>(
                      value: vehicles_num,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onChanged: (int? newValue) {
                        setState(() {
                          vehicles_num = newValue!;
                        });
                      },
                      dropdownColor: Colors.white,
                      items: <int>[1, 2, 3, 4, 5].map<DropdownMenuItem<int>>((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text(
                            '$value ${value == 1 ? 'Vehicle' : 'Vehicles'}',
                            style: TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Trip Segments',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                    Column(
                      children: _segments.map((segment) => Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: '${segment.name} Distance (miles)',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFEE8374)),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            segment.distance = double.tryParse(value) ?? 0.0;
                          },
                        ),
                      )).toList(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: ElevatedButton(
                        onPressed: _addSegment,
                        child: Text('Add', style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFEE8374),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: calc,
                          child: Text('Calculate', style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFEE8374),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: restFields,
                          child: Text('Reset', style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              if (_totalCost != null)
                Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  color: Color(0xFF54567A),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Fuel Cost for $vehicles_num vehicles: \$${_totalCost!.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        if (vehicles_num > 0 && numPass > 0)
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              'Cost per Person: \$${(_totalCost! / (vehicles_num * numPass)).toStringAsFixed(2)}',
                              style: TextStyle(fontSize: 18, color: Colors.greenAccent),
                            ),
                          ),
                        ..._segments.map((segment) => Text(
                          '${segment.name} - Fuel Needed: ${segment.fuelNeeded?.toStringAsFixed(2)} liters, Segment Cost: \$${segment.segmentCost?.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        )),
                      ],
                    ),
                  ),
                ),
              SizedBox(height: 20),
              Card(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                color: Color(0xFF54567A),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Description:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'This calculator helps you determine the total cost of fuel for a trip based on your vehicle\'s fuel efficiency, fuel cost per liter, and the distance for each segment of the trip. You can also calculate the cost per person if there are multiple vehicles and passengers.',
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        )
            : _pages[index],
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.input),
              label: 'Calculator',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.tips_and_updates),
              label: 'Tips',
            ),
          ],
          currentIndex: index,
          onTap: tappedItem,
          selectedItemColor: Color(0xFFEE8374),
          unselectedItemColor: Colors.black54,
        ),
      ),
    );
  }
}

// Segment class to store trip segment details
class TripSegment {
  final String name;
  double distance = 0.0;
  double? fuelNeeded;
  double? segmentCost;

  TripSegment({required this.name});
}