import 'package:gurps_character_creation/models/gear/gear.dart';

class Possession extends Gear {
  final String description;

  Possession({
    required super.name,
    required super.price,
    required super.weight,
    this.description = '',
  });

  Possession.withId({
    required super.id,
    required super.name,
    required super.price,
    required super.weight,
    this.description = '',
  }) : super.withId();

  factory Possession.copyWith(
    Possession poss, {
    String? name,
    double? price,
    double? weight,
    String? description,
  }) {
    return Possession.withId(
      id: poss.id,
      name: name ?? poss.name,
      price: price ?? poss.price,
      weight: weight ?? poss.weight,
    );
  }

  factory Possession.empty() => Possession(
        name: '',
        price: 0,
        weight: 0,
      );

  factory Possession.fromJson(Map<String, dynamic> json) => Possession(
        name: json['name'],
        price: json['price'],
        weight: json['weight'],
        description: json['description'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'price': price,
        'weight': weight,
        'description': description,
      };

  Map<String, dynamic> get dataTableColumns => {
        'name': name,
        'price': price,
        'weight': weight,
      };
}
