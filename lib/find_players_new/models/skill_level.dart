/// Skill level enum representing player proficiency (1-5)
enum SkillLevel {
  beginner(1, 'Beginner'),
  beginnerPlus(2, 'Beginner+'),
  intermediate(3, 'Intermediate'),
  upperIntermediate(4, 'Upper Intermediate'),
  advanced(5, 'Advanced');

  final int value;
  final String label;

  const SkillLevel(this.value, this.label);

  /// Convert integer value to SkillLevel enum
  static SkillLevel fromValue(int value) {
    return SkillLevel.values.firstWhere(
      (e) => e.value == value,
      orElse: () => SkillLevel.beginner,
    );
  }

  /// Get color for skill level (for map markers)
  String get hexColor {
    switch (this) {
      case SkillLevel.beginner:
        return '#81C784'; // Light Green
      case SkillLevel.beginnerPlus:
        return '#4CAF50'; // Green
      case SkillLevel.intermediate:
        return '#2196F3'; // Blue
      case SkillLevel.upperIntermediate:
        return '#FF9800'; // Orange
      case SkillLevel.advanced:
        return '#F44336'; // Red
    }
  }
}
