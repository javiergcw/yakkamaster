import 'package:get/get.dart';
import 'api_service.dart';

/// Binding para inicializar el servicio de API
class ApiServiceBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ApiService>(ApiService(), permanent: true);
  }
}
