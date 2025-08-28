import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/app_flavor.dart';

class SearchInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final AppFlavor? flavor;
  final Function(String)? onChanged;
  final Function()? onSearch;
  final double? height;
  final double? fontSize;

  const SearchInputField({
    super.key,
    required this.controller,
    required this.hintText,
    this.flavor,
    this.onChanged,
    this.onSearch,
    this.height,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final currentFlavor = flavor ?? AppFlavorConfig.currentFlavor;
    final inputHeight = height ?? 45.0;
    final inputFontSize = fontSize ?? screenWidth * 0.035;

    return SizedBox(
      width: double.infinity,
      height: inputHeight,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.poppins(
            color: Colors.grey[400],
            fontSize: inputFontSize,
          ),
          suffixIcon: GestureDetector(
            onTap: onSearch,
            child: Container(
              margin: EdgeInsets.only(right: 0, top: 0, bottom: 0),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(AppFlavorConfig.getPrimaryColor(currentFlavor)),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: Icon(
                Icons.search,
                color: Colors.black,
                size: 20,
              ),
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Colors.grey[300]!,
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Colors.grey[300]!,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Color(AppFlavorConfig.getPrimaryColor(currentFlavor)),
              width: 2,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: horizontalPadding * 0.8,
            vertical: verticalSpacing * 0.4,
          ),
        ),
        style: GoogleFonts.poppins(
          fontSize: inputFontSize,
          color: Colors.black,
        ),
        onChanged: onChanged,
      ),
    );
  }
}
