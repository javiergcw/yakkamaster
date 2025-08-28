import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../features/widgets/custom_text_field.dart';
import '../../../../../features/widgets/custom_button.dart';
import '../../data/dto/job_site_dto.dart';
import '../../logic/controllers/job_site_controller.dart';

class CreateEditJobSiteScreen extends StatefulWidget {
  final AppFlavor? flavor;
  final JobSiteDto? jobSite; // null para crear, con datos para editar

  const CreateEditJobSiteScreen({
    super.key,
    this.flavor,
    this.jobSite,
  });

  @override
  State<CreateEditJobSiteScreen> createState() => _CreateEditJobSiteScreenState();
}

class _CreateEditJobSiteScreenState extends State<CreateEditJobSiteScreen> {
  AppFlavor get _currentFlavor => widget.flavor ?? AppFlavorConfig.currentFlavor;
  late JobSiteController _controller;
  
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _suburbController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<JobSiteController>();
    
    // Si estamos editando, llenar los campos con los datos existentes
    if (widget.jobSite != null) {
      _addressController.text = widget.jobSite!.name;
      _suburbController.text = widget.jobSite!.location;
      _descriptionController.text = widget.jobSite!.description;
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    _suburbController.dispose();
    _descriptionController.dispose();
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
                      "Where do you need labourers?",
                      style: GoogleFonts.poppins(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  
                  // Close Button
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
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
                  key: _formKey,
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
                         controller: _addressController,
                         hintText: "Address",
                         flavor: _currentFlavor,
                         validator: (value) {
                           if (value == null || value.trim().isEmpty) {
                             return 'Please enter an address';
                           }
                           return null;
                         },
                       ),
                      
                      SizedBox(height: verticalSpacing * 1.5),
                      
                                             // Suburb Field
                       CustomTextField(
                         controller: _suburbController,
                         hintText: "Suburb",
                         flavor: _currentFlavor,
                         validator: (value) {
                           if (value == null || value.trim().isEmpty) {
                             return 'Please enter a suburb';
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
                         controller: _descriptionController,
                         hintText: "Add more information",
                         flavor: _currentFlavor,
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
               child: CustomButton(
                 text: widget.jobSite != null ? "Update jobsite" : "Save jobsite",
                 onPressed: _handleSave,
                 type: ButtonType.secondary,
                 isLoading: _isLoading,
                 flavor: _currentFlavor,
               ),
             ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final jobSite = JobSiteDto(
        id: widget.jobSite?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _addressController.text.trim(),
        location: _suburbController.text.trim(),
        description: _descriptionController.text.trim(),
      );

      if (widget.jobSite != null) {
        // Actualizar job site existente
        await _controller.updateJobSite(jobSite);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Job site updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Crear nuevo job site
        await _controller.createJobSite(jobSite);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Job site created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }

      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
