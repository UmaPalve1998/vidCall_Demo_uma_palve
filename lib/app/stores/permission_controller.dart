import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart'; // For location services and fetching location

class PermissionService extends GetxController {
  // Method to check and request permissions
  Future<void> checkAndRequestPermission(Permission permission) async {
    // Check current status of the permission
    var status = await permission.status;

    // If permission is not granted, request it
    if (!status.isGranted) {
      status = await permission.request();

      if (status.isGranted) {
        print("${permission.toString()} permission granted");
      } else if (status.isDenied) {
        print("${permission.toString()} permission denied");
      } else if (status.isPermanentlyDenied) {
        print("${permission.toString()} permission permanently denied");
        // Optionally, navigate to app settings
        openAppSettings();
      }
    } else {
      print("${permission.toString()} permission already granted");
    }
  }

  // Method to request permissions based on type
  Future<void> requestPermissions(String permissionType) async {
    switch (permissionType) {
      case 'location':
        await checkAndRequestPermission(Permission.location);
        break;
      case 'camera':
        await checkAndRequestPermission(Permission.camera);
        break;
      case 'storage':
        await checkAndRequestPermission(Permission.storage);
        break;
      case 'microphone':
        await checkAndRequestPermission(Permission.microphone);
        break;
      case 'notification':
        await checkAndRequestPermission(Permission.notification);
        break;
      default:
        print("Unknown permission type");
    }
  }

  Future<Position?> getCurrentLocation() async {
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationServiceEnabled) {
      // Trigger the system popup to enable location services (Uber-like prompt)
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        print("Location services are still disabled or permission not granted");
        return null;
      }
    }

    var status = await Permission.location.status;
    if (!status.isGranted) {
      await requestPermissions('location');
      status = await Permission.location.status;
    }
    if (status.isGranted) {
      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        return position;
      } catch (e) {
        print("Failed to fetch location: $e");
        return null;
      }
    } else {
      print("Location permission not granted");
      return null;
    }
  }

  String message = "";
  Future<bool> checkLocation() async {
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationServiceEnabled) {
      message = "Location services are still disabled Pease enabled and try";
      update();
      return false;
    } else {
      return true;
    }
  }
}
