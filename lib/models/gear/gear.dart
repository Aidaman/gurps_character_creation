import 'package:uuid/uuid.dart';

abstract class Gear {
  String id;
  String name;
  double price;
  double weight;

  Gear({
    required this.name,
    required this.price,
    required this.weight,
  }) : id = const Uuid().v4();

  Gear.withId({
    required this.id,
    required this.name,
    required this.price,
    required this.weight,
  });

  /* I am not sure yet what should be the string representation of that class, so, let it be the name only for now */
  @override
  String toString() => name;
}
