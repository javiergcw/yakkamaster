import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../config/app_flavor.dart';
import '../../data/data.dart';

class ApplicantCard extends StatelessWidget {
  final ApplicantDto applicant;
  final AppFlavor? flavor;
  final VoidCallback onChat;
  final VoidCallback onDecline;
  final VoidCallback onHire;

  const ApplicantCard({
    super.key,
    required this.applicant,
    this.flavor,
    required this.onChat,
    required this.onDecline,
    required this.onHire,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    // Calcular valores responsive
    final cardPadding = screenWidth * 0.04;
    final profileImageSize = screenWidth * 0.11;
    final titleFontSize = screenWidth * 0.038;
    final bodyFontSize = screenWidth * 0.032;
    final buttonFontSize = screenWidth * 0.03;

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: screenHeight * 0.01,
        horizontal: screenWidth * 0.02,
      ),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Aumentar padding horizontal y reducir vertical
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            offset: const Offset(0, 4),
            blurRadius: 12,
            spreadRadius: 0,
          ),
        ],
      ),
             child: Stack(
         children: [
           // Contenido principal en 2 filas
           Column(
             mainAxisSize: MainAxisSize.min, // Hacer que la columna se ajuste al contenido
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
              // Primera fila: Información del postulante
              Row(
                children: [
                  // Foto del postulante (izquierda)
                  Container(
                    width: profileImageSize,
                    height: profileImageSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(applicant.profileImageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  
                  SizedBox(width: cardPadding * 0.7),
                  
                  // Información del postulante (derecha)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nombre del postulante
                        Text(
                          applicant.name,
                          style: GoogleFonts.poppins(
                            fontSize: titleFontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        
                        SizedBox(height: screenHeight * 0.004),
                        
                        // Rol del postulante
                        Text(
                          applicant.jobRole,
                          style: GoogleFonts.poppins(
                            fontSize: bodyFontSize,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        
                        SizedBox(height: screenHeight * 0.003),
                        
                        // Rating con estrella amarilla
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 16,
                              color: Colors.amber[600],
                            ),
                            SizedBox(width: screenWidth * 0.01),
                            Text(
                              applicant.rating.toString(),
                              style: GoogleFonts.poppins(
                                fontSize: bodyFontSize,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
                             SizedBox(height: screenHeight * 0.008), // Reducir espacio entre filas
              
              // Segunda fila: Botones de acción
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Botón Decline (OutlinedButton)
                  OutlinedButton(
                    onPressed: onDecline,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey[700],
                      side: BorderSide(color: Colors.grey[400]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.close,
                          size: 14,
                          color: Colors.grey[700],
                        ),
                        SizedBox(width: screenWidth * 0.01),
                        Text(
                          'Decline',
                          style: GoogleFonts.poppins(
                            fontSize: buttonFontSize,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Botón Hire (ElevatedButton)
                  ElevatedButton(
                    onPressed: onHire,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(AppFlavorConfig.getPrimaryColor(flavor ?? AppFlavorConfig.currentFlavor)),
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shadowColor: Color(AppFlavorConfig.getPrimaryColor(flavor ?? AppFlavorConfig.currentFlavor)).withOpacity(0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check,
                          size: 14,
                          color: Colors.white,
                        ),
                        SizedBox(width: screenWidth * 0.01),
                        Text(
                          'Hire',
                          style: GoogleFonts.poppins(
                            fontSize: buttonFontSize,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          // Botón de Chat en la esquina superior derecha
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: onChat,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.message_outlined,
                  size: 18,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
