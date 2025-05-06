import 'package:uuid/uuid.dart';

abstract class Equipment {
  String id;
  String name;
  double price;
  double weight;

  Equipment({
    required this.name,
    required this.price,
    required this.weight,
  }) : id = const Uuid().v4();

  Equipment.withId({
    required this.id,
    required this.name,
    required this.price,
    required this.weight,
  });

  /* I am not sure yet what should be the string representation of that class, so, let it be the name only for now */
  @override
  String toString() => name;
}
