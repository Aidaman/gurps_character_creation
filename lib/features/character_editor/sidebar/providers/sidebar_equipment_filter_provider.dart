import 'package:flutter/material.dart';
import 'package:gurps_character_creation/features/gear/models/gear.dart';

enum EquipmentFilterTypes { MELLEE_WEAPONS, RANGED_WEAPONS, ARMOR }

extension SidebarEquipmentFilterTypesStringExtension on EquipmentFilterTypes {
  String get stringValue {
    switch (this) {
      case EquipmentFilterTypes.MELLEE_WEAPONS:
        return 'Melee Weapons';
      case EquipmentFilterTypes.RANGED_WEAPONS:
        return 'Ranged Weapons';
      case EquipmentFilterTypes.ARMOR:
        return 'Armor';
    }
  }

  String get abbreviatedStringValue {
    switch (this) {
      case EquipmentFilterTypes.MELLEE_WEAPONS:
        return 'Melee';
      case EquipmentFilterTypes.RANGED_WEAPONS:
        return 'Ranged';
      case EquipmentFilterTypes.ARMOR:
        return 'Armor';
    }
  }

  IconData get icon {
    switch (this) {
      case EquipmentFilterTypes.MELLEE_WEAPONS:
        return Icons.front_hand_outlined;
      case EquipmentFilterTypes.RANGED_WEAPONS:
        return Icons.gps_fixed_outlined;
      case EquipmentFilterTypes.ARMOR:
        return Icons.shield_outlined;
    }
  }

  static EquipmentFilterTypes fromString(String value) {
    switch (value.toLowerCase()) {
      case 'melee weapons':
      case 'melee':
        return EquipmentFilterTypes.MELLEE_WEAPONS;
      case 'ranged weapons':
      case 'ranged':
        return EquipmentFilterTypes.RANGED_WEAPONS;
      case 'armor':
        return EquipmentFilterTypes.ARMOR;
      default:
        return EquipmentFilterTypes.MELLEE_WEAPONS;
    }
  }
}

class SidebarEquipmentFilterProvider with ChangeNotifier {
  String _filterQuerry = '';
  EquipmentFilterTypes _sidebarContent = EquipmentFilterTypes.MELLEE_WEAPONS;

  String get filterQuerry => _filterQuerry;
  EquipmentFilterTypes get sidebarContent => _sidebarContent;

  set sidebarContent(EquipmentFilterTypes type) {
    _sidebarContent = type;
    notifyListeners();
  }

  set filterQuerry(String value) {
    _filterQuerry = value;
    notifyListeners();
  }

  void clearFilters() {
    _filterQuerry = '';
    notifyListeners();
  }

  bool filterPredicate<T extends Gear>(T gear) {
    String nameLowerCase = gear.name.toLowerCase();
    String queryLowerCase = filterQuerry.toLowerCase();

    if (queryLowerCase.isEmpty) {
      return true;
    }

    bool matchesFilterQuerry = nameLowerCase.contains(queryLowerCase);

    return matchesFilterQuerry;
  }
}
