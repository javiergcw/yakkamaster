import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../../config/app_flavor.dart';
import '../../../../config/constants.dart';
import '../../logic/controllers/job_search_screen_controller.dart';

class JobSearchScreen extends StatefulWidget {
  static const String id = '/job-search';
  
  final AppFlavor? flavor;
  JobSearchScreen({super.key, this.flavor});

  @override
  State<JobSearchScreen> createState() => _JobSearchScreenState();
}

class _JobSearchScreenState extends State<JobSearchScreen> {
  final JobSearchScreenController controller = Get.put(JobSearchScreenController());
  
  // Controladores persistentes para los TextFields
  late TextEditingController _whatController;
  late TextEditingController _whereController;

  @override
  void initState() {
    super.initState();
    
    // Inicializar controladores
    _whatController = TextEditingController();
    _whereController = TextEditingController();
    
    // Establecer el flavor en el controlador si se proporciona
    if (widget.flavor != null) {
      controller.currentFlavor.value = widget.flavor!;
    }
    
    // Escuchar cambios en los observables para actualizar los controladores
    controller.whatQuery.listen((value) {
      if (_whatController.text != value) {
        _whatController.text = value;
      }
    });
    
    controller.whereQuery.listen((value) {
      if (_whereController.text != value) {
        _whereController.text = value;
      }
    });
  }

