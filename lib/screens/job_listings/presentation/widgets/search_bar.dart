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
      margin: EdgeInsets.symmetric(vertical: verticalSpacing * 0.5),
      child: Container(
        height: verticalSpacing * 1.8,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0, 1),
              blurRadius: 3,
              spreadRadius: 0,
            ),
          ],
        ),
        child: TextField(
          controller: TextEditingController(text: searchQuery),
          onChanged: onSearchChanged,
          onSubmitted: (value) => onSearch(),
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
            contentPadding: EdgeInsets.symmetric(
              horizontal: horizontalPadding * 0.5,
              vertical: verticalSpacing * 0.2,
            ),
            suffixIcon: Container(
              margin: EdgeInsets.all(verticalSpacing * 0.1),
              decoration: BoxDecoration(
                color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                borderRadius: BorderRadius.circular(6),
              ),
              child: IconButton(
                onPressed: onSearch,
                icon: Icon(
                  Icons.search,
                  size: iconSize,
                  color: Colors.black87,
                ),
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(
                  minWidth: verticalSpacing * 1.2,
                  minHeight: verticalSpacing * 1.2,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
