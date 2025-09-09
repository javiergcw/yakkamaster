import 'package:get/get.dart';
import '../data/digital_id_dto.dart';

class DigitalIdController extends GetxController {
  final Rx<DigitalIdDto?> digitalIdData = Rx<DigitalIdDto?>(null);
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadDigitalIdData();
  }

  void loadDigitalIdData() {
    isLoading.value = true;
    
    // Simular carga de datos
    Future.delayed(const Duration(milliseconds: 500), () {
      digitalIdData.value = DigitalIdDto(
        id: '1',
        name: 'Testing Testing',
        avatarUrl: '', // Usaremos un avatar por defecto
        qrCodeData: 'https://yakka.com/profile/testing123',
        identificationNumber: 'ID123456789',
      );
      isLoading.value = false;
    });
  }

  void shareDigitalId() {
    // TODO: Implementar funcionalidad de compartir pantalla
    print('Sharing Digital ID: ${digitalIdData.value?.id}');
    // Esta funcionalidad se implementará en la pantalla para capturar la vista
  }
}
