import 'package:get/get.dart';
import '../../screens/labour/create_profile_labour/logic/controllers/industry_selection_controller.dart';
import '../../screens/labour/create_profile_labour/logic/controllers/create_profile_controller.dart';
import '../../screens/labour/create_profile_labour/logic/controllers/skills_experience_controller.dart';
import '../../screens/labour/create_profile_labour/logic/controllers/location_controller.dart';
import '../../screens/labour/create_profile_labour/logic/controllers/previous_employer_controller.dart';
import '../../screens/labour/create_profile_labour/logic/controllers/documents_controller.dart';
import '../../screens/labour/create_profile_labour/logic/controllers/respect_controller.dart';
import '../../screens/labour/create_profile_labour/logic/controllers/lets_be_clear_controller.dart';
import '../../screens/labour/create_profile_labour/logic/controllers/profile_created_controller.dart';
import '../../screens/labour/home/logic/controllers/home_screen_controller.dart';
import '../../screens/labour/home/logic/controllers/profile_screen_controller.dart';
import '../../screens/labour/home/logic/controllers/messages_screen_controller.dart';
import '../../screens/labour/home/logic/controllers/notifications_screen_controller.dart';
import '../../screens/labour/home/logic/controllers/applied_jobs_screen_controller.dart';
import '../../screens/labour/home/logic/controllers/wallet_screen_controller.dart';
import '../../screens/labour/home/logic/controllers/invoice_screen_controller.dart';
import '../../screens/labour/home/logic/controllers/chat_screen_controller.dart';
import '../../screens/labour/home/logic/controllers/edit_bank_details_controller.dart';
import '../../screens/labour/home/logic/controllers/edit_bank_details_no_payid_controller.dart';
import '../../screens/labour/home/logic/controllers/edit_documents_controller.dart';
import '../../screens/labour/home/logic/controllers/edit_personal_details_controller.dart';
import '../../screens/labour/home/logic/controllers/pdf_viewer_controller.dart';
import '../../screens/labour/home/logic/digital_id_controller.dart';

class LabourBinding extends Bindings {
  @override
  void dependencies() {
    // Inyectar controladores de create profile
    Get.lazyPut<IndustrySelectionController>(() => IndustrySelectionController());
    Get.lazyPut<CreateProfileController>(() => CreateProfileController());
    Get.lazyPut<SkillsExperienceController>(() => SkillsExperienceController());
    Get.lazyPut<LocationController>(() => LocationController());
    Get.lazyPut<PreviousEmployerController>(() => PreviousEmployerController());
    Get.lazyPut<DocumentsController>(() => DocumentsController());
    Get.lazyPut<RespectController>(() => RespectController());
    Get.lazyPut<LetsBeClearController>(() => LetsBeClearController());
    Get.lazyPut<ProfileCreatedController>(() => ProfileCreatedController());
    Get.lazyPut<HomeScreenController>(() => HomeScreenController());
    Get.lazyPut<ProfileScreenController>(() => ProfileScreenController());
    Get.lazyPut<MessagesScreenController>(() => MessagesScreenController());
    Get.lazyPut<NotificationsScreenController>(() => NotificationsScreenController());
    Get.lazyPut<AppliedJobsScreenController>(() => AppliedJobsScreenController());
    Get.lazyPut<WalletScreenController>(() => WalletScreenController());
    Get.lazyPut<InvoiceScreenController>(() => InvoiceScreenController());
    Get.lazyPut<ChatScreenController>(() => ChatScreenController());
    Get.lazyPut<EditBankDetailsController>(() => EditBankDetailsController());
    Get.lazyPut<EditBankDetailsNoPayIdController>(() => EditBankDetailsNoPayIdController());
    Get.lazyPut<EditDocumentsController>(() => EditDocumentsController());
    Get.lazyPut<EditPersonalDetailsController>(() => EditPersonalDetailsController());
    Get.lazyPut<PdfViewerController>(() => PdfViewerController());
    Get.lazyPut<DigitalIdController>(() => DigitalIdController());
  }
}
