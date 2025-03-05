import 'package:flutter/material.dart';

class GameBoard extends StatefulWidget {
  final int level;

  const GameBoard({super.key, required this.level});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  // Game state
  late int level;
  int timer = 0;
  int score = 0;
  int rightCount = 0;
  int problemCount = 0;
  int wrongCount = 0;
  
  // Time thresholds
  int targetTime = 0;  // 3 stars time
  int targetTime1 = 0; // 4 stars time 
  int targetTime2 = 0; // 1 star time
  int levelTime = 0;   // 2 stars time
  int prevTime = 0;
  double blueNumber = 0;
  List<String> problemAnswers = [];

  // Answer handling
  String answerString = "";
  int answer = 0;
  bool isNegative = false;
  
  // Animation flags
  bool showingAnswer = false;
  bool dimFlag = false;
  bool firstEnterFlag = false;
  
  // Game mode flags  
  bool fractionMode = false;
  bool decimalMode = false;
  int axisMode = 0;

  // Game state variables
  List<int> selectedNumbers = [];

  // UI positioning constants
  final double _homeButtonX = 0.1;  // Left side
  final double _homeButtonY = 0.9;  // Near top
  final double _homeButtonSize = 0.1;

  // Grid layout constants
  final double _gridWidth = 0.8;  // 80% of screen width
  final double _gridHeight = 0.6;  // 60% of screen height
  final double _gridY = 0.3;  // 30% from top

  // Coconut constants
  final double _coconutRowHeight = 0.12;    // 12% of screen height
  final double _coconutRowBottom = 0.07;    // Changed from 0.02 to 0.07 (7% from bottom)
  final double _coconutSize = 0.085;        // 8.5% of screen width
  final double _coconutRowWidth = 0.85;     // 85% of screen width

  // Home button state
  bool _isHomePressed = false;

  // Add to state variables
  List<Widget> problemWidgets = [];

  // Keep these
  late Image achiSprite;
  late Image fiboSprite;

  @override
  void initState() {
    super.initState();
    level = widget.level;
    // Just initialize game state here, no widget building
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Background
          Image.asset(
            'assets/images/gameboard.png',
            width: screenWidth,
            height: screenHeight,
            fit: BoxFit.cover,
          ),

          // Timer and Score
          _buildTimerScore(),

          // Answer Layer
          _buildAnswerLayer(),

          // Home Button
          Positioned(
            left: screenWidth * _homeButtonX - (screenWidth * _homeButtonSize / 2),
            top: screenHeight * (1 - _homeButtonY),
            child: GestureDetector(
              onTapDown: (_) => setState(() => _isHomePressed = true),
              onTapUp: (_) {
                setState(() => _isHomePressed = false);
                Navigator.of(context).pop();
              },
              onTapCancel: () => setState(() => _isHomePressed = false),
              child: Image.asset(
                _isHomePressed 
                    ? 'assets/images/game/home_selected.png'
                    : 'assets/images/game/home.png',
                width: screenWidth * _homeButtonSize,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // Coconut number row
          _buildCoconutNumberRow(),

          // Problem widgets
          ...problemWidgets,
        ],
      ),
    );
  }

