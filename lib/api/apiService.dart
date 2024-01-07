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

  Future<List<Animal>> fetchAnimalsByType(String type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    String url = type == 'All' ? '$baseUrl/dairy/api/animals/' : '$baseUrl/dairy/api/animals/?type=$type';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Token $token",
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> animalsJson = json.decode(response.body) as List;
      return animalsJson.map((json) => Animal.fromJson(json)).toList();
    } else {
      print('Failed to load animals with status code: ${response.statusCode}');
      throw Exception('Failed to load animals with status code: ${response.statusCode}');
    }
  }

  Future<List<Map<String, dynamic>>> fetchAnimalTypes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    final response = await http.get(
      Uri.parse('$baseUrl/dairy/api/animal_types/'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Token $token",
      },
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      print('Failed to load animal types with status code: ${response.statusCode}');
      throw Exception('Failed to load animal types');
    }
  }

  Future<List<MilkingData>> fetchMilkingData(int animalId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    final response = await http.get(
      Uri.parse('$baseUrl/dairy/api/milk_records/$animalId/'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Token $token",
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> milkRecordsJson = json.decode(response.body) as List;
      return milkRecordsJson.map((json) => MilkingData.fromJson(json)).toList();
    } else {
      print('Failed to load milking data with status code: ${response.statusCode}');
      throw Exception('Failed to load milking data with status code: ${response.statusCode}');
    }
  }







}
