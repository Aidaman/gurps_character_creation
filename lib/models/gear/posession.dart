import 'package:gurps_character_creation/models/gear/gear.dart';

class Posession extends Gear {
  final String? description;

  Posession({
    required super.name,
    required super.price,
    required super.weight,
    this.description,
  });

  Posession.withId({
    required super.id,
    required super.name,
    required super.price,
    required super.weight,
    this.description,
  }) : super.withId();

  factory Posession.copyWith(
    Posession poss, {
    String? name,
    double? price,
    double? weight,
    String? description,
  }) {
    return Posession.withId(
      id: poss.id,
      name: name ?? poss.name,
      price: price ?? poss.price,
      weight: weight ?? poss.weight,
    );
  }

  factory Posession.empty() => Posession(
        name: '',
        price: 0,
        weight: 0,
      );

  factory Posession.fromJson(Map<String, dynamic> json) => Posession(
        name: json['name'],
        price: json['price'],
        weight: json['weight'],
        description: json['description'],
      );

  Map<String, dynamic> get dataTableColumns => {
        'name': name,
        'price': price,
        'weight': weight,
      };
}
