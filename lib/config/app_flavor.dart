import 'package:flutter/material.dart';
import 'assets_config.dart';

// Re-export AppFlavor enum for easier access
export 'assets_config.dart' show AppFlavor;

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

  // Timesheet specific methods
  static Color getTimesheetPrimaryColor(AppFlavor flavor) {
    switch (flavor) {
      case AppFlavor.labour:
        return const Color(0xFFFFD700); // Amarillo
      case AppFlavor.sport:
        return const Color(0xFF06AB24); // Verde deportivo
      case AppFlavor.hospitality:
        return const Color(0xFFFF6B35); // Naranja
    }
  }

  static Color getTimesheetAccentColor(AppFlavor flavor) {
    switch (flavor) {
      case AppFlavor.labour:
        return const Color(0xFFFFE082); // Amarillo claro
      case AppFlavor.sport:
        return const Color(0xFF81C784); // Verde claro
      case AppFlavor.hospitality:
        return const Color(0xFFFFAB91); // Naranja claro
    }
  }

  static String getTimesheetTitle(AppFlavor flavor) {
    switch (flavor) {
      case AppFlavor.labour:
        return "Work Timesheet";
      case AppFlavor.sport:
        return "Training Timesheet";
      case AppFlavor.hospitality:
        return "Shift Timesheet";
    }
  }

  static String getWorkTimeTitle(AppFlavor flavor) {
    switch (flavor) {
      case AppFlavor.labour:
        return "Work time";
      case AppFlavor.sport:
        return "Training time";
      case AppFlavor.hospitality:
        return "Shift time";
    }
  }

  static String getWorkTimeSubtitle(AppFlavor flavor) {
    switch (flavor) {
      case AppFlavor.labour:
        return "Add your working hours";
      case AppFlavor.sport:
        return "Add your training hours";
      case AppFlavor.hospitality:
        return "Add your shift hours";
    }
  }

  static String getOvertimeQuestion(AppFlavor flavor) {
    switch (flavor) {
      case AppFlavor.labour:
        return "Any work beyond your scheduled shift?";
      case AppFlavor.sport:
        return "Any training beyond your scheduled session?";
      case AppFlavor.hospitality:
        return "Any work beyond your scheduled shift?";
    }
  }

  static String getAllowanceQuestion(AppFlavor flavor) {
    switch (flavor) {
      case AppFlavor.labour:
        return "Do you have any additional Allowance?";
      case AppFlavor.sport:
        return "Do you have any additional Bonus?";
      case AppFlavor.hospitality:
        return "Do you have any additional Tips?";
    }
  }

  static String getSubmitButtonText(AppFlavor flavor) {
    switch (flavor) {
      case AppFlavor.labour:
        return "Submit Timesheet";
      case AppFlavor.sport:
        return "Submit Training";
      case AppFlavor.hospitality:
        return "Submit Shift";
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

  // Timesheet getters
  static Color get timesheetPrimaryColor => getTimesheetPrimaryColor(currentFlavor);
  static Color get timesheetAccentColor => getTimesheetAccentColor(currentFlavor);
  static String get timesheetTitle => getTimesheetTitle(currentFlavor);
  static String get workTimeTitle => getWorkTimeTitle(currentFlavor);
  static String get workTimeSubtitle => getWorkTimeSubtitle(currentFlavor);
  static String get overtimeQuestion => getOvertimeQuestion(currentFlavor);
  static String get allowanceQuestion => getAllowanceQuestion(currentFlavor);
  static String get submitButtonText => getSubmitButtonText(currentFlavor);

}
