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

  String get abbreviatedStringValue => switch (this) {
        SkillDifficulty.EASY => 'E',
        SkillDifficulty.AVERAGE => 'A',
        SkillDifficulty.HARD => 'H',
        SkillDifficulty.VERY_HARD => 'VH',
        SkillDifficulty.NONE => 'NONE',
      };

  static SkillDifficulty? fromString(String difficulty) {
    return switch (difficulty.toLowerCase()) {
      'e' => SkillDifficulty.EASY,
      'easy' => SkillDifficulty.EASY,
      'a' => SkillDifficulty.AVERAGE,
      'average' => SkillDifficulty.AVERAGE,
      'h' => SkillDifficulty.HARD,
      'hard' => SkillDifficulty.HARD,
      'vh' => SkillDifficulty.VERY_HARD,
      'very hard' => SkillDifficulty.VERY_HARD,
      String() => SkillDifficulty.NONE,
    };
  }
}
