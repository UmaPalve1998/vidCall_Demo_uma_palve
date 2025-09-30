
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import '../shared_prefernce.dart';

push(BuildContext context, Widget destination) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => destination));
}

pushAndRemoveUntil(BuildContext context, Widget destination, bool predict) {
  Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => destination),
      (Route<dynamic> route) => predict);
}

pushReplacement(BuildContext context, Widget destination) {
  Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (context) => destination));
}

pushWithNavbar(BuildContext context, Widget destination) {
  PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
    context,
    settings: const RouteSettings(name: "Drawer"),
    screen: destination,
    withNavBar: true,
    pageTransitionAnimation: PageTransitionAnimation.fade,
  );
}

void pushWithNavbar2(BuildContext context, Widget destination) {
  PersistentNavBarNavigator.pushNewScreen(
    context,
    screen: destination,
    withNavBar: true, // Ensures navbar stays
    pageTransitionAnimation: PageTransitionAnimation.fade,
  );
}

Future<bool> logout() async {
  bool logout = await SPManager.instance.clearLoginSp();
  await SPManager.instance.logout();
  print("${logout} logout!");

  return logout;
}
