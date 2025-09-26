import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/app_flavor.dart';
import '../widgets/sidebar.dart';
import '../../../applicants/logic/controllers/applicant_controller.dart';
import '../../logic/controllers/builder_home_controller.dart';

class BuilderHomeScreen extends StatelessWidget {
  static const String id = '/builder/home';

  final AppFlavor? flavor;

  BuilderHomeScreen({super.key, this.flavor});

  BuilderHomeController get controller => Get.find<BuilderHomeController>();

  @override
  Widget build(BuildContext context) {
    // Establecer el flavor en el controlador si viene en los argumentos
    try {
      if (flavor != null) {
        controller.currentFlavor.value = flavor!;
      }
    } catch (e) {
      print('⚠️ Error setting flavor: $e');
    }

    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    // Calcular valores responsive
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            top: false,
            child: Stack(
              children: [
                Column(
                  children: [
                    // Header (Dark Grey) - Más alto
                    _buildHeader(),

                    // Main Content (Scrollable)
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.only(
                          left: horizontalPadding,
                          right: horizontalPadding,
                          top:
                              verticalSpacing *
                              3, // Reducido para menos espacio
                          bottom:
                              verticalSpacing *
                              2, // Reducido para menos espacio
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // WORKERS Section
                            _buildWorkersSection(),

                            SizedBox(height: verticalSpacing * 2),

                            // MANAGEMENT Section
                            _buildManagementSection(),

                            SizedBox(height: verticalSpacing * 2),

                            // INSIGHTS Section
                            _buildInsightsSection(),

                            SizedBox(height: verticalSpacing * 2),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // Post a job or task Button - Fijo sobre el header
                Positioned(
                  top:
                      verticalSpacing *
                      6, // Ajustado para que se vea sobre el header
                  left: horizontalPadding,
                  right: horizontalPadding,
                  child: _buildPostJobButton(),
                ),
              ],
            ),
          ),
          bottomNavigationBar: _buildBottomNavigationBar(),
        ),

        // Overlay para cerrar sidebar al tocar fuera con animación
        Obx(
          () => AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: controller.isSidebarOpen.value ? 1.0 : 0.0,
            child: controller.isSidebarOpen.value
                ? Positioned.fill(
                    child: GestureDetector(
                      onTap: controller.closeSidebar,
                      child: Container(color: Colors.black.withOpacity(0.2)),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ),

        // Sidebar (por encima de todo) con animación
        Obx(
          () => AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            top: 0,
            left: controller.isSidebarOpen.value ? 0 : -MediaQuery.of(Get.context!).size.width,
            right: controller.isSidebarOpen.value ? 0 : MediaQuery.of(Get.context!).size.width,
            bottom: 0,
            child: Material(
              color: Colors.transparent,
              child: Sidebar(
                flavor: controller.currentFlavor.value,
                onClose: controller.closeSidebar,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    final mediaQuery = MediaQuery.of(Get.context!);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final titleFontSize = screenWidth * 0.055;
    final profileImageSize = screenWidth * 0.12;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        left: horizontalPadding,
        right: horizontalPadding,
        top: verticalSpacing * 2.5, // Aumentado el padding top
        bottom: verticalSpacing * 3, // Reducido un poco la altura
      ),
      decoration: BoxDecoration(
        color: Colors.grey[800], // Cambiado a gris
      ),
      child: Row(
        children: [
          // Profile Image (circular avatar a la izquierda)
          GestureDetector(
            onTap: _toggleSidebar,
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

          // Notification Icon (en la misma fila)
          IconButton(
            onPressed: () => controller.navigateToNotifications(),
            icon: Icon(
              Icons.notifications_none_outlined,
              color: Colors.white,
              size: screenWidth * 0.06,
            ),
          ),
        ],
      ),
    );
  }

  void _toggleSidebar() {
    controller.toggleSidebar();
  }

  Widget _buildPostJobButton() {
    final mediaQuery = MediaQuery.of(Get.context!);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final bodyFontSize =
        screenWidth * 0.045; // Aumentado el tamaño de la fuente

    return GestureDetector(
      onTap: () => controller.navigateToJobSites(),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding * 0.6,
          vertical: verticalSpacing * 1.2,
        ),
        decoration: BoxDecoration(
          color: Color(
            AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value),
          ),
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
            Icon(Icons.add_circle_outline, color: Colors.white, size: 38),
            SizedBox(width: horizontalPadding * 0.4),
            Expanded(
              child: Text(
                'Post a job or task',
                style: GoogleFonts.poppins(
                  fontSize: bodyFontSize,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: bodyFontSize * 1.1,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkersSection() {
    final mediaQuery = MediaQuery.of(Get.context!);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    final verticalSpacing = screenHeight * 0.025;
    final sectionTitleFontSize = screenWidth * 0.045;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "WORKERS",
          style: GoogleFonts.poppins(
            fontSize: sectionTitleFontSize,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            letterSpacing: 0.5,
          ),
        ),

        SizedBox(height: verticalSpacing * 1),

        // Workers Grid - 3 cards horizontales
        Row(
          children: [
            Expanded(
              child: _buildWorkerCard(
                icon: Icons.work,
                title: "Jobs",
                onTap: () => controller.navigateToMyJobs(),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: _buildWorkerCard(
                icon: Icons.people,
                title: "Applicants",
                onTap: () => controller.navigateToApplicants(),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: _buildWorkerCard(
                icon: Icons.search,
                title: "Search",
                onTap: () => controller.navigateToWorkers(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildManagementSection() {
    final mediaQuery = MediaQuery.of(Get.context!);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    final verticalSpacing = screenHeight * 0.025;
    final sectionTitleFontSize = screenWidth * 0.045;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "MANAGEMENT",
          style: GoogleFonts.poppins(
            fontSize: sectionTitleFontSize,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            letterSpacing: 0.5,
          ),
        ),

        SizedBox(height: verticalSpacing * 1),

        // Management Items - cards verticales
        _buildManagementItem(
          icon: Icons.people,
          title: "Staff",
          subtitle: "Chat, review or unhire workers",
          onTap: () => controller.navigateToStaff(),
        ),

        SizedBox(height: verticalSpacing),

        _buildManagementItem(
          icon: Icons.location_on,
          title: "See your job sites",
          subtitle: "Get report by workplaces",
          onTap: () => controller.navigateToJobSitesList(),
        ),
      ],
    );
  }

  Widget _buildInsightsSection() {
    final mediaQuery = MediaQuery.of(Get.context!);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    final verticalSpacing = screenHeight * 0.025;
    final sectionTitleFontSize = screenWidth * 0.045;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "INSIGHTS",
          style: GoogleFonts.poppins(
            fontSize: sectionTitleFontSize,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            letterSpacing: 0.5,
          ),
        ),

        SizedBox(height: verticalSpacing * 1),

        _buildInsightsItem(
          icon: Icons.receipt,
          title: "Invoices & payments",
          onTap: () => controller.navigateToInvoices(),
        ),

        SizedBox(height: verticalSpacing),

        _buildInsightsItem(
          icon: Icons.account_balance_wallet,
          title: "Expenses",
          onTap: () => controller.navigateToExpenses(),
        ),
      ],
    );
  }

  Widget _buildWorkerCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120, // Altura fija para hacerlas rectangulares verticales
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Stack(
          children: [
            // Contenido principal centrado
            Center(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Centrar contenido verticalmente
                crossAxisAlignment: CrossAxisAlignment
                    .center, // Centrar contenido horizontalmente
                children: [
                  Icon(
                    icon,
                    color: Color(
                      AppFlavorConfig.getPrimaryColor(
                        controller.currentFlavor.value,
                      ),
                    ),
                    size: 40, // Icono más grande
                  ),
                  const SizedBox(height: 12), // Más espacio entre icono y texto
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            // Punto rojo para nuevos applicants
            if (title == "Applicants")
              Positioned(
                top: 8,
                right: 8,
                child: Obx(() {
                  try {
                    final applicantController = Get.find<ApplicantController>();
                    return applicantController.hasNewApplicants
                        ? Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          )
                        : const SizedBox.shrink();
                  } catch (e) {
                    print('⚠️ Error finding ApplicantController: $e');
                    return const SizedBox.shrink();
                  }
                }),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildManagementItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Color(
                AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value),
              ),
              size: 32, // Icono más grande para MANAGEMENT
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightsItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Color(
                AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value),
              ),
              size: 32, // Icono más grande para INSIGHTS
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildBottomNavItem(
            Icons.grid_view,
            'Home',
            0,
            controller.selectedIndex.value == 0,
          ),
          _buildBottomNavItem(
            Icons.map,
            'Map',
            1,
            controller.selectedIndex.value == 1,
          ),
          _buildBottomNavItem(
            Icons.chat_bubble,
            'Messages',
            2,
            controller.selectedIndex.value == 2,
          ),
          _buildBottomNavItem(
            Icons.person,
            'Profile',
            3,
            controller.selectedIndex.value == 3,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavItem(
    IconData icon,
    String label,
    int index,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () {
        if (index == 1) {
          // Map
          controller.navigateToMap();
        } else {
          controller.selectTab(index);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isSelected ? Colors.black : Colors.grey, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: isSelected ? Colors.black : Colors.grey,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
