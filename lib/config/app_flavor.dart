import 'package:flutter/material.dart';
import 'assets_config.dart';

// Usar el enum de AssetsConfig

class AppFlavorConfig {
  static AppFlavor currentFlavor = AppFlavor.sport;

  // Métodos que reciben flavor como parámetro
  static String getAppName(AppFlavor flavor) {
    switch (flavor) {
      case AppFlavor.labour:
        return 'Yakka Labour';
      case AppFlavor.sport:
        return 'Yakka Sports';
      case AppFlavor.hospitality:
        return 'Yakka Hospitality';
    }
  }

  static String getTagline(AppFlavor flavor) {
    switch (flavor) {
      case AppFlavor.labour:
        return 'Tu trabajo, tu futuro';
      case AppFlavor.sport:
        return 'Tu pasiósssn por el deporte';
      case AppFlavor.hospitality:
        return 'Experiencias únicas';
    }
  }

  static int getPrimaryColor(AppFlavor flavor) {
    switch (flavor) {
      case AppFlavor.labour:
        return 0xFFFFD700; // Azul
      case AppFlavor.sport:
        return 0xFF06AB24; // Verde deportivo
      case AppFlavor.hospitality:
        return 0xFFFF6B35; // Naranja
    }
  }

  static int getSecondaryColor(AppFlavor flavor) {
    switch (flavor) {
      case AppFlavor.labour:
        return 0xFF42A5F5; // Azul claro
      case AppFlavor.sport:
        return 0xFF4CAF50; // Verde claro
      case AppFlavor.hospitality:
        return 0xFFFF8A65; // Naranja claro
    }
  }

  static Color getJoinBackgroundColor(AppFlavor flavor) {
    switch (flavor) {
      case AppFlavor.labour:
        return const Color(0xFFFFD700); // Amarillo
      case AppFlavor.sport:
        return const Color(0xFF06AB24); // Verde deportivo
      case AppFlavor.hospitality:
        return const Color(0xFFFF6B35); // Naranja
    }
  }

  static String getLoginGreeting(AppFlavor flavor) {
    switch (flavor) {
      case AppFlavor.labour:
        return "G'day, mate.";
      case AppFlavor.sport:
        return "Ready to play?";
      case AppFlavor.hospitality:
        return "Welcome back!";
    }
  }

  static String getLoginSubtitle(AppFlavor flavor) {
    switch (flavor) {
      case AppFlavor.labour:
        return "Login with your phone number.";
      case AppFlavor.sport:
        return "Join the game with your phone.";
      case AppFlavor.hospitality:
        return "Access your account.";
    }
  }

  static String getContinueButtonText(AppFlavor flavor) {
    switch (flavor) {
      case AppFlavor.labour:
        return "Continue";
      case AppFlavor.sport:
        return "Play Now";
      case AppFlavor.hospitality:
        return "Sign In";
    }
  }

  // Getters originales (para compatibilidad)
  static String get appName => getAppName(currentFlavor);
  static String get tagline => getTagline(currentFlavor);
  static int get primaryColor => getPrimaryColor(currentFlavor);
  static int get secondaryColor => getSecondaryColor(currentFlavor);

  static IconData get appIcon {
    switch (currentFlavor) {
      case AppFlavor.labour:
        return Icons.work;
      case AppFlavor.sport:
        return Icons.sports_soccer;
      case AppFlavor.hospitality:
        return Icons.hotel;
    }
  }

  static String get logoSvgPath {
    return AssetsConfig.getLogo(currentFlavor);
  }

  static String get joinSvgPath {
    return AssetsConfig.getJoinLogo(currentFlavor);
  }

  static String get joinTitle {
    switch (currentFlavor) {
      case AppFlavor.labour:
        return 'WORK OR HIRE';
      case AppFlavor.sport:
        return 'PLAY OR WATCH';
      case AppFlavor.hospitality:
        return 'SERVE OR ENJOY';
    }
  }

  static String get joinSubtitle {
    switch (currentFlavor) {
      case AppFlavor.labour:
        return 'No worries.';
      case AppFlavor.sport:
        return 'No limits.';
      case AppFlavor.hospitality:
        return 'No boundaries.';
    }
  }

  static String get joinDescription {
    switch (currentFlavor) {
      case AppFlavor.labour:
        return 'Construction &\nHospitality Jobs';
      case AppFlavor.sport:
        return 'Sports &\nFitness Activities';
      case AppFlavor.hospitality:
        return 'Hospitality &\nService Industry';
    }
  }

  static Color get joinBackgroundColor => getJoinBackgroundColor(currentFlavor);

  static String get loginGreeting => getLoginGreeting(currentFlavor);
  static String get loginSubtitle => getLoginSubtitle(currentFlavor);
  static String get continueButtonText => getContinueButtonText(currentFlavor);

}
