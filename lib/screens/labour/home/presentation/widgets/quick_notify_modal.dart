import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QuickNotifyModal extends StatelessWidget {
  final VoidCallback? onClose;
  final Function(String)? onOptionSelected;

  const QuickNotifyModal({
    Key? key,
    this.onClose,
    this.onOptionSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final titleFontSize = screenWidth * 0.045;
    final bodyFontSize = screenWidth * 0.035;
    final iconSize = screenWidth * 0.06;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            margin: EdgeInsets.only(top: verticalSpacing),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: EdgeInsets.all(horizontalPadding),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Send an Update to Your Boss',
                    style: GoogleFonts.poppins(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                IconButton(
                  onPressed: onClose,
                  icon: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 18,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Options list
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Column(
              children: [
                _buildOption(
                  icon: Icons.check,
                  iconColor: Colors.white,
                  iconBackground: Colors.green,
                  title: 'Check-in',
                  bodyFontSize: bodyFontSize,
                  onTap: () => onOptionSelected?.call('check-in'),
                ),
                _buildDivider(),
                _buildOption(
                  icon: Icons.access_time,
                  iconColor: Colors.white,
                  iconBackground: Colors.lightBlue,
                  title: 'I\'m running late',
                  bodyFontSize: bodyFontSize,
                  onTap: () => onOptionSelected?.call('running-late'),
                ),
                _buildDivider(),
                _buildOption(
                  icon: Icons.exit_to_app,
                  iconColor: Colors.white,
                  iconBackground: Colors.orange,
                  title: 'Leaving early',
                  bodyFontSize: bodyFontSize,
                  onTap: () => onOptionSelected?.call('leaving-early'),
                ),
                _buildDivider(),
                _buildOption(
                  icon: Icons.warning,
                  iconColor: Colors.black,
                  iconBackground: Colors.yellow,
                  title: 'Hazard / Incident report',
                  bodyFontSize: bodyFontSize,
                  onTap: () => onOptionSelected?.call('hazard-incident'),
                ),
                _buildDivider(),
                _buildOption(
                  icon: Icons.cancel,
                  iconColor: Colors.white,
                  iconBackground: Colors.red,
                  title: 'Cancel shift',
                  titleColor: Colors.red,
                  bodyFontSize: bodyFontSize,
                  onTap: () => onOptionSelected?.call('cancel-shift'),
                ),
              ],
            ),
          ),
          
          SizedBox(height: verticalSpacing * 2),
        ],
      ),
    );
  }

  Widget _buildOption({
    required IconData icon,
    required Color iconColor,
    required Color iconBackground,
    required String title,
    Color? titleColor,
    required double bodyFontSize,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBackground,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: bodyFontSize,
                  fontWeight: FontWeight.w500,
                  color: titleColor ?? Colors.black87,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      color: Colors.grey[200],
      margin: const EdgeInsets.only(left: 56),
    );
  }
}
