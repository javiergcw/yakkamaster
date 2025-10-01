import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../config/constants.dart';
import '../widgets/activity_item.dart';
import '../widgets/profile_item.dart';
import '../widgets/sidebar.dart';
import 'profile_screen.dart';
import 'messages_screen.dart';
import '../widgets/applied_job_card.dart';
import '../../logic/controllers/home_screen_controller.dart';
import 'edit_documents_screen.dart';
import 'wallet_screen.dart';
import '../../../../job_listings/presentation/widgets/search_button_bar.dart';
import '../../../../job_listings/presentation/pages/job_search_screen.dart';

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
    final bodyFontSize = screenWidth * 0.035;
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;

    return Obx(
      () => Stack(
        children: [
          Scaffold(
            backgroundColor: controller.selectedIndex.value == 3
                ? const Color(0xFF2C2C2C)
                : Colors.grey[100],
            body: SafeArea(
              top: false,
              child: Stack(
                children: [
                  // Main Content basado en el tab seleccionado
                  _buildCurrentView(),
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
                currentIndex: controller.isShiftsModalOpen.value
                    ? 1
                    : controller.selectedIndex.value,
                onTap: controller.handleBottomNavTap,
                selectedItemColor: Color(
                  AppFlavorConfig.getPrimaryColor(
                    controller.currentFlavor.value,
                  ),
                ),
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

          // Overlay para cerrar sidebar al tocar fuera (solo sobre el contenido principal) con animación
          AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: controller.isSidebarOpen.value ? 1.0 : 0.0,
            child: controller.isSidebarOpen.value
                ? Positioned(
                    left: screenWidth * 0.7, // Empezar después del sidebar
                    top: 0,
                    right: 0,
                    bottom: 0,
                    child: GestureDetector(
                      onTap: controller.closeSidebar,
                      child: Container(color: Colors.black.withOpacity(0.3)),
                    ),
                  )
                : const SizedBox.shrink(),
          ),

          // Sidebar (por encima de todo, sin overlay) con animación
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            left: controller.isSidebarOpen.value ? 0 : -screenWidth * 0.7,
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
              child: Container(color: Colors.black.withOpacity(0.3)),
            ),

          // Modal de Shifts (por encima de todo)
          if (controller.isShiftsModalOpen.value) _buildShiftsModal(),

          // Floating Action Buttons (over AppBar) - con animación suave
          if (controller.selectedIndex.value == 0 && !controller.isShiftsModalOpen.value && !controller.isSidebarOpen.value)
            Positioned(
              top: verticalSpacing * 9.5, // Position below search bar
              left: horizontalPadding,
              right: horizontalPadding,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                opacity: controller.showFloatingButtons.value ? 1.0 : 0.0,
                child: AnimatedSlide(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  offset: controller.showFloatingButtons.value 
                      ? Offset.zero 
                      : const Offset(0, -0.5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Workplace Check-in Button
                      _buildActionButton(
                        icon: Icons.location_on,
                        title: "Workplace\nCheck-in",
                        onTap: () {
                          // Handle workplace check-in
                          print('Workplace Check-in tapped');
                        },
                      ),

                      // Create Invoice Button
                      _buildActionButton(
                        icon: Icons.receipt,
                        title: "Create\ninvoice",
                        onTap: () {
                          controller.navigateToInvoice();
                        },
                      ),

                      // Show ID/QR Button
                      _buildActionButton(
                        icon: Icons.qr_code,
                        title: "Show your\nID / QR",
                        onTap: () {
                          controller.navigateToDigitalId();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
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
    final profileImageSize = screenWidth * 0.12;

    return Column(
      children: [
        // Header (Dark Grey) con animación dinámica
        Obx(() => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalSpacing * 2.5 * controller.headerHeight.value,
          ),
          decoration: BoxDecoration(color: AppConstants.darkGreyColor),
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
                      textAlign: TextAlign.center,
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
                      Icons.notifications_none_outlined,
                      color: Colors.white,
                      size: screenWidth * 0.06,
                    ),
                  ),
                ],
              ),

              // Search Bar con animación de visibilidad
              AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                opacity: controller.showSearchBar.value ? 1.0 : 0.0,
                child: AnimatedSlide(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  offset: controller.showSearchBar.value 
                      ? Offset.zero 
                      : const Offset(0, -0.5),
                  child: controller.showSearchBar.value
                      ? Column(
                          children: [
                            SizedBox(height: verticalSpacing * 1.5),
                            SearchButtonBar(
                              placeholder: "Apply and Find jobs",
                              onTap: () {
                                print(
                                  'SearchButtonBar tapped - navigating to: ${JobSearchScreen.id}',
                                );
                                Get.toNamed(
                                  JobSearchScreen.id,
                                  arguments: {'flavor': controller.currentFlavor.value},
                                );
                              },
                              horizontalPadding: horizontalPadding,
                              verticalSpacing: verticalSpacing,
                              bodyFontSize: bodyFontSize,
                              iconSize: screenWidth * 0.05,
                              flavor: controller.currentFlavor.value,
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                ),
              ),
            ],
          ),
        )),

        // Main Content (Scrollable)
        Expanded(
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              // Controlar visibilidad de los botones flotantes y header basado en la posición del scroll
              if (scrollInfo is ScrollUpdateNotification) {
                controller.updateFloatingButtonsVisibility(
                  scrollInfo.metrics.pixels,
                );
                controller.updateHeaderVisibility(
                  scrollInfo.metrics.pixels,
                );
              }
              return false;
            },
            child: SingleChildScrollView(
              controller: controller.scrollController,
              padding: EdgeInsets.only(
                left: horizontalPadding,
                right: horizontalPadding,
                top: verticalSpacing * 2,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ACTIVE JOBS Section (solo si hay trabajos aplicados)
                  if (controller.hasAppliedJobs.value &&
                      controller.appliedJobs.isNotEmpty)
                    _buildActiveJobsSection(),

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
                        final Uri url = Uri.parse(
                          AppConstants.reportHarassmentUrl,
                        );
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
                      Get.toNamed(
                        WalletScreen.id,
                        arguments: {'flavor': controller.currentFlavor.value},
                      );
                    },
                  ),

                  SizedBox(height: verticalSpacing),

                  ProfileItem(
                    icon: Icons.description,
                    title: "Licenses",
                    subtitle: "Manage your credentials",
                    onTap: () {
                      Get.toNamed(
                        EditDocumentsScreen.id,
                        arguments: {'flavor': controller.currentFlavor.value},
                      );
                    },
                  ),

                  SizedBox(height: verticalSpacing * 1.2),
                ],
              ),
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

  Widget _buildActionButton({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final mediaQuery = MediaQuery.of(Get.context!);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    final verticalSpacing = screenHeight * 0.025;
    final bodyFontSize = screenWidth * 0.035;
    final buttonHeight = screenHeight * 0.1; // Aumentado de 0.09 a 0.1

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: buttonHeight,
        width: screenWidth * 0.25, // Ancho fijo más pequeño
        decoration: BoxDecoration(
          color: Color(
            AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value),
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0, 2),
              blurRadius: 4,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: screenWidth * 0.06, color: Colors.white),
            SizedBox(height: verticalSpacing * 0.3),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: bodyFontSize * 0.8,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                height: 1.1,
                decoration: TextDecoration.none, // Quitar underline
              ),
            ),
          ],
        ),
      ),
    );
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

  Widget _buildActiveJobsSection() {
    final mediaQuery = MediaQuery.of(Get.context!);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    final horizontalPadding = screenWidth * 0.06;
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
                  color: Color(
                    AppFlavorConfig.getPrimaryColor(
                      controller.currentFlavor.value,
                    ),
                  ),
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
        // Lista horizontal con cards de trabajos aplicados
        Container(
          height:
              screenHeight *
              0.32, // Altura más reducida para cards más compactas
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.appliedJobs.length,
            itemBuilder: (context, index) {
              final job = controller.appliedJobs[index];
              return Container(
                width: screenWidth * 0.65, // Mantener el mismo ancho
                margin: EdgeInsets.only(
                  right: index < controller.appliedJobs.length - 1
                      ? horizontalPadding * 0.5
                      : 0,
                ),
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
              );
            },
          ),
        ),
      ],
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

            // Mostrar shifts si hay alguna seleccionada
            if (controller.hasShiftsForSelectedDate()) ...[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: _buildShiftsSection(),
              ),
              SizedBox(height: verticalSpacing),
            ],

            // Texto instructivo (solo si no hay shifts seleccionadas)
            if (!controller.hasShiftsForSelectedDate())
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
                      controller.getMonthYearString(
                        controller.focusedDate.value,
                      ),
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
                  children: [Expanded(child: _buildCalendarGrid())],
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

    final firstDayOfMonth = DateTime(
      controller.focusedDate.value.year,
      controller.focusedDate.value.month,
      1,
    );
    final lastDayOfMonth = DateTime(
      controller.focusedDate.value.year,
      controller.focusedDate.value.month + 1,
      0,
    );
    final firstWeekday = firstDayOfMonth.weekday;
    final daysInMonth = lastDayOfMonth.day;

    List<Widget> calendarDays = [];

    // Agregar días vacíos al inicio
    for (int i = 1; i < firstWeekday; i++) {
      calendarDays.add(const SizedBox());
    }

    // Agregar días del mes
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(
        controller.focusedDate.value.year,
        controller.focusedDate.value.month,
        day,
      );
      final isSelected =
          date.year == controller.selectedDate.value.year &&
          date.month == controller.selectedDate.value.month &&
          date.day == controller.selectedDate.value.day;

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
                color: isSelected
                    ? Color(
                        AppFlavorConfig.getPrimaryColor(
                          controller.currentFlavor.value,
                        ),
                      )
                    : Colors.transparent,
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
                        color: isSelected ? Colors.white : Colors.black87,
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
                          color: Color(
                            AppFlavorConfig.getPrimaryColor(
                              controller.currentFlavor.value,
                            ),
                          ),
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
        SizedBox(height: verticalSpacing * 0.3),
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
      margin: EdgeInsets.only(bottom: verticalSpacing * 0.3),
      padding: EdgeInsets.all(horizontalPadding * 0.5),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
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
          SizedBox(height: verticalSpacing * 0.2),
          Text(
            shift.jobSite,
            style: GoogleFonts.poppins(
              fontSize: subtitleFontSize * 0.9,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
              decoration: TextDecoration.none,
            ),
          ),
          SizedBox(height: verticalSpacing * 0.2),
          Text(
            '${shift.startTime}-${shift.endTime}',
            style: GoogleFonts.poppins(
              fontSize: subtitleFontSize * 0.9,
              fontWeight: FontWeight.w500,
              color: Color(
                AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value),
              ),
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }
}
