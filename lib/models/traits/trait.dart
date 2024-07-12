// ignore_for_file: constant_identifier_names

enum TraitTypes {
  MENTAl,
  PHYSICAL,
  SOCIAL,
  MAGICAL,
  SKILLS,
  PERKS,
  QUIRKS,
  SPELLS,
  PSIONIC,
}

class Trait {
  final String name;
  final String description;
  final TraitTypes traitType;
  final int cost;

  Trait(
      {required this.name,
      required this.description,
      required this.traitType,
      required this.cost});
}
