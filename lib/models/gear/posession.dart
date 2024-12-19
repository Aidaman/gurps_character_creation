import 'package:gurps_character_creation/models/gear/gear.dart';

class Posession extends Gear {
  final String? description;

  Posession({
    required super.name,
    required super.price,
    required super.weight,
    this.description,
  });
}
