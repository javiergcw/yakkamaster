import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../features/logic/masters/use_case/master_use_case.dart';
import '../../../../../features/logic/masters/models/receive/dto_receive_company.dart';

class CompanySelectionDialogV2 extends StatefulWidget {
  final AppFlavor? flavor;
  final Function(String) onCompanySelected;
  final Function() onRegisterNewCompany;
  final List<String>? additionalCompanies;

  const CompanySelectionDialogV2({
    super.key,
    this.flavor,
    required this.onCompanySelected,
    required this.onRegisterNewCompany,
    this.additionalCompanies,
  });

  @override
  State<CompanySelectionDialogV2> createState() => _CompanySelectionDialogV2State();
}

class _CompanySelectionDialogV2State extends State<CompanySelectionDialogV2> {
  final TextEditingController _searchController = TextEditingController();
  final MasterUseCase _masterUseCase = MasterUseCase();
  
  List<DtoReceiveCompany> _apiCompanies = [];
  List<String> _additionalCompanies = [];
  List<String> _filteredCompanies = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadCompanies();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCompanies() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      // Obtener empresas del API
      final result = await _masterUseCase.getCompaniesList();
      
      if (result.isSuccess && result.data != null) {
        setState(() {
          _apiCompanies = result.data!;
          _updateFilteredCompanies();
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = result.message ?? 'Error loading companies';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading companies: $e';
        _isLoading = false;
      });
    }

    // Agregar empresas adicionales si se proporcionan
    if (widget.additionalCompanies != null) {
      setState(() {
        _additionalCompanies = List.from(widget.additionalCompanies!);
        _updateFilteredCompanies();
      });
    }
  }

  void _updateFilteredCompanies() {
    List<String> allCompanies = [];
    
    // Agregar empresas del API
    allCompanies.addAll(_apiCompanies.map((company) => company.name));
    
    // Agregar empresas adicionales
    allCompanies.addAll(_additionalCompanies);
    
    // Filtrar según el texto de búsqueda
    if (_searchController.text.isEmpty) {
      _filteredCompanies = allCompanies;
    } else {
      _filteredCompanies = allCompanies
          .where((company) => company.toLowerCase().contains(_searchController.text.toLowerCase()))
          .toList();
    }
  }

  void _filterCompanies(String query) {
    setState(() {
      _updateFilteredCompanies();
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
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Color(AppFlavorConfig.getPrimaryColor(widget.flavor ?? AppFlavorConfig.currentFlavor)),
            ),
            const SizedBox(height: 16),
            Text(
              'Loading companies...',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading companies',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadCompanies,
              child: Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_filteredCompanies.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.business_outlined,
              color: Colors.grey[400],
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'No companies found',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try registering a new company',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

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
