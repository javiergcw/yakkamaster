import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../config/assets_config.dart';
import '../../../../../config/constants.dart';
import '../../../../../features/widgets/custom_button.dart';
import '../widgets/activity_item.dart';
import 'invoice_screen.dart';
import '../widgets/profile_item.dart';
import '../widgets/sidebar.dart';
import 'digital_id_screen.dart';
import '../../../../job_listings/presentation/pages/job_listings_screen.dart';
import 'profile_screen.dart';
import 'messages_screen.dart';
import '../../data/applied_job_dto.dart';
import '../widgets/applied_job_card.dart';
import 'applied_jobs_screen.dart';
import 'notifications_screen.dart';
import '../../logic/controllers/home_screen_controller.dart';
import 'edit_documents_screen.dart';
import 'wallet_screen.dart';

class HomeScreen extends StatelessWidget {
  static const String id = '/labour/home';
  
  final AppFlavor? flavor;
  HomeScreen({super.key, this.flavor});

  final HomeScreenController controller = Get.put(HomeScreenController());


  @override
  Widget build(BuildContext context) {
    // Establecer el flavor en el controlador si se proporciona
    if (flavor != null) {
      controller.currentFlavor.value = flavor!;
    }

    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    // Calcular valores responsive
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final titleFontSize = screenWidth * 0.055;
    final sectionTitleFontSize = screenWidth * 0.045;
    final bodyFontSize = screenWidth * 0.035;
    final buttonFontSize = screenWidth * 0.04;
    final profileImageSize = screenWidth * 0.12;

    return Obx(() => Stack(
      children: [
        Scaffold(
          backgroundColor: controller.selectedIndex.value == 3 ? const Color(0xFF2C2C2C) : Colors.grey[100],
          body: SafeArea(
            child: Stack(
              children: [
                // Main Content basado en el tab seleccionado
                _buildCurrentView(),
                
                // Banner flotante para Home tab
                if (controller.selectedIndex.value == 0) _buildFloatingBanner(),
              ],
            ),
          ),
          
          // Bottom Navigation Bar
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(0, -2),
                  blurRadius: 4,
                ),
              ],
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: controller.isShiftsModalOpen.value ? 1 : controller.selectedIndex.value,
              onTap: controller.handleBottomNavTap,
              selectedItemColor: Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)),
              unselectedItemColor: Colors.grey[600],
              selectedLabelStyle: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: bodyFontSize * 0.9,
              ),
              unselectedLabelStyle: GoogleFonts.poppins(
                fontSize: bodyFontSize * 0.9,
              ),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_today),
                  label: 'Shifts',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.message),
                  label: 'Messages',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
        
        // Overlay para cerrar sidebar al tocar fuera (solo sobre el contenido principal)
        if (controller.isSidebarOpen.value)
          Positioned(
            left: screenWidth * 0.7, // Empezar después del sidebar
            top: 0,
            right: 0,
            bottom: 0,
            child: GestureDetector(
              onTap: controller.closeSidebar,
              child: Container(
                color: Colors.black.withOpacity(0.3),
              ),
            ),
          ),
        
        // Sidebar (por encima de todo, sin overlay)
        if (controller.isSidebarOpen.value)
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: screenWidth * 0.7,
              child: Sidebar(
                flavor: controller.currentFlavor.value,
                onClose: controller.closeSidebar,
              ),
            ),
          ),
        
        // Overlay semi-transparente para el modal de shifts
        if (controller.isShiftsModalOpen.value)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),
        
        // Modal de Shifts (por encima de todo)
        if (controller.isShiftsModalOpen.value)
          _buildShiftsModal(),
      ],
    ));
  }

  Widget _buildCurrentView() {
    switch (controller.selectedIndex.value) {
      case 0:
        return _buildHomeView();
      case 1:
        return _buildShiftsView();
      case 2:
        return _buildMessagesView();
      case 3:
        return ProfileScreen(flavor: controller.currentFlavor.value);
      default:
        return _buildHomeView();
    }
  }

  Widget _buildHomeView() {
    final mediaQuery = MediaQuery.of(Get.context!);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    // Calcular valores responsive
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final titleFontSize = screenWidth * 0.055;
    final sectionTitleFontSize = screenWidth * 0.045;
    final bodyFontSize = screenWidth * 0.035;
    final buttonFontSize = screenWidth * 0.04;
    final profileImageSize = screenWidth * 0.12;

    return Column(
      children: [
        // Header (Dark Grey)
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalSpacing * 2.5,
          ),
          decoration: BoxDecoration(
            color: AppConstants.darkGreyColor,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: verticalSpacing * 0.1),
              Row(
                children: [
                  // Profile Image (clickeable para abrir sidebar)
                  GestureDetector(
                    onTap: controller.toggleSidebar,
                    child: Container(
                      width: profileImageSize,
                      height: profileImageSize,
                      decoration: BoxDecoration(
                        color: Colors.grey[600],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: profileImageSize * 0.5,
                      ),
                    ),
                  ),
                  
                  SizedBox(width: horizontalPadding),
                  
                  // App Name
                  Expanded(
                    child: Text(
                      "YAKKA",
                      style: GoogleFonts.poppins(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  
                  // Notification Icon
                  IconButton(
                    onPressed: () {
                      controller.navigateToNotifications();
                    },
                    icon: Icon(
                      Icons.notifications,
                      color: Colors.white,
                      size: screenWidth * 0.06,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        // Main Content (Scrollable)
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: horizontalPadding,
              right: horizontalPadding,
              top: verticalSpacing * 3,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ACTIVE JOBS Section (solo si hay trabajos aplicados)
                if (controller.hasAppliedJobs.value && controller.appliedJobs.isNotEmpty) _buildActiveJobsSection(),
                
                // ACTIVITY Section
                Text(
                  "ACTIVITY",
                  style: GoogleFonts.poppins(
                    fontSize: sectionTitleFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    letterSpacing: 0.5,
                  ),
                ),
                
                SizedBox(height: verticalSpacing * 0.8),
                
                // Activity Items
                ActivityItem(
                  icon: Icons.receipt,
                  title: "Invoices",
                  onTap: () {
                    controller.navigateToInvoice();
                  },
                ),
                
                SizedBox(height: verticalSpacing),
                
                ActivityItem(
                  icon: Icons.work,
                  title: "Applied jobs",
                  onTap: () {
                    controller.navigateToAppliedJobs();
                  },
                ),
                
                SizedBox(height: verticalSpacing),
                
                ActivityItem(
                  icon: Icons.warning,
                  title: "Report harassment",
                  subtitle: "You can remain anonymous",
                  onTap: () async {
                    try {
                      final Uri url = Uri.parse(AppConstants.reportHarassmentUrl);
                      final bool launched = await launchUrl(
                        url,
                        mode: LaunchMode.platformDefault,
                      );
                      
                      if (!launched) {
                        _showUrlDialog(AppConstants.reportHarassmentUrl);
                      }
                    } catch (e) {
                      print('Error launching URL: $e');
                      _showUrlDialog(AppConstants.reportHarassmentUrl);
                    }
                  },
                ),
                
                SizedBox(height: verticalSpacing * 1.5),
                
                // PROFILE Section
                Text(
                  "PROFILE",
                  style: GoogleFonts.poppins(
                    fontSize: sectionTitleFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    letterSpacing: 0.5,
                  ),
                ),
                
                SizedBox(height: verticalSpacing * 0.8),
                
                // Profile Items
                ProfileItem(
                  icon: Icons.qr_code,
                  title: "Show your QR",
                  subtitle: "Share your profile to get hired",
                  onTap: () {
                    controller.navigateToDigitalId();
                  },
                ),
                
                SizedBox(height: verticalSpacing),
                
                ProfileItem(
                  icon: Icons.attach_money,
                  title: "Earnings",
                  subtitle: "View your payment history",
                  onTap: () {
                    Get.toNamed(WalletScreen.id, arguments: {'flavor': controller.currentFlavor.value});
                  },
                ),
                
                SizedBox(height: verticalSpacing),
                
                ProfileItem(
                  icon: Icons.description,
                  title: "Licenses",
                  subtitle: "Manage your credentials",
                  onTap: () {
                    Get.toNamed(EditDocumentsScreen.id, arguments: {'flavor': controller.currentFlavor.value});
                  },
                ),
                
                SizedBox(height: verticalSpacing * 1.2),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShiftsView() {
    // Retornar la vista actual (Home) ya que el modal se mostrará encima
    return _buildHomeView();
  }

  Widget _buildMessagesView() {
    return MessagesScreen(flavor: controller.currentFlavor.value);
  }

  void _showUrlDialog(String url) {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Report Harassment'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Please copy and paste this URL in your browser:'),
              SizedBox(height: 8),
              SelectableText(
                url,
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildApplyForJobBanner() {
    final mediaQuery = MediaQuery.of(Get.context!);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final bodyFontSize = screenWidth * 0.035;

    return GestureDetector(
      onTap: controller.handleApplyForJob,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding * 0.6,
          vertical: verticalSpacing * 1.2,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0, 2),
              blurRadius: 8,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              Icons.search,
              color: Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)),
              size: bodyFontSize * 1.3,
            ),
            SizedBox(width: horizontalPadding * 0.4),
            Expanded(
              child: Text(
                'Apply for a job',
                style: GoogleFonts.poppins(
                  fontSize: bodyFontSize,
                  fontWeight: FontWeight.w600,
                  color: Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)),
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)),
              size: bodyFontSize * 1.1,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveJobsSection() {
    final mediaQuery = MediaQuery.of(Get.context!);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final sectionTitleFontSize = screenWidth * 0.045;
    final bodyFontSize = screenWidth * 0.035;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header con título y "Show all"
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "ACTIVE JOBS",
              style: GoogleFonts.poppins(
                fontSize: sectionTitleFontSize,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                letterSpacing: 0.5,
              ),
            ),
            TextButton(
              onPressed: () {
                controller.navigateToAppliedJobs();
              },
              child: Text(
                'Show all',
                style: GoogleFonts.poppins(
                  fontSize: bodyFontSize * 0.9,
                  fontWeight: FontWeight.w500,
                  color: Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)),
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
        // Instrucción
        Text(
          'In order to get paid submit your timesheet daily',
          style: GoogleFonts.poppins(
            fontSize: bodyFontSize * 0.85,
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
          ),
        ),
        // Swiper con cards de trabajos aplicados
          Container(
            height: screenHeight * 0.4, // Altura reducida para cards más compactas
            child: PageView.builder(
            itemCount: controller.appliedJobs.length,
            itemBuilder: (context, index) {
              final job = controller.appliedJobs[index];
              return Center(
                child: Container(
                  width: screenWidth * 0.65, // Aumentar un poco más el ancho
                  child: AppliedJobCard(
                    job: job,
                    onShowDetails: () {
                      print('Show details for job: ${job.companyName}');
                    },
                    onSubmitTimesheet: () {
                      print('Submit timesheet for job: ${job.companyName}');
                    },
                    onQuickNotify: () {
                      print('Quick notify for job: ${job.companyName}');
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingBanner() {
    final mediaQuery = MediaQuery.of(Get.context!);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final sectionTitleFontSize = screenWidth * 0.045;
    final bodyFontSize = screenWidth * 0.035;
    final buttonFontSize = screenWidth * 0.04;

    return Positioned(
      top: verticalSpacing * 6,
      left: horizontalPadding,
      right: horizontalPadding,
      child: controller.hasAppliedJobs.value && controller.appliedJobs.isNotEmpty 
        ? _buildApplyForJobBanner()
        : Container(
            padding: EdgeInsets.all(horizontalPadding * 0.4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(0, 2),
                  blurRadius: 8,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "No active jobs yet",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: sectionTitleFontSize * 0.85,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: verticalSpacing * 0.2),
                Text(
                  "Once you get hired, you'll see your timesheets to submit here",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: bodyFontSize * 0.8,
                    color: Colors.grey[700],
                    height: 1.1,
                  ),
                ),
                SizedBox(height: verticalSpacing * 1.0),
                Center(
                  child: SizedBox(
                    width: screenWidth * 0.45,
                    height: screenHeight * 0.05,
                    child: ElevatedButton(
                      onPressed: controller.handleApplyForJob,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "Apply for a job now",
                        style: GoogleFonts.poppins(
                          fontSize: buttonFontSize * 0.75,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  
  Widget _buildShiftsModal() {
    final mediaQuery = MediaQuery.of(Get.context!);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final titleFontSize = screenWidth * 0.045;
    final subtitleFontSize = screenWidth * 0.035;

        return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: screenHeight * 0.8,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Header del modal
            Container(
              padding: EdgeInsets.all(horizontalPadding),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Shifts',
                      style: GoogleFonts.poppins(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      controller.closeShiftsModal();
                    },
                    icon: Icon(
                      Icons.close,
                      color: Colors.black,
                      size: screenWidth * 0.06,
                    ),
                  ),
                ],
              ),
            ),

            // Texto instructivo
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                              child: Text(
                  'Select a day to view the events.',
                  style: GoogleFonts.poppins(
                    fontSize: subtitleFontSize,
                    color: Colors.grey[600],
                    decoration: TextDecoration.none,
                  ),
                ),
            ),

            SizedBox(height: verticalSpacing * 1.5),

            // Navegación del mes
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      controller.navigateMonth(false);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black,
                      size: screenWidth * 0.04,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      controller.getMonthYearString(controller.focusedDate.value),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: subtitleFontSize,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      controller.navigateMonth(true);
                    },
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black,
                      size: screenWidth * 0.04,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: verticalSpacing),

            // Días de la semana
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Row(
                children: ['S', 'M', 'T', 'W', 'T', 'F', 'S'].map((day) {
                  return Expanded(
                    child: Text(
                      day,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: subtitleFontSize * 0.8,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                        decoration: TextDecoration.none,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            SizedBox(height: verticalSpacing * 0.5),

            // Calendario
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  children: [
                    Expanded(
                      child: _buildCalendarGrid(),
                    ),
                    if (controller.hasShiftsForSelectedDate()) ...[
                      SizedBox(height: verticalSpacing),
                      _buildShiftsSection(),
                    ],
                  ],
                ),
              ),
            ),

            SizedBox(height: verticalSpacing),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final mediaQuery = MediaQuery.of(Get.context!);
    final screenWidth = mediaQuery.size.width;
    final subtitleFontSize = screenWidth * 0.035;

    final firstDayOfMonth = DateTime(controller.focusedDate.value.year, controller.focusedDate.value.month, 1);
    final lastDayOfMonth = DateTime(controller.focusedDate.value.year, controller.focusedDate.value.month + 1, 0);
    final firstWeekday = firstDayOfMonth.weekday;
    final daysInMonth = lastDayOfMonth.day;

    List<Widget> calendarDays = [];

    // Agregar días vacíos al inicio
    for (int i = 1; i < firstWeekday; i++) {
      calendarDays.add(const SizedBox());
    }

    // Agregar días del mes
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(controller.focusedDate.value.year, controller.focusedDate.value.month, day);
      final isSelected = date.year == controller.selectedDate.value.year &&
          date.month == controller.selectedDate.value.month &&
          date.day == controller.selectedDate.value.day;
      
      final dateKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final hasShift = controller.hasShiftsForDate(date);

      calendarDays.add(
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              controller.selectDate(date);
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected ? Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)) : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      day.toString(),
                      style: GoogleFonts.poppins(
                        fontSize: subtitleFontSize * 0.9,
                        fontWeight: FontWeight.w500,
                        color: isSelected ? Colors.black : Colors.black87,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  if (hasShift)
                    Positioned(
                      bottom: 2,
                      right: 2,
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: calendarDays.length,
      itemBuilder: (context, index) => calendarDays[index],
    );
  }


  Widget _buildShiftsSection() {
    final mediaQuery = MediaQuery.of(Get.context!);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final subtitleFontSize = screenWidth * 0.035;

    final shifts = controller.getShiftsForSelectedDate();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
                  Text(
            'Shifts for ${controller.selectedDate.value.day}/${controller.selectedDate.value.month}/${controller.selectedDate.value.year}',
            style: GoogleFonts.poppins(
              fontSize: subtitleFontSize,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              decoration: TextDecoration.none,
            ),
          ),
        SizedBox(height: verticalSpacing * 0.5),
        ...shifts.map((shift) => _buildShiftCard(shift)).toList(),
      ],
    );
  }

  Widget _buildShiftCard(Shift shift) {
    final mediaQuery = MediaQuery.of(Get.context!);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final subtitleFontSize = screenWidth * 0.035;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: verticalSpacing * 0.5),
      padding: EdgeInsets.all(horizontalPadding * 0.8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300] ?? Colors.grey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            shift.companyName,
            style: GoogleFonts.poppins(
              fontSize: subtitleFontSize,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              decoration: TextDecoration.none,
            ),
          ),
          SizedBox(height: verticalSpacing * 0.3),
          Text(
            shift.jobSite,
            style: GoogleFonts.poppins(
              fontSize: subtitleFontSize * 0.9,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
              decoration: TextDecoration.none,
            ),
          ),
          SizedBox(height: verticalSpacing * 0.3),
          Text(
            '${shift.startTime}-${shift.endTime}',
            style: GoogleFonts.poppins(
              fontSize: subtitleFontSize * 0.9,
              fontWeight: FontWeight.w500,
              color: Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)),
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }
}
