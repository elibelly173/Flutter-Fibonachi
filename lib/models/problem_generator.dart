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
    if (level <= 5) {
      // Simple addition problems for early levels
      return _generateAdditionProblem();
    } else if (level <= 10) {
      // Addition and subtraction
      return _generateAddSubProblem();
    } else if (level <= 15) {
      // Multiplication
      return _generateMultiplicationProblem();
    } else if (level <= 19) {
      // Division problems
      return _generateDivisionProblem();
    } else if (level <= 25) {
      // Fraction problems
      return _generateFractionProblem(level);
    } else {
      // Mixed problems for advanced levels
      return _generateMixedProblem(level);
    }
  }

  // Helper methods for different problem types
  static MathProblem _generateAdditionProblem() {
    final int a = 1 + (DateTime.now().millisecondsSinceEpoch % 9);
    final int b = 1 + (DateTime.now().millisecondsSinceEpoch % 10 + 5) % 9;

    final String problem = "$a + $b";
    final String answer = "${a + b}";

    return MathProblem(problem: problem, answer: answer, level: 1);
  }

  static MathProblem _generateAddSubProblem() {
    // Similar implementation for addition/subtraction
    final bool isAddition = (DateTime.now().millisecondsSinceEpoch % 2 == 0);
    final int a = 5 + (DateTime.now().millisecondsSinceEpoch % 10);
    final int b = 1 + (DateTime.now().millisecondsSinceEpoch % 5);

    final String operation = isAddition ? "+" : "-";
    final String problem = "$a $operation $b";
    final String answer = isAddition ? "${a + b}" : "${a - b}";

    return MathProblem(problem: problem, answer: answer, level: 6);
  }

  static MathProblem _generateMultiplicationProblem() {
    final int a = 1 + (DateTime.now().millisecondsSinceEpoch % 9);
    final int b = 1 + (DateTime.now().millisecondsSinceEpoch % 9);

    final String problem = "$a × $b";
    final String answer = "${a * b}";

    return MathProblem(problem: problem, answer: answer, level: 11);
  }

  static MathProblem _generateDivisionProblem() {
    // Create division problems that have whole number answers
    final int b = 1 + (DateTime.now().millisecondsSinceEpoch % 9);
    final int answer = 1 + (DateTime.now().millisecondsSinceEpoch % 9);
    final int a = b * answer;

    final String problem = "$a ÷ $b";

    return MathProblem(problem: problem, answer: "$answer", level: 16);
  }

  static MathProblem _generateFractionProblem(int level) {
    // Generate fraction problems based on level
    if (level == 20) {
      // Simple fraction identification
      final int numerator = 1 + (DateTime.now().millisecondsSinceEpoch % 5);
      final int denominator = 2 + (DateTime.now().millisecondsSinceEpoch % 8);

      final String problem = "$numerator/$denominator";
      final String answer = "$numerator/$denominator";

      return MathProblem(problem: problem, answer: answer, level: level);
    } else {
      // Fraction addition
      final int denominator = 2 + (DateTime.now().millisecondsSinceEpoch % 8);
      final int numerator1 =
          1 + (DateTime.now().millisecondsSinceEpoch % denominator);
      final int numerator2 =
          1 + ((DateTime.now().millisecondsSinceEpoch + 5) % denominator);

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
    // Mixed operations
    final int operation = DateTime.now().millisecondsSinceEpoch % 4;

    switch (operation) {
      case 0:
        return _generateAdditionProblem();
      case 1:
        return _generateAddSubProblem();
      case 2:
        return _generateMultiplicationProblem();
      default:
        return _generateDivisionProblem();
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
}
