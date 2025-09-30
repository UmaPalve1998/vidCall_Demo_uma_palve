import 'dart:convert';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../models/user_info_model.dart';

class UserController extends GetxController {
  RxList<User> users = <User>[].obs;
  RxBool isLoading = true.obs;

  late Box<User> userBox;

  @override
  void onInit() async {
    super.onInit();
    userBox = await Hive.openBox<User>('users');
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    isLoading.value = true;

    try {
      final response = await http.get(Uri.parse("https://jsonplaceholder.typicode.com/users"));
      print("useList ${response.body}");
      if (response.statusCode == 200) {
        print("useList ${response.body}");
        final List<dynamic> data = json.decode(response.body);
        users.value = data.map((json) {
          // Use avatar placeholder
          return User(
            id: json['id'],
            name: json['name'],
            avatar: "https://i.pravatar.cc/150?img=${json['id']}",
          );
        }).toList();
print("useList ${users.value}");
        // Cache locally
        await userBox.clear();
        await userBox.addAll(users);
        update();

      } else {
        loadFromCache();
      }
    } catch (e) {
      loadFromCache();
    }

    isLoading.value = false;
  }

  void loadFromCache() {
    users.value = userBox.values.toList();
  }
}
