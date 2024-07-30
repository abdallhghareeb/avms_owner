import 'dart:convert';

import 'package:avms/services/api_service/end_point.dart';
import 'package:http/http.dart' as http;

class ApiServer{

  void fetchData() async {
    var url = Uri.parse('your_api_endpoint_here'); // Replace with your actual API endpoint

    try {
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        // Request body can be empty if not needed
        body: jsonEncode({
          "username": "example_username",
          "password": "example_password",
          // Include other fields as needed
        }),
      );

      if (response.statusCode == 200) {
        // Successful response handling
        var responseData = jsonDecode(response.body);
        var confirmMessage = responseData['data']['confirmMessage'];
        print('Confirm message: $confirmMessage');
      } else {
        // Error handling
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception details: $e');
    }
  }
}