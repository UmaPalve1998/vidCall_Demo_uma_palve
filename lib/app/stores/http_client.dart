import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:video/app/stores/rest_apis_urls.dart';
import '../utils/helpers/common_message.dart';
import '../utils/shared_prefernce.dart';
import 'app_exception.dart';

import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class HttpClient {
  // Singleton instance
  // static final HttpClient _singleton = HttpClient._internal();
  // factory HttpClient() => _singleton;
  // HttpClient._internal();

  // static HttpClient get instance => _singleton;

  Future<String?> setFirebaseNotification() async {
    String? pushCode = '';

    // Don't disable auto-init as it's needed for Firebase messaging to work
    // await FirebaseMessaging.instance.setAutoInitEnabled(false);

    try {
      await FirebaseMessaging.instance
          .getToken()
          .then((String? _deviceToken) async {
        if (_deviceToken != null) {
          pushCode = _deviceToken;
          debugPrint("FCM Token obtained: $pushCode");
        } else {
          debugPrint("Failed to get FCM token");
        }
      });

      // Set foreground notification presentation options
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      debugPrint("Firebase notification setup completed. Token: $pushCode");
    } catch (e) {
      debugPrint("Error setting up Firebase notification: $e");
    }

    return pushCode;
  }

  // Check Internet Connectivity
  Future<bool> isConnected() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi;
  }

  // Common method to get headers
  Future<Map<String, String>> getHeaders() async {
    String? token = await SPManager.instance.getToken();
    print("from sp $token");
    return {
      'Content-Type': 'application/json; charset=UTF-8',
    };
  }

  // Method to process response
  dynamic _processResponse(http.Response response) {
    var responseJson = utf8.decode(response.bodyBytes);
    switch (response.statusCode) {
      case 200:
        return responseJson;
      case 201:
        return responseJson;
      case 400:
        throw BadRequestException(
            responseJson, response.request!.url.toString());
      case 401:
        _handleSessionExpiry();
        throw UnAuthorizedException(
            responseJson, response.request!.url.toString());
      case 403:
        _handleSessionExpiry();
        throw UnAuthorizedException(
            responseJson, response.request!.url.toString());
      case 404:
        throw FetchDataException(
            "Resource not found", response.request!.url.toString());
      case 500:
      default:
        throw FetchDataException(
            "Error occurred with code : ${response.statusCode}",
            response.request!.url.toString());
    }
  }

  dynamic _processResponseDoc(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return base64.encode(response.bodyBytes); // For images/PDFs
      case 400:
      case 401:
      case 403:
        return _processResponse(
            response); // Reuse the same logic for non-binary responses
      case 500:
      default:
        throw FetchDataException(
            "Error occurred with code : ${response.statusCode}",
            response.request!.url.toString());
    }
  }

  // Get Request
  Future<dynamic> get(String endPoint) async {
    var uri = Uri.parse( endPoint);
    var headers = await getHeaders();
    if (!await isConnected()) {
      CommonMessage.showsnackBar("Make sure you have an internet connection.");
      return null;
    }

    try {
      final response = await http
          .get(uri, headers:    {'Accept': 'application/json'},)
          .timeout(const Duration(minutes: 5));
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException("No Internet Connection", uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
          "API not responded in time", uri.toString());
    }
  }

  // Post Request
  Future<dynamic> post(String endPoint, dynamic body) async {
    var uri = Uri.parse(RestApisUrls.BASE_URL + endPoint);
    print("body from Http client ${body}");
    var headers = await getHeaders();
    if (!await isConnected()) {
      CommonMessage.showsnackBar("No Internet Connection");
      return null;
    }
    try {
      final response = await http
          .post(uri, body: jsonEncode(body), headers: headers)
          .timeout(const Duration(seconds: 60));
      print(response.body);
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException("No Internet Connection", uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
          "API not responded in time", uri.toString());
    }
  }

  Future<dynamic> multipartForm({
    required String endPoint,
    required Map<String, String> fields,
    required List<http.MultipartFile> files,
  }) async {
    if (!await isConnected()) {
      CommonMessage.showsnackBar("No Internet Connection");
      return null;
    }

    var uri = Uri.parse(RestApisUrls.BASE_URL + endPoint);
    var headers = await getHeaders();

    try {
      var request = http.MultipartRequest('POST', uri)
        ..headers.addAll(headers)
        ..fields.addAll(fields);

      for (var file in files) {
        request.files.add(file);
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return _processResponse(response);
      } else {
        print("Multipart request failed: ${response.body}");
        throw Exception("Failed to upload data");
      }
    } catch (e) {
      print("Error in multipart form upload: $e");
      throw Exception("Multipart form upload failed");
    }
  }

  // Put Request
  Future<dynamic> put(String endPoint, dynamic body) async {
    var uri = Uri.parse(RestApisUrls.BASE_URL + endPoint);
    var headers = await getHeaders();
    if (!await isConnected()) {
      CommonMessage.showsnackBar("No Internet Connection");
      return null;
    }

    try {
      final response = await http
          .put(uri, body: jsonEncode(body), headers: headers)
          .timeout(const Duration(seconds: 60));
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException("No Internet Connection", uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
          "API not responded in time", uri.toString());
    }
  }

  // Delete Request
  Future<dynamic> delete(String endPoint, dynamic body) async {
    var uri = Uri.parse(RestApisUrls.BASE_URL + endPoint);
    var headers = await getHeaders();
    if (!await isConnected()) {
      CommonMessage.showsnackBar("No Internet Connection");
      return null;
    }

    try {
      final response = await http
          .delete(uri, body: jsonEncode(body), headers: headers)
          .timeout(const Duration(seconds: 60));
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException("No Internet Connection", uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
          "API not responded in time", uri.toString());
    }
  }

  // Get Image Request
  Future<dynamic> getImage(String baseUrl, String endPoint) async {
    var uri = Uri.parse(baseUrl + endPoint);
    var headers = await getHeaders();
    if (!await isConnected()) {
      CommonMessage.showsnackBar("No Internet Connection");
      return null;
    }

    try {
      final response = await http
          .get(uri, headers: headers)
          .timeout(const Duration(seconds: 25));
      return _processResponseDoc(response);
    } on SocketException {
      throw FetchDataException("No Internet Connection", uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
          "API not responded in time", uri.toString());
    }
  }

  // Get PDF Request
  Future<dynamic> getPDF(String url) async {
    var uri = Uri.parse(url);
    var headers = await getHeaders();
    if (!await isConnected()) {
      CommonMessage.showsnackBar("No Internet Connection");
      return null;
    }

    try {
      final response = await http
          .get(uri, headers: headers)
          .timeout(const Duration(seconds: 25));
      return _processResponseDoc(response);
    } on SocketException {
      throw FetchDataException("No Internet Connection", uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
          "API not responded in time", uri.toString());
    }
  }

  void _handleSessionExpiry() async {
    // Show a snackbar message or alert
    CommonMessage.showsnackBar("Session Expired. Please log in again.");

    // Clear stored session data (e.g., token)
    await SPManager.instance.clearLoginSp();

    // Navigate to the login screen (adjust navigation logic if using a different package)
    Future.delayed(const Duration(seconds: 1), () {
      // Use your navigation logic (GetX example below)
      // Get.offAll(() => const LoginScreen());
    });
  }
}
