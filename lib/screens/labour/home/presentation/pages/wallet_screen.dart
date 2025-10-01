import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/app_flavor.dart';
import '../widgets/transaction_item.dart';
import '../widgets/under_construction_widget.dart';
import '../../logic/controllers/wallet_screen_controller.dart';

class WalletScreen extends StatelessWidget {
  static const String id = '/labour/wallet';
  
  final AppFlavor? flavor;
  
  // Booleano para controlar si mostrar el widget de construcción o el contenido normal
  static const bool showUnderConstruction = true;

  WalletScreen({
    Key? key,
    this.flavor,
  }) : super(key: key);

  final WalletScreenController controller = Get.put(WalletScreenController());

  @override
  Widget build(BuildContext context) {
    // Si está en modo construcción, mostrar el widget de construcción con AppBar y BottomNavigationBar
    if (showUnderConstruction) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: MediaQuery.of(context).size.width * 0.06,
            ),
            onPressed: () => Get.back(),
          ),
          title: Text(
            'Earnings',
            style: GoogleFonts.poppins(
              fontSize: MediaQuery.of(context).size.width * 0.055,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.06,
              vertical: MediaQuery.of(context).size.height * 0.05,
            ),
            child: UnderConstructionWidget(
              flavor: flavor ?? AppFlavorConfig.currentFlavor,
              customMessage: "We are working on improving your earnings and payment tracking features. This will be available soon with enhanced financial insights!",
            ),
          ),
        ),
      );
    }

    // Establecer el flavor en el controlador si se proporciona
    if (flavor != null) {
      controller.currentFlavor.value = flavor!;
    }
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // Cálculos responsivos
    final horizontalPadding = screenWidth * 0.05; // 5% del ancho
    final verticalSpacing = screenHeight * 0.015; // 1.5% del alto
    final headerHeight = screenHeight * 0.38; // 38% del alto para el header
    final balanceFontSize = screenWidth * 0.07; // 7% del ancho para el balance
    final titleFontSize = screenWidth * 0.045; // 4.5% del ancho para títulos

    return Scaffold(
      body: Column(
        children: [
          // Header con AppBar degradado Apple minimalista
          Container(
            height: headerHeight,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)),
                  Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)).withOpacity(0.8),
                  Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)).withOpacity(0.6),
                ],
                stops: [0.0, 0.7, 1.0],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Stack(
              children: [
                // Patrón de fondo geométrico sutil
                Positioned.fill(
                  child: CustomPaint(
                    painter: GeometricPatternPainter(
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                ),
                
                // Contenido del header
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: Column(
                      children: [
                        // AppBar minimalista
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Botón de regreso con estilo Apple
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: IconButton(
                                  onPressed: controller.handleBackNavigation,
                                  icon: Icon(
                                    Icons.arrow_back_ios_new,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                  padding: EdgeInsets.all(2),
                                  constraints: BoxConstraints(
                                    minWidth: 28,
                                    minHeight: 28,
                                  ),
                                ),
                              ),
                              
                              // Título centrado
                              Text(
                                'My wallet',
                                style: TextStyle(
                                  fontSize: titleFontSize * 0.7,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              
                              // Botón de agregar con estilo Apple
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: IconButton(
                                  onPressed: controller.addMoney,
                                  icon: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                  padding: EdgeInsets.all(2),
                                  constraints: BoxConstraints(
                                    minWidth: 28,
                                    minHeight: 28,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        SizedBox(height: verticalSpacing * 0.3),
                        
                        // Icono del wallet con estilo Apple
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.account_balance_wallet_outlined,
                            color: Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)),
                            size: 28,
                          ),
                        ),
                        
                        SizedBox(height: verticalSpacing * 1),
                        
                        // Balance con estilo Apple
                        Obx(() => Text(
                          '\$ ${controller.walletController.balance.value.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: balanceFontSize,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 1.0,
                          ),
                        )),
                        
                        SizedBox(height: verticalSpacing * 0.3),
                        
                        Text(
                          'Available Balance',
                          style: TextStyle(
                            fontSize: titleFontSize * 0.65,
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.3,
                          ),
                        ),
                        
                        SizedBox(height: verticalSpacing * 1.2),
                        
                        // Botón de retirar con estilo Apple
                        Container(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: controller.withdrawBalance,
                            icon: Container(
                              width: 26,
                              height: 26,
                              decoration: BoxDecoration(
                                color: Colors.black87,
                                borderRadius: BorderRadius.circular(13),
                              ),
                              child: Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                            label: Text(
                              'Withdraw balance',
                              style: TextStyle(
                                fontSize: titleFontSize * 0.7,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                                letterSpacing: 0.3,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black87,
                              elevation: 0,
                              padding: EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              shadowColor: Colors.black.withOpacity(0.1),
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
          
          // Sección de transacciones recientes con estilo Apple
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  children: [
                                         SizedBox(height: verticalSpacing * 2),
                    
                    // Header de transacciones con estilo Apple
                    Container(
                      padding: EdgeInsets.symmetric(vertical: verticalSpacing),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recent transactions',
                            style: TextStyle(
                              fontSize: titleFontSize * 0.85,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                              letterSpacing: 0.3,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: PopupMenuButton<String>(
                              onSelected: controller.setSort,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Sort By',
                                      style: TextStyle(
                                        fontSize: titleFontSize * 0.6,
                                        color: Colors.grey[700],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(width: 6),
                                    Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.grey[700],
                                      size: 16,
                                    ),
                                  ],
                                ),
                              ),
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 'Date',
                                  child: Text('Date'),
                                ),
                                PopupMenuItem(
                                  value: 'Amount',
                                  child: Text('Amount'),
                                ),
                                PopupMenuItem(
                                  value: 'Status',
                                  child: Text('Status'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: verticalSpacing * 1.5),
                    
                    // Lista de transacciones con estilo Apple
                    Expanded(
                      child: Obx(() {
                        if (controller.walletController.isLoading.value) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: Color(AppFlavorConfig.getPrimaryColor(controller.currentFlavor.value)),
                            ),
                          );
                        }
                        
                        if (controller.walletController.transactions.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.receipt_long_outlined,
                                  size: 60,
                                  color: Colors.grey[400],
                                ),
                                SizedBox(height: verticalSpacing),
                                Text(
                                  'No transactions found',
                                  style: TextStyle(
                                    fontSize: titleFontSize * 0.65,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        
                        return ListView.separated(
                          itemCount: controller.walletController.transactions.length,
                          separatorBuilder: (context, index) => Container(
                            margin: EdgeInsets.symmetric(horizontal: horizontalPadding * 0.5),
                            height: 1,
                            color: Colors.grey[200],
                          ),
                          itemBuilder: (context, index) {
                            final transaction = controller.walletController.transactions[index];
                            return TransactionItem(
                              transaction: transaction,
                              horizontalPadding: horizontalPadding,
                              verticalSpacing: verticalSpacing,
                            );
                          },
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Pintor personalizado para el patrón geométrico de fondo
class GeometricPatternPainter extends CustomPainter {
  final Color color;

  GeometricPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Dibujar formas geométricas simples
    for (int i = 0; i < 5; i++) {
      for (int j = 0; j < 3; j++) {
        final rect = Rect.fromLTWH(
          i * size.width / 5,
          j * size.height / 3,
          size.width / 8,
          size.height / 6,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, Radius.circular(8)),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
