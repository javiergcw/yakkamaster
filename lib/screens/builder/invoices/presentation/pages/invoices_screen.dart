import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../features/widgets/search_input_field.dart';
import '../widgets/invoice_card.dart';
import '../widgets/skill_filter_input.dart';
import '../../logic/controllers/invoices_screen_controller.dart';

class InvoicesScreen extends StatelessWidget {
  static const String id = '/builder/invoices';
  
  final AppFlavor? flavor;

  InvoicesScreen({
    super.key,
    this.flavor,
  });

  final InvoicesScreenController controller = Get.put(InvoicesScreenController());

  @override
  Widget build(BuildContext context) {
    // Establecer flavor en el controlador
    if (flavor != null) {
      controller.currentFlavor.value = flavor!;
    }
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    final horizontalPadding = screenWidth * 0.05;
    final verticalSpacing = screenHeight * 0.02;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // App Bar
            _buildAppBar(),
            
            // Outstanding Invoices Section
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalSpacing,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Outstanding invoices',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Select the invoices you want to pay.',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: verticalSpacing),
                  
                  // Search Bar
                  SearchInputField(
                    controller: controller.searchController.value,
                    hintText: 'Search Workers',
                    flavor: flavor,
                    height: 40,
                    fontSize: 14,
                    onChanged: controller.handleSearchChanged,
                    onSearch: () {
                      // Search is handled by onChanged
                    },
                  ),
                  
                  SizedBox(height: verticalSpacing),
                  
                  // Dropdown Filters
                  Obx(() => Row(
                    children: [
                      Expanded(
                        child: _buildDropdown(
                          value: controller.invoiceController.selectedJobsite,
                          items: controller.invoiceController.getAvailableJobsites(),
                          onChanged: controller.handleJobsiteChanged,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: SkillFilterInput(
                          flavor: flavor,
                          availableSkills: controller.invoiceController.getAvailableSkills(),
                          selectedSkill: controller.invoiceController.selectedSkill,
                          onSkillSelected: controller.handleSkillSelected,
                        ),
                      ),
                    ],
                  )),
                  
                  SizedBox(height: verticalSpacing * 1.5),
                  
                  // Quick Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildQuickActionButton(
                        icon: Icons.people,
                        label: 'Move Workers',
                        onTap: controller.navigateToMoveWorkers,
                      ),
                      _buildQuickActionButton(
                        icon: Icons.access_time,
                        label: 'Extend shifts',
                        onTap: controller.navigateToExtendShifts,
                      ),
                      _buildQuickActionButton(
                        icon: Icons.person_remove,
                        label: 'Unhire workers',
                        onTap: controller.navigateToUnhireWorkers,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Invoices List
            Expanded(
              child: TabBarView(
                controller: controller.tabController,
                children: [
                  _buildInvoicesList(true), // Outstanding invoices
                  _buildInvoicesList(false), // Payment history
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      color: Colors.grey[900],
      padding: EdgeInsets.fromLTRB(16, 54, 16, 16),
      child: Column(
        children: [
          // Header with back button and title
          Row(
            children: [
              GestureDetector(
                onTap: controller.handleBackNavigation,
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              SizedBox(width: 16),
              Text(
                'Invoices',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 8),
          
          // Tabs
          AnimatedBuilder(
            animation: controller.tabController,
            builder: (context, child) {
              return Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => controller.handleTabChange(0),
                      child: Column(
                        children: [
                          Text(
                            'Completed jobs',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: controller.tabController.index == 0 ? FontWeight.w600 : FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 12),
                          if (controller.tabController.index == 0)
                            Container(
                              height: 3,
                              width: 150,
                              decoration: BoxDecoration(
                                color: Color(AppFlavorConfig.getPrimaryColor(flavor ?? AppFlavorConfig.currentFlavor)),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => controller.handleTabChange(1),
                      child: Column(
                        children: [
                          Text(
                            'Payment History',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: controller.tabController.index == 1 ? FontWeight.w600 : FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 12),
                          if (controller.tabController.index == 1)
                            Container(
                              height: 3,
                              width: 150,
                              decoration: BoxDecoration(
                                color: Color(AppFlavorConfig.getPrimaryColor(flavor ?? AppFlavorConfig.currentFlavor)),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      height: 40,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: DropdownButton<String>(
        value: value,
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.black,
              ),
            ),
          );
        }).toList(),
        onChanged: onChanged,
        underline: SizedBox(),
        icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[600], size: 20),
        isExpanded: true,
      ),
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Color(AppFlavorConfig.getPrimaryColor(flavor ?? AppFlavorConfig.currentFlavor)),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInvoicesList(bool isOutstanding) {
    return Obx(() {
      final jobsiteInvoices = isOutstanding 
          ? controller.invoiceController.getOutstandingInvoices()
          : controller.invoiceController.getCompletedInvoices();
      
      if (controller.invoiceController.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }
      
      if (jobsiteInvoices.isEmpty) {
        return Center(
          child: Text(
            'No ${isOutstanding ? 'outstanding' : 'completed'} invoices found',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        );
      }
      
      return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: jobsiteInvoices.length,
        itemBuilder: (context, index) {
          final jobsite = jobsiteInvoices[index];
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              Text(
                'Jobsite: ${jobsite.jobsiteAddress}',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 12),
              SizedBox(
                height: 200, // Increased height for invoice cards
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: jobsite.invoices.length,
                  itemBuilder: (context, invoiceIndex) {
                    final invoice = jobsite.invoices[invoiceIndex];
                    return InvoiceCard(
                      invoice: invoice,
                      flavor: flavor,
                      onView: () => controller.invoiceController.viewInvoice(invoice.id),
                      onSend: () => controller.invoiceController.sendInvoice(invoice.id),
                      onReport: () => controller.showReportModal(invoice.id, invoice.workerName),
                      onPay: () => controller.invoiceController.payInvoice(invoice.id),
                      onToggleSelection: () => controller.invoiceController.toggleInvoiceSelection(invoice.id),
                    );
                  },
                ),
              ),
            ],
          );
        },
      );
    });
  }

}
