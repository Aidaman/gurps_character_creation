class SkillBonus {
  final String? name;
  final String? specialization;
  final int amount;

  SkillBonus({
    required this.amount,
    this.name,
    this.specialization,
  });

  factory SkillBonus.fromJson(Map<String, dynamic> json) => SkillBonus(
        name: json['name'] ?? '',
        specialization: json['specialization'] ?? '',
        amount: json['amount'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'specialization': specialization,
        'amount': amount,
      };
}
