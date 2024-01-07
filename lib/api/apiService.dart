import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'models.dart';

class ApiService {
  final String baseUrl = "http://farmapp.channab.com/";

  Future<Map<String, dynamic>?> loginUser(String mobileNumber, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/accounts/api/login/'),
      body: {
        'username': mobileNumber,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      String? token = data['token'];  // Assuming the token is returned with the key 'token'
      if (token != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
      }
      return data;
    }
  }


  Future<List<Animal>> fetchAnimals(int page) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    final response = await http.get(
      Uri.parse('$baseUrl/dairy/api/animals/'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Token $token",
      },
    );

    if (response.statusCode == 200) {
      // Directly decode the response body as a list
      List<dynamic> animalsJson = json.decode(response.body) as List;
      // Map each item in the list to an Animal object
      return animalsJson.map((json) => Animal.fromJson(json)).toList();
    } else {
      print('Failed to load animals with status code: ${response.statusCode}');
      throw Exception('Failed to load animals with status code: ${response.statusCode}');
    }
  }





}
