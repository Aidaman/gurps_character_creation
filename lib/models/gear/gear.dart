abstract class Gear {
  final String name;
  final double price;
  final double weight;

  const Gear({
    required this.name,
    required this.price,
    required this.weight,
  });

  /* I not sure yet what should be the string representation of that class, so, let it be the name only for now */
  @override
  String toString() => name;
}
