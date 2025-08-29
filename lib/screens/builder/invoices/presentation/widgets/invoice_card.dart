import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/app_flavor.dart';
import '../../data/dto/invoice_dto.dart';

class InvoiceCard extends StatelessWidget {
  final InvoiceDto invoice;
  final AppFlavor? flavor;
  final VoidCallback onView;
  final VoidCallback onSend;
  final VoidCallback onReport;
  final VoidCallback onPay;
  final VoidCallback onToggleSelection;

  const InvoiceCard({
    super.key,
    required this.invoice,
    this.flavor,
    required this.onView,
    required this.onSend,
    required this.onReport,
    required this.onPay,
    required this.onToggleSelection,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      margin: EdgeInsets.only(right: 16),
      padding: EdgeInsets.fromLTRB(12, 12, 12, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            offset: const Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with profile picture, info, and actions
          Row(
            children: [
              // Profile Picture
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22.5),
                  image: DecorationImage(
                    image: NetworkImage(invoice.workerImageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              
              SizedBox(width: 10),
              
              // Worker Information
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            invoice.workerName,
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        // View and Checkbox buttons
                        Row(
                          children: [
                            GestureDetector(
                              onTap: onView,
                              child: Container(
                                padding: EdgeInsets.all(4),
                                child: Icon(
                                  Icons.visibility,
                                  size: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            GestureDetector(
                              onTap: onToggleSelection,
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: invoice.isSelected ? Color(AppFlavorConfig.getPrimaryColor(flavor ?? AppFlavorConfig.currentFlavor)) : Colors.transparent,
                                  border: Border.all(
                                    color: invoice.isSelected ? Color(AppFlavorConfig.getPrimaryColor(flavor ?? AppFlavorConfig.currentFlavor)) : Colors.grey[400]!,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: invoice.isSelected
                                    ? Icon(
                                        Icons.check,
                                        size: 14,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 2),
                    Text(
                      invoice.workerRole,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          SizedBox(height: 12),
          
          // Action Buttons Row
          Row(
            children: [
              // View Button
              Expanded(
                child: SizedBox(
                  height: 32,
                  child: OutlinedButton.icon(
                    onPressed: onView,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey[300]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    icon: Icon(Icons.visibility, size: 14, color: Colors.grey[600]),
                    label: Text(
                      'View',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ),
              ),
              
              SizedBox(width: 6),
              
              // Send Button
              Expanded(
                child: SizedBox(
                  height: 32,
                  child: OutlinedButton.icon(
                    onPressed: onSend,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey[300]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    icon: Icon(Icons.send, size: 14, color: Colors.grey[600]),
                    label: Text(
                      'Send',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ),
              ),
              
              SizedBox(width: 6),
              
              // Report Button
              Expanded(
                child: SizedBox(
                  height: 32,
                  child: OutlinedButton.icon(
                    onPressed: onReport,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey[300]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    icon: Icon(Icons.report, size: 14, color: Colors.grey[600]),
                    label: Text(
                      'Report',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: 12),
          
          // Payment Details Row
          Row(
            children: [
              // Left side - Total and Date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      '\$${invoice.total.toStringAsFixed(2)}',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      invoice.date,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Right side - Pay Button
              SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: onPay,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(AppFlavorConfig.getPrimaryColor(flavor ?? AppFlavorConfig.currentFlavor)),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  icon: Icon(Icons.payment, size: 16),
                  label: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Pay',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Pay by Bank',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
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
    );
  }
}
