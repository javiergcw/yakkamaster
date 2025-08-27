import 'package:flutter/material.dart';

enum AssetType {
  logo,
  joinLogo,
  icon,
  background,
  respect,
  logoMiddle,
  employees,
}

enum AppFlavor {
  labour,
  sport,
  hospitality,
}

class AssetsConfig {
  static const Map<AppFlavor, Map<AssetType, String>> _assets = {
    AppFlavor.labour: {
      AssetType.logo: 'assets/yakka_sport_logo.svg',
      AssetType.joinLogo: 'assets/yakka_sport_logo.svg',
      AssetType.icon: 'assets/icons/labour_icon.png',
      AssetType.background: 'assets/backgrounds/labour_bg.png',
      AssetType.respect: 'assets/respect.png',
      AssetType.logoMiddle: 'assets/yakka_sport_logo_middle.svg',
      AssetType.employees: 'assets/employees.png',
    },
    AppFlavor.sport: {
      AssetType.logo: 'assets/yakka_sport_logo.svg',
      AssetType.joinLogo: 'assets/yakka_sport_logo.svg',
      AssetType.icon: 'assets/icons/sport_icon.png',
      AssetType.background: 'assets/backgrounds/sport_bg.png',
      AssetType.respect: 'assets/respect.png',
      AssetType.logoMiddle: 'assets/yakka_sport_logo_middle.svg',
      AssetType.employees: 'assets/employees.png',
    },
    AppFlavor.hospitality: {
      AssetType.logo: 'assets/yakka_sport_logo.svg',
      AssetType.joinLogo: 'assets/yakka_sport_logo.svg',
      AssetType.icon: 'assets/icons/hospitality_icon.png',
      AssetType.background: 'assets/backgrounds/hospitality_bg.png',
      AssetType.respect: 'assets/respect.png',
      AssetType.logoMiddle: 'assets/yakka_sport_logo_middle.svg',
      AssetType.employees: 'assets/employees.png',
    },
  };

  static String getAsset(AppFlavor flavor, AssetType type) {
    return _assets[flavor]?[type] ?? _assets[AppFlavor.sport]![type]!;
  }

  static String getLogo(AppFlavor flavor) {
    return getAsset(flavor, AssetType.logo);
  }

  static String getJoinLogo(AppFlavor flavor) {
    return getAsset(flavor, AssetType.joinLogo);
  }

  static String getIcon(AppFlavor flavor) {
    return getAsset(flavor, AssetType.icon);
  }

  static String getBackground(AppFlavor flavor) {
    return getAsset(flavor, AssetType.background);
  }

  static String getRespect(AppFlavor flavor) {
    return getAsset(flavor, AssetType.respect);
  }

  static String getLogoMiddle(AppFlavor flavor) {
    return getAsset(flavor, AssetType.logoMiddle);
  }

  static String getEmployees(AppFlavor flavor) {
    return getAsset(flavor, AssetType.employees);
  }
}
