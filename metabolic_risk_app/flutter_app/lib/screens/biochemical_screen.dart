import 'dart:math';
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class BioScreen extends StatefulWidget {
  @override
  _BioScreenState createState() => _BioScreenState();
}

class _BioScreenState extends State<BioScreen> {

  final tgController = TextEditingController();
  final hdlController = TextEditingController();
  final glucoseController = TextEditingController();

  final tygController = TextEditingController();
  final spiseController = TextEditingController();
  final aipController = TextEditingController();
  final tghdlController = TextEditingController();

  double? risk;

  /*
  -----------------------------
  CALCULATE ALL INDICES
  -----------------------------
  */
  void calculateIndices() {

    if (tgController.text.isEmpty ||
        hdlController.text.isEmpty ||
        glucoseController.text.isEmpty) {
      return;
    }

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

  /*
  -----------------------------
  API PREDICTION
  -----------------------------
  */
  void predict() async {

    double tg = double.parse(tgController.text);
    double hdl = double.parse(hdlController.text);
    double glucose = double.parse(glucoseController.text);
    double tyg = double.parse(tygController.text);
    double spise = double.parse(spiseController.text);
    double aip = double.parse(aipController.text);
    double tghdl = double.parse(tghdlController.text);

    double result =
        await ApiService.predictBio(glucose, hdl, tg, tyg, spise, aip, tghdl);

    setState(() {
      risk = result;
    });
  }

  /*
  -----------------------------
  CLEAR
  -----------------------------
  */
  void clearFields() {

    tgController.clear();
    hdlController.clear();
    glucoseController.clear();
    tygController.clear();
    spiseController.clear();
    aipController.clear();
    tghdlController.clear();

    setState(() {
      risk = null;
    });
  }

  /*
  -----------------------------
  RESULT
  -----------------------------
  */
  Color getRiskColor(double risk) {
    if (risk < 0.3) return Colors.green;
    if (risk < 0.6) return Colors.orange; // yellowish for moderate
    return Colors.red;
  }

  String getRiskLabel(double risk) {
    if (risk < 0.3) return "Low Risk";
    if (risk < 0.6) return "Moderate Risk";
    return "High Risk";
  }

  // Helper to get risk message
  String getRiskMessage(double risk) {
    if (risk < 0.3) {
      return "Biochemical markers fall within lower-risk metabolic ranges. \n"
          "Current lipid and glucose profile does not suggest elevated cardiometabolic risk.";
    } else if (risk < 0.6) {
      return "Some biochemical markers are approaching higher-risk ranges, particularly indicators related "
          "to insulin resistance and lipid metabolism. \nLifestyle optimisation may help prevent progression.";
    } else {
      return "Biochemical indicators suggest increased metabolic risk driven by dyslipidemia and "
          "insulin resistance markers. \nClinical monitoring and lifestyle intervention are recommended.";
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text("Biochemical Risk")),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),

        child: Column(
          children: [

            /*
            TG
            */
            TextField(
              controller: tgController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Triglycerides"),
              onChanged: (v) => calculateIndices(),
            ),

            /*
            HDL
            */
            TextField(
              controller: hdlController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "HDL"),
              onChanged: (v) => calculateIndices(),
            ),

            /*
            GLUCOSE
            */
            TextField(
              controller: glucoseController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Glucose"),
              onChanged: (v) => calculateIndices(),
            ),

            /*
            AUTO CALCULATED
            */

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

            /*
            BUTTONS
            */

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

            SizedBox(height: 25),

            /*
            RESULT
            */

          if (risk != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "${getRiskLabel(risk!)}: ${risk!.toStringAsFixed(2)}",
                  textAlign: TextAlign.center,
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