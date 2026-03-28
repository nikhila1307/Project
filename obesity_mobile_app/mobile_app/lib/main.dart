import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Obesity Predictor',
      home: PredictionPage(),
    );

  }
}

class PredictionPage extends StatefulWidget {

  @override
  _PredictionPageState createState() => _PredictionPageState();

}

class _PredictionPageState extends State<PredictionPage> {

  TextEditingController bmi = TextEditingController();
  TextEditingController age = TextEditingController();

  String result="";

  Future predict() async {

    var url = Uri.parse("http://10.0.2.2:8000/predict_combined");

    var response = await http.post(
      url,
      headers: {"Content-Type":"application/json"},
      body: jsonEncode({
        "BMI": double.parse(bmi.text),
        "Age": int.parse(age.text)
      })
    );

    var data = jsonDecode(response.body);

    setState(() {
      result = data["prediction"].toString();
    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(title: Text("Obesity Predictor")),

      body: Padding(
        padding: EdgeInsets.all(20),

        child: Column(

          children: [

            TextField(
              controller: bmi,
              decoration: InputDecoration(labelText: "BMI"),
            ),

            TextField(
              controller: age,
              decoration: InputDecoration(labelText: "Age"),
            ),

            SizedBox(height:20),

            ElevatedButton(
              onPressed: predict,
              child: Text("Predict"),
            ),

            SizedBox(height:20),

            Text(result,style:TextStyle(fontSize:20))

          ],

        ),
      ),

    );

  }

}