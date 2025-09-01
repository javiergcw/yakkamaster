import 'package:flutter/material.dart';
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

class Shift {
  final String companyName;
  final String jobSite;
  final String startTime;
  final String endTime;

  Shift({
    required this.companyName,
    required this.jobSite,
    required this.startTime,
    required this.endTime,
  });
}

class HomeScreen extends StatefulWidget {
  final AppFlavor? flavor;

  const HomeScreen({
    super.key,
    this.flavor,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AppFlavor get _currentFlavor => widget.flavor ?? (AppFlavorConfig.currentFlavor);
  int _selectedIndex = 0; // Home tab selected
  bool _isSidebarOpen = false; // Control del sidebar
  
  // Variables para el modal de shifts
  bool _isShiftsModalOpen = false;
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDate = DateTime.now();
  
  // Datos de ejemplo de shifts
  late final Map<String, List<Shift>> _shiftsData;
  
  // Datos de ejemplo de trabajos aplicados
  late final List<AppliedJobDto> _appliedJobs;
  
  // Variable para alternar entre estados (true = con trabajos, false = sin trabajos)
  bool _hasAppliedJobs = false;
  
  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final currentMonth = now.month.toString().padLeft(2, '0');
    final currentYear = now.year;
    
    _shiftsData = {
      '$currentYear-$currentMonth-15': [
        Shift(
          companyName: 'Yakka Labour',
          jobSite: 'Australia LTD',
          startTime: '8:00',
          endTime: '6:00pm',
        ),
      ],
      '$currentYear-$currentMonth-18': [
        Shift(
          companyName: 'Yakka Labour',
          jobSite: 'Melbourne Construction',
          startTime: '7:00',
          endTime: '5:00pm',
        ),
      ],
      '$currentYear-$currentMonth-22': [
        Shift(
          companyName: 'Yakka Labour',
          jobSite: 'Sydney Projects',
          startTime: '9:00',
          endTime: '7:00pm',
        ),
      ],
    };
    
    // Datos de ejemplo de trabajos aplicados
    _appliedJobs = [
      AppliedJobDto(
        id: '1',
        companyName: 'Test company by yakka',
        jobTitle: 'Truck Driver',
        location: 'Sydney',
        status: 'Active',
        appliedDate: DateTime.now().subtract(Duration(days: 5)),
      ),
      AppliedJobDto(
        id: '2',
        companyName: 'Construction Corp',
        jobTitle: 'Laborer',
        location: 'Melbourne',
        status: 'Active',
        appliedDate: DateTime.now().subtract(Duration(days: 3)),
      ),
    ];
  }

  void _handleApplyForJob() {
    // Navegar a la pantalla de job listings
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => JobListingsScreen(flavor: _currentFlavor),
      ),
    );
  }

  void _handleBottomNavTap(int index) {
    if (index == 1) {
      // Si se selecciona el tab de Shifts, abrir el modal
      setState(() {
        _isShiftsModalOpen = true;
      });
    } else {
      setState(() {
        _selectedIndex = index;
        _isShiftsModalOpen = false;
      });
    }
  }

  void _toggleSidebar() {
    setState(() {
      _isSidebarOpen = !_isSidebarOpen;
    });
  }

  void _closeSidebar() {
    setState(() {
      _isSidebarOpen = false;
    });
  }

  Widget _buildCurrentView() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeView();
      case 1:
        return _buildShiftsView();
      case 2:
        return _buildMessagesView();
      case 3:
        return ProfileScreen(flavor: _currentFlavor);
      default:
        return _buildHomeView();
    }
  }

  Widget _buildHomeView() {
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
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => NotificationsScreen(
                            flavor: _currentFlavor,
                          ),
                        ),
                      );
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
                if (_hasAppliedJobs && _appliedJobs.isNotEmpty) _buildActiveJobsSection(),
                
                SizedBox(height: verticalSpacing * 0.8),
                
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InvoiceScreen(flavor: _currentFlavor),
                      ),
                    );
                  },
                ),
                
                SizedBox(height: verticalSpacing),
                
                ActivityItem(
                  icon: Icons.work,
                  title: "Applied jobs",
                  onTap: () {
                    print('Applied jobs pressed');
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
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DigitalIdScreen(flavor: _currentFlavor),
                      ),
                    );
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
    return MessagesScreen(flavor: _currentFlavor);
  }

  void _showUrlDialog(String url) {
    showDialog(
      context: context,
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
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final bodyFontSize = screenWidth * 0.035;

    return GestureDetector(
      onTap: _handleApplyForJob,
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
              color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
              size: bodyFontSize * 1.3,
            ),
            SizedBox(width: horizontalPadding * 0.4),
            Expanded(
              child: Text(
                'Apply for a job',
                style: GoogleFonts.poppins(
                  fontSize: bodyFontSize,
                  fontWeight: FontWeight.w600,
                  color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
              size: bodyFontSize * 1.1,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveJobsSection() {
    final mediaQuery = MediaQuery.of(context);
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
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AppliedJobsScreen(
                      flavor: _currentFlavor,
                      appliedJobs: _appliedJobs,
                    ),
                  ),
                );
              },
              child: Text(
                'Show all',
                style: GoogleFonts.poppins(
                  fontSize: bodyFontSize * 0.9,
                  fontWeight: FontWeight.w500,
                  color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
        
        SizedBox(height: verticalSpacing * 0.8),
        
        // Instrucción
        Text(
          'In order to get paid submit your timesheet daily',
          style: GoogleFonts.poppins(
            fontSize: bodyFontSize * 0.85,
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
          ),
        ),
        
        SizedBox(height: verticalSpacing * 1.5),
        
                  // Swiper con cards de trabajos aplicados
          Container(
            height: screenHeight * 0.28, // Altura reducida para cards más compactas
            child: PageView.builder(
            itemCount: _appliedJobs.length,
            itemBuilder: (context, index) {
              final job = _appliedJobs[index];
              return AppliedJobCard(
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
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingBanner() {
    final mediaQuery = MediaQuery.of(context);
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
      child: _hasAppliedJobs && _appliedJobs.isNotEmpty 
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
                      onPressed: _handleApplyForJob,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
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

  @override
  Widget build(BuildContext context) {
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

    return Stack(
      children: [
        Scaffold(
          backgroundColor: _selectedIndex == 3 ? const Color(0xFF2C2C2C) : Colors.grey[100],
          body: SafeArea(
            child: Stack(
              children: [
                // Main Content basado en el tab seleccionado
                _buildCurrentView(),
                
                // Banner flotante para Home tab
                if (_selectedIndex == 0) _buildFloatingBanner(),
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
              currentIndex: _isShiftsModalOpen ? 1 : _selectedIndex,
              onTap: _handleBottomNavTap,
              selectedItemColor: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
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
        if (_isSidebarOpen)
          Positioned(
            left: screenWidth * 0.7, // Empezar después del sidebar
            top: 0,
            right: 0,
            bottom: 0,
            child: GestureDetector(
              onTap: _closeSidebar,
              child: Container(
                color: Colors.black.withOpacity(0.3),
              ),
            ),
          ),
        
        // Sidebar (por encima de todo, sin overlay)
        if (_isSidebarOpen)
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: screenWidth * 0.7,
              child: Sidebar(
                flavor: _currentFlavor,
                onClose: _closeSidebar,
              ),
            ),
          ),
        
        // Overlay semi-transparente para el modal de shifts
        if (_isShiftsModalOpen)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),
        
        // Modal de Shifts (por encima de todo)
        if (_isShiftsModalOpen)
          _buildShiftsModal(),
      ],
    );
  }
  
  Widget _buildShiftsModal() {
    final mediaQuery = MediaQuery.of(context);
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
                      setState(() {
                        _isShiftsModalOpen = false;
                      });
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
                      setState(() {
                        _focusedDate = DateTime(
                          _focusedDate.year,
                          _focusedDate.month - 1,
                        );
                      });
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black,
                      size: screenWidth * 0.04,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      _getMonthYearString(_focusedDate),
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
                      setState(() {
                        _focusedDate = DateTime(
                          _focusedDate.year,
                          _focusedDate.month + 1,
                        );
                      });
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
                    if (_hasShiftsForSelectedDate()) ...[
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
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final subtitleFontSize = screenWidth * 0.035;

    final firstDayOfMonth = DateTime(_focusedDate.year, _focusedDate.month, 1);
    final lastDayOfMonth = DateTime(_focusedDate.year, _focusedDate.month + 1, 0);
    final firstWeekday = firstDayOfMonth.weekday;
    final daysInMonth = lastDayOfMonth.day;

    List<Widget> calendarDays = [];

    // Agregar días vacíos al inicio
    for (int i = 1; i < firstWeekday; i++) {
      calendarDays.add(const SizedBox());
    }

    // Agregar días del mes
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_focusedDate.year, _focusedDate.month, day);
      final isSelected = date.year == _selectedDate.year &&
          date.month == _selectedDate.month &&
          date.day == _selectedDate.day;
      
      final dateKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final hasShift = _shiftsData.containsKey(dateKey);

      calendarDays.add(
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              setState(() {
                _selectedDate = date;
              });
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected ? Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)) : Colors.transparent,
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
                          color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
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

  String _getMonthYearString(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  bool _hasShiftsForSelectedDate() {
    final dateKey = '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}';
    return _shiftsData.containsKey(dateKey);
  }

  Widget _buildShiftsSection() {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final subtitleFontSize = screenWidth * 0.035;

    final dateKey = '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}';
    final shifts = _shiftsData[dateKey] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
                  Text(
            'Shifts for ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
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
    final mediaQuery = MediaQuery.of(context);
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
              color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }
}
