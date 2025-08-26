import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../config/app_flavor.dart';
import '../../data/invoice_dto.dart';

class InvoiceCard extends StatelessWidget {
  final InvoiceDto invoice;
  final VoidCallback onView;
  final VoidCallback onEdit;
  final AppFlavor flavor;

  const InvoiceCard({
    super.key,
    required this.invoice,
    required this.onView,
    required this.onEdit,
    required this.flavor,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    // Calcular valores responsive
    final cardPadding = screenWidth * 0.04;
    final verticalSpacing = screenHeight * 0.015;
    final titleFontSize = screenWidth * 0.035;
    final subtitleFontSize = screenWidth * 0.03;
    final buttonFontSize = screenWidth * 0.028;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(cardPadding),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fecha
          Text(
            invoice.dateRange,
            style: GoogleFonts.poppins(
              fontSize: titleFontSize,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          
          SizedBox(height: verticalSpacing * 1.5),
          
          // Información del destinatario y botones
          Row(
            children: [
              // Avatar y información
              Expanded(
                child: Row(
                  children: [
                    // Avatar
                    Container(
                      width: screenWidth * 0.12,
                      height: screenWidth * 0.12,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                      child: invoice.recipientImage.isNotEmpty
                          ? ClipOval(
                              child: Image.network(
                                invoice.recipientImage,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.person,
                                    size: screenWidth * 0.06,
                                    color: Colors.grey[600],
                                  );
                                },
                              ),
                            )
                          : Icon(
                              Icons.person,
                              size: screenWidth * 0.06,
                              color: Colors.grey[600],
                            ),
                    ),
                    
                    SizedBox(width: screenWidth * 0.03),
                    
                    // Información del usuario
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            invoice.recipientName,
                            style: GoogleFonts.poppins(
                              fontSize: subtitleFontSize,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            invoice.recipientStatus,
                            style: GoogleFonts.poppins(
                              fontSize: subtitleFontSize * 0.9,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Botones de acción
              Column(
                children: [
                  // Botón View
                  GestureDetector(
                    onTap: () {
                      print('View button tapped for invoice: ${invoice.dateRange}');
                      onView();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.03,
                        vertical: verticalSpacing * 0.8,
                      ),
                      decoration: BoxDecoration(
                        color: Color(AppFlavorConfig.getPrimaryColor(flavor)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.list,
                            color: Colors.black,
                            size: screenWidth * 0.04,
                          ),
                          SizedBox(width: screenWidth * 0.015),
                          Text(
                            "View",
                            style: GoogleFonts.poppins(
                              fontSize: buttonFontSize,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  SizedBox(height: verticalSpacing * 0.8),
                  
                  // Botón Edit
                  GestureDetector(
                    onTap: () {
                      print('Edit button tapped for invoice: ${invoice.dateRange}');
                      onEdit();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.03,
                        vertical: verticalSpacing * 0.8,
                      ),
                      decoration: BoxDecoration(
                        color: Color(AppFlavorConfig.getPrimaryColor(flavor)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.edit,
                            color: Colors.black,
                            size: screenWidth * 0.04,
                          ),
                          SizedBox(width: screenWidth * 0.015),
                          Text(
                            "Edit",
                            style: GoogleFonts.poppins(
                              fontSize: buttonFontSize,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
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
