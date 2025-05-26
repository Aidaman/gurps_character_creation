import 'package:flutter/material.dart';
import 'package:gurps_character_creation/features/equipment/models/equipment.dart';
import 'package:gurps_character_creation/features/equipment/models/weapons/weapon.dart';

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
  String _selectedSkillName = '';
  EquipmentFilterTypes _sidebarContent = EquipmentFilterTypes.MELLEE_WEAPONS;

  String get filterQuerry => _filterQuerry;
  String get selectedSkillName => _selectedSkillName;
  EquipmentFilterTypes get sidebarContent => _sidebarContent;

  set sidebarContent(EquipmentFilterTypes type) {
    _sidebarContent = type;
    notifyListeners();
  }

  set filterQuerry(String value) {
    _filterQuerry = value;
    notifyListeners();
  }

  set selectedSkillName(String value) {
    _selectedSkillName = value;
    notifyListeners();
  }

  void clearFilters() {
    _filterQuerry = '';
    _selectedSkillName = '';
    _sidebarContent = EquipmentFilterTypes.MELLEE_WEAPONS;
    notifyListeners();
  }

  bool filterPredicate<T extends Equipment>(T eqp) {
    String nameLowerCase = eqp.name.toLowerCase();
    String queryLowerCase = filterQuerry.toLowerCase();

    bool matchesFilterQuerry = nameLowerCase.contains(queryLowerCase);

    if (eqp is Weapon && eqp.associatedSkillName.isNotEmpty) {
      return matchesFilterQuerry &&
          eqp.associatedSkillName.contains(_selectedSkillName);
    }

    if (queryLowerCase.isEmpty) {
      return true;
    }

    return matchesFilterQuerry;
  }
}
