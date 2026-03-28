import 'dart:math';
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class CombinedScreen extends StatefulWidget {
  @override
  _CombinedScreenState createState() => _CombinedScreenState();
}

class _CombinedScreenState extends State<CombinedScreen> {
  // Anthropometric controllers
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final waistController = TextEditingController();
  final hipController = TextEditingController();
  final neckController = TextEditingController();
  final bmiController = TextEditingController();
  final whrController = TextEditingController();
  final wherController = TextEditingController();

  // Biochemical controllers
  final tgController = TextEditingController();
  final hdlController = TextEditingController();
  final glucoseController = TextEditingController();
  final tygController = TextEditingController();
  final tghdlController = TextEditingController();
  final aipController = TextEditingController();
  final spiseController = TextEditingController();

  double? risk;

  // ----------------------------
  // CALCULATE BMI
  // ----------------------------
  void calculateBMI() {
    if (heightController.text.isEmpty || weightController.text.isEmpty) return;

    double heightCm = double.parse(heightController.text);
    double weight = double.parse(weightController.text);
    double heightM = heightCm / 100;
    double bmi = weight / (heightM * heightM);

    bmiController.text = bmi.toStringAsFixed(2);
    calculateWHER();
  }

  // ----------------------------
  // CALCULATE WHR
  // ----------------------------
  void calculateWHR() {
    if (waistController.text.isEmpty || hipController.text.isEmpty) return;

    double waist = double.parse(waistController.text);
    double hip = double.parse(hipController.text);

    double whr = waist / hip;
    whrController.text = whr.toStringAsFixed(3);
  }

  // ----------------------------
  // CALCULATE WHER
  // ----------------------------
  void calculateWHER() {
    if (waistController.text.isEmpty || heightController.text.isEmpty) return;

    double waist = double.parse(waistController.text);
    double height = double.parse(heightController.text);

    double wher = waist / height;
    wherController.text = wher.toStringAsFixed(3);
  }

  // ----------------------------
  // CALCULATE BIOCHEMICAL INDICES
  // ----------------------------
  void calculateBioIndices() {
    if (tgController.text.isEmpty ||
        hdlController.text.isEmpty ||
        glucoseController.text.isEmpty) return;

    double tg = double.parse(tgController.text);
    double hdl = double.parse(hdlController.text);
    double glucose = double.parse(glucoseController.text);

    double tyg = log((tg * glucose) / 2);
    double tghdl = tg / hdl;
    double aip = log(tghdl) / ln10;
    double spise = 600 * pow(hdl, 0.185) / pow(tg, 0.2);

    tygController.text = tyg.toStringAsFixed(3);
    tghdlController.text = tghdl.toStringAsFixed(3);
    aipController.text = aip.toStringAsFixed(3);
    spiseController.text = spise.toStringAsFixed(3);
  }

  // ----------------------------
  // PREDICT COMBINED RISK
  // ----------------------------
  void predict() async {
    double bmi = double.parse(bmiController.text);
    double waist = double.parse(waistController.text);
    double hip = double.parse(hipController.text);
    double neck = double.parse(neckController.text);
    double whr = double.parse(whrController.text);
    double wher = double.parse(wherController.text);
    double tg = double.parse(tgController.text);
    double hdl = double.parse(hdlController.text);
    double glucose = double.parse(glucoseController.text);
    double tyg = double.parse(tygController.text);
    double spise = double.parse(spiseController.text);
    double aip = double.parse(aipController.text);
    double tghdl = double.parse(tghdlController.text);

    double result = await ApiService.predictCombined(
        bmi, waist, hip, neck, whr, wher, glucose, hdl, tg, tyg, spise, aip, tghdl);

    setState(() {
      risk = result;
    });
  }

