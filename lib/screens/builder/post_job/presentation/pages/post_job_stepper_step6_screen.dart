import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../features/widgets/custom_button.dart';
import '../../../../../features/widgets/custom_text_field.dart';
import '../../logic/controllers/unified_post_job_controller.dart';

class PostJobStepperStep6Screen extends StatefulWidget {
  static const String id = '/builder/post-job-step6';
  
  final AppFlavor? flavor;

  PostJobStepperStep6Screen({
    super.key,
    this.flavor,
  });

  @override
  State<PostJobStepperStep6Screen> createState() => _PostJobStepperStep6ScreenState();
}

class _PostJobStepperStep6ScreenState extends State<PostJobStepperStep6Screen> {
  final UnifiedPostJobController controller = Get.find<UnifiedPostJobController>();
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(text: controller.description.value);
    _descriptionController.addListener(() {
      controller.updateDescription(_descriptionController.text);
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Establecer el flavor en el controlador
    if (widget.flavor != null) {
      controller.currentFlavor.value = widget.flavor!;
    }

    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final titleFontSize = screenWidth * 0.055;
    final questionFontSize = screenWidth * 0.075;
    final iconSize = screenWidth * 0.06;
    
    final currentFlavor = widget.flavor ?? AppFlavorConfig.currentFlavor;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalSpacing * 0.6,
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey[300]!,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  // Back Button
                  GestureDetector(
                    onTap: () {
                      controller.handleBackNavigation();
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: iconSize,
                    ),
                  ),
                  
                  SizedBox(width: horizontalPadding),
                  
                  // Title
                  Expanded(
                    child: Text(
                      "Post a job",
                      style: GoogleFonts.poppins(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  
                  SizedBox(width: horizontalPadding + iconSize),
                ],
              ),
            ),
            
            // Progress Indicator
            Container(
              width: double.infinity,
              height: 2,
              child: Row(
                children: [
                  // Progress (yellow) - 6 steps completed
                  Expanded(
                    flex: 6,
                    child: Container(
                      color: Color(AppFlavorConfig.getPrimaryColor(currentFlavor)),
                    ),
                  ),
                  // Remaining (grey)
                  Expanded(
                    flex: 3,
                    child: Container(
                      color: Colors.grey[300],
                    ),
                  ),
                ],
              ),
            ),
            
            // Main Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: verticalSpacing * 0.2),
                    
                    // Main Question
                    Text(
                      "What details do you need for this job?",
                      style: GoogleFonts.poppins(
                        fontSize: questionFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    
                                         SizedBox(height: verticalSpacing),
                     
                     // Job Requirements Section
                     Text(
                       "Job Requirements",
                       style: GoogleFonts.poppins(
                         fontSize: screenWidth * 0.04,
                         fontWeight: FontWeight.w600,
                         color: Colors.black,
                       ),
                     ),
                     
                     SizedBox(height: verticalSpacing),
                     
                     // Requirements chips
                     _buildRequirementsChips(context),
                     
                     SizedBox(height: verticalSpacing * 2),
                     
                                          // Licenses Section
                     Text(
                       "List any required licenses, tickets, or insurances.",
                       style: GoogleFonts.poppins(
                         fontSize: screenWidth * 0.035,
                         color: Colors.black87,
                       ),
                     ),
                     
                     SizedBox(height: verticalSpacing),
                     
                                          // Licenses input field with dropdown and add button
                     Row(
                       children: [
                         Expanded(
                           child: GestureDetector(
                             onTap: () => _showCredentialDropdown(context),
                             child: Container(
                               padding: EdgeInsets.symmetric(
                                 horizontal: horizontalPadding * 0.8,
                                 vertical: verticalSpacing * 0.8,
                               ),
                               decoration: BoxDecoration(
                                 color: Colors.white,
                                 borderRadius: BorderRadius.circular(12),
                                 border: Border.all(color: Colors.grey[300]!),
                               ),
                               child: Row(
                                 children: [
                                   Expanded(
                                     child: Obx(() => Text(
                                       controller.selectedCredential.value.isNotEmpty ? controller.selectedCredential.value : "Select credential",
                                       style: GoogleFonts.poppins(
                                         fontSize: screenWidth * 0.035,
                                         color: controller.selectedCredential.value.isNotEmpty ? Colors.black : Colors.grey[600],
                                       ),
                                     )),
                                   ),
                                   Icon(
                                     Icons.keyboard_arrow_down,
                                     color: Colors.grey[600],
                                     size: screenWidth * 0.05,
                                   ),
                                 ],
                               ),
                             ),
                           ),
                         ),
                         SizedBox(width: horizontalPadding * 0.5),
                                                   GestureDetector(
                            onTap: () => controller.addCredential(),
                                                         child: Container(
                               width: screenWidth * 0.12,
                               height: screenWidth * 0.12,
                               decoration: BoxDecoration(
                                 color: Color(AppFlavorConfig.getPrimaryColor(currentFlavor)),
                                 borderRadius: BorderRadius.circular(12),
                               ),
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                                size: screenWidth * 0.06,
                              ),
                            ),
                          ),
                       ],
                     ),
                     
                                           // Selected credentials display
                      Obx(() {
                        if (controller.selectedCredentials.isNotEmpty) {
                          return Column(
                            children: [
                              SizedBox(height: verticalSpacing),
                              Wrap(
                               spacing: horizontalPadding * 0.5,
                               runSpacing: verticalSpacing * 0.5,
                               children: controller.selectedCredentials.map((credential) {
                           return Container(
                             padding: EdgeInsets.symmetric(
                               horizontal: horizontalPadding * 0.6,
                               vertical: verticalSpacing * 0.4,
                             ),
                             decoration: BoxDecoration(
                               color: Color(AppFlavorConfig.getPrimaryColor(currentFlavor)).withOpacity(0.1),
                               borderRadius: BorderRadius.circular(20),
                               border: Border.all(
                                 color: Color(AppFlavorConfig.getPrimaryColor(currentFlavor)).withOpacity(0.3),
                               ),
                             ),
                             child: Row(
                               mainAxisSize: MainAxisSize.min,
                               children: [
                                 Text(
                                   credential,
                                   style: GoogleFonts.poppins(
                                     fontSize: screenWidth * 0.03,
                                     color: Colors.white,
                                   ),
                                 ),
                                 SizedBox(width: horizontalPadding * 0.3),
                                 GestureDetector(
                                   onTap: () {
                                     controller.removeCredential(credential);
                                   },
                                   child: Icon(
                                     Icons.close,
                                     size: screenWidth * 0.035,
                                     color: Colors.white,
                                   ),
                                 ),
                               ],
                             ),
                           );
                               }).toList(),
                             ),
                            ],
                          );
                        } else {
                          return SizedBox.shrink();
                        }
                      }),
                     
                     SizedBox(height: verticalSpacing * 2),
                     
                                          // Job Description Section
                     Text(
                       "Briefly explain what the worker will be doing and if they need to bring their own tools.",
                       style: GoogleFonts.poppins(
                         fontSize: screenWidth * 0.035,
                         color: Colors.black87,
                       ),
                     ),
                     
                     SizedBox(height: verticalSpacing),
                     
                                          // Description input field with Done button
                     Row(
                       children: [
                         Expanded(
                           child: CustomTextField(
                             labelText: "Description",
                             hintText: "Description...",
                             controller: _descriptionController,
                             flavor: currentFlavor,
                             maxLines: 4,
                           ),
                         ),
                         SizedBox(width: horizontalPadding * 0.5),
                         TextButton(
                           onPressed: () {
                             // Hide keyboard
                             FocusScope.of(context).unfocus();
                           },
                           style: TextButton.styleFrom(
                             backgroundColor: Color(AppFlavorConfig.getPrimaryColor(currentFlavor)),
                             shape: RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(8),
                             ),
                             padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                           ),
                           child: Text(
                             "Done",
                             style: GoogleFonts.poppins(
                               fontSize: 12,
                               color: Colors.white,
                               fontWeight: FontWeight.w500,
                             ),
                           ),
                         ),
                       ],
                                          ),
                   
                   SizedBox(height: verticalSpacing * 2),
                  ],
                ),
              ),
            ),
            
            // Continue Button
            Padding(
              padding: EdgeInsets.all(horizontalPadding),
              child: Obx(() => CustomButton(
                text: "Continue",
                onPressed: controller.canProceedToNextStep() ? _handleContinue : null,
                type: ButtonType.secondary,
                flavor: currentFlavor,
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequirementsChips(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final chipHeight = screenHeight * 0.045;
    final chipFontSize = screenWidth * 0.03;
    final currentFlavor = widget.flavor ?? AppFlavorConfig.currentFlavor;

    return Obx(() {
      if (controller.isLoadingJobRequirements.value) {
        return Container(
          padding: EdgeInsets.all(verticalSpacing * 2),
          child: Center(
            child: Column(
              children: [
                CircularProgressIndicator(
                  color: Color(AppFlavorConfig.getPrimaryColor(currentFlavor)),
                ),
                SizedBox(height: verticalSpacing),
                Text(
                  'Loading job requirements...',
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.035,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        );
      }
      
      if (controller.jobRequirementsFromApi.isEmpty) {
        return Container(
          padding: EdgeInsets.all(verticalSpacing * 2),
          child: Center(
            child: Text(
              'No job requirements available',
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.035,
                color: Colors.grey[600],
              ),
            ),
          ),
        );
      }
      
      return Column(
        children: [
          for (int i = 0; i < controller.jobRequirementsFromApi.length; i += 2)
            Padding(
              padding: EdgeInsets.only(bottom: verticalSpacing * 0.8),
              child: Row(
                children: _buildRequirementRow(i, horizontalPadding, verticalSpacing, chipHeight, chipFontSize, currentFlavor),
              ),
            ),
        ],
      );
    });
  }

  List<Widget> _buildRequirementRow(int i, double horizontalPadding, double verticalSpacing, double chipHeight, double chipFontSize, AppFlavor currentFlavor) {
    return [
      // First column
      Expanded(
          child: Obx(() => GestureDetector(
            onTap: () {
              controller.toggleRequirement(controller.jobRequirementsFromApi[i].name);
            },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding * 0.8,
              vertical: verticalSpacing * 0.6,
            ),
            decoration: BoxDecoration(
              color: controller.selectedRequirements.contains(controller.jobRequirementsFromApi[i].name)
                  ? Color(AppFlavorConfig.getPrimaryColor(currentFlavor))
                  : Colors.white,
              borderRadius: BorderRadius.circular(chipHeight * 0.5),
              border: Border.all(
                color: controller.selectedRequirements.contains(controller.jobRequirementsFromApi[i].name)
                    ? Color(AppFlavorConfig.getPrimaryColor(currentFlavor))
                    : Colors.grey[300]!,
                width: 1,
              ),
            ),
            child: Text(
              controller.jobRequirementsFromApi[i].name,
              style: GoogleFonts.poppins(
                fontSize: chipFontSize,
                fontWeight: FontWeight.w500,
                color: controller.selectedRequirements.contains(controller.jobRequirementsFromApi[i].name) ? Colors.white : Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        )),
      ),
      
      // Spacing between columns
      SizedBox(width: horizontalPadding * 0.5),
      
      // Second column (if exists)
      if (i + 1 < controller.jobRequirementsFromApi.length)
        Expanded(
          child: Obx(() => GestureDetector(
            onTap: () {
              controller.toggleRequirement(controller.jobRequirementsFromApi[i + 1].name);
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding * 0.8,
                vertical: verticalSpacing * 0.6,
              ),
              decoration: BoxDecoration(
                color: controller.selectedRequirements.contains(controller.jobRequirementsFromApi[i + 1].name)
                    ? Color(AppFlavorConfig.getPrimaryColor(currentFlavor))
                    : Colors.white,
                borderRadius: BorderRadius.circular(chipHeight * 0.5),
                border: Border.all(
                  color: controller.selectedRequirements.contains(controller.jobRequirementsFromApi[i + 1].name)
                      ? Color(AppFlavorConfig.getPrimaryColor(currentFlavor))
                      : Colors.grey[300]!,
                  width: 1,
                ),
              ),
              child: Text(
                controller.jobRequirementsFromApi[i + 1].name,
                style: GoogleFonts.poppins(
                  fontSize: chipFontSize,
                  fontWeight: FontWeight.w500,
                  color: controller.selectedRequirements.contains(controller.jobRequirementsFromApi[i + 1].name) ? Colors.white : Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          )),
        )
      else
        Expanded(child: SizedBox()), // Empty space for odd number of items
    ];
  }

  void _handleContinue() {
    controller.handleContinue();
  }

  void _showCredentialDropdown(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final titleFontSize = screenWidth * 0.045;
    final itemFontSize = screenWidth * 0.035;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Text(
                'Select Credential',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            Flexible(
              child: Obx(() {
                if (controller.isLoadingCredentials.value) {
                  return Container(
                    padding: const EdgeInsets.all(20),
                    child: const CircularProgressIndicator(),
                  );
                }
                
                if (controller.credentials.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'No credentials available',
                      style: GoogleFonts.poppins(
                        fontSize: itemFontSize,
                        color: Colors.grey[600],
                      ),
                    ),
                  );
                }
                
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.credentials.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        controller.credentials[index],
                        style: GoogleFonts.poppins(
                          fontSize: itemFontSize,
                          color: Colors.black87,
                        ),
                      ),
                      onTap: () {
                        controller.setSelectedCredential(controller.credentials[index]);
                        Navigator.pop(context);
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

}
