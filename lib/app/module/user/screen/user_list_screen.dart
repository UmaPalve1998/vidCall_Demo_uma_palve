import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/video_call_controller.dart';

class UserListScreen extends StatelessWidget {
  final UserController ctrl = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height / 2,
        color: Colors.red,
        child: Obx(() {
          if (ctrl.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: ctrl.users.length,
            itemBuilder: (context, index) {
              final user = ctrl.users[index];
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
