import 'package:flutter/material.dart';
import '../../../../../config/app_flavor.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final AppFlavor? flavor;

  const ProgressIndicatorWidget({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.flavor,
  });

  AppFlavor get _currentFlavor => flavor ?? AppFlavorConfig.currentFlavor;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;

    // Siempre mostrar 5 pasos para mantener un tamaño consistente
    final displaySteps = 5;
    
    // Calcular valores responsive para 5 pasos
    final circleSize = screenWidth * 0.055; // 5.5% del ancho para el círculo
    final lineWidth = screenWidth * 0.1; // 10% del ancho para la línea
    final lineHeight = 3.0; // Línea más gruesa

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(displaySteps, (index) {
        // Calcular el estado del paso basado en el progreso real
        final progressRatio = currentStep / totalSteps;
        final stepProgress = (index + 1) / displaySteps;
        
        final isCompleted = stepProgress <= progressRatio;
        final isCurrent = stepProgress > progressRatio && (index == 0 || (index - 1) / displaySteps < progressRatio);
        
        return Row(
          children: [
            // Círculo
            Container(
              width: circleSize,
              height: circleSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted 
                    ? Color(AppFlavorConfig.getPrimaryColor(_currentFlavor))
                    : Colors.transparent,
                border: Border.all(
                  color: isCompleted || isCurrent
                      ? Color(AppFlavorConfig.getPrimaryColor(_currentFlavor))
                      : Colors.grey[300]!,
                  width: 2,
                ),
              ),
              child: isCompleted
                  ? Center(
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: circleSize * 0.5,
                      ),
                    )
                  : isCurrent
                      ? Center(
                          child: Container(
                            width: circleSize * 0.3,
                            height: circleSize * 0.3,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(AppFlavorConfig.getPrimaryColor(_currentFlavor)),
                            ),
                          ),
                        )
                      : null,
            ),
            
            // Línea conectora (excepto para el último elemento)
            if (index < displaySteps - 1)
              Container(
                width: lineWidth,
                height: lineHeight,
                color: isCompleted 
                    ? Color(AppFlavorConfig.getPrimaryColor(_currentFlavor))
                    : Colors.grey[300]!,
              ),
          ],
        );
      }),
    );
  }
}
