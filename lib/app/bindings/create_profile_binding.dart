import 'package:get/get.dart';
import '../../screens/builder/create_profile_builder/logic/controllers/create_profile_builder_controller.dart';
import '../../screens/builder/create_profile_builder/logic/controllers/employee_selection_controller.dart';
import '../../screens/builder/create_profile_builder/logic/controllers/register_new_company_controller.dart';
import '../../screens/builder/create_profile_builder/logic/controllers/lets_be_clear_controller.dart';
import '../../screens/builder/create_profile_builder/logic/controllers/profile_created_controller.dart';

class CreateProfileBinding extends Bindings {
  @override
  void dependencies() {
    // Inyectar controladores del módulo create profile
    Get.lazyPut<CreateProfileBuilderController>(() => CreateProfileBuilderController());
    Get.lazyPut<EmployeeSelectionController>(() => EmployeeSelectionController());
    Get.lazyPut<RegisterNewCompanyController>(() => RegisterNewCompanyController());
    Get.lazyPut<LetsBeClearController>(() => LetsBeClearController());
    Get.lazyPut<ProfileCreatedController>(() => ProfileCreatedController());
  }
}
