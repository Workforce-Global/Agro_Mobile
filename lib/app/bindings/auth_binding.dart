// auth_binding.dart
// TODO: Implement AuthBinding class
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../../services/shared_prefs_service.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.putAsync(() => SharedPrefsService.instance.init().then((_) => SharedPrefsService.instance));
    Get.put<AuthController>(AuthController(), permanent: true);
  }
}
