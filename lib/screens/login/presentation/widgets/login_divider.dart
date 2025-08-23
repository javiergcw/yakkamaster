import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginDivider extends StatelessWidget {
  final String? text;

  const LoginDivider({
    super.key,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey[300])),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            text ?? 'or login with',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey[300])),
      ],
    );
  }
}
