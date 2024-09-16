import 'package:gurps_character_creation/models/gear/gear.dart';

class Posession extends Gear {
  final String? description;
  final String? condition; //e.g. new, broken, worn, etc.

  Posession({
    required super.name,
    required super.price,
    required super.weight,
    this.description,
    this.condition,
  });

  @override
  String toString() {
    String res = super.toString();

    if (condition != null) {
      res += '\ncondition: $condition';
    }
    if (description != null) {
      res += '\n$description';
    }

    return res;
  }
}
