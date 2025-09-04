import 'package:get/get.dart';
import '../../screens/login/logic/controllers/login_controller.dart';
import '../../screens/login/logic/controllers/email_login_controller.dart';
import '../../screens/login/logic/controllers/stepper_selection_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    // Inyectar controladores del módulo login
    Get.lazyPut<LoginController>(() => LoginController());
    Get.lazyPut<EmailLoginController>(() => EmailLoginController());
    Get.lazyPut<StepperSelectionController>(() => StepperSelectionController());
  }
}
