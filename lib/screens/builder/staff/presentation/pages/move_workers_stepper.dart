import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../config/assets_config.dart';
import '../../data/data.dart';
import '../../../post_job/presentation/pages/create_edit_job_site_screen.dart';

class MoveWorkersStepper extends StatefulWidget {
  final AppFlavor? flavor;

  const MoveWorkersStepper({
    super.key,
    this.flavor,
  });

  @override
  State<MoveWorkersStepper> createState() => _MoveWorkersStepperState();
}

class _MoveWorkersStepperState extends State<MoveWorkersStepper> {
  int _currentStep = 0;
  String? _selectedJobsite;
  List<String> _selectedWorkerIds = [];
  final List<JobsiteWorkersDto> _jobsiteWorkers = [];
  final List<WorkerDto> _mockWorkers = [
    WorkerDto(
      id: '1',
      name: 'davide rinaldo',
      role: 'General Labourer',
      hourlyRate: '\$32.00/hr',
      imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
      isActive: true,
      jobsiteId: '1',
      jobsiteName: 'Pyrmont',
    ),
    WorkerDto(
      id: '2',
      name: 'Pietro Giuffre',
      role: 'Carpenter',
      hourlyRate: '\$45.00/hr',
      imageUrl: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
      isActive: true,
      jobsiteId: '1',
      jobsiteName: 'Pyrmont',
    ),
    WorkerDto(
      id: '3',
      name: 'Ramiro Ignacio Arevalo',
      role: 'Electrician',
      hourlyRate: '\$50.00/hr',
      imageUrl: 'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face',
      isActive: true,
      jobsiteId: '1',
      jobsiteName: 'Pyrmont',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadMockData();
  }

  void _loadMockData() {
    // Mock data for jobsites
    _jobsiteWorkers.addAll([
      JobsiteWorkersDto(
        jobsiteId: '1',
        jobsiteName: '56 Fuller St',
        jobsiteAddress: '56 Fuller St, Mount Druitt, Sydney',
        workers: [],
      ),
      JobsiteWorkersDto(
        jobsiteId: '2',
        jobsiteName: '1 Belinda Place',
        jobsiteAddress: '1 Belinda Place, New Port, Sydney',
        workers: [],
      ),
      JobsiteWorkersDto(
        jobsiteId: '3',
        jobsiteName: '357 New South Head Rd',
        jobsiteAddress: '357 New South Head Rd, Double Bay, Sydney',
        workers: [],
      ),
      JobsiteWorkersDto(
        jobsiteId: '4',
        jobsiteName: 'Sydney Olympic Park',
        jobsiteAddress: 'Sydney Olympic Park NSW, Australia, Sydney',
        workers: [],
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: _buildCurrentStep(),
            ),
            _buildBottomButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
                     // Logo
                       SvgPicture.asset(
              AssetsConfig.getLogoMiddle(widget.flavor ?? AppFlavorConfig.currentFlavor),
              width: 48,
              height: 48,
              fit: BoxFit.cover,
            ),
          Spacer(),
          // Title
          Text(
            'Move workers',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Spacer(),
                     // Close button
           IconButton(
             onPressed: () {
               Navigator.pop(context);
             },
             icon: Icon(Icons.close, color: Colors.black, size: 24),
           ),
        ],
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildStep1();
      case 1:
        return _buildStep2();
      case 2:
        return _buildStep3();
      default:
        return _buildStep1();
    }
  }

  Widget _buildStep1() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Where do you need workers?',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              itemCount: _jobsiteWorkers.length,
              itemBuilder: (context, index) {
                final jobsite = _jobsiteWorkers[index];
                final isSelected = _selectedJobsite == jobsite.jobsiteId;
                
                return Container(
                  margin: EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? Color(AppFlavorConfig.getPrimaryColor(widget.flavor ?? AppFlavorConfig.currentFlavor)) : Colors.grey[300]!,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: RadioListTile<String>(
                    value: jobsite.jobsiteId,
                    groupValue: _selectedJobsite,
                    onChanged: (value) {
                      setState(() {
                        _selectedJobsite = value;
                      });
                    },
                    title: Text(
                      jobsite.jobsiteAddress.split(', ').take(2).join(', '),
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    subtitle: Text(
                      jobsite.jobsiteAddress.split(', ').last,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    activeColor: Color(AppFlavorConfig.getPrimaryColor(widget.flavor ?? AppFlavorConfig.currentFlavor)),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 16),
          Container(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
                             onPressed: () {
                 Navigator.push(
                   context,
                   MaterialPageRoute(
                     builder: (context) => CreateEditJobSiteScreen(
                       flavor: widget.flavor,
                     ),
                   ),
                 );
               },
              icon: Icon(Icons.add, color: Colors.white),
              label: Text(
                'Create new a jobsite',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[800],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

     Widget _buildStep2() {

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search bar
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search Workers',
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                      border: InputBorder.none,
                    ),
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color(AppFlavorConfig.getPrimaryColor(widget.flavor ?? AppFlavorConfig.currentFlavor)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          // Header with select all
          Row(
            children: [
              Text(
                'Workers',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Spacer(),
                             GestureDetector(
                 onTap: () {
                   setState(() {
                     if (_selectedWorkerIds.length == _mockWorkers.length) {
                       _selectedWorkerIds.clear();
                     } else {
                       _selectedWorkerIds = _mockWorkers.map((w) => w.id).toList();
                     }
                   });
                 },
                child: Row(
                  children: [
                    Text(
                      'Select All',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(width: 8),
                                         Container(
                       width: 20,
                       height: 20,
                       decoration: BoxDecoration(
                         border: Border.all(color: Colors.grey[400]!),
                         borderRadius: BorderRadius.circular(4),
                         color: _selectedWorkerIds.length == _mockWorkers.length 
                             ? Color(AppFlavorConfig.getPrimaryColor(widget.flavor ?? AppFlavorConfig.currentFlavor))
                             : Colors.transparent,
                       ),
                       child: _selectedWorkerIds.length == _mockWorkers.length
                           ? Icon(
                               Icons.check,
                               size: 16,
                               color: Colors.white,
                             )
                           : null,
                     ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          // Workers list
          Expanded(
                         child: ListView.builder(
               itemCount: _mockWorkers.length,
               itemBuilder: (context, index) {
                 final worker = _mockWorkers[index];
                 final isSelected = _selectedWorkerIds.contains(worker.id);
                
                return Container(
                  margin: EdgeInsets.only(bottom: 12),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected ? Color(AppFlavorConfig.getPrimaryColor(widget.flavor ?? AppFlavorConfig.currentFlavor)).withValues(alpha: 0.1) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? Color(AppFlavorConfig.getPrimaryColor(widget.flavor ?? AppFlavorConfig.currentFlavor)) : Colors.grey[300]!,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Profile picture
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          image: DecorationImage(
                            image: NetworkImage(worker.imageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      // Worker info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              worker.name,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              worker.jobsiteName,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Selection checkbox
                      GestureDetector(
                                                 onTap: () {
                           setState(() {
                             if (isSelected) {
                               _selectedWorkerIds.remove(worker.id);
                             } else {
                               _selectedWorkerIds.add(worker.id);
                             }
                           });
                         },
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isSelected 
                                  ? Color(AppFlavorConfig.getPrimaryColor(widget.flavor ?? AppFlavorConfig.currentFlavor))
                                  : Colors.grey[400]!,
                            ),
                            borderRadius: BorderRadius.circular(4),
                            color: isSelected 
                                ? Color(AppFlavorConfig.getPrimaryColor(widget.flavor ?? AppFlavorConfig.currentFlavor))
                                : Colors.transparent,
                          ),
                          child: isSelected
                              ? Icon(
                                  Icons.check,
                                  size: 16,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    final selectedJobsite = _jobsiteWorkers.firstWhere(
      (jobsite) => jobsite.jobsiteId == _selectedJobsite,
      orElse: () => _jobsiteWorkers.first,
    );

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                                 Text(
                   'Confirm to move ${_selectedWorkerIds.length}\nworkers to ${selectedJobsite.jobsiteAddress}',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 32),
                // Selected workers preview
                                 Wrap(
                   spacing: 12,
                   runSpacing: 12,
                                        children: _selectedWorkerIds.map((workerId) {
                       final worker = _mockWorkers.firstWhere((w) => w.id == workerId);
                    return Stack(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            image: DecorationImage(
                              image: NetworkImage(worker.imageUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: GestureDetector(
                                                         onTap: () {
                               setState(() {
                                 _selectedWorkerIds.remove(worker.id);
                               });
                             },
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.close,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Text(
                            worker.name.split(' ').take(2).join('\n'),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Row(
        children: [
          TextButton(
            onPressed: () {
              if (_currentStep > 0) {
                setState(() {
                  _currentStep--;
                });
              } else {
                Navigator.pop(context);
              }
            },
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          Spacer(),
          ElevatedButton(
            onPressed: _canProceed() ? () {
              if (_currentStep < 2) {
                setState(() {
                  _currentStep++;
                });
              } else {
                // TODO: Execute move workers
                Navigator.pop(context);
              }
            } : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(AppFlavorConfig.getPrimaryColor(widget.flavor ?? AppFlavorConfig.currentFlavor)),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
                         child: Text(
               _currentStep == 2 ? 'Move ${_selectedWorkerIds.length} workers' : 'Next',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

     bool _canProceed() {
     switch (_currentStep) {
       case 0:
         return _selectedJobsite != null;
       case 1:
         return _selectedWorkerIds.isNotEmpty;
       case 2:
         return _selectedWorkerIds.isNotEmpty;
       default:
         return false;
     }
   }
}
