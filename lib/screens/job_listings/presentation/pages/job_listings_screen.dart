import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../config/app_flavor.dart';
import '../../../../config/assets_config.dart';
import '../../logic/job_listings_controller.dart';
import '../widgets/job_card.dart';
import '../widgets/search_bar.dart';
import '../../../home/presentation/pages/home_screen.dart';

class JobListingsScreen extends StatefulWidget {
  final AppFlavor? flavor;

  const JobListingsScreen({
    super.key,
    this.flavor,
  });

  @override
  State<JobListingsScreen> createState() => _JobListingsScreenState();
}

class _JobListingsScreenState extends State<JobListingsScreen> {
  AppFlavor get _currentFlavor => widget.flavor ?? AppFlavorConfig.currentFlavor;
  late JobListingsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = JobListingsController();
    _controller.onJobsChanged = () => setState(() {});
    _controller.onSearchChanged = () => setState(() {});
    _controller.onLoadingChanged = () => setState(() {});
    _controller.onCountdownChanged = () => setState(() {});
    _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
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
    final sectionTitleFontSize = screenWidth * 0.045;
    final bodyFontSize = screenWidth * 0.035;
    final iconSize = screenWidth * 0.06;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black87,
            size: iconSize,
          ),
          onPressed: () {
            // Siempre navegar a home
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => HomeScreen(flavor: _currentFlavor),
              ),
            );
          },
        ),
        title: Column(
          children: [
            Text(
              'Job Listings Will Be Updated in:',
              style: GoogleFonts.poppins(
                fontSize: bodyFontSize * 0.9,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              _controller.countdown,
              style: GoogleFonts.poppins(
                fontSize: bodyFontSize * 1.1,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            children: [
                             // Search Bar
               JobSearchBar(
                 placeholder: 'Search job or skill',
                 searchQuery: _controller.searchQuery,
                 onSearchChanged: _controller.updateSearchQuery,
                 onSearch: () {
                   // TODO: Implement search functionality
                   print('Search pressed');
                 },
                 horizontalPadding: horizontalPadding,
                 verticalSpacing: verticalSpacing,
                 bodyFontSize: bodyFontSize,
                 iconSize: iconSize,
                 flavor: _currentFlavor,
               ),
              
              // Recommended Section
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: verticalSpacing),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recommended for you',
                      style: GoogleFonts.poppins(
                        fontSize: sectionTitleFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: verticalSpacing * 0.3),
                    Text(
                      '+${_controller.totalJobs.toStringAsFixed(0)} jobs available in Australia',
                      style: GoogleFonts.poppins(
                        fontSize: bodyFontSize,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Job Listings
              Expanded(
                child: _controller.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : _controller.filteredJobs.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: iconSize * 3,
                                  color: Colors.grey[400],
                                ),
                                SizedBox(height: verticalSpacing),
                                Text(
                                  'No jobs found',
                                  style: GoogleFonts.poppins(
                                    fontSize: sectionTitleFontSize,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                SizedBox(height: verticalSpacing * 0.5),
                                Text(
                                  'Try adjusting your search criteria',
                                  style: GoogleFonts.poppins(
                                    fontSize: bodyFontSize,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.only(bottom: verticalSpacing * 2),
                            itemCount: _controller.filteredJobs.length,
                            itemBuilder: (context, index) {
                              final job = _controller.filteredJobs[index];
                                                             return JobCard(
                                 job: job,
                                 onShare: () => _controller.shareJob(job),
                                 onShowMore: () => _controller.showMoreDetails(job),
                                 horizontalPadding: horizontalPadding,
                                 verticalSpacing: verticalSpacing,
                                 titleFontSize: titleFontSize,
                                 bodyFontSize: bodyFontSize,
                                 iconSize: iconSize,
                                 flavor: _currentFlavor,
                               );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
