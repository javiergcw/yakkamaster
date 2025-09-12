import 'package:get/get.dart';
import 'dart:io';
import '../../config/app_flavor.dart';

// Importar pantallas principales
import '../../screens/join_splash_screen.dart';

// Importar pantallas de login
import '../../screens/login/presentation/pages/login_screen.dart';
import '../../screens/login/presentation/pages/email_login_screen.dart';
import '../../screens/login/presentation/pages/stepper_selection_screen.dart';

// Importar pantallas de perfil
import '../../screens/labour/create_profile_labour/presentation/pages/industry_selection_screen.dart';
import '../../screens/labour/create_profile_labour/presentation/pages/create_profile_screen.dart';
import '../../screens/labour/create_profile_labour/presentation/pages/create_profile_step2_screen.dart';
import '../../screens/labour/create_profile_labour/presentation/pages/skills_experience_screen.dart';
import '../../screens/labour/create_profile_labour/presentation/pages/location_screen.dart';
import '../../screens/labour/create_profile_labour/presentation/pages/profile_photo_screen.dart';
import '../../screens/labour/create_profile_labour/presentation/pages/license_screen.dart';
import '../../screens/labour/create_profile_labour/presentation/pages/previous_employer_screen.dart';
import '../../screens/labour/create_profile_labour/presentation/pages/documents_screen.dart';
import '../../screens/labour/create_profile_labour/presentation/pages/respect_screen.dart';
import '../../screens/labour/create_profile_labour/presentation/pages/lets_be_clear_screen.dart';
import '../../screens/labour/create_profile_labour/presentation/pages/profile_created_screen.dart';
import '../../screens/builder/create_profile_builder/presentation/pages/create_profile_builder_screen.dart';
import '../../screens/builder/create_profile_builder/presentation/pages/create_profile_step2_builder_screen.dart';
import '../../screens/builder/create_profile_builder/presentation/pages/location_builder_screen.dart';
import '../../screens/builder/create_profile_builder/presentation/pages/profile_photo_builder_screen.dart';
import '../../screens/builder/create_profile_builder/presentation/pages/license_builder_screen.dart';
import '../../screens/builder/create_profile_builder/presentation/pages/employee_selection_screen.dart';
import '../../screens/builder/create_profile_builder/presentation/pages/register_new_company_screen.dart';
import '../../screens/builder/create_profile_builder/presentation/pages/respect_screen.dart'
    as builder_respect;
import '../../screens/builder/create_profile_builder/presentation/pages/lets_be_clear_screen.dart'
    as builder_lets_be_clear;
import '../../screens/builder/create_profile_builder/presentation/pages/profile_created_screen.dart'
    as builder_profile_created;

// Importar pantallas de builder
import '../../screens/builder/home/presentation/pages/builder_home_screen.dart';
import '../../screens/builder/home/presentation/pages/profile_screen.dart'
    as builder_profile;
import '../../screens/builder/home/presentation/pages/messages_screen.dart'
    as builder_messages;
import '../../screens/builder/home/presentation/pages/notifications_screen.dart'
    as builder_notifications;
import '../../screens/builder/home/presentation/pages/edit_personal_details_screen.dart';
import '../../screens/builder/home/presentation/pages/camera_with_overlay_screen.dart';
import '../../screens/builder/home/presentation/pages/job_sites_list_screen.dart';
import '../../screens/builder/home/presentation/pages/map_screen.dart';
import '../../screens/builder/home/presentation/pages/worker_list_screen.dart';
import '../../screens/builder/home/presentation/pages/chat_screen.dart'
    as builder_chat;

// Importar pantallas de post job
import '../../screens/builder/post_job/presentation/pages/post_job_stepper_screen.dart';
import '../../screens/builder/post_job/presentation/pages/job_sites_screen.dart';
import '../../screens/builder/post_job/presentation/pages/create_edit_job_site_screen.dart';
import '../../screens/builder/post_job/presentation/pages/post_job_review_screen.dart';
import '../../screens/builder/post_job/presentation/pages/project_overview_screen.dart';

