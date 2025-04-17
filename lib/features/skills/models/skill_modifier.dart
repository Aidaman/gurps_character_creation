class SkillModifier {
  final String type;
  final String modifier;
  final String? name;
  final String? specialization;

  SkillModifier({
    required this.type,
    required this.modifier,
    required this.name,
    required this.specialization,
  });

  factory SkillModifier.fromJson(Map<String, dynamic> json) => SkillModifier(
        type: json['type'] ?? '',
        modifier: json['modifier'] ?? '',
        name: json['name'] ?? '',
        specialization: json['specialization'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'type': type,
        'modifier': modifier,
        'name': name,
        'specialization': specialization,
      };
}
