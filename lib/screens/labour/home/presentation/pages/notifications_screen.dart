import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/app_flavor.dart';
import '../../data/notification_dto.dart';
import '../../logic/controllers/notifications_screen_controller.dart';
import '../widgets/under_construction_widget.dart';

class NotificationsScreen extends StatelessWidget {
  static const String id = '/labour/notifications';
  
  final AppFlavor? flavor;
  
  // Booleano para controlar si mostrar el widget de construcción o el contenido normal
  static const bool showUnderConstruction = true;

  NotificationsScreen({
    super.key,
    this.flavor,
  });

  final NotificationsScreenController controller = Get.put(NotificationsScreenController());

  @override
  Widget build(BuildContext context) {
    // Si está en modo construcción, mostrar el widget de construcción con AppBar
    if (showUnderConstruction) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: MediaQuery.of(context).size.width * 0.06,
            ),
            onPressed: () => Get.back(),
          ),
          title: Text(
            'Notifications',
            style: GoogleFonts.poppins(
              fontSize: MediaQuery.of(context).size.width * 0.055,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.06,
              vertical: MediaQuery.of(context).size.height * 0.05,
            ),
            child: UnderConstructionWidget(
              flavor: flavor ?? AppFlavorConfig.currentFlavor,
              customMessage: "We are working on improving your notifications and alerts system. This will be available soon with enhanced notification management!",
            ),
          ),
        ),
      );
    }

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
    final bodyFontSize = screenWidth * 0.035;
    final tabFontSize = screenWidth * 0.032;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalSpacing * 2,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: controller.handleBackNavigation,
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.black87,
                      size: screenWidth * 0.06,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Notifications',
                      style: GoogleFonts.poppins(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                                     IconButton(
                     onPressed: controller.refreshNotifications,
                     icon: Icon(
                       Icons.refresh,
                       color: Colors.black87,
                       size: screenWidth * 0.06,
                     ),
                   ),
                ],
              ),
            ),

                         // Tabs
             Container(
               color: Colors.white,
               padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
               child: SingleChildScrollView(
                 scrollDirection: Axis.horizontal,
                 child: Row(
                   children: [
                     _buildTab('All', controller.allNotifications.length, 0, tabFontSize),
                     _buildTab('Hire Requests', controller.hireNotifications.length, 1, tabFontSize),
                     _buildTab('Hired', controller.hiredNotifications.length, 2, tabFontSize),
                     _buildTab('Payments', controller.paymentNotifications.length, 3, tabFontSize),
                     _buildTab('Timesheets', controller.timesheetNotifications.length, 4, tabFontSize),
                   ],
                 ),
               ),
             ),

             // Notifications List
             Expanded(
               child: GetBuilder<NotificationsScreenController>(
                 builder: (controller) => controller.currentNotifications.isEmpty
                     ? _buildEmptyState(screenWidth, screenHeight, horizontalPadding, verticalSpacing, bodyFontSize)
                     : ListView.builder(
                         padding: EdgeInsets.symmetric(vertical: verticalSpacing),
                         itemCount: controller.currentNotifications.length,
                         itemBuilder: (context, index) {
                           final notification = controller.currentNotifications[index];
                         return _buildNotificationCard(
                           notification,
                           screenWidth,
                           screenHeight,
                           horizontalPadding,
                           verticalSpacing,
                           bodyFontSize,
                         );
                       },
                     ),
               ),
             ),
          ],
        ),
      ),
    );
  }



  Widget _buildTab(String title, int count, int index, double fontSize) {
    final mediaQuery = MediaQuery.of(Get.context!);
    final screenWidth = mediaQuery.size.width;
    final horizontalPadding = screenWidth * 0.06;
    
    return GetBuilder<NotificationsScreenController>(
      builder: (controller) {
        final isSelected = controller.selectedTabIndex == index;
        
        return GestureDetector(
          onTap: () => controller.setSelectedTabIndex(index),
      child: Container(
        margin: EdgeInsets.only(right: horizontalPadding * 0.5),
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding * 0.8,
          vertical: horizontalPadding * 0.4,
        ),
        decoration: BoxDecoration(
          color: isSelected 
              ? Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          '$title $count',
          style: GoogleFonts.poppins(
            fontSize: fontSize,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? Colors.white : Colors.grey[600],
          ),
        ),
      ),
        );
      },
    );
  }

  Widget _buildNotificationCard(
    NotificationItem notification,
    double screenWidth,
    double screenHeight,
    double horizontalPadding,
    double verticalSpacing,
    double bodyFontSize,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalSpacing * 0.5,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => controller.handleNotificationTap(notification),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(horizontalPadding * 0.8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                                 // Icono de notificación
                 Container(
                   width: screenWidth * 0.12,
                   height: screenWidth * 0.12,
                   decoration: BoxDecoration(
                     color: controller.getNotificationColor(notification.type).withOpacity(0.1),
                     shape: BoxShape.circle,
                   ),
                   child: Icon(
                     controller.getNotificationIcon(notification.type),
                     color: controller.getNotificationColor(notification.type),
                     size: screenWidth * 0.06,
                   ),
                 ),
                
                SizedBox(width: horizontalPadding * 0.6),
                
                // Contenido de la notificación
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.title,
                        style: GoogleFonts.poppins(
                          fontSize: bodyFontSize,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      
                      SizedBox(height: verticalSpacing * 0.3),
                      
                      Text(
                        notification.message,
                        style: GoogleFonts.poppins(
                          fontSize: bodyFontSize * 0.9,
                          color: Colors.grey[600],
                          height: 1.3,
                        ),
                      ),
                      
                      if (notification.jobTitle != null) ...[
                        SizedBox(height: verticalSpacing * 0.3),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: horizontalPadding * 0.4,
                            vertical: verticalSpacing * 0.2,
                          ),
                          decoration: BoxDecoration(
                            color: Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            notification.jobTitle!,
                            style: GoogleFonts.poppins(
                              fontSize: bodyFontSize * 0.8,
                              fontWeight: FontWeight.w500,
                              color: Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)),
                            ),
                          ),
                        ),
                      ],
                      
                      if (notification.amount != null) ...[
                        SizedBox(height: verticalSpacing * 0.3),
                        Text(
                          '\$${notification.amount!.toStringAsFixed(2)}',
                          style: GoogleFonts.poppins(
                            fontSize: bodyFontSize * 0.9,
                            fontWeight: FontWeight.w600,
                            color: Colors.green[700],
                          ),
                        ),
                      ],
                      
                      SizedBox(height: verticalSpacing * 0.3),
                      
                                             Text(
                         controller.getTimeAgo(notification.timestamp),
                         style: GoogleFonts.poppins(
                           fontSize: bodyFontSize * 0.8,
                           color: Colors.grey[500],
                         ),
                       ),
                    ],
                  ),
                ),
                
                // Indicador de no leído
                if (!notification.isRead)
                  Container(
                    width: screenWidth * 0.02,
                    height: screenWidth * 0.02,
                    decoration: BoxDecoration(
                      color: Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)),
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(
    double screenWidth,
    double screenHeight,
    double horizontalPadding,
    double verticalSpacing,
    double bodyFontSize,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: screenWidth * 0.2,
            height: screenWidth * 0.2,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_none,
              size: screenWidth * 0.1,
              color: Colors.grey[600],
            ),
          ),
          
          SizedBox(height: verticalSpacing * 2),
          
          Text(
            'No notifications',
            style: GoogleFonts.poppins(
              fontSize: bodyFontSize * 1.2,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          
          SizedBox(height: verticalSpacing),
          
          Text(
            'You\'re all caught up!',
            style: GoogleFonts.poppins(
              fontSize: bodyFontSize,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