// Importar pantallas de my jobs
import '../../screens/builder/my_jobs/presentation/pages/my_jobs_screen.dart';
import '../../screens/builder/post_job/presentation/pages/post_job_stepper_step2_screen.dart';
import '../../screens/builder/post_job/presentation/pages/post_job_stepper_step3_screen.dart';
import '../../screens/builder/post_job/presentation/pages/post_job_stepper_step4_screen.dart';
import '../../screens/builder/post_job/presentation/pages/post_job_stepper_step5_screen.dart';
import '../../screens/builder/post_job/presentation/pages/post_job_stepper_step6_screen.dart';
import '../../screens/builder/post_job/presentation/pages/post_job_stepper_step7_screen.dart';
import '../../screens/builder/post_job/presentation/pages/post_job_stepper_step8_screen.dart';

// Importar pantallas de invoices
import '../../screens/builder/invoices/presentation/pages/invoices_screen.dart';

// Importar pantallas de expenses
import '../../screens/builder/expenses/presentation/pages/expenses_screen.dart';
import '../../screens/builder/expenses/logic/bindings/expenses_binding.dart';
import '../../screens/builder/expenses/presentation/pages/filter_jobsites_screen.dart';
import '../../screens/builder/expenses/logic/bindings/filter_jobsites_binding.dart';
import '../../screens/builder/expenses/presentation/pages/custom_date_range_screen.dart';
import '../../screens/builder/expenses/logic/bindings/custom_date_range_binding.dart';

// Importar pantallas de staff
import '../../screens/builder/staff/presentation/pages/staff_screen.dart';
import '../../screens/builder/staff/presentation/pages/move_workers_stepper.dart';
import '../../screens/builder/staff/presentation/pages/extend_shifts_stepper.dart';
import '../../screens/builder/staff/presentation/pages/unhire_workers_stepper.dart';
import '../../screens/builder/staff/presentation/pages/worker_profile_screen.dart';

// Importar pantallas de applicants
import '../../screens/builder/applicants/presentation/pages/pages.dart';

// Importar pantallas de labour
import '../../screens/labour/home/presentation/pages/home_screen.dart';
import '../../screens/labour/home/presentation/pages/profile_screen.dart'
    as labour_profile;
import '../../screens/labour/home/presentation/pages/messages_screen.dart'
    as labour_messages;
import '../../screens/labour/home/presentation/pages/notifications_screen.dart'
    as labour_notifications;
import '../../screens/labour/home/presentation/pages/applied_jobs_screen.dart';
import '../../screens/labour/home/presentation/pages/wallet_screen.dart';
import '../../screens/labour/home/presentation/pages/invoice_screen.dart';
import '../../screens/labour/home/presentation/pages/chat_screen.dart'
    as labour_chat;
import '../../screens/labour/home/presentation/pages/digital_id_screen.dart';
import '../../screens/labour/home/presentation/pages/edit_bank_details_screen.dart';
import '../../screens/labour/home/presentation/pages/edit_bank_details_no_payid_screen.dart';
import '../../screens/labour/home/presentation/pages/edit_documents_screen.dart';
import '../../screens/labour/home/presentation/pages/edit_personal_details_screen.dart'
    as labour_edit_personal;
import '../../screens/labour/home/presentation/pages/pdf_viewer_screen.dart';

// Importar pantallas de job listings
import '../../screens/job_listings/presentation/pages/job_listings_screen.dart';
import '../../screens/job_listings/presentation/pages/job_details_screen.dart';
import '../../screens/job_listings/data/dto/job_details_dto.dart';

// Importar bindings
import '../bindings/login_binding.dart';
import '../bindings/join_splash_binding.dart';
import '../bindings/builder_binding.dart';
import '../bindings/create_profile_binding.dart';
import '../bindings/labour_binding.dart';
import '../bindings/job_listings_binding.dart';

abstract class AppPages {
  static const duration = Duration(milliseconds: 500);

