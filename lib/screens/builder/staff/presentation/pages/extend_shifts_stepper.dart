import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../config/app_flavor.dart';
import '../../../../../config/assets_config.dart';
import '../../data/data.dart';

class ExtendShiftsStepper extends StatefulWidget {
  final AppFlavor? flavor;
  final List<JobsiteWorkersDto> workers;

  const ExtendShiftsStepper({
    super.key,
    this.flavor,
    required this.workers,
  });

  @override
  State<ExtendShiftsStepper> createState() => _ExtendShiftsStepperState();
}

class _ExtendShiftsStepperState extends State<ExtendShiftsStepper> {
  int _currentStep = 0;
  List<String> _selectedWorkerIds = [];
  DateTime? _selectedEndDate;
  List<WorkerDto> get _allWorkers {
    List<WorkerDto> allWorkers = [];
    for (var jobsite in widget.workers) {
      allWorkers.addAll(jobsite.workers);
    }
    return allWorkers;
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
            'Extend shifts',
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
            'Which workers need extended shifts?',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 24),
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
                            if (_selectedWorkerIds.length == _allWorkers.length) {
          _selectedWorkerIds.clear();
        } else {
          _selectedWorkerIds = _allWorkers.map((w) => w.id).toList();
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
                        color: _selectedWorkerIds.length == _allWorkers.length 
                            ? Color(AppFlavorConfig.getPrimaryColor(widget.flavor ?? AppFlavorConfig.currentFlavor))
                            : Colors.transparent,
                      ),
                      child: _selectedWorkerIds.length == _allWorkers.length
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
                              itemCount: _allWorkers.length,
                itemBuilder: (context, index) {
                  final worker = _allWorkers[index];
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

  Widget _buildStep2() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Until when do you need them?',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 24),
          // Date picker
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'End Date',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 12),
                GestureDetector(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _selectedEndDate ?? DateTime.now().add(Duration(days: 7)),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(Duration(days: 365)),
                    );
                    if (date != null) {
                      setState(() {
                        _selectedEndDate = date;
                      });
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: Colors.grey[600],
                          size: 20,
                        ),
                        SizedBox(width: 12),
                        Text(
                          _selectedEndDate != null
                              ? '${_selectedEndDate!.day}/${_selectedEndDate!.month}/${_selectedEndDate!.year}'
                              : 'Select end date',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: _selectedEndDate != null ? Colors.black : Colors.grey[600],
                          ),
                        ),
                        Spacer(),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey[600],
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
                     ),
           SizedBox(height: 24),
           // Selected workers preview
          Text(
            'Selected Workers (${_selectedWorkerIds.length})',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _selectedWorkerIds.map((workerId) {
                final worker = _allWorkers.firstWhere((w) => w.id == workerId);
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
          ),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Confirm to extend shifts for ${_selectedWorkerIds.length}\nworkers until ${_selectedEndDate != null ? '${_selectedEndDate!.day}/${_selectedEndDate!.month}/${_selectedEndDate!.year}' : 'selected date'}',
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
                    final worker = _allWorkers.firstWhere((w) => w.id == workerId);
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
                // TODO: Execute extend shifts
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
              _currentStep == 2 ? 'Extend ${_selectedWorkerIds.length} shifts' : 'Next',
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
        return _selectedWorkerIds.isNotEmpty;
      case 1:
        return _selectedWorkerIds.isNotEmpty && _selectedEndDate != null;
      case 2:
        return _selectedWorkerIds.isNotEmpty && _selectedEndDate != null;
      default:
        return false;
    }
  }
}
