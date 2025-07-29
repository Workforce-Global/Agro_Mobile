import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<void> requestAllPermissions() async {
    await [
      Permission.camera,
      Permission.storage,
      Permission.locationWhenInUse,
    ].request();
  }
}
