import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../config/assets_config.dart';
import 'respect_screen.dart';

class EmployeeSelectionScreen extends StatefulWidget {
  final AppFlavor? flavor;

  const EmployeeSelectionScreen({
    super.key,
    this.flavor,
  });

  @override
  State<EmployeeSelectionScreen> createState() => _EmployeeSelectionScreenState();
}

class _EmployeeSelectionScreenState extends State<EmployeeSelectionScreen> {
  String? _selectedEmployeeRange;

  final List<String> _employeeRanges = [
    '0-1',
    '2-6',
    '7-15',
    '16-49',
    '50+',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Botón de regreso
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 24,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Icono de mano mágica
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Image.asset(
                    AssetsConfig.getEmployees(widget.flavor ?? AppFlavorConfig.currentFlavor),
                    height: 60,
                    width: 60,
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 16,
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Título
              Text(
                'How many employees does your company have?',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              // Opciones de empleados
              Expanded(
                child: Column(
                  children: _employeeRanges.map((range) {
                    final isSelected = _selectedEmployeeRange == range;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedEmployeeRange = range;
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                          decoration: BoxDecoration(
                            color: isSelected 
                                ? Color(AppFlavorConfig.getPrimaryColor(widget.flavor ?? AppFlavorConfig.currentFlavor))
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected 
                                  ? Color(AppFlavorConfig.getPrimaryColor(widget.flavor ?? AppFlavorConfig.currentFlavor))
                                  : Colors.grey[300]!,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            range,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: isSelected ? Colors.black : Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              // Botón Next
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 20),
                child: ElevatedButton(
                  onPressed: _selectedEmployeeRange != null ? _handleNext : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(AppFlavorConfig.getPrimaryColor(widget.flavor ?? AppFlavorConfig.currentFlavor)),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Next',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleNext() {
    if (_selectedEmployeeRange != null) {
      // Navegar a la pantalla de respeto
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RespectScreen(
            flavor: widget.flavor,
          ),
        ),
      );
    }
  }
}
