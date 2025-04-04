import 'dart:math';

class MathProblem {
  final String problem;
  final String answer;
  final int level;

  MathProblem(
      {required this.problem, required this.answer, required this.level});
}

class ProblemGenerator {
  // Generate a problem based on level
  static MathProblem generateProblem(int level) {
    // Simple placeholder implementation
    if (level <= 5) {
      // Simple addition (1-9)
      return MathProblem(problem: "5 + 3", answer: "8", level: level);
    } else if (level <= 10) {
      // Addition with larger numbers
      return MathProblem(problem: "12 + 7", answer: "19", level: level);
    } else if (level <= 15) {
      // Subtraction
      return MathProblem(problem: "15 - 6", answer: "9", level: level);
    } else if (level <= 20) {
      // Multiplication
      return MathProblem(problem: "4 × 6", answer: "24", level: level);
    } else {
      // Division or fractions
      return MathProblem(problem: "1/2 + 1/4", answer: "3/4", level: level);
    }
  }

  // Helper methods for different problem types
  static MathProblem _generateAdditionProblem(
      {required int maxA, required int maxB}) {
    final random = Random();
    final int a = random.nextInt(maxA) + 1; // 1 to maxA
    final int b = random.nextInt(maxB) + 1; // 1 to maxB

    final String problem = "$a + $b";
    final String answer = "${a + b}";

    return MathProblem(problem: problem, answer: answer, level: 1);
  }

  static MathProblem _generateSubtractionProblem(
      {required int maxA, required int maxB}) {
    final random = Random();
    final int a = random.nextInt(maxA) + 1; // 1 to maxA
    final int b = random.nextInt(maxB) + 1; // 1 to maxB

    final String problem = "$a - $b";
    final String answer = "${a - b}";

    return MathProblem(problem: problem, answer: answer, level: 11);
  }

  static MathProblem _generateMultiplicationProblem(
      {required int maxA, required int maxB}) {
    final random = Random();
    final int a = random.nextInt(maxA) + 1; // 1 to maxA
    final int b = random.nextInt(maxB) + 1; // 1 to maxB

    final String problem = "$a × $b";
    final String answer = "${a * b}";

    return MathProblem(problem: problem, answer: answer, level: 16);
  }

  static MathProblem _generateDivisionProblem(
      {required int maxA, required int maxB}) {
    final random = Random();
    final int b = 1 + random.nextInt(9);
    final int answer = 1 + random.nextInt(9);
    final int a = b * answer;

    final String problem = "$a ÷ $b";

    return MathProblem(problem: problem, answer: "$answer", level: 16);
  }

  static MathProblem _generateFractionProblem(int level) {
    final random = Random();
    if (level == 20) {
      // Simple fraction identification
      final int numerator = 1 + random.nextInt(5);
      final int denominator = 2 + random.nextInt(8);

      final String problem = "$numerator/$denominator";
      final String answer = "$numerator/$denominator";

      return MathProblem(problem: problem, answer: answer, level: level);
    } else {
      // Fraction addition
      final int denominator = 2 + random.nextInt(8);
      final int numerator1 = 1 + random.nextInt(denominator);
      final int numerator2 = 1 + random.nextInt(denominator);

      final String problem =
          "$numerator1/$denominator + $numerator2/$denominator";

      // Calculate answer (simplified)
      int resultNumerator = numerator1 + numerator2;
      int resultDenominator = denominator;

      // Simplify fraction (if possible)
      int gcd = _findGCD(resultNumerator, resultDenominator);
      resultNumerator ~/= gcd;
      resultDenominator ~/= gcd;

      final String answer = "$resultNumerator/$resultDenominator";

      return MathProblem(problem: problem, answer: answer, level: level);
    }
  }

  static MathProblem _generateMixedProblem(int level) {
    final random = Random();
    final int operation = random.nextInt(4);

    switch (operation) {
      case 0:
        return _generateAdditionProblem(maxA: 20, maxB: 20);
      case 1:
        return _generateSubtractionProblem(maxA: 20, maxB: 10);
      case 2:
        return _generateMultiplicationProblem(maxA: 10, maxB: 10);
      default:
        return _generateDivisionProblem(maxA: 100, maxB: 10);
    }
  }

  // Helper function to find greatest common divisor (for fraction simplification)
  static int _findGCD(int a, int b) {
    while (b != 0) {
      int t = b;
      b = a % b;
      a = t;
    }
    return a;
  }

