import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CompanyField extends StatelessWidget {
  final String? selectedCompany;
  final VoidCallback onTap;
  final double? fontSize;

  const CompanyField({
    super.key,
    this.selectedCompany,
    required this.onTap,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                selectedCompany?.isNotEmpty == true 
                    ? selectedCompany! 
                    : "Company Name",
                style: GoogleFonts.poppins(
                  fontSize: fontSize ?? 16,
                  color: selectedCompany?.isNotEmpty == true 
                      ? Colors.black 
                      : Colors.grey[600],
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              color: Colors.grey[600],
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
