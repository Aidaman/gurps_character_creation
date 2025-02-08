// Aspect of a character, as something fundamental
// Trait is an Aspect that forms personality as well as Skills do
abstract class Aspect {
  final String id;
  final String name;
  final String reference;

  const Aspect({
    required this.id,
    required this.name,
    required this.reference,
  });
}
