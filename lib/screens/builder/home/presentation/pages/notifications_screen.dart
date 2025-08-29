import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../features/widgets/custom_button.dart';
import '../../data/notification_dto.dart';
import '../../logic/notifications_controller.dart';

class NotificationsScreen extends StatefulWidget {
  final AppFlavor? flavor;

  const NotificationsScreen({
    super.key,
    this.flavor,
  });

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  AppFlavor get _currentFlavor => widget.flavor ?? AppFlavorConfig.currentFlavor;
  
  // Controlador de notificaciones
  late final NotificationsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = NotificationsController();
  }

  void _markAllAsRead() {
    _controller.markAllAsRead();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('All notifications marked as read'),
        backgroundColor: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleNotificationTap(NotificationItem notification) {
    _controller.handleNotificationTap(notification);
    
    // Ejemplo: mostrar un diálogo con más detalles
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(notification.title),
        content: Text(notification.message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
        ],
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
                    onPressed: () => Navigator.of(context).pop(),
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
                    onPressed: () {
                      // Refresh notifications
                      setState(() {
                        _controller.refreshNotifications();
                      });
                    },
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
                    _buildTab('All', _controller.allNotifications.length, 0, tabFontSize),
                    _buildTab('Hire Requests', _controller.hireNotifications.length, 1, tabFontSize),
                    _buildTab('Hired', _controller.hiredNotifications.length, 2, tabFontSize),
                    _buildTab('Payments', _controller.paymentNotifications.length, 3, tabFontSize),
                    _buildTab('Timesheets', _controller.timesheetNotifications.length, 4, tabFontSize),
                  ],
                ),
              ),
            ),

            // Notifications List
            Expanded(
              child: _controller.currentNotifications.isEmpty
                  ? _buildEmptyState(screenWidth, screenHeight, horizontalPadding, verticalSpacing, bodyFontSize)
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: verticalSpacing),
                      itemCount: _controller.currentNotifications.length,
                      itemBuilder: (context, index) {
                        final notification = _controller.currentNotifications[index];
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
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String title, int count, int index, double fontSize) {
    final isSelected = _controller.selectedTabIndex == index;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _controller.setSelectedTabIndex(index);
        });
      },
      child: Container(
        margin: EdgeInsets.only(right: 16),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected 
              ? Color(AppFlavorConfig.getPrimaryColor(_currentFlavor))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Colors.grey[600],
              ),
            ),
            if (count > 0) ...[
              SizedBox(width: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  count.toString(),
                  style: GoogleFonts.poppins(
                    fontSize: fontSize * 0.8,
                    fontWeight: FontWeight.w600,
                    color: isSelected 
                        ? Color(AppFlavorConfig.getPrimaryColor(_currentFlavor))
                        : Colors.grey[700],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
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
          onTap: () => _handleNotificationTap(notification),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(horizontalPadding * 0.8),
            child: Row(
              children: [
                // Icon Container
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: _controller.getNotificationColor(notification.type).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Icon(
                    _controller.getNotificationIcon(notification.type),
                    color: _controller.getNotificationColor(notification.type),
                    size: 24,
                  ),
                ),
                
                SizedBox(width: 12),
                
                // Content
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
                      
                      SizedBox(height: 4),
                      
                      Text(
                        notification.message,
                        style: GoogleFonts.poppins(
                          fontSize: bodyFontSize * 0.9,
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      if (notification.jobTitle != null) ...[
                        SizedBox(height: 4),
                        Text(
                          notification.jobTitle!,
                          style: GoogleFonts.poppins(
                            fontSize: bodyFontSize * 0.8,
                            fontWeight: FontWeight.w500,
                            color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                          ),
                        ),
                      ],
                      
                      SizedBox(height: 4),
                      
                      Text(
                        _controller.getTimeAgo(notification.timestamp),
                        style: GoogleFonts.poppins(
                          fontSize: bodyFontSize * 0.8,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Unread indicator
                if (!notification.isRead)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
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
