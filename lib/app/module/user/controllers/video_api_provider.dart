import 'dart:convert';
import 'package:video/app/module/auth/models/auth_model.dart';
import 'package:video/app/stores/http_client.dart';

import 'package:video/app/utils/shared_prefernce.dart';

import '../../../stores/app_exception.dart';
import '../../../stores/rest_apis_urls.dart';
import 'package:http/http.dart' as http;

class VideoProvider {
  final HttpClient _httpClient = HttpClient();

  Future<String> getUser() async {
    final response = await _httpClient.get("https://jsonplaceholder.typicode.com/users");
    if (response.statusCode == 200) {
      print("token ${response.body}");
      return response.body; // token string
    } else {
      throw Exception("Failed to fetch token");
    }
  }
}
