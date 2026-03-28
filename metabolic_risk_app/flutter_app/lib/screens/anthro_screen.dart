import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AnthroScreen extends StatefulWidget {
  @override
  _AnthroScreenState createState() => _AnthroScreenState();
}

class _AnthroScreenState extends State<AnthroScreen> {

  final heightController = TextEditingController();
  final weightController = TextEditingController();

  final bmiController = TextEditingController();
  final waistController = TextEditingController();
  final neckController = TextEditingController();
  final hipController = TextEditingController();
  final whrController = TextEditingController();
  final wherController = TextEditingController();

  double? risk;

  /*
  ----------------------------
  CALCULATE BMI
  ----------------------------
  */
  void calculateBMI() {
    if (heightController.text.isEmpty || weightController.text.isEmpty) return;

    double heightCm = double.parse(heightController.text);
    double weight = double.parse(weightController.text);

    double heightM = heightCm / 100;

    double bmi = weight / (heightM * heightM);

    bmiController.text = bmi.toStringAsFixed(2);

    calculateWHER();
  }

  /*
  ----------------------------
  CALCULATE WHR
  ----------------------------
  */
  void calculateWHR() {
    if (waistController.text.isEmpty || hipController.text.isEmpty) return;

    double waist = double.parse(waistController.text);
    double hip = double.parse(hipController.text);

    double whr = waist / hip;

    whrController.text = whr.toStringAsFixed(3);
  }

  /*
  ----------------------------
  CALCULATE WAIST HEIGHT RATIO
  ----------------------------
  */
  void calculateWHER() {
    if (waistController.text.isEmpty || heightController.text.isEmpty) return;

    double waist = double.parse(waistController.text);
    double height = double.parse(heightController.text);

    double wher = waist / height;

    wherController.text = wher.toStringAsFixed(3);
  }

  /*
  ----------------------------
  CALL API
  ----------------------------
  */
  void predict() async {

    double bmi = double.parse(bmiController.text);
    double waist = double.parse(waistController.text);
    double neck = double.parse(neckController.text);
    double hip = double.parse(hipController.text);
    double whr = double.parse(whrController.text);
    double wher = double.parse(wherController.text);

    double result = await ApiService.predictAnthro(
        bmi, waist, hip, neck, whr, wher);

    setState(() {
      risk = result;
    });
  }

  /*
  ----------------------------
  CLEAR FIELD
  ----------------------------
  */
  void clearFields() {

    heightController.clear();
    weightController.clear();
    bmiController.clear();
    waistController.clear();
    hipController.clear();
    neckController.clear();
    whrController.clear();
    wherController.clear();

    setState(() {
      risk = null;
    });

  }

  /*
  ----------------------------
  RISK TEXT
  ----------------------------
  */
  String getRiskText(double value) {

    if (value < 0.30) {
      return "Low Risk";
    } else if (value < 0.60) {
      return "Moderate Risk";
    } else {
      return "High Risk";
    }
  }

  /*
  ----------------------------
  RISK COLOR
  ----------------------------
  */
  Color getRiskColor(double value) {

    if (value < 0.30) {
      return Colors.green;
    } else if (value < 0.60) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  /*
  ----------------------------
  RISK text
  ----------------------------
  */
  String getRiskMessage(double value) {

  if (value < 0.30) {
    return "Anthropometric parameters fall within lower-risk ranges. Current body fat distribution does not indicate elevated metabolic risk. Maintenance of healthy lifestyle habits is recommended.";
  } 
  else if (value < 0.60) {
    return "Some anthropometric measures are approaching higher-risk ranges, particularly indicators of central adiposity. Lifestyle optimisation including physical activity and dietary moderation may help prevent progression toward metabolic risk.";
  } 
  else {
    return "Anthropometric indicators suggest increased central fat distribution, which is associated with elevated cardiometabolic risk. Reduction in abdominal adiposity through structured lifestyle intervention is recommended.";
  }

}

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text("Anthropometric Risk")),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),

        child: Column(
          children: [

            /*
            HEIGHT
            */
            TextField(
              controller: heightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Height (cm)"),
              onChanged: (v) => calculateBMI(),
            ),

            /*
            WEIGHT
            */
            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Weight (kg)"),
              onChanged: (v) => calculateBMI(),
            ),

            /*
            BMI AUTO
            */
            TextField(
              controller: bmiController,
              decoration: InputDecoration(labelText: "BMI"),
              readOnly: true,
            ),

            /*
            WAIST
            */
            TextField(
              controller: waistController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Waist Circumference"),
              onChanged: (v){
                calculateWHR();
                calculateWHER();
              },
            ),

            /*
            HIP
            */
            TextField(
              controller: hipController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Hip Circumference"),
              onChanged: (v) => calculateWHR(),
            ),

            /*
            NECK
            */
            TextField(
              controller: neckController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Neck Circumference"),
            ),

            /*
            WHR AUTO
            */
            TextField(
              controller: whrController,
              decoration: InputDecoration(labelText: "Waist-Hip Ratio"),
              readOnly: true,
            ),

            /*
            WHER AUTO
            */
            TextField(
              controller: wherController,
              decoration: InputDecoration(labelText: "Waist-Height Ratio"),
              readOnly: true,
            ),

            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                ElevatedButton(
                  onPressed: predict,
                  child: Text("Predict"),
                ),

                SizedBox(width: 20),

                ElevatedButton(
                  onPressed: clearFields,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                  ),
                  child: Text("Clear"),
                ),

              ],
            ),

            SizedBox(height: 30),

            /*
            RESULT
            */
            if (risk != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Text(
                  "Risk Score: ${risk!.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 10),

                Text(
                  getRiskText(risk!),
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: getRiskColor(risk!),
                  ),
                ),

                SizedBox(height: 15),

                Text(
                  getRiskMessage(risk!),
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: getRiskColor(risk!),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}