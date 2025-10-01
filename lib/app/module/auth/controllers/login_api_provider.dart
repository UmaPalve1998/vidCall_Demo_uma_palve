import 'dart:convert';
import 'package:video/app/module/auth/models/auth_model.dart';
import 'package:video/app/stores/http_client.dart';

import 'package:video/app/utils/shared_prefernce.dart';

import '../../../stores/app_exception.dart';
import '../../../stores/rest_apis_urls.dart';

class LoginApiProvider {
  final HttpClient _httpClient = HttpClient();

  Future<LoginResponse> userLogin(String userName, String password) async {
    var pushCode = await _httpClient.setFirebaseNotification();
    final response = await _httpClient.post(RestApisUrls.authURL, {
      "email": userName,
      "password": password,
    });
    if (response != null) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response);
      final loginResponse = LoginResponse.fromJson(jsonResponse);
      print("FCM code $pushCode");
      if (loginResponse.access_token != null) {
        await SPManager.instance
            .setToken(loginResponse.access_token!); // Example of saving the token
      }

      return loginResponse;
    } else {
      throw FetchDataException("Failed to login", RestApisUrls.authURL);
    }
  }
}
