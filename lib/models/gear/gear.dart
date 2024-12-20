import 'package:uuid/uuid.dart';

class Gear {
  final String id;
  final String name;
  final double price;
  final double weight;

  Gear({
    required this.name,
    required this.price,
    required this.weight,
  }) : id = const Uuid().v4();

  const Gear.withId({
    required this.id,
    required this.name,
    required this.price,
    required this.weight,
  });

  factory Gear.copyWith(
    Gear gear, {
    String? id,
    String? name,
    double? price,
    double? weight,
  }) {
    return Gear.withId(
      id: id ?? gear.id,
      name: name ?? gear.name,
      price: price ?? gear.price,
      weight: weight ?? gear.weight,
    );
  }

  factory Gear.empty() => Gear(
        name: '',
        price: 0,
        weight: 0,
      );

  /* I am not sure yet what should be the string representation of that class, so, let it be the name only for now */
  @override
  String toString() => name;
}
