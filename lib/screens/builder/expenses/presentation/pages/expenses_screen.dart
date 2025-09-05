import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../../config/app_flavor.dart';
import '../../logic/controllers/expenses_controller.dart';

class ExpensesScreen extends StatelessWidget {
  static const String id = '/builder/expenses';
  
  final AppFlavor? flavor;

  ExpensesScreen({super.key, this.flavor});

  ExpensesController get controller => Get.find<ExpensesController>();

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
    final titleFontSize = screenWidth * 0.055;
    final bodyFontSize = screenWidth * 0.045;
    final subtitleFontSize = screenWidth * 0.04;
    final smallFontSize = screenWidth * 0.035;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header (Dark Grey)
            _buildHeader(context, horizontalPadding, verticalSpacing, titleFontSize),
            
            // Main Content (Scrollable)
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding, 
                  horizontalPadding * 0.3, // Padding superior reducido
                  horizontalPadding, 
                  horizontalPadding
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: verticalSpacing * 0.2), // Espacio reducido
                    
                    // Filter jobsite button
                    _buildFilterJobsiteButton(horizontalPadding, verticalSpacing, bodyFontSize),
                    
                    SizedBox(height: verticalSpacing * 0.5), // Espacio reducido
                    
                    // Date range tabs
                    _buildDateRangeTabs(horizontalPadding, verticalSpacing, bodyFontSize),
                    
                    SizedBox(height: verticalSpacing * 0.8), // Espacio reducido
                    
                    // Summary Statistics Cards
                    _buildSummaryCards(horizontalPadding, verticalSpacing, bodyFontSize, smallFontSize),
                    
                    SizedBox(height: verticalSpacing * 1.5),
                    
                    // Hours Graph Section
                    _buildHoursGraphSection(horizontalPadding, verticalSpacing, bodyFontSize, smallFontSize),
                    
                    SizedBox(height: verticalSpacing * 1.5),
                    
                    // By Worker Section
                    _buildByWorkerSection(horizontalPadding, verticalSpacing, bodyFontSize, subtitleFontSize, smallFontSize),
                    
                    SizedBox(height: verticalSpacing * 2),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, double horizontalPadding, double verticalSpacing, double titleFontSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalSpacing * 1.2,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[800],
      ),
      child: Row(
        children: [
          // Back Button
          GestureDetector(
            onTap: () => Get.back(),
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: screenWidth * 0.06,
            ),
          ),
          
          SizedBox(width: horizontalPadding),
          
          // Title
          Expanded(
            child: Text(
              "Reporting",
              style: GoogleFonts.poppins(
                fontSize: titleFontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          SizedBox(width: horizontalPadding + screenWidth * 0.06),
        ],
      ),
    );
  }

  Widget _buildFilterJobsiteButton(double horizontalPadding, double verticalSpacing, double bodyFontSize) {
    return GestureDetector(
      onTap: () => controller.navigateToFilterJobSites(),
      child: Container(
        width: double.infinity,
        height: 40, // Altura fija reducida
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
        ),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, // Centrado horizontal
          children: [
            Icon(
              Icons.filter_list,
              color: Colors.grey[600],
              size: bodyFontSize * 1.1, // Tamaño ligeramente reducido
            ),
            SizedBox(width: horizontalPadding * 0.3), // Espaciado reducido
            Obx(() => Text(
              controller.selectedJobsiteDisplayName.value,
              style: GoogleFonts.poppins(
                fontSize: bodyFontSize * 0.9, // Tamaño ligeramente reducido
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildDateRangeTabs(double horizontalPadding, double verticalSpacing, double bodyFontSize) {
    return Obx(() => Row(
      children: [
        Expanded(
          child: _buildDateTab(
            "This week",
            controller.selectedDateRange.value == "this_week",
            () => controller.selectDateRange("this_week"),
            bodyFontSize,
            verticalSpacing,
          ),
                 ),
         SizedBox(width: horizontalPadding * 0.2),
         Expanded(
           child: _buildDateTab(
             "Last 30 days",
            controller.selectedDateRange.value == "last_30_days",
            () => controller.selectDateRange("last_30_days"),
            bodyFontSize,
            verticalSpacing,
          ),
                 ),
         SizedBox(width: horizontalPadding * 0.2),
         Expanded(
           child: _buildDateTab(
             "Custom",
             controller.selectedDateRange.value == "custom",
             () => controller.navigateToCustomDateRange(),
             bodyFontSize,
             verticalSpacing,
           ),
         ),
      ],
    ));
  }

  Widget _buildDateTab(String text, bool isSelected, VoidCallback onTap, double bodyFontSize, double verticalSpacing) {
    final mediaQuery = MediaQuery.of(Get.context!);
    final screenWidth = mediaQuery.size.width;
    final horizontalPadding = screenWidth * 0.06;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
                 height: 36, // Altura fija para todos los botones
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding * 0.3,
        ),
        decoration: BoxDecoration(
          color: isSelected 
              ? Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value))
              : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected 
                ? Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value))
                : Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            text,
                         style: GoogleFonts.poppins(
               fontSize: bodyFontSize * 0.75,
               fontWeight: FontWeight.w600,
               color: isSelected ? Colors.white : Colors.grey[700],
             ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCards(double horizontalPadding, double verticalSpacing, double bodyFontSize, double smallFontSize) {
    return Column(
      children: [
        // First row
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                "Total paid",
                "\$25,500.00",
                horizontalPadding,
                verticalSpacing,
                bodyFontSize,
                smallFontSize,
              ),
            ),
            SizedBox(width: horizontalPadding * 0.5),
            Expanded(
              child: _buildSummaryCard(
                "Total hours",
                "312h",
                horizontalPadding,
                verticalSpacing,
                bodyFontSize,
                smallFontSize,
              ),
            ),
          ],
        ),
        SizedBox(height: verticalSpacing * 0.8),
        // Second row
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                "Workers hired",
                "14",
                horizontalPadding,
                verticalSpacing,
                bodyFontSize,
                smallFontSize,
              ),
            ),
            SizedBox(width: horizontalPadding * 0.5),
            Expanded(
              child: _buildSummaryCard(
                "Avg hourly rate",
                "\$32/h",
                horizontalPadding,
                verticalSpacing,
                bodyFontSize,
                smallFontSize,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String value, double horizontalPadding, double verticalSpacing, double bodyFontSize, double smallFontSize) {
    return Container(
      height: 80, // Altura reducida
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding * 0.6, // Padding horizontal reducido
        vertical: verticalSpacing * 0.4, // Padding vertical reducido
      ),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // Centrado horizontal
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: smallFontSize * 0.95, // Tamaño aumentado
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: verticalSpacing * 0.15), // Espaciado reducido
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: bodyFontSize * 0.95, // Tamaño ligeramente reducido
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildHoursGraphSection(double horizontalPadding, double verticalSpacing, double bodyFontSize, double smallFontSize) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(horizontalPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title and icons
          Row(
            children: [
              Text(
                "Hours",
                style: GoogleFonts.poppins(
                  fontSize: bodyFontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Spacer(),
              Icon(
                Icons.filter_list,
                color: Colors.grey[600],
                size: bodyFontSize * 1.2,
              ),
              SizedBox(width: horizontalPadding * 0.5),
              Icon(
                Icons.download,
                color: Colors.grey[600],
                size: bodyFontSize * 1.2,
              ),
            ],
          ),
          
          SizedBox(height: verticalSpacing * 1.5),
          
                     // Hours Graph
           Container(
             height: 200,
             width: double.infinity,
             decoration: BoxDecoration(
               color: Colors.grey[50],
               borderRadius: BorderRadius.circular(8),
             ),
             child: Padding(
               padding: EdgeInsets.all(16),
               child: Obx(() => LineChart(
                 LineChartData(
                   gridData: FlGridData(
                     show: true,
                     drawVerticalLine: true,
                     horizontalInterval: 1,
                     verticalInterval: controller.selectedDateRange.value == "last_30_days" ? 5 : 1,
                     getDrawingHorizontalLine: (value) {
                       return FlLine(
                         color: Colors.grey[300]!,
                         strokeWidth: 1,
                       );
                     },
                     getDrawingVerticalLine: (value) {
                       return FlLine(
                         color: Colors.grey[300]!,
                         strokeWidth: 1,
                       );
                     },
                   ),
                   titlesData: FlTitlesData(
                     show: true,
                     rightTitles: AxisTitles(
                       sideTitles: SideTitles(showTitles: false),
                     ),
                     topTitles: AxisTitles(
                       sideTitles: SideTitles(showTitles: false),
                     ),
                     bottomTitles: AxisTitles(
                       sideTitles: SideTitles(showTitles: false),
                     ),
                     leftTitles: AxisTitles(
                       sideTitles: SideTitles(showTitles: false),
                     ),
                   ),
                   borderData: FlBorderData(
                     show: false,
                   ),
                   minX: 0,
                   maxX: controller.selectedDateRange.value == "last_30_days" ? 29 : 6,
                   minY: 0,
                   maxY: 10,
                   lineBarsData: [
                     LineChartBarData(
                       spots: controller.getChartData(),
                       isCurved: true,
                       gradient: LinearGradient(
                         colors: [
                           Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)),
                           Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)).withOpacity(0.3),
                         ],
                       ),
                       barWidth: 3,
                       isStrokeCapRound: true,
                       dotData: FlDotData(
                         show: true,
                         getDotPainter: (spot, percent, barData, index) {
                           return FlDotCirclePainter(
                             radius: 4,
                             color: Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)),
                             strokeWidth: 2,
                             strokeColor: Colors.white,
                           );
                         },
                       ),
                       belowBarData: BarAreaData(
                         show: true,
                         gradient: LinearGradient(
                           colors: [
                             Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)).withOpacity(0.2),
                             Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)).withOpacity(0.05),
                           ],
                           begin: Alignment.topCenter,
                           end: Alignment.bottomCenter,
                         ),
                       ),
                     ),
                   ],
                 ),
               )),
             ),
           ),
          
          SizedBox(height: verticalSpacing * 0.8),
          
          // Days labels
          Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: controller.getChartLabels().map((label) => 
              _buildDayLabel(label, smallFontSize)
            ).toList(),
          )),
        ],
      ),
    );
  }

  Widget _buildDayLabel(String day, double smallFontSize) {
    return Text(
      day,
      style: GoogleFonts.poppins(
        fontSize: smallFontSize,
        color: Colors.grey[600],
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildByWorkerSection(double horizontalPadding, double verticalSpacing, double bodyFontSize, double subtitleFontSize, double smallFontSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with title and search icon
        Row(
          children: [
            Text(
              "By worker",
              style: GoogleFonts.poppins(
                fontSize: bodyFontSize,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Spacer(),
            Icon(
              Icons.search,
              color: Colors.grey[600],
              size: bodyFontSize * 1.2,
            ),
          ],
        ),
        
        SizedBox(height: verticalSpacing),
        
        // Worker list
        _buildWorkerItem(
          "José Perez",
          "General Labour",
          "21/08/2025 - 8h x \$23/hr",
          "\$283,05",
          true, // Paid
          horizontalPadding,
          verticalSpacing,
          subtitleFontSize,
          smallFontSize,
        ),
        
        SizedBox(height: verticalSpacing * 0.8),
        
        _buildWorkerItem(
          "John Bailey",
          "Concreter",
          "25/08/2025 - 5h x \$23/hr",
          "\$115,05",
          false, // Pending
          horizontalPadding,
          verticalSpacing,
          subtitleFontSize,
          smallFontSize,
        ),
      ],
    );
  }

  Widget _buildWorkerItem(String name, String role, String details, String amount, bool isPaid, double horizontalPadding, double verticalSpacing, double subtitleFontSize, double smallFontSize) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(horizontalPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.poppins(
                    fontSize: subtitleFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: verticalSpacing * 0.2),
                Text(
                  role,
                  style: GoogleFonts.poppins(
                    fontSize: smallFontSize,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: verticalSpacing * 0.2),
                Text(
                  details,
                  style: GoogleFonts.poppins(
                    fontSize: smallFontSize * 0.9,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: GoogleFonts.poppins(
                  fontSize: subtitleFontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: verticalSpacing * 0.2),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: isPaid ? Colors.green : Colors.grey[400],
                    size: smallFontSize * 1.2,
                  ),
                  SizedBox(width: horizontalPadding * 0.2),
                  Text(
                    isPaid ? "Paid" : "Pending",
                    style: GoogleFonts.poppins(
                      fontSize: smallFontSize,
                      color: isPaid ? Colors.green : Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