  // ----------------------------
  // CLEAR ALL FIELDS
  // ----------------------------
  void clearFields() {
    // Anthropometric
    heightController.clear();
    weightController.clear();
    waistController.clear();
    hipController.clear();
    neckController.clear();
    bmiController.clear();
    whrController.clear();
    wherController.clear();

    // Biochemical
    tgController.clear();
    hdlController.clear();
    glucoseController.clear();
    tygController.clear();
    tghdlController.clear();
    aipController.clear();
    spiseController.clear();

    setState(() {
      risk = null;
    });
  }

  // ----------------------------
  // RISK COLOR / LABEL / MESSAGE
  // ----------------------------
  Color getRiskColor(double value) {
    if (value < 0.3) return Colors.green;
    if (value < 0.6) return Colors.orange;
    return Colors.red;
  }

  String getRiskLabel(double value) {
    if (value < 0.3) return "Low Risk";
    if (value < 0.6) return "Moderate Risk";
    return "High Risk";
  }

  String getRiskMessage(double value) {
    if (value < 0.3) {
      return "Combined anthropometric and biochemical parameters fall within favourable ranges suggesting low cardiometabolic risk.";
    } else if (value < 0.6) {
      return "Some anthropometric and biochemical indicators are approaching higher-risk ranges. \n"
      "Improving body composition and lipid profile may reduce future metabolic risk.";
    } else {
      return "Combined body composition and metabolic markers indicate increased cardiometabolic risk driven by central adiposity and insulin resistance indicators. "
          "\nLifestyle and clinical monitoring are recommended.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Combined Risk Assessment")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // -------------------
            // ANTHROPOMETRIC INPUTS
            // -------------------
            TextField(
              controller: heightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Height (cm)"),
              onChanged: (v) => calculateBMI(),
            ),
            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Weight (kg)"),
              onChanged: (v) => calculateBMI(),
            ),
            TextField(
              controller: bmiController,
              readOnly: true,
              decoration: InputDecoration(labelText: "BMI"),
            ),
            TextField(
              controller: waistController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Waist Circumference"),
              onChanged: (v) {
                calculateWHR();
                calculateWHER();
              },
            ),
            TextField(
              controller: hipController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Hip Circumference"),
              onChanged: (v) => calculateWHR(),
            ),
            TextField(
              controller: neckController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Neck Circumference"),
            ),
            TextField(
              controller: whrController,
              readOnly: true,
              decoration: InputDecoration(labelText: "Waist-Hip Ratio"),
            ),
            TextField(
              controller: wherController,
              readOnly: true,
              decoration: InputDecoration(labelText: "Waist-Height Ratio"),
            ),

            SizedBox(height: 20),

            // -------------------
            // BIOCHEMICAL INPUTS
            // -------------------
            TextField(
              controller: tgController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Triglycerides"),
              onChanged: (v) => calculateBioIndices(),
            ),
            TextField(
              controller: hdlController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "HDL"),
              onChanged: (v) => calculateBioIndices(),
            ),
            TextField(
              controller: glucoseController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Glucose"),
              onChanged: (v) => calculateBioIndices(),
            ),
            TextField(
              controller: tygController,
              readOnly: true,
              decoration: InputDecoration(labelText: "TyG Index"),
            ),
            TextField(
              controller: tghdlController,
              readOnly: true,
              decoration: InputDecoration(labelText: "TG / HDL Ratio"),
            ),
            TextField(
              controller: aipController,
              readOnly: true,
              decoration: InputDecoration(labelText: "AIP"),
            ),
            TextField(
              controller: spiseController,
              readOnly: true,
              decoration: InputDecoration(labelText: "SPISE Index"),
            ),

            SizedBox(height: 20),

            // -------------------
            // BUTTONS
            // -------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: predict, child: Text("Predict")),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: clearFields,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  child: Text("Clear"),
                ),
              ],
            ),

            SizedBox(height: 30),

            // -------------------
            // RESULT
            // -------------------
            if (risk != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "${getRiskLabel(risk!)}: ${risk!.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: getRiskColor(risk!),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    getRiskMessage(risk!),
                    textAlign: TextAlign.center,
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