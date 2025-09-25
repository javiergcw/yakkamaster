import 'package:get/get.dart';
import '../../screens/builder/create_profile_builder/logic/controllers/create_profile_builder_controller.dart';
import '../../screens/builder/create_profile_builder/logic/controllers/employee_selection_controller.dart';
import '../../screens/builder/create_profile_builder/logic/controllers/register_company_controller.dart';

class CreateProfileBinding extends Bindings {
  @override
  void dependencies() {
    // Inyectar controladores del módulo create profile
    Get.put<CreateProfileBuilderController>(CreateProfileBuilderController(), tag: 'builder_profile');
    Get.lazyPut<EmployeeSelectionController>(() => EmployeeSelectionController());
    Get.lazyPut<RegisterCompanyController>(() => RegisterCompanyController());
  }
}
