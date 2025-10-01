import 'dart:convert';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../../auth/controllers/login_api_provider.dart';
import '../models/user_info_model.dart';

class UserController extends GetxController {
  RxList<User> users = <User>[].obs;
  RxBool isLoading = true.obs;

  late Box<User> userBox;

  @override
  void onInit() async {
    super.onInit();
    userBox = await Hive.openBox<User>('users');
  }
  final LoginApiProvider apiProvider = LoginApiProvider();
  Future<void> fetchUsers() async {
    isLoading.value = true;
  users.clear();
    try {
      final response = await http.get(Uri.parse("https://jsonplaceholder.typicode.com/users"),headers:    {'Accept': 'application/json'},);
      if (response.statusCode == 200) {

        final List<dynamic> data = json.decode(response.body);
        for(int i=0;i<data.length;i++){
          User u = User(
            id: data[i]['id'],
            name: data[i]['name'],
            avatar: "https://i.pravatar.cc/150?img=${data[i]['id']}",
          );
          users.value.insert(users.length, u);
          print("user ${users[i].name}");

        }
        print("useList ${  users.value}");
        update();
        print("useList ${  users.value}");
      } else {
        loadFromCache();
      }
    } catch (e) {
      loadFromCache();
    }finally{
      isLoading.value = false;
      update();
    }


  }

  void loadFromCache() {
    users.value = userBox.values.toList();
  }
}