  @override
  void dispose() {
    _whatController.dispose();
    _whereController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    // Calcular valores responsive
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final sectionTitleFontSize = screenWidth * 0.045;
    final bodyFontSize = screenWidth * 0.035;
    final iconSize = screenWidth * 0.06;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppConstants.darkGreyColor,
        elevation: 0,
        surfaceTintColor: AppConstants.darkGreyColor,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: iconSize,
          ),
          onPressed: () => Get.back(),
        ),
        actions: [
          TextButton(
            onPressed: controller.clearAllFilters,
            child: Text(
              'Clear all',
              style: GoogleFonts.poppins(
                fontSize: bodyFontSize,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: verticalSpacing),
              
              // What Section
              Text(
                'What',
                style: GoogleFonts.poppins(
                  fontSize: sectionTitleFontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: verticalSpacing * 0.5),
              
              Obx(() => _buildWhatSearchField(
                value: controller.whatQuery.value,
                onChanged: controller.updateWhatQuery,
                onClear: controller.clearWhatQuery,
                horizontalPadding: horizontalPadding,
                verticalSpacing: verticalSpacing,
                bodyFontSize: bodyFontSize,
                suggestions: controller.whatSuggestions,
                onSuggestionTap: controller.selectWhatSuggestion,
              )),
              
              SizedBox(height: verticalSpacing * 1.5),
              
              // Where Section
              Text(
                'Where',
                style: GoogleFonts.poppins(
                  fontSize: sectionTitleFontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: verticalSpacing * 0.5),
              
              Obx(() => _buildSearchField(
                value: controller.whereQuery.value,
                onChanged: controller.updateWhereQuery,
                onClear: controller.clearWhereQuery,
                horizontalPadding: horizontalPadding,
                verticalSpacing: verticalSpacing,
                bodyFontSize: bodyFontSize,
              )),
              
              SizedBox(height: verticalSpacing * 2),
              
              // Jobs Count Button
              Obx(() => _buildJobsCountButton(
                jobCount: controller.jobCount.value,
                onTap: controller.performSearch,
                horizontalPadding: horizontalPadding,
                verticalSpacing: verticalSpacing,
                bodyFontSize: bodyFontSize,
                flavor: controller.currentFlavor.value,
              )),
              
              SizedBox(height: verticalSpacing * 2),
              
              // Last Search Section
              Text(
                'Last search',
                style: GoogleFonts.poppins(
                  fontSize: sectionTitleFontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: verticalSpacing * 0.5),
              
              Obx(() => _buildLastSearchItem(
                searchText: controller.lastSearch.value,
                newCount: controller.newJobsCount.value,
                onTap: controller.useLastSearch,
                horizontalPadding: horizontalPadding,
                verticalSpacing: verticalSpacing,
                bodyFontSize: bodyFontSize,
                flavor: controller.currentFlavor.value,
              )),
              
              SizedBox(height: verticalSpacing * 2), // Espacio extra al final
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWhatSearchField({
    required String value,
    required Function(String) onChanged,
    required VoidCallback onClear,
    required double horizontalPadding,
    required double verticalSpacing,
    required double bodyFontSize,
    required List<String> suggestions,
    required Function(String) onSuggestionTap,
  }) {
    return Column(
      children: [
        Container(
          height: verticalSpacing * 2.2,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300] ?? Colors.grey),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding * 0.5),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _whatController,
                    onChanged: onChanged,
                    style: GoogleFonts.poppins(
                      fontSize: bodyFontSize,
                      color: Colors.black87,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: value.isEmpty ? 'Enter search term' : null,
                      hintStyle: GoogleFonts.poppins(
                        fontSize: bodyFontSize,
                        color: Colors.grey[500],
                      ),
                    ),
                  ),
                ),
                if (value.isNotEmpty)
                  GestureDetector(
                    onTap: onClear,
                    child: Icon(
                      Icons.close,
                      size: bodyFontSize * 1.2,
                      color: Colors.grey[600],
                    ),
                  ),
              ],
            ),
          ),
        ),
        // Dropdown de sugerencias
        if (suggestions.isNotEmpty && value.isNotEmpty)
          Container(
            margin: EdgeInsets.only(top: verticalSpacing * 0.3),
            constraints: BoxConstraints(
              maxHeight: verticalSpacing * 8, // Limitar altura máxima
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300] ?? Colors.grey),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(0, 2),
                  blurRadius: 4,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: suggestions.length > 3 ? 3 : suggestions.length,
              itemBuilder: (context, index) {
                final suggestion = suggestions[index];
                return GestureDetector(
                  onTap: () => onSuggestionTap(suggestion),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding * 0.5,
                      vertical: verticalSpacing * 0.4,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey[200] ?? Colors.grey,
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: Text(
                      suggestion,
                      style: GoogleFonts.poppins(
                        fontSize: bodyFontSize,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildSearchField({
    required String value,
    required Function(String) onChanged,
    required VoidCallback onClear,
    required double horizontalPadding,
    required double verticalSpacing,
    required double bodyFontSize,
  }) {
    return Container(
      height: verticalSpacing * 2.2,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300] ?? Colors.grey),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding * 0.5),
        child: Row(
          children: [
                Expanded(
                  child: TextField(
                    controller: _whereController,
                    onChanged: onChanged,
                    style: GoogleFonts.poppins(
                      fontSize: bodyFontSize,
                      color: Colors.black87,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: value.isEmpty ? 'Enter search term' : null,
                      hintStyle: GoogleFonts.poppins(
                        fontSize: bodyFontSize,
                        color: Colors.grey[500],
                      ),
                    ),
                  ),
                ),
            if (value.isNotEmpty)
              GestureDetector(
                onTap: onClear,
                child: Icon(
                  Icons.close,
                  size: bodyFontSize * 1.2,
                  color: Colors.grey[600],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobsCountButton({
    required int jobCount,
    required VoidCallback onTap,
    required double horizontalPadding,
    required double verticalSpacing,
    required double bodyFontSize,
    required AppFlavor flavor,
  }) {
    return GestureDetector(
      onTap: () {
        print('Jobs button tapped!');
        onTap();
      },
      child: Container(
        width: double.infinity,
        height: verticalSpacing * 2.5,
        decoration: BoxDecoration(
          color: Color(AppFlavorConfig.getPrimaryColor(flavor)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            '$jobCount Jobs',
            style: GoogleFonts.poppins(
              fontSize: bodyFontSize * 1.1,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLastSearchItem({
    required String searchText,
    required int newCount,
    required VoidCallback onTap,
    required double horizontalPadding,
    required double verticalSpacing,
    required double bodyFontSize,
    required AppFlavor flavor,
  }) {
    if (searchText.isEmpty) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding * 0.5,
          vertical: verticalSpacing * 0.5,
        ),
        child: Row(
          children: [
            Icon(
              Icons.access_time,
              size: bodyFontSize * 1.2,
              color: Colors.grey[600],
            ),
            SizedBox(width: horizontalPadding * 0.5),
            Expanded(
              child: Text(
                searchText,
                style: GoogleFonts.poppins(
                  fontSize: bodyFontSize,
                  color: Colors.black87,
                ),
              ),
            ),
            if (newCount > 0)
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding * 0.3,
                  vertical: verticalSpacing * 0.2,
                ),
                decoration: BoxDecoration(
                  color: Color(AppFlavorConfig.getPrimaryColor(flavor)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$newCount+ new',
                  style: GoogleFonts.poppins(
                    fontSize: bodyFontSize * 0.8,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
