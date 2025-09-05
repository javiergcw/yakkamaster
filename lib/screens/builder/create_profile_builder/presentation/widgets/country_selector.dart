import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/countries.dart';
import '../../../../../config/app_flavor.dart';

class CountrySelector extends StatefulWidget {
  final String initialCountryCode;
  final Function(Country) onCountryChanged;
  final AppFlavor? flavor;

  const CountrySelector({
    super.key,
    required this.initialCountryCode,
    required this.onCountryChanged,
    this.flavor,
  });

  @override
  State<CountrySelector> createState() => _CountrySelectorState();
}

class _CountrySelectorState extends State<CountrySelector> {
  late Country selectedCountry;
  List<Country> filteredCountries = countries;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedCountry = countries.firstWhere(
      (country) => country.code == widget.initialCountryCode,
      orElse: () => countries.firstWhere((country) => country.code == 'AU'),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void filterCountries(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredCountries = countries;
      } else {
        filteredCountries = countries.where((country) {
          return country.name.toLowerCase().contains(query.toLowerCase()) ||
                 country.code.toLowerCase().contains(query.toLowerCase()) ||
                 country.dialCode.contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;

    return GestureDetector(
      onTap: () => _showCountryPicker(context, screenWidth),
      child: Container(
        height: screenWidth * 0.12,
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
          child: Row(
            children: [
              Text(
                selectedCountry.flag,
                style: TextStyle(fontSize: screenWidth * 0.05),
              ),
              SizedBox(width: screenWidth * 0.02),
              Text(
                '+${selectedCountry.dialCode}',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.04,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.keyboard_arrow_down,
                color: Colors.grey[600],
                size: screenWidth * 0.05,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCountryPicker(BuildContext context, double screenWidth) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              width: screenWidth * 0.15,
              height: 4,
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Select Country',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            
            // Search field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: searchController,
                onChanged: filterCountries,
                decoration: InputDecoration(
                  hintText: 'Search country...',
                  hintStyle: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.04,
                    color: Colors.grey[500],
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey[600],
                    size: screenWidth * 0.05,
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: screenWidth * 0.03,
                  ),
                ),
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.04,
                  color: Colors.black87,
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Countries list
            Expanded(
              child: ListView.builder(
                itemCount: filteredCountries.length,
                itemBuilder: (context, index) {
                  final country = filteredCountries[index];
                  final isSelected = country.code == selectedCountry.code;
                  
                  return ListTile(
                    leading: Text(
                      country.flag,
                      style: TextStyle(fontSize: screenWidth * 0.05),
                    ),
                    title: Text(
                      country.name,
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.04,
                        color: Colors.black87,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                    trailing: Text(
                      '+${country.dialCode}',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.04,
                        color: Colors.grey[600],
                      ),
                    ),
                    selected: isSelected,
                    selectedTileColor: Colors.grey[100],
                    onTap: () {
                      setState(() {
                        selectedCountry = country;
                      });
                      widget.onCountryChanged(country);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