  static final pages = [
    // ===== RUTAS GENERALES =====
    // Pantalla de selección de tipo de usuario
    GetPage(
      name: JoinSplashScreen.id,
      page: () => JoinSplashScreen(),
      binding: JoinSplashBinding(),
      transitionDuration: duration,
      transition: Transition.rightToLeft,
    ),

    // Rutas de Login (Compartidas)
    GetPage(
      name: LoginScreen.id,
      page: () => LoginScreen(),
      binding: LoginBinding(),
      transitionDuration: duration,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: EmailLoginScreen.id,
      page: () => EmailLoginScreen(),
      binding: LoginBinding(),
      transitionDuration: duration,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: StepperSelectionScreen.id,
      page: () => StepperSelectionScreen(),
      binding: LoginBinding(),
      transitionDuration: duration,
      transition: Transition.rightToLeft,
    ),

    // ===== RUTAS DE LABOUR =====
    // Labour - Creación de Perfil
    GetPage(
      name: IndustrySelectionScreen.id,
      page: () => IndustrySelectionScreen(),
      binding: LabourBinding(),
      transitionDuration: duration,
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: CreateProfileScreen.id,
      page: () => CreateProfileScreen(),
      binding: LabourBinding(),
      transitionDuration: duration,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: CreateProfileStep2Screen.id,
      page: () => CreateProfileStep2Screen(),
      binding: LabourBinding(),
      transitionDuration: duration,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: SkillsExperienceScreen.id,
      page: () => SkillsExperienceScreen(),
      binding: LabourBinding(),
      transitionDuration: duration,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: LocationScreen.id,
      page: () => LocationScreen(),
      binding: LabourBinding(),
      transitionDuration: duration,
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: ProfilePhotoScreen.id,
      page: () => ProfilePhotoScreen(),
      binding: LabourBinding(),
      transitionDuration: duration,
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: LicenseScreen.id,
      page: () => LicenseScreen(),
      binding: LabourBinding(),
      transitionDuration: duration,
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: PreviousEmployerScreen.id,
      page: () => PreviousEmployerScreen(),
      binding: LabourBinding(),
      transitionDuration: duration,
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: DocumentsScreen.id,
      page: () => DocumentsScreen(),
      binding: LabourBinding(),
      transitionDuration: duration,
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: RespectScreen.id,
      page: () => RespectScreen(),
      binding: LabourBinding(),
      transitionDuration: duration,
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: LetsBeClearScreen.id,
      page: () => LetsBeClearScreen(),
      binding: LabourBinding(),
      transitionDuration: duration,
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: ProfileCreatedScreen.id,
      page: () => ProfileCreatedScreen(),
      binding: LabourBinding(),
      transitionDuration: duration,
      transition: Transition.fadeIn,
    ),

    // Labour - Home y Perfil
    GetPage(
      name: HomeScreen.id,
      page: () => HomeScreen(),
      binding: LabourBinding(),
      transitionDuration: duration,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: labour_profile.ProfileScreen.id,
      page: () => labour_profile.ProfileScreen(),
      binding: LabourBinding(),
      transitionDuration: duration,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: labour_messages.MessagesScreen.id,
      page: () => labour_messages.MessagesScreen(),
      binding: LabourBinding(),
      transitionDuration: duration,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: labour_notifications.NotificationsScreen.id,
      page: () => labour_notifications.NotificationsScreen(),
      binding: LabourBinding(),
      transitionDuration: duration,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppliedJobsScreen.id,
      page: () => AppliedJobsScreen(),
      binding: LabourBinding(),
      transitionDuration: duration,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: WalletScreen.id,
      page: () => WalletScreen(),
      binding: LabourBinding(),
      transitionDuration: duration,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: InvoiceScreen.id,
      page: () => InvoiceScreen(),
      binding: LabourBinding(),
      transitionDuration: duration,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: labour_chat.ChatScreen.id,
      page: () => labour_chat.ChatScreen(
        recipientName: 'Builder',
        recipientAvatar: 'assets/employees.png',
      ),
      binding: LabourBinding(),
      transitionDuration: duration,
      transition: Transition.fadeIn,
    ),

    // Labour - Configuración y Documentos
    GetPage(
      name: DigitalIdScreen.id,
      page: () => DigitalIdScreen(flavor: Get.arguments?['flavor']),
      binding: LabourBinding(),
      transitionDuration: duration,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: EditBankDetailsScreen.id,
      page: () => EditBankDetailsScreen(flavor: Get.arguments?['flavor']),
      binding: LabourBinding(),
      transitionDuration: duration,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: EditBankDetailsNoPayIdScreen.id,
      page: () =>
          EditBankDetailsNoPayIdScreen(flavor: Get.arguments?['flavor']),
      binding: LabourBinding(),
      transitionDuration: duration,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: EditDocumentsScreen.id,
      page: () => EditDocumentsScreen(flavor: Get.arguments?['flavor']),
      binding: LabourBinding(),
      transitionDuration: duration,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: labour_edit_personal.EditPersonalDetailsScreen.id,
      page: () => labour_edit_personal.EditPersonalDetailsScreen(
        flavor: Get.arguments?['flavor'],
      ),
      binding: LabourBinding(),
      transitionDuration: duration,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: PdfViewerScreen.id,
      page: () => PdfViewerScreen(
        invoice: Get.arguments?['invoice'],
        flavor: Get.arguments?['flavor'],
      ),
      binding: LabourBinding(),
      transitionDuration: duration,
      transition: Transition.fadeIn,
    ),

    // ===== RUTAS DE BUILDER =====
    // Builder - Creación de Perfil
    GetPage(
      name: CreateProfileBuilderScreen.id,
      page: () => CreateProfileBuilderScreen(),
      binding: CreateProfileBinding(),
      transitionDuration: duration,
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: CreateProfileStep2BuilderScreen.id,
      page: () => CreateProfileStep2BuilderScreen(),
      binding: CreateProfileBinding(),
      transitionDuration: duration,
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: LocationBuilderScreen.id,
      page: () => LocationBuilderScreen(),
      binding: CreateProfileBinding(),
      transitionDuration: duration,
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: ProfilePhotoBuilderScreen.id,
      page: () => ProfilePhotoBuilderScreen(),
      binding: CreateProfileBinding(),
      transitionDuration: duration,
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: LicenseBuilderScreen.id,
      page: () => LicenseBuilderScreen(),
      binding: CreateProfileBinding(),
      transitionDuration: duration,
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: EmployeeSelectionScreen.id,
      page: () => EmployeeSelectionScreen(),
      binding: CreateProfileBinding(),
      transitionDuration: duration,
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: RegisterNewCompanyScreen.id,
      page: () => RegisterNewCompanyScreen(),
      binding: CreateProfileBinding(),
      transitionDuration: duration,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: builder_respect.RespectScreen.id,
      page: () => builder_respect.RespectScreen(),
      binding: CreateProfileBinding(),
      transitionDuration: duration,
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: builder_lets_be_clear.LetsBeClearScreen.id,
      page: () => builder_lets_be_clear.LetsBeClearScreen(),
      binding: CreateProfileBinding(),
      transitionDuration: duration,
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: builder_profile_created.ProfileCreatedScreen.id,
      page: () => builder_profile_created.ProfileCreatedScreen(),
      binding: CreateProfileBinding(),
      transitionDuration: duration,
      transition: Transition.fadeIn,
    ),

    // Builder - Home y Perfil
    GetPage(
      name: BuilderHomeScreen.id,
      page: () => BuilderHomeScreen(),
      binding: BuilderBinding(),
      transitionDuration: duration,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: builder_profile.ProfileScreen.id,
      page: () => builder_profile.ProfileScreen(),
      binding: BuilderBinding(),
      transitionDuration: duration,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: builder_messages.MessagesScreen.id,
      page: () => builder_messages.MessagesScreen(),
      binding: BuilderBinding(),
      transitionDuration: duration,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: builder_notifications.NotificationsScreen.id,
      page: () => builder_notifications.NotificationsScreen(),
      binding: BuilderBinding(),
      transitionDuration: duration,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: EditPersonalDetailsScreen.id,
      page: () => EditPersonalDetailsScreen(),
      binding: BuilderBinding(),
      transitionDuration: duration,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: CameraWithOverlayScreen.id,
      page: () => CameraWithOverlayScreen(
        flavor: Get.arguments?['flavor'] ?? AppFlavor.sport,
        onImageCaptured: (File image) {
          // Este callback se ejecutará cuando se capture la imagen
          print('Image captured in route: ${image.path}');
        },
      ),
      transitionDuration: duration,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: JobSitesListScreen.id,
      page: () => JobSitesListScreen(),
      binding: BuilderBinding(),
      transitionDuration: duration,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: MapScreen.id,
      page: () => MapScreen(flavor: Get.arguments?['flavor']),
      binding: BuilderBinding(),
      transitionDuration: duration,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: WorkerListScreen.id,
      page: () => WorkerListScreen(),
      binding: BuilderBinding(),
      transitionDuration: duration,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: builder_chat.ChatScreen.id,
      page: () => builder_chat.ChatScreen(
        recipientName: Get.arguments?['recipientName'] ?? 'Worker',
        recipientAvatar: Get.arguments?['recipientAvatar'] ?? 'W',
        flavor: Get.arguments?['flavor'],
      ),
      binding: BuilderBinding(),
      transitionDuration: duration,
      transition: Transition.fadeIn,
    ),

    // Builder - Post Job
    GetPage(
      name: PostJobStepperScreen.id,
      page: () => PostJobStepperScreen(),
      binding: BuilderBinding(),
      transitionDuration: duration,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: PostJobStepperStep2Screen.id,
      page: () => PostJobStepperStep2Screen(flavor: Get.arguments?['flavor']),
      binding: BuilderBinding(),
      transitionDuration: duration,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: PostJobStepperStep3Screen.id,
      page: () => PostJobStepperStep3Screen(flavor: Get.arguments?['flavor']),
      binding: BuilderBinding(),
      transitionDuration: duration,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: PostJobStepperStep4Screen.id,
      page: () => PostJobStepperStep4Screen(flavor: Get.arguments?['flavor']),
      binding: BuilderBinding(),
      transitionDuration: duration,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: PostJobStepperStep5Screen.id,
      page: () => PostJobStepperStep5Screen(flavor: Get.arguments?['flavor']),
      binding: BuilderBinding(),
      transitionDuration: duration,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: PostJobStepperStep6Screen.id,
      page: () => PostJobStepperStep6Screen(flavor: Get.arguments?['flavor']),
      binding: BuilderBinding(),
      transitionDuration: duration,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: PostJobStepperStep7Screen.id,
      page: () => PostJobStepperStep7Screen(flavor: Get.arguments?['flavor']),
      binding: BuilderBinding(),
      transitionDuration: duration,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: PostJobStepperStep8Screen.id,
      page: () => PostJobStepperStep8Screen(flavor: Get.arguments?['flavor']),
      binding: BuilderBinding(),
      transitionDuration: duration,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: MyJobsScreen.id,
      page: () => MyJobsScreen(flavor: Get.arguments?['flavor']),
      binding: BuilderBinding(),
      transitionDuration: duration,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: JobSitesScreen.id,
      page: () => JobSitesScreen(),
      binding: BuilderBinding(),
      transitionDuration: duration,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: CreateEditJobSiteScreen.id,
      page: () => CreateEditJobSiteScreen(),
      binding: BuilderBinding(),
      transitionDuration: duration,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: PostJobReviewScreen.id,
      page: () => PostJobReviewScreen(),
      binding: BuilderBinding(),
      transitionDuration: duration,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: ProjectOverviewScreen.id,
      page: () => ProjectOverviewScreen(
        flavor: Get.arguments?['flavor'],
        jobSite: Get.arguments?['jobSite'],
      ),
      binding: BuilderBinding(),
      transitionDuration: duration,
      transition: Transition.fadeIn,
    ),

    // Builder - Invoices
    GetPage(
      name: InvoicesScreen.id,
      page: () => InvoicesScreen(),
      binding: BuilderBinding(),
      transitionDuration: duration,
      transition: Transition.fadeIn,
    ),

    // Builder - Expenses
    GetPage(
      name: ExpensesScreen.id,
      page: () => ExpensesScreen(flavor: Get.arguments?['flavor']),
      binding: ExpensesBinding(),
      transitionDuration: duration,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: FilterJobSitesScreen.id,
      page: () => FilterJobSitesScreen(flavor: Get.arguments?['flavor']),
      binding: FilterJobSitesBinding(),
      transitionDuration: duration,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: CustomDateRangeScreen.id,
      page: () => CustomDateRangeScreen(flavor: Get.arguments?['flavor']),
      binding: CustomDateRangeBinding(),
      transitionDuration: duration,
      transition: Transition.fadeIn,
    ),

    // Builder - Staff Management
    GetPage(
      name: StaffScreen.id,
      page: () => StaffScreen(),
      binding: BuilderBinding(),
      transitionDuration: duration,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: MoveWorkersStepper.id,
      page: () => MoveWorkersStepper(
        flavor: Get.arguments?['flavor'],
        workers: Get.arguments?['workers'] ?? [],
      ),
      binding: BuilderBinding(),
      transitionDuration: duration,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: ExtendShiftsStepper.id,
      page: () => ExtendShiftsStepper(
        flavor: Get.arguments?['flavor'],
        workers: Get.arguments?['workers'] ?? [],
      ),
      binding: BuilderBinding(),
      transitionDuration: duration,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: UnhireWorkersStepper.id,
      page: () => UnhireWorkersStepper(
        flavor: Get.arguments?['flavor'],
        workers: Get.arguments?['workers'] ?? [],
      ),
      binding: BuilderBinding(),
      transitionDuration: duration,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: WorkerProfileScreen.id,
      page: () => WorkerProfileScreen(
        worker: Get.arguments?['worker'],
        flavor: Get.arguments?['flavor'],
      ),
      binding: BuilderBinding(),
      transitionDuration: duration,
      transition: Transition.fadeIn,
    ),

    // Builder - Applicants
    GetPage(
      name: ApplicantsScreen.id,
      page: () => ApplicantsScreen(flavor: Get.arguments?['flavor']),
      binding: BuilderBinding(),
      transitionDuration: duration,
      transition: Transition.fadeIn,
    ),

    // ===== RUTAS COMPARTIDAS =====
    // Job Listings (Compartidas entre Labour y Builder)
    GetPage(
      name: JobListingsScreen.id,
      page: () => JobListingsScreen(),
      binding: JobListingsBinding(),
      transitionDuration: duration,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: JobDetailsScreen.id,
      page: () => JobDetailsScreen(
        jobDetails: JobDetailsDto(
          id: '1',
          title: 'Sample Job',
          hourlyRate: 25.0,
          location: 'Sydney, NSW',
          dateRange: '01/01/2024 - 31/01/2024',
          jobType: 'Casual',
          source: 'Company Name',
          postedDate: '01-01',
          company: 'Company Name',
          address: '123 Main St',
          suburb: 'Suburb',
          city: 'Sydney',
          startDate: '01/01/2024',
          time: '9:00 AM - 5:00 PM',
          paymentExpected: 'Within 7 days',
          aboutJob: 'Job description',
          requirements: ['Requirement 1', 'Requirement 2'],
          latitude: -33.8688,
          longitude: 151.2093,
        ),
      ),
      binding: JobListingsBinding(),
      transitionDuration: duration,
      transition: Transition.fadeIn,
    ),
  ];
}