  // Specific fraction problems for level 20
  static MathProblem _getSpecificFractionProblem() {
    final predefinedProblems = [
      MathProblem(problem: "1/2 + 1/4", answer: "3/4", level: 20),
      MathProblem(problem: "2/3 + 1/6", answer: "5/6", level: 20),
      // Add more as needed
    ];

    final random = Random();
    return predefinedProblems[random.nextInt(predefinedProblems.length)];
  }

  // Other generator methods
  static MathProblem _generateFractionAdditionProblem(
      {required List<int> denominators}) {
    final random = Random();

    // Select denominators from the provided list
    final int denominator = denominators[random.nextInt(denominators.length)];

    // Generate numerators that are less than the denominator
    final int numerator1 = 1 + random.nextInt(denominator - 1);
    final int numerator2 = 1 + random.nextInt(denominator - 1);

    // Create the problem
    final String problem =
        "$numerator1/$denominator + $numerator2/$denominator";

    // Calculate answer (simplified)
    int resultNumerator = numerator1 + numerator2;
    int resultDenominator = denominator;

    // Simplify fraction (if possible)
    int gcd = _findGCD(resultNumerator, resultDenominator);
    resultNumerator ~/= gcd;
    resultDenominator ~/= gcd;

    final String answer = "$resultNumerator/$resultDenominator";

    return MathProblem(problem: problem, answer: answer, level: 21);
  }

  static MathProblem _generateDivisionWithFraction() {
    final random = Random();
    final int numerator = 1 + random.nextInt(5);
    final int denominator = 2 + random.nextInt(4);

    // Create a division problem with a fraction
    final String problem = "1 ÷ ($numerator/$denominator)";

    // Calculate answer: 1 ÷ (a/b) = b/a
    final String answer = "$denominator/$numerator";

    return MathProblem(problem: problem, answer: answer, level: 23);
  }

  static MathProblem _generateMixedFractions() {
    final random = Random();
    final int whole1 = 1 + random.nextInt(3);
    final int numerator1 = 1 + random.nextInt(3);
    final int denominator1 = 2 + random.nextInt(3);

    final int whole2 = 1 + random.nextInt(3);
    final int numerator2 = 1 + random.nextInt(3);
    final int denominator2 = 2 + random.nextInt(3);

    final String problem =
        "$whole1 $numerator1/$denominator1 + $whole2 $numerator2/$denominator2";

    // Convert to improper fractions
    final int improperNum1 = whole1 * denominator1 + numerator1;
    final int improperNum2 = whole2 * denominator2 + numerator2;

    // Find common denominator
    final int lcm = _findLCM(denominator1, denominator2);

    // Convert to common denominator
    final int newNum1 = improperNum1 * (lcm ~/ denominator1);
    final int newNum2 = improperNum2 * (lcm ~/ denominator2);

    // Add fractions
    int resultNum = newNum1 + newNum2;

    // Convert back to mixed fraction
    int resultWhole = resultNum ~/ lcm;
    int resultNumFraction = resultNum % lcm;

    // Simplify remaining fraction
    int gcd = _findGCD(resultNumFraction, lcm);
    if (gcd > 1) {
      resultNumFraction ~/= gcd;
      int resultDenom = lcm ~/ gcd;
      return MathProblem(
          problem: problem,
          answer: resultWhole > 0
              ? "$resultWhole $resultNumFraction/$resultDenom"
              : "$resultNumFraction/$resultDenom",
          level: 24);
    }

    return MathProblem(
        problem: problem,
        answer: resultWhole > 0
            ? "$resultWhole $resultNumFraction/$lcm"
            : "$resultNumFraction/$lcm",
        level: 24);
  }

  static MathProblem _generateDecimalProblems() {
    final random = Random();
    final double a = (random.nextInt(10) + 1) + (random.nextInt(10) / 10);
    final double b = (random.nextInt(10) + 1) + (random.nextInt(10) / 10);

    final String problem = "${a.toStringAsFixed(1)} + ${b.toStringAsFixed(1)}";
    final double result = a + b;

    return MathProblem(
        problem: problem, answer: result.toStringAsFixed(1), level: 30);
  }

  // Helper method to find least common multiple
  static int _findLCM(int a, int b) {
    return (a * b) ~/ _findGCD(a, b);
  }
}

// Add this class after the ProblemGenerator class
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
