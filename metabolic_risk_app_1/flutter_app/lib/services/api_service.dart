import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {

  static const baseUrl = "http://localhost:8000";

  // -----------------------------
  // Anthropometric Model
  // -----------------------------
  static Future<double> predictAnthro(
        double bmi,
        double waist,
        double hip,
        double neck,
        double whr,
        double wher) async {

    final response = await http.post(
      Uri.parse("$baseUrl/predict_anthro"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "BMI": bmi,
        "Waist": waist,
        "WHR": whr,
        "neck": neck,
        "Hip": hip,
        "wher": wher
      }),
    );
    print("Status: ${response.statusCode}");
    print("Body: ${response.body}");
    final data = jsonDecode(response.body);
    return (data["risk"][0]).toDouble();
  }

  // -----------------------------
  // Biochemical Model
  // -----------------------------
  static Future<double> predictBio(
      double tg,
      double hdl,
      double glucose,
      double tyg,
      double spise,
      double aip,
      double tghdl) async {

    final response = await http.post(
      Uri.parse("$baseUrl/predict_bio"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "TG": tg,
        "HDL": hdl,
        "Glucose": glucose,
        "tyg": tyg,
        "spise": spise,
        "aip": aip,
        "tghdl": tghdl
      }),
    );

    final data = jsonDecode(response.body);
    return (data["risk"][0]).toDouble();
  }

  // -----------------------------
  // Combined Model
  // -----------------------------
  static Future<double> predictCombined(
      double bmi,
      double waist,
      double hip,
      double neck,
      double whr,
      double wher,
      double glucose,
      double hdl,
      double tg,
      double tyg,
      double spise,
      double aip,
      double tghdl
      ) async {

    final response = await http.post(
      Uri.parse("$baseUrl/predict_combined"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "BMI": bmi,
        "Waist": waist,
        "WHR": whr,
        "Neck": neck,
        "Hip": hip,
        "wher": wher,
        "TG": tg,
        "HDL": hdl,
        "Glucose": glucose,
        "TyG": tyg,
        "SPISE": spise,
        "AIP": aip,
        "TGHDL": tghdl
      }),
    );

    final data = jsonDecode(response.body);
    return (data["risk"][0]).toDouble();
  }
}