import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../config/app_flavor.dart';
import '../../data/invoice_dto.dart';

class PdfViewerScreen extends StatefulWidget {
  final InvoiceDto invoice;
  final AppFlavor? flavor;

  const PdfViewerScreen({
    super.key,
    required this.invoice,
    this.flavor,
  });

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  AppFlavor get _currentFlavor => widget.flavor ?? AppFlavorConfig.currentFlavor;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Simular carga del PDF
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    final horizontalPadding = screenWidth * 0.06;
    final verticalSpacing = screenHeight * 0.025;
    final titleFontSize = screenWidth * 0.055;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Factura PDF',
          style: GoogleFonts.poppins(
            fontSize: titleFontSize,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.download, color: Colors.black),
            onPressed: () => _downloadPdf(),
          ),
          IconButton(
            icon: Icon(Icons.share, color: Colors.black),
            onPressed: () => _sharePdf(),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Información de la factura
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Factura: ${widget.invoice.dateRange}',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Destinatario: ${widget.invoice.recipientName}',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    'Estado: ${widget.invoice.status == 'paid' ? 'Pagada' : 'Pendiente'}',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: widget.invoice.status == 'paid' ? Colors.green[600] : Colors.orange[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: verticalSpacing * 2),
            
            // Contenedor del PDF
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: _isLoading
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Cargando PDF...',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          // Header del PDF
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.picture_as_pdf,
                                  color: Colors.red[600],
                                  size: 24,
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'factura_${widget.invoice.dateRange.replaceAll(' ', '_')}.pdf',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Text(
                                  '2.3 MB',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // Contenido del PDF (simulado)
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              color: Colors.white,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.picture_as_pdf,
                                    size: 80,
                                    color: Colors.grey[400],
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'Vista previa del PDF',
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Aquí se mostraría el contenido del PDF',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                  SizedBox(height: 24),
                                  ElevatedButton.icon(
                                    onPressed: () => _openPdfInBrowser(),
                                    icon: Icon(Icons.open_in_browser),
                                    label: Text('Abrir en navegador'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                                      foregroundColor: Colors.black,
                                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _downloadPdf() {
    // Aquí implementarías la descarga del PDF
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Descargando PDF...'),
        backgroundColor: Colors.blue[600],
      ),
    );
  }

  void _sharePdf() {
    // Aquí implementarías el compartir del PDF
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Compartiendo PDF...'),
        backgroundColor: Colors.green[600],
      ),
    );
  }

  void _openPdfInBrowser() async {
    // URL de ejemplo - aquí usarías la URL real del PDF
    final url = Uri.parse('https://example.com/invoice.pdf');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo abrir el PDF'),
          backgroundColor: Colors.red[600],
        ),
      );
    }
  }
}
