import 'dart:async';
import 'dart:convert';
import 'package:blacklist/core/constants.dart';
import 'package:http/http.dart' as http;

class APIService {
  static Future<dynamic> getEmployeesList() async {
    final String url = "${Constants.baseUrl}/employees";

    try {
      http.Response response = await http
          .get(
            Uri.parse(url),
            headers: <String, String>{
              "Content-Type": "application/json",
              "Accept": "application/json",
            },
          )
          .timeout(
            Duration(seconds: 30),
            onTimeout: () {
              throw TimeoutException("The connection has timed out");
            },
          );
      return json.decode(response.body);
    } catch (e) {
      return null;
    }
  }
}