  // Add this method to build the number row
  Widget _buildCoconutNumberRow() {
    return Positioned(
      bottom: MediaQuery.of(context).size.height * _coconutRowBottom,
      left: MediaQuery.of(context).size.width * ((1 - _coconutRowWidth) / 2),
      width: MediaQuery.of(context).size.width * _coconutRowWidth,
      height: MediaQuery.of(context).size.height * _coconutRowHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (int i = 1; i <= 9; i++)
            GestureDetector(
              onTap: () {
                print('Coconut number $i tapped');
              },
              child: Image.asset(
                'assets/images/key/key$i.png',
                width: MediaQuery.of(context).size.width * _coconutSize,
                height: MediaQuery.of(context).size.width * _coconutSize,
                fit: BoxFit.contain,
              ),
            ),
          // Add 0 at the end
          GestureDetector(
            onTap: () {
              print('Coconut number 0 tapped');
            },
            child: Image.asset(
              'assets/images/key/key10.png',
              width: MediaQuery.of(context).size.width * _coconutSize,
              height: MediaQuery.of(context).size.width * _coconutSize,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  // Convert initTimerScore to a widget builder
  Widget _buildTimerScore() {
    return Stack(
      children: [
        // Base dial
        Positioned(
          left: MediaQuery.of(context).size.width * 0.2,
          top: MediaQuery.of(context).size.height - MediaQuery.of(context).size.width * 0.038,
          child: Image.asset(
            'assets/images/GameBoard/Clock/v3/Clock/dial.png',
            scale: MediaQuery.of(context).size.width * 0.00035,
          ),
        ),
        // Dial lines (tick marks)
        Positioned(
          left: MediaQuery.of(context).size.width * 0.2,
          top: MediaQuery.of(context).size.height - MediaQuery.of(context).size.width * 0.038,
          child: Image.asset(
            'assets/images/GameBoard/Clock/v3/Clock/dial lines.png',
            scale: MediaQuery.of(context).size.width * 0.00035,
          ),
        ),
        // Outer circle
        Positioned(
          left: MediaQuery.of(context).size.width * 0.2,
          top: MediaQuery.of(context).size.height - MediaQuery.of(context).size.width * 0.038,
          child: Image.asset(
            'assets/images/GameBoard/Clock/v3/Clock/Dial Circle.png',
            scale: MediaQuery.of(context).size.width * 0.00035,
          ),
        ),
        // Color overlay (changes based on time)
        Positioned(
          left: MediaQuery.of(context).size.width * 0.2,
          top: MediaQuery.of(context).size.height - MediaQuery.of(context).size.width * 0.038,
          child: Image.asset(
            'assets/images/GameBoard/Clock/v3/Clock/Blue.png', // Will change based on time
            scale: MediaQuery.of(context).size.width * 0.00035,
          ),
        ),
        // Timer needle
        Positioned(
          left: MediaQuery.of(context).size.width * 0.2,
          top: MediaQuery.of(context).size.height - MediaQuery.of(context).size.width * 0.038,
          child: Transform.rotate(
            angle: targetTime > 0 ? (timer / targetTime) * 2 * 3.14159 : 0, // Add safety check
            child: Image.asset(
              'assets/images/GameBoard/Clock/v3/Clock/timer_needle.png',
              scale: MediaQuery.of(context).size.width * 0.00035,
            ),
          ),
        ),
        // Score display
        Positioned(
          left: MediaQuery.of(context).size.width * 0.5,
          top: MediaQuery.of(context).size.height - MediaQuery.of(context).size.width * 0.06,
          child: Text(
            score.toString(),
            style: TextStyle(
              color: Colors.black,
              fontSize: MediaQuery.of(context).size.width * 0.035,
              fontFamily: 'Yesterday Dream',
            ),
          ),
        ),
      ],
    );
  }

  // Convert initAnswerLayer to a widget builder
  Widget _buildAnswerLayer() {
    if (fractionMode && !decimalMode) {
      return Positioned(
        left: MediaQuery.of(context).size.width * 0.75,
        top: MediaQuery.of(context).size.height * 0.2 + MediaQuery.of(context).size.width * 0.08,
        child: Opacity(
          opacity: 0,
          child: Container(), // Temporary placeholder
        ),
      );
    } else if (decimalMode) {
      // Decimal answer layer
      return Positioned(
        left: MediaQuery.of(context).size.width * 0.66,
        top: MediaQuery.of(context).size.height * 0.2 + MediaQuery.of(context).size.width * 0.17,
        child: Container( // Add Container with fixed size
          width: MediaQuery.of(context).size.width * 0.2,
          height: MediaQuery.of(context).size.height * 0.1,
          child: Column(
            mainAxisSize: MainAxisSize.min, // Add this
            children: [
              Text(
                '',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: MediaQuery.of(context).size.width * 0.04,
                ),
              ),
              Text(
                '_',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: MediaQuery.of(context).size.width * 0.05,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      // Regular number answer layer
      return Positioned(
        left: MediaQuery.of(context).size.width * 0.66,
        top: MediaQuery.of(context).size.height * 0.3 + MediaQuery.of(context).size.width * 0.13,
        child: Text(
          '',
          style: TextStyle(
            color: Colors.black,
            fontSize: MediaQuery.of(context).size.width * 0.04,
          ),
        ),
      );
    }
  }

  // These methods are called in handleAnswer() but not implemented
  bool isCorrectAnswer() {
    if (fractionMode || decimalMode) {
      return answerString == problemAnswers[rightCount];
    } else {
      return answer == int.parse(problemAnswers[rightCount]);
    }
  }

  double calculateScore() {
    double subtract = (timer - prevTime) / 10.0;
    
    if (subtract <= blueNumber / 3.0) {
      return 500;
    } else if (subtract > blueNumber / 3.0 && subtract < 3.536 * blueNumber) {
      return 542 - (125 * subtract) / blueNumber;
    } else {
      return 100;
    }
  }

  void animateSuccess() {
    setState(() {
      // Show Achi animation
      achiSprite = Image.asset(
        'assets/images/achianim/achiAnim1.png',
        width: MediaQuery.of(context).size.width * 0.22,
      );
    });
    
    // Animate through frames
    for (int i = 1; i <= 10; i++) {
      Future.delayed(Duration(milliseconds: 80 * i), () {
        setState(() {
          achiSprite = Image.asset(
            'assets/images/achianim/achiAnim$i.png',
            width: MediaQuery.of(context).size.width * 0.22,
          );
        });
      });
    }
  }

  void animateFailure() {
    setState(() {
      // Show Fibo animation
      fiboSprite = Image.asset(
        'assets/images/fibo/fibo0.png',
        width: MediaQuery.of(context).size.width * 0.15,
      );
    });
    
    // Animate through frames
    for (int i = 0; i < 14; i++) {
      Future.delayed(Duration(milliseconds: 50 * i), () {
        setState(() {
          fiboSprite = Image.asset(
            'assets/images/fibo/fibo$i.png',
            width: MediaQuery.of(context).size.width * 0.15,
          );
        });
      });
    }
  }

  void nextProblem() {
    problemCount++;
    // Generate new problem based on level and mode
    if (problemCount > 0) {
      // Schedule the animation for after the build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        animateProblemTransition();
      });
    }
    // Add new problem
    generateProblem();
  }

  void animateProblemTransition() {
    if (rightCount >= problemWidgets.length) return;
    
    final currentProblem = problemWidgets[rightCount];
    final problemWithBubble = Stack(
      children: [
        // Thought bubble
        Positioned(
          left: MediaQuery.of(context).size.width * 0.25,
          top: MediaQuery.of(context).size.height * 0.71,
          child: Opacity(
            opacity: 0.1,
            child: Image.asset(
              'assets/images/game/cloud.png',
              width: MediaQuery.of(context).size.width * 0.33,
              height: MediaQuery.of(context).size.height * 0.35,
              fit: BoxFit.fill,
            ),
          ),
        ),
        currentProblem,
      ],
    );

    // First animation
    setState(() {
      problemWidgets[rightCount] = AnimatedPositioned(
        duration: const Duration(milliseconds: 50),
        curve: Curves.easeOut,
        left: MediaQuery.of(context).size.width * 0.34,
        top: MediaQuery.of(context).size.height * 0.74 - MediaQuery.of(context).size.width * 0.085,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeIn,
          opacity: 1.0,
          child: problemWithBubble,
        ),
      );
    });

    // Schedule later animations
    Future.delayed(const Duration(milliseconds: 200), () {
      if (!mounted) return;
      setState(() {
        problemWidgets[rightCount] = AnimatedOpacity(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
          opacity: 0,
          child: problemWithBubble,
        );
      });
    });

    Future.delayed(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      setState(() {
        problemWidgets.removeAt(rightCount);
      });
    });
  }

  // Helper method to add new problem widget
  void addProblemWidget(Widget problemWidget) {
    setState(() {
      problemWidgets.add(
        AnimatedPositioned(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          left: MediaQuery.of(context).size.width * 0.52,
          top: fractionMode 
              ? MediaQuery.of(context).size.height * 0.2 + MediaQuery.of(context).size.width * 0.08
              : MediaQuery.of(context).size.height * 0.2 + MediaQuery.of(context).size.width * 0.04,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 400),
            opacity: 1.0,
            child: problemWidget,
          ),
        ),
      );
    });
  }

  void generateProblem() {
    // Placeholder implementation
    setState(() {
      // Will implement actual problem generation later
    });
  }
} 