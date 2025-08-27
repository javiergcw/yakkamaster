import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/app_flavor.dart';

class CompanySelectionDialog extends StatefulWidget {
  final AppFlavor? flavor;
  final Function(String) onCompanySelected;
  final Function() onRegisterNewCompany;

  const CompanySelectionDialog({
    super.key,
    this.flavor,
    required this.onCompanySelected,
    required this.onRegisterNewCompany,
  });

  @override
  State<CompanySelectionDialog> createState() => _CompanySelectionDialogState();
}

class _CompanySelectionDialogState extends State<CompanySelectionDialog> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _availableCompanies = [
    'Test company by Yakka',
    'Yakka Labour LTD',
    'Construction Corp',
    'Build Masters Inc',
    'Urban Development Co',
  ];
  List<String> _filteredCompanies = [];

  @override
  void initState() {
    super.initState();
    _filteredCompanies = List.from(_availableCompanies);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterCompanies(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCompanies = List.from(_availableCompanies);
      } else {
        _filteredCompanies = _availableCompanies
            .where((company) => company.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.95,
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header con título y botón de cerrar
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Select Company',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.close,
                    color: Colors.grey[600],
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
          
          // Barra de búsqueda
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildSearchBar(),
          ),
          
          const SizedBox(height: 16),
          
          // Botón para registrar nueva empresa
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildRegisterNewCompanyButton(),
          ),
          
          const SizedBox(height: 16),
          
          // Lista de empresas
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildCompanyList(),
            ),
          ),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: "Search",
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey),
              ),
              onChanged: _filterCompanies,
            ),
          ),
          Icon(Icons.search, color: Colors.grey[600]),
        ],
      ),
    );
  }

  Widget _buildRegisterNewCompanyButton() {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        widget.onRegisterNewCompany();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              "REGISTER NEW COMPANY",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(AppFlavorConfig.getPrimaryColor(widget.flavor ?? AppFlavorConfig.currentFlavor)),
              ),
            ),
            Text(
              "or SOLE TRADER ABN",
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompanyList() {
    return ListView.builder(
      itemCount: _filteredCompanies.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.pop(context);
            widget.onCompanySelected(_filteredCompanies[index]);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Text(
              _filteredCompanies[index],
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
        );
      },
    );
  }
}
