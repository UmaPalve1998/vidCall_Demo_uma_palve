import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/user_call_controller.dart';

class UserListScreen extends StatefulWidget {
  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final UserController ctrl = Get.put(UserController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    load();
  }

  load() async {
    await ctrl.fetchUsers();
    print("user l ${ctrl.users.length}");
  }

  @override
  Widget build(BuildContext context) {
    return  Container(
        height: MediaQuery.of(context).size.height / 1.5,
          child: Obx(() {

            return  (ctrl.isLoadingList.value)
            ?Center(child: CircularProgressIndicator()) :ListView.builder(
              itemCount: ctrl.users.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final user = ctrl.users[index];
                print("use ${user.name}");
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user.avatar),
                  ),
                  title: Text(user.name),
                );
              },
            );
          }),

    );
  }
}
