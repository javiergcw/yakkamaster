import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/countries.dart';
import '../../config/assets_config.dart';
import 'custom_text_field.dart';

class PhoneInput extends StatefulWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final AppFlavor? flavor;
  final String? hintText;

  const PhoneInput({
    super.key,
    this.controller,
    this.validator,
    this.flavor,
    this.hintText,
  });

  @override
  State<PhoneInput> createState() => _PhoneInputState();
}

class _PhoneInputState extends State<PhoneInput> {
  String _selectedCountryCode = '+61';
  String _selectedCountry = 'AU';
  String _selectedFlag = '🇦🇺';

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    // Calcular valores responsive
    final countrySelectorWidth = screenWidth * 0.3; // 30% del ancho de pantalla
    final inputHeight = screenHeight * 0.065; // 6.5% de la altura
    final fontSize = screenWidth * 0.04; // 4% del ancho para el tamaño de fuente
    final flagSize = screenWidth * 0.05; // 5% del ancho para el tamaño de la bandera
    final iconSize = screenWidth * 0.05; // 5% del ancho para el tamaño del icono
    final spacing = screenWidth * 0.03; // 3% del ancho para espaciado
    
    return Row(
      children: [
        // Country code selector
        Container(
          width: countrySelectorWidth,
          height: inputHeight,
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: InkWell(
            onTap: () {
              _showCountrySelector();
            },
            borderRadius: BorderRadius.circular(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Bandera del país seleccionado
                Text(_selectedFlag, style: TextStyle(fontSize: flagSize)),
                SizedBox(width: spacing),
                Text(
                  _selectedCountryCode,
                  style: GoogleFonts.poppins(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(width: spacing * 0.5),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.grey[600],
                  size: iconSize,
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: spacing),
        // Phone number field
        Expanded(
          child: Container(
            height: inputHeight,
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: CustomTextField(
              controller: widget.controller,
              hintText: widget.hintText ?? "Phone number",
              keyboardType: TextInputType.phone,
              flavor: widget.flavor,
              showBorder: false,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              validator: widget.validator,
            ),
          ),
        ),
      ],
    );
  }

  void _showCountrySelector() {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    // Calcular valores responsive para el modal
    final modalHeight = screenHeight * 0.7;
    final modalPadding = screenWidth * 0.05;
    final titleFontSize = screenWidth * 0.045;
    final itemFontSize = screenWidth * 0.04;
    final subtitleFontSize = screenWidth * 0.035;
    final flagSize = screenWidth * 0.06;
    
    // Lista completa de países usando la librería intl_phone_field
    final allCountries = countries.map((country) => {
      'name': country.name,
      'code': country.code,
      'dialCode': country.dialCode,
      'flag': country.flag,
    }).toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        height: modalHeight,
        padding: EdgeInsets.all(modalPadding),
        child: Column(
          children: [
            Text(
              'Select Country',
              style: GoogleFonts.poppins(
                fontSize: titleFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: modalPadding),
            Expanded(
              child: ListView.builder(
                itemCount: allCountries.length,
                itemBuilder: (context, index) {
                  final country = allCountries[index];
                  return ListTile(
                    leading: Text(
                      country['flag']!,
                      style: TextStyle(fontSize: flagSize),
                    ),
                    title: Text(
                      country['name']!,
                      style: GoogleFonts.poppins(
                        fontSize: itemFontSize,
                        color: Colors.black87,
                      ),
                    ),
                    subtitle: Text(
                      country['dialCode']!,
                      style: GoogleFonts.poppins(
                        fontSize: subtitleFontSize,
                        color: Colors.grey[600],
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        _selectedCountryCode = country['dialCode']!;
                        _selectedCountry = country['code']!;
                        _selectedFlag = country['flag']!;
                      });
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
