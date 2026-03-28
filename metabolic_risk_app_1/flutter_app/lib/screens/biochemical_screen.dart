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
  final tghdlController = TextEditingController();
  final aipController = TextEditingController();
  final spiseController = TextEditingController();

  double? risk;

  void calculateIndices() {
    if (tgController.text.isEmpty || hdlController.text.isEmpty || glucoseController.text.isEmpty) return;

    double tg = double.parse(tgController.text);
    double hdl = double.parse(hdlController.text);
    double glucose = double.parse(glucoseController.text);

    tygController.text = log((tg * glucose) / 2).toStringAsFixed(3);
    tghdlController.text = (tg / hdl).toStringAsFixed(3);
    aipController.text = (log(tg / hdl) / ln10).toStringAsFixed(3);
    spiseController.text = (600 * pow(hdl, 0.185) / pow(tg, 0.2)).toStringAsFixed(3);
  }

  void predict() async {
    double result = await ApiService.predictBio(
      double.parse(glucoseController.text),
      double.parse(hdlController.text),
      double.parse(tgController.text),
      double.parse(tygController.text),
      double.parse(spiseController.text),
      double.parse(aipController.text),
      double.parse(tghdlController.text),
    );
    setState(() => risk = result);
  }

  void clearFields() {
    [tgController, hdlController, glucoseController, tygController, tghdlController, aipController, spiseController].forEach((c) => c.clear());
    setState(() => risk = null);
  }

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
    if (value < 0.3) return "Biochemical markers are in healthy ranges.";
    if (value < 0.6) return "Some markers approaching higher-risk; optimize lifestyle.";
    return "High risk! Dyslipidemia & insulin resistance markers elevated.";
  }

  Widget buildInputCard(String label, TextEditingController controller,
      {IconData? icon, bool readOnly = false, Function(String)? onChanged}) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      padding: EdgeInsets.all(4),
      margin: EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: controller.text.isEmpty ? Colors.grey : Colors.green, width: 2),
      ),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          prefixIcon: icon != null ? Icon(icon) : null,
          labelText: label,
          border: InputBorder.none,
        ),
        onChanged: onChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Biochemical Risk")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            buildInputCard("Triglycerides", tgController, icon: Icons.opacity, onChanged: (_) => calculateIndices()),
            buildInputCard("HDL", hdlController, icon: Icons.health_and_safety, onChanged: (_) => calculateIndices()),
            buildInputCard("Glucose", glucoseController, icon: Icons.bloodtype, onChanged: (_) => calculateIndices()),
            buildInputCard("TyG Index", tygController, icon: Icons.show_chart, readOnly: true),
            buildInputCard("TG / HDL", tghdlController, icon: Icons.stacked_line_chart, readOnly: true),
            buildInputCard("AIP", aipController, icon: Icons.bar_chart, readOnly: true),
            buildInputCard("SPISE Index", spiseController, icon: Icons.insights, readOnly: true),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Colors.green, Colors.lightGreenAccent]),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.greenAccent.withOpacity(0.4), blurRadius: 8, offset: Offset(0, 4))],
                    ),
                    child: ElevatedButton(
                      onPressed: predict,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent, padding: EdgeInsets.symmetric(vertical: 16)),
                      child: Text("Predict", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Colors.grey, Colors.blueGrey]),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ElevatedButton(
                      onPressed: clearFields,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent, padding: EdgeInsets.symmetric(vertical: 16)),
                      child: Text("Clear", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            if (risk != null)
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: risk!),
                duration: Duration(seconds: 1),
                builder: (context, value, child) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 120,
                        width: 120,
                        child: CircularProgressIndicator(
                          value: value,
                          strokeWidth: 12,
                          color: getRiskColor(value),
                          backgroundColor: Colors.grey[300],
                        ),
                      ),
                      SizedBox(height: 16),
                      AnimatedOpacity(
                        opacity: 1,
                        duration: Duration(milliseconds: 800),
                        child: Text(getRiskLabel(value), style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: getRiskColor(value))),
                      ),
                      SizedBox(height: 8),
                      AnimatedOpacity(
                        opacity: 1,
                        duration: Duration(milliseconds: 800),
                        child: Text(getRiskMessage(value), textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: getRiskColor(value))),
                      ),
                    ],
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}