class SkillBonus {
  final String name;
  final String specialization;
  final int amount;

  SkillBonus({
    required this.amount,
    required this.name,
    required this.specialization,
  });

  factory SkillBonus.fromJson(Map<String, dynamic> json) => SkillBonus(
        name: json['name'] ?? '',
        specialization: json['specialization'] ?? '',
        amount: json['amount'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'specialization': specialization,
        'amount': amount,
      };
}
