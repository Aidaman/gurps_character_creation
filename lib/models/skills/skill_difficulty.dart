// ignore: constant_identifier_names
enum SkillDifficulty {
  EASY,
  AVERAGE,
  HARD,
  VERY_HARD,
  NONE,
}

extension SkillDifficultyExtension on SkillDifficulty {
  String get stringValue => switch (this) {
        SkillDifficulty.EASY => 'Easy',
        SkillDifficulty.AVERAGE => 'Average',
        SkillDifficulty.HARD => 'Hard',
        SkillDifficulty.VERY_HARD => 'Very Hard',
        SkillDifficulty.NONE => 'NONE',
      };

  static SkillDifficulty? fromString(String difficulty) {
    return switch (difficulty.toLowerCase()) {
      'e' => SkillDifficulty.EASY,
      'a' => SkillDifficulty.AVERAGE,
      'h' => SkillDifficulty.HARD,
      'vh' => SkillDifficulty.VERY_HARD,
      String() => SkillDifficulty.NONE,
    };
  }
}
