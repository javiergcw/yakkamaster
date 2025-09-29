import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../features/widgets/custom_text_field.dart';
import '../../../../../features/widgets/custom_button.dart';
import '../../data/dto/job_site_dto.dart';
import '../../logic/controllers/create_edit_job_site_screen_controller.dart';

class CreateEditJobSiteScreen extends StatelessWidget {
  static const String id = '/builder/create-edit-job-site';
  
  final AppFlavor? flavor;
  final JobSiteDto? jobSite; // null para crear, con datos para editar

  CreateEditJobSiteScreen({
    super.key,
    this.flavor,
    this.jobSite,
  });

  final CreateEditJobSiteScreenController controller = Get.put(CreateEditJobSiteScreenController());



  @override
  Widget build(BuildContext context) {
    // Establecer el flavor en el controlador si se proporciona
    if (flavor != null) {
      controller.currentFlavor.value = flavor!;
    }

    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    // Calcular valores responsive
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final titleFontSize = screenWidth * 0.055;
    final labelFontSize = screenWidth * 0.04;
    final iconSize = screenWidth * 0.06;

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
                vertical: verticalSpacing * 1.5,
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
                  // Title
                  Expanded(
                    child: Text(
                      "Where do you need workers?",
                      style: GoogleFonts.poppins(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  
                  // Close Button
                  GestureDetector(
                    onTap: () => controller.handleClose(),
                    child: Icon(
                      Icons.close,
                      color: Colors.black,
                      size: iconSize,
                    ),
                  ),
                ],
              ),
            ),
            
            // Form Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(horizontalPadding),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: verticalSpacing * 2),
                      
                      // Location Label
                      Text(
                        "Specify the location",
                        style: GoogleFonts.poppins(
                          fontSize: labelFontSize,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      
                      SizedBox(height: verticalSpacing),
                      
                                             // Address Field
                       CustomTextField(
                         controller: controller.addressController,
                         hintText: "Address",
                         flavor: controller.currentFlavor.value,
                         validator: (value) {
                           if (value == null || value.trim().isEmpty) {
                             return 'Please enter an address';
                           }
                           if (value.trim().length < 10) {
                             return 'Address must be at least 10 characters long';
                           }
                           return null;
                         },
                       ),
                      
                      SizedBox(height: verticalSpacing * 1.5),
                      
                      // Suburb Field
                       CustomTextField(
                         controller: controller.suburbController,
                         hintText: "Suburb",
                         flavor: controller.currentFlavor.value,
                         validator: (value) {
                           if (value == null || value.trim().isEmpty) {
                             return 'Please enter a suburb';
                           }
                           if (value.trim().length < 3) {
                             return 'Suburb must be at least 3 characters long';
                           }
                           return null;
                         },
                       ),
                      
                      SizedBox(height: verticalSpacing * 2),
                      
                      // Optional Information Label
                      Text(
                        "Specify the place or provide a reference to make it easier for your laborers to find the place (optional)",
                        style: GoogleFonts.poppins(
                          fontSize: labelFontSize * 0.9,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      
                      SizedBox(height: verticalSpacing),
                      
                      // Description Field
                       CustomTextField(
                         controller: controller.descriptionController,
                         hintText: "Add more information",
                         flavor: controller.currentFlavor.value,
                         maxLines: 4,
                       ),
                      
                      SizedBox(height: verticalSpacing * 3),
                    ],
                  ),
                ),
              ),
            ),
            
                         // Save Button
             Padding(
               padding: EdgeInsets.all(horizontalPadding),
               child: Obx(() => CustomButton(
                 text: (controller.editingJobSite.value != null || controller.editingJobSiteReceive.value != null) ? "Update jobsite" : "Save jobsite",
                 onPressed: controller.handleSave,
                 type: ButtonType.secondary,
                 isLoading: controller.isLoading.value,
                 flavor: controller.currentFlavor.value,
               )),
             ),
          ],
        ),
      ),
    );
  }

}
