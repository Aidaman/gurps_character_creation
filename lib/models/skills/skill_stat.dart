// ignore: constant_identifier_names
enum SkillStat { ST, DX, IQ, HT, Per, Will, NONE }

extension SkillStatExtension on SkillStat {
  String get stringValue => switch (this) {
        SkillStat.ST => 'Strength',
        SkillStat.DX => 'Dexterity',
        SkillStat.IQ => 'IQ',
        SkillStat.HT => 'Health',
        SkillStat.Per => 'Perception',
        SkillStat.Will => 'Will',
        SkillStat.NONE => 'None'
      };

  static SkillStat? fromString(String stat) {
    return switch (stat.toLowerCase()) {
      'st' => SkillStat.ST,
      'dx' => SkillStat.DX,
      'iq' => SkillStat.IQ,
      'ht' => SkillStat.HT,
      'per' => SkillStat.Per,
      'will' => SkillStat.Will,
      String() => SkillStat.NONE
    };
  }
}
