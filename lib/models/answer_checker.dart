class AnswerChecker {
  // Check if the provided answer matches the expected answer
  static bool checkAnswer(String userAnswer, String correctAnswer, int level) {
    // For basic levels with simple arithmetic (levels 1-19)
    if (level < 20) {
      // Compare numerical values to handle whitespace and formatting
      try {
        int userValue = int.parse(userAnswer.trim());
        int correctValue = int.parse(correctAnswer.trim());
        return userValue == correctValue;
      } catch (e) {
        // If parsing fails, fall back to string comparison
        return userAnswer.trim() == correctAnswer.trim();
      }
    }
    // For fraction levels (20-25)
    else if (level >= 20 && level <= 25) {
      return _checkFractionAnswer(userAnswer, correctAnswer);
    }
    // For decimal levels (26-32)
    else if (level > 25) {
      return _checkDecimalAnswer(userAnswer, correctAnswer);
    }

    return userAnswer.trim() == correctAnswer.trim();
  }

  // Helper method to check fraction answers
  static bool _checkFractionAnswer(String userAnswer, String correctAnswer) {
    try {
      // Parse fraction strings (e.g., "3/4")
      List<String> userParts = userAnswer.split('/');
      List<String> correctParts = correctAnswer.split('/');

      if (userParts.length != 2 || correctParts.length != 2) {
        return userAnswer.trim() == correctAnswer.trim();
      }

      int userNum = int.parse(userParts[0].trim());
      int userDenom = int.parse(userParts[1].trim());
      int correctNum = int.parse(correctParts[0].trim());
      int correctDenom = int.parse(correctParts[1].trim());

      // Check if fractions are equivalent
      return (userNum * correctDenom) == (correctNum * userDenom);
    } catch (e) {
      // If parsing fails, fall back to string comparison
      return userAnswer.trim() == correctAnswer.trim();
    }
  }

  // Helper method to check decimal answers
  static bool _checkDecimalAnswer(String userAnswer, String correctAnswer) {
    try {
      double userValue = double.parse(userAnswer.trim());
      double correctValue = double.parse(correctAnswer.trim());

      // Use a small epsilon for floating point comparison
      return (userValue - correctValue).abs() < 0.0001;
    } catch (e) {
      // If parsing fails, fall back to string comparison
      return userAnswer.trim() == correctAnswer.trim();
    }
  }
}
