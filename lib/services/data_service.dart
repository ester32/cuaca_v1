import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:cuaca_v1/dto/news.dart';
import 'package:cuaca_v1/endpoints/endpoints.dart';

class DataService {
  static Future<List<News>> fetchNews() async {
    final response = await http.get(Uri.parse(Endpoints.news));
    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((item) => News.fromJson(item)).toList();
    } else {
      // Handle error
      throw Exception('Failed to load news');
    }
  }
}
