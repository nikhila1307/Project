import 'package:flutter/material.dart';
import 'screens/anthro_screen.dart';
import 'screens/biochemical_screen.dart';
import 'screens/combined_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Metabolic Risk Predictor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Metabolic Risk Predictor"),
      ),

      body: Padding(
        padding: EdgeInsets.all(20),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity,60),
              ),
              child: Text("Anthropometric Risk"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AnthroScreen()),
                );
              },
            ),

            SizedBox(height:20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity,60),
              ),
              child: Text("Biochemical Risk"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BioScreen()),
                );
              },
            ),

            SizedBox(height:20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity,60),
              ),
              child: Text("Combined Risk"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CombinedScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}