import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../config/app_flavor.dart';
import '../../../../config/assets_config.dart';

class JobSearchBar extends StatelessWidget {
  final String placeholder;
  final String searchQuery;
  final Function(String) onSearchChanged;
  final VoidCallback onSearch;
  final double horizontalPadding;
  final double verticalSpacing;
  final double bodyFontSize;
  final double iconSize;

  const JobSearchBar({
    super.key,
    required this.placeholder,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onSearch,
    required this.horizontalPadding,
    required this.verticalSpacing,
    required this.bodyFontSize,
    required this.iconSize,
    this.flavor,
  });

  final AppFlavor? flavor;
  AppFlavor get _currentFlavor => flavor ?? AppFlavorConfig.currentFlavor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: verticalSpacing),
      child: Row(
        children: [
          // Search input field
          Expanded(
            child: Container(
                             padding: EdgeInsets.symmetric(
                 horizontal: horizontalPadding,
                 vertical: verticalSpacing * 0.3, // Más reducido la altura del input
               ),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: TextEditingController(text: searchQuery),
                onChanged: onSearchChanged,
                style: GoogleFonts.poppins(
                  fontSize: bodyFontSize,
                  color: Colors.black87,
                ),
                decoration: InputDecoration(
                  hintText: placeholder,
                  hintStyle: GoogleFonts.poppins(
                    fontSize: bodyFontSize,
                    color: Colors.grey[500],
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
          
          SizedBox(width: horizontalPadding * 0.5),
          
          // Search button
          GestureDetector(
            onTap: onSearch,
            child: Container(
              width: iconSize * 2.5,
              height: iconSize * 2.5,
                             decoration: BoxDecoration(
                 color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                 borderRadius: BorderRadius.circular(8),
               ),
              child: Icon(
                Icons.search,
                size: iconSize,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
