import 'package:flutter/material.dart';
import 'dart:async';

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
  int targetTime = 0; // 3 stars time
  int targetTime1 = 0; // 4 stars time
  int targetTime2 = 0; // 1 star time
  int levelTime = 0; // 2 stars time
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
  double _homeButtonX = 0.08; // 8% from left
  double _homeButtonY = 0.97; // 97% up from bottom
  double _homeButtonSize = 0.08; // 8% of screen width

  // Grid layout constants
  final double _gridWidth = 0.8; // 80% of screen width
  final double _gridHeight = 0.6; // 60% of screen height
  final double _gridY = 0.3; // 30% from top

  // Coconut constants
  double _coconutRowHeight = 0.08; // 8% of screen height
  double _coconutRowBottom = 0.03; // 3% from bottom
  double _coconutSize = 0.065; // 6.5% of screen width
  final double _coconutRowWidth = 0.95; // 95% of screen width

  // Home button state
  bool _isHomePressed = false;

  // Add to state variables
  List<Widget> problemWidgets = [];

  // Keep these
  late Image achiSprite;
  late Image fiboSprite;

  // Add adjustment variables
  double clockX = 0.15; // 15% from left
  double clockY = 0.86; // 86% up from bottom
  double clockSize = 0.05; // 5% of screen width

  // Update initial score board values
  double scoreX = 0.41; // 41% from left
  double scoreY = 0.85; // 85% from bottom
  double scoreSize = 0.2; // 20% of screen width

  // Add at the top with other variables
  Timer? _clockTimer;

  @override
  void initState() {
    super.initState();
    level = widget.level;

    // Start the clock timer
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        this.timer = (this.timer + 1) % 60; // Increment timer and wrap at 60
      });
    });
  }

  // Add dispose method to clean up the timer
  @override
  void dispose() {
    _clockTimer?.cancel(); // Cancel timer first
    super.dispose(); // Then call super.dispose()
  }

  // Update adjustment buttons to rebuild timer
  Widget _buildAdjustmentButtons() {
    return Positioned(
      left: 20,
      bottom: MediaQuery.of(context).size.height * 0.25,
      child: Column(
        children: [
          Text('Clock:', style: TextStyle(fontWeight: FontWeight.bold)),
          Row(
            children: [
              Text('X: ${clockX.toStringAsFixed(3)}'),
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () => setState(() => clockX -= 0.01),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => setState(() => clockX += 0.01),
              ),
            ],
          ),
          Row(
            children: [
              Text('Y: ${clockY.toStringAsFixed(3)}'),
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () => setState(() => clockY -= 0.01),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => setState(() => clockY += 0.01),
              ),
            ],
          ),
          Row(
            children: [
              Text('Size: ${clockSize.toStringAsFixed(3)}'),
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () => setState(() => clockSize -= 0.01),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => setState(() => clockSize += 0.01),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Background - full screen
          Image.asset(
            'assets/images/gameboard.png',
            width: screenWidth,
            height: screenHeight,
            fit: BoxFit.fill, // Stretch to fill screen
          ),

          _buildTimerScore(),
          _buildAnswerLayer(),
          _buildScoreBoard(), // Move after other layers

          // Home Button
          Positioned(
            left: screenWidth * _homeButtonX -
                (screenWidth * _homeButtonSize / 2),
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

          // Add adjustment buttons
          _buildAdjustmentButtons(),
        ],
      ),
    );
  }

  // Add this method to build the number row
  Widget _buildCoconutNumberRow() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final rowWidth = screenWidth * _coconutRowWidth;

    final totalCoconutWidth = 10 * screenWidth * _coconutSize;
    final spacing = (rowWidth - totalCoconutWidth) / 9;

    return Positioned(
      bottom: screenHeight * _coconutRowBottom,
      left: screenWidth * ((1 - _coconutRowWidth) / 2),
      width: rowWidth,
      height:
          screenHeight * _coconutRowHeight * 2, // Double the container height
      child: Stack(
        children: [
          for (int i = 1; i <= 9; i++)
            Positioned(
              left: (i - 1) * (screenWidth * _coconutSize + spacing),
              child: GestureDetector(
                onTap: () {
                  print('Coconut number $i tapped');
                },
                child: Image.asset(
                  'assets/images/key/key$i.png',
                  width: screenWidth * _coconutSize,
                  height: screenWidth *
                      _coconutSize, // Make height match width for square aspect ratio
                  fit: BoxFit.contain,
                ),
              ),
            ),
          // Add 0 at the end
          Positioned(
            left: 9 * (screenWidth * _coconutSize + spacing),
            child: GestureDetector(
              onTap: () {
                print('Coconut number 0 tapped');
              },
              child: Image.asset(
                'assets/images/key/key10.png',
                width: screenWidth * _coconutSize,
                height: screenWidth *
                    _coconutSize, // Make height match width for square aspect ratio
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Replace _buildTimerScore with this simpler version
  Widget _buildTimerScore() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Positioned(
      left: screenWidth * clockX,
      bottom: screenHeight * clockY,
      child: Stack(
        children: [
          // Base circle (bottom layer)
          Image.asset(
            'assets/images/GameBoard/Clock/v3/Clock/Dial Circle.png',
            width: screenWidth * clockSize,
            fit: BoxFit.contain,
          ),
          // Dial lines (middle layer)
          Image.asset(
            'assets/images/GameBoard/Clock/v3/Clock/Dial Lines.png',
            width: screenWidth * clockSize,
            fit: BoxFit.contain,
          ),
          // Clock hand (top layer)
          Positioned(
            left: screenWidth * clockSize * 0.5,    // Center of clock horizontally
            top: 0,                                 // Position so bottom is at center
            child: Transform.rotate(
              angle: timer * 2 * 3.14159 / 60,     // Restore animation
              alignment: Alignment.bottomCenter,     // Keep pivoting around bottom of dial
              child: Image.asset(
                'assets/images/GameBoard/Clock/v3/Clock/Dial.png',
                width: screenWidth * clockSize * 0.055,  // 5.5% of clock size
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Convert initAnswerLayer to a widget builder
  Widget _buildAnswerLayer() {
    if (fractionMode && !decimalMode) {
      return Positioned(
        left: MediaQuery.of(context).size.width * 0.75,
        top: MediaQuery.of(context).size.height * 0.2 +
            MediaQuery.of(context).size.width * 0.08,
        child: Opacity(
          opacity: 0,
          child: Container(), // Temporary placeholder
        ),
      );
    } else if (decimalMode) {
      // Decimal answer layer
      return Positioned(
        left: MediaQuery.of(context).size.width * 0.66,
        top: MediaQuery.of(context).size.height * 0.2 +
            MediaQuery.of(context).size.width * 0.17,
        child: Container(
          // Add Container with fixed size
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
        top: MediaQuery.of(context).size.height * 0.3 +
            MediaQuery.of(context).size.width * 0.13,
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
        top: MediaQuery.of(context).size.height * 0.74 -
            MediaQuery.of(context).size.width * 0.085,
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
              ? MediaQuery.of(context).size.height * 0.2 +
                  MediaQuery.of(context).size.width * 0.08
              : MediaQuery.of(context).size.height * 0.2 +
                  MediaQuery.of(context).size.width * 0.04,
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

  // Update score board display method
  Widget _buildScoreBoard() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Positioned(
      left: screenWidth * scoreX,
      bottom: screenHeight * scoreY,
      child: Image.asset(
        'assets/images/game/Score.png',
        width: screenWidth * scoreSize,
        fit: BoxFit.contain,
      ),
    );
  }
}
