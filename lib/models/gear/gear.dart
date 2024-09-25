import 'package:uuid/uuid.dart';

abstract class Gear {
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

  /* I am not sure yet what should be the string representation of that class, so, let it be the name only for now */
  @override
  String toString() => name;
}
