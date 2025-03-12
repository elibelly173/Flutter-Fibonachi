import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' show pi;
import 'dart:ui' as ui;
import 'package:flutter/services.dart' show rootBundle;

// Add at the top of the file after imports
class FiboFrame {
  final Rect textureRect;
  final bool rotated;
  final Size sourceSize;
  final Offset spriteOffset;

  FiboFrame({
    required this.textureRect,
    required this.rotated,
    required this.sourceSize,
    required this.spriteOffset,
  });
}

class AchiFrame {
  final Rect textureRect;
  final bool rotated;
  final Size sourceSize;
  final Offset spriteOffset;

  AchiFrame({
    required this.textureRect,
    required this.rotated,
    required this.sourceSize,
    required this.spriteOffset,
  });
}

class FiboSpritePainter extends CustomPainter {
  final ui.Image sprite;
  final FiboFrame frame;
  final Size spriteSheetSize;

  FiboSpritePainter({
    required this.sprite,
    required this.frame,
    required this.spriteSheetSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();

    // Draw the frame directly without scaling or offsets first
    canvas.drawImageRect(
      sprite,
      frame.textureRect,
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint(),
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(FiboSpritePainter oldDelegate) {
    if (oldDelegate.frame == frame && oldDelegate.sprite == sprite) {
      return false;
    }
    return true;
  }
}

class AchiSpritePainter extends CustomPainter {
  final ui.Image sprite;
  final AchiFrame frame;
  final Size spriteSheetSize;

  AchiSpritePainter({
    required this.sprite,
    required this.frame,
    required this.spriteSheetSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    print('Painting Achi:');
    print('- Frame rect: ${frame.textureRect}');
    print('- Frame size: ${frame.textureRect.size}');
    print('- Widget size: $size');
    print('- Rotated: ${frame.rotated}');
    print('- Source size: ${frame.sourceSize}');
    print('- Sprite offset: ${frame.spriteOffset}');

    canvas.save();

    if (frame.rotated) {
      // Move to center, rotate 90 degrees, move back
      canvas.translate(size.width / 2, size.height / 2);
      canvas.rotate(-pi / 2); // Back to original rotation
      canvas.translate(-size.height / 2, -size.width / 2);

      // Draw rotated frame with swapped dimensions
      canvas.drawImageRect(
        sprite,
        frame.textureRect,
        Rect.fromLTWH(0, 0, size.height, size.width), // Swap dimensions
        Paint(),
      );
    } else {
      // Draw normally
      canvas.drawImageRect(
        sprite,
        frame.textureRect,
        Rect.fromLTWH(0, 0, size.width, size.height),
        Paint(),
      );
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(AchiSpritePainter oldDelegate) {
    if (oldDelegate.frame == frame && oldDelegate.sprite == sprite) {
      return false;
    }
    return true;
  }
}

class GameBoard extends StatefulWidget {
  final int level;

  const GameBoard({super.key, required this.level});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> with TickerProviderStateMixin {
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

  // Add with other state variables
  late Image treeSprite;
  String currentTree = 'tree10';
  bool _isDisposed = false;

  // Update tree position variables
  double treeX = 0.72; // X position at 72%
  double treeY = 0.11; // Y position at 11%
  double treeSize = 0.28; // Size at 28%

  // Add tick tracking
  int currentTicks = 0;

  // Keep tick position variables relative to tree
  double tickOffsetX = 0.14; // Update from 0.08
  double tickOffsetY = 0.165; // Update from 0.20
  double tickScale = 0.5; // Update from 0.35

  // Update Fibo position variables
  double fiboX = 0.802; // Update X position
  double fiboY = 0.191; // Update Y position
  double fiboSize = 0.099; // Update size

  // Add state for Fibo selection
  bool _isFiboSelected = false;

  // Add near other Fibo variables
  int _currentFrame = 0; // Track which frame we're showing

  // Add animation controller
  late AnimationController _fiboController;

  // Add in the _GameBoardState class
  final Map<int, FiboFrame> fiboFrames = {
    0: FiboFrame(
      textureRect: Rect.fromLTWH(1, 1409, 192, 400),
      rotated: false,
      sourceSize: const Size(500, 770),
      spriteOffset: const Offset(-37, -185),
    ),
    1: FiboFrame(
      textureRect: Rect.fromLTWH(195, 1409, 192, 400),
      rotated: false,
      sourceSize: const Size(500, 770),
      spriteOffset: const Offset(-37, -185),
    ),
    2: FiboFrame(
      textureRect: Rect.fromLTWH(389, 1409, 192, 400),
      rotated: false,
      sourceSize: const Size(500, 770),
      spriteOffset: const Offset(-37, -185),
    ),
    3: FiboFrame(
      textureRect: Rect.fromLTWH(583, 1409, 192, 400),
      rotated: false,
      sourceSize: const Size(500, 770),
      spriteOffset: const Offset(-37, -185),
    ),
    4: FiboFrame(
      textureRect: Rect.fromLTWH(777, 1409, 192, 400),
      rotated: false,
      sourceSize: const Size(500, 770),
      spriteOffset: const Offset(-37, -185),
    ),
    5: FiboFrame(
      textureRect: Rect.fromLTWH(1, 1005, 192, 400),
      rotated: false,
      sourceSize: const Size(500, 770),
      spriteOffset: const Offset(-37, -185),
    ),
    6: FiboFrame(
      textureRect: Rect.fromLTWH(195, 1005, 192, 400),
      rotated: false,
      sourceSize: const Size(500, 770),
      spriteOffset: const Offset(-37, -185),
    ),
    7: FiboFrame(
      textureRect: Rect.fromLTWH(389, 1005, 192, 400),
      rotated: false,
      sourceSize: const Size(500, 770),
      spriteOffset: const Offset(-37, -185),
    ),
    8: FiboFrame(
      textureRect: Rect.fromLTWH(583, 1005, 192, 400),
      rotated: false,
      sourceSize: const Size(500, 770),
      spriteOffset: const Offset(-37, -185),
    ),
    9: FiboFrame(
      textureRect: Rect.fromLTWH(777, 1005, 192, 400),
      rotated: false,
      sourceSize: const Size(500, 770),
      spriteOffset: const Offset(-37, -185),
    ),
    10: FiboFrame(
      textureRect: Rect.fromLTWH(195, 487, 438, 344),
      rotated: true,
      sourceSize: const Size(500, 770),
      spriteOffset: const Offset(-16, -213),
    ),
    11: FiboFrame(
      textureRect: Rect.fromLTWH(195, 927, 438, 358),
      rotated: true,
      sourceSize: const Size(500, 770),
      spriteOffset: const Offset(5, -206),
    ),
    12: FiboFrame(
      textureRect: Rect.fromLTWH(531, 1, 436, 374),
      rotated: false,
      sourceSize: const Size(500, 770),
      spriteOffset: const Offset(32, -198),
    ),
    13: FiboFrame(
      textureRect: Rect.fromLTWH(555, 1319, 192, 400),
      rotated: true,
      sourceSize: const Size(500, 770),
      spriteOffset: const Offset(-37, -185),
    ),
  };

  // Replace individual frame loading with sprite sheet loading
  ui.Image? _fiboSprite;

  Future<void> _loadFiboSprite() async {
    if (!mounted) return;

    final data = await rootBundle.load('assets/images/fibo/fibo.png');
    final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    final frame = await codec.getNextFrame();

    if (!mounted) return;
    setState(() {
      _fiboSprite = frame.image;
    });
  }

  Future<void> _loadAchiSprite() async {
    if (!mounted) return;

    print('Loading Achi sprite...');
    try {
      final data = await rootBundle.load('assets/images/achianim/achianim.png');
      final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
      final frame = await codec.getNextFrame();

      if (!mounted) return;

      // Force a rebuild after setting sprite
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(() {
          _achiSprite = frame.image;
          print(
              'Set _achiSprite in state with size: ${frame.image.width}x${frame.image.height}');
        });
      });
    } catch (e) {
      print('Error loading Achi sprite: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    level = widget.level;
    _setTreeType();
    _loadFiboSprite();
    _loadAchiSprite();

    // Initialize tree after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _initializeTree();
    });

    // Comment out clock timer temporarily
    // _clockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
    //   if (!mounted || _isDisposed) {
    //     timer.cancel();
    //     return;
    //   }
    //   setState(() {
    //     this.timer = (this.timer + 1) % 60;
    //   });
    // });

    // Match the original timing: 14 frames * 0.05s = 0.7s total
    _fiboController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..addListener(() {
        if (!mounted) return; // Check if mounted before setState
        setState(() {
          _currentFrame = (_fiboController.value * 13).floor();
        });
      });

    // Add Achi animation controller - 80ms per frame * 10 frames = 800ms total
    _achiController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..addListener(() {
        if (!mounted) return;
        setState(() {
          _currentAchiFrame = (_achiController.value * 9).floor() + 1;
        });
      });
  }

  void _setTreeType() {
    // Base tree position stays same for all types
    treeX = 0.72;
    treeY = 0.11;
    treeSize = 0.28;

    if (level <= 14) {
      currentTree = 'tree20';
      tickOffsetX = 0.14;
      tickOffsetY = 0.159; // Update to match tree20's correct Y offset
      tickScale = 0.5;
    } else if ([15, 18, 19, 21, 22, 23, 29, 30, 31, 32].contains(level)) {
      currentTree = 'tree10';
      tickOffsetX = 0.14;
      tickOffsetY = 0.165;
      tickScale = 0.5;
    } else if ([20, 24, 25, 26, 27, 28].contains(level)) {
      currentTree = 'tree5';
      tickOffsetX = 0.14;
      tickOffsetY = 0.159;
      tickScale = 0.5;
    } else {
      currentTree = 'tree20';
      tickOffsetX = 0.14;
      tickOffsetY = 0.159; // Update default case too
      tickScale = 0.5;
    }
  }

  void _initializeTree() {
    setState(() {
      treeSprite = Image.asset(
        'assets/images/$currentTree/tree.png',
        width: MediaQuery.of(context).size.width * treeSize,
        fit: BoxFit.contain,
      );
    });
  }

  @override
  void dispose() {
    _fiboController.dispose();
    _achiController.dispose();
    _isDisposed = true;
    _clockTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Generate tick overlays in build method
    final List<Widget> currentTickOverlays = [];
    for (int i = 1; i <= currentTicks; i++) {
      currentTickOverlays.add(
        Positioned(
          left: screenWidth * (treeX + tickOffsetX),
          bottom: screenHeight * (treeY + tickOffsetY),
          child: Image.asset(
            'assets/images/$currentTree/tick$i.png',
            width: screenWidth * (treeSize * tickScale),
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              print('Error loading tick$i.png: $error');
              return Container();
            },
          ),
        ),
      );
    }

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

          // Add tree sprite
          Positioned(
            left: MediaQuery.of(context).size.width * treeX,
            bottom: MediaQuery.of(context).size.height * treeY,
            child: Image.asset(
              'assets/images/$currentTree/tree.png',
              width: MediaQuery.of(context).size.width * treeSize,
              fit: BoxFit.contain,
            ),
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

          // Keep tick overlays
          ...currentTickOverlays,

          // Simple Fibo implementation
          if (_fiboSprite != null)
            Positioned(
              left: MediaQuery.of(context).size.width * fiboX,
              bottom: MediaQuery.of(context).size.height * fiboY,
              child: ClipRect(
                child: CustomPaint(
                  size: Size(
                    MediaQuery.of(context).size.width * fiboSize,
                    MediaQuery.of(context).size.width *
                        fiboSize *
                        2, // Try doubling height
                  ),
                  painter: FiboSpritePainter(
                    sprite: _fiboSprite!,
                    frame: fiboFrames[_currentFrame]!,
                    spriteSheetSize: const Size(1008, 1812),
                  ),
                ),
              ),
            ),

          // Updated Achi display
          if (_achiSprite != null)
            Positioned(
              left: MediaQuery.of(context).size.width * achiX,
              bottom: MediaQuery.of(context).size.height * achiY +
                  achiFrames[_currentAchiFrame]!.spriteOffset.dy,
              child: ClipRect(
                child: CustomPaint(
                  size: Size(
                    MediaQuery.of(context).size.width * achiSize,
                    MediaQuery.of(context).size.width * achiSize,
                  ),
                  painter: AchiSpritePainter(
                    sprite: _achiSprite!,
                    frame: achiFrames[_currentAchiFrame]!,
                    spriteSheetSize: const Size(502, 428),
                  ),
                ),
              ),
            ),

          _buildAchiControls(),
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
          // Color rings (second layer)
          Opacity(
            opacity: _getRingOpacity('Blue'),
            child: Image.asset(
              'assets/images/GameBoard/Clock/v3/Clock/Blue.png',
              width: screenWidth * clockSize,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                print('Error loading Blue.png: $error');
                return Container();
              },
            ),
          ),
          Opacity(
            opacity: _getRingOpacity('Green'),
            child: Image.asset(
              'assets/images/GameBoard/Clock/v3/Clock/Green.png',
              width: screenWidth * clockSize,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                print('Error loading Green.png: $error');
                return Container();
              },
            ),
          ),
          Opacity(
            opacity: _getRingOpacity('Red'),
            child: Image.asset(
              'assets/images/GameBoard/Clock/v3/Clock/Red.png',
              width: screenWidth * clockSize,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                print('Error loading Red.png: $error');
                return Container();
              },
            ),
          ),
          Opacity(
            opacity: _getRingOpacity('Yellow'),
            child: Image.asset(
              'assets/images/GameBoard/Clock/v3/Clock/Yellow.png',
              width: screenWidth * clockSize,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                print('Error loading Yellow.png: $error');
                return Container();
              },
            ),
          ),
          // Dial lines (third layer)
          Image.asset(
            'assets/images/GameBoard/Clock/v3/Clock/Dial Lines.png',
            width: screenWidth * clockSize,
            fit: BoxFit.contain,
          ),
          // Clock hand (top layer)
          Positioned(
            left: (screenWidth * clockSize * 0.5) -
                (screenWidth * clockSize * 0.055 * 0.5),
            top: 0,
            child: Transform.rotate(
              angle: timer * 2 * 3.14159 / 60,
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                'assets/images/GameBoard/Clock/v3/Clock/Dial.png',
                width: screenWidth * clockSize * 0.055,
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

  double _getRingOpacity(String color) {
    // Implement the logic to determine the opacity based on the color
    // This is a placeholder and should be replaced with the actual logic
    return 1.0; // Placeholder return, actual implementation needed
  }

  // Add near other state variables
  double achiX = 0.155; // Initial X position
  double achiY = 0.22; // Initial Y position
  double achiSize = 0.11; // Keep current size
  ui.Image? _achiSprite; // For sprite sheet

  // Add with other frame data
  final Map<int, AchiFrame> achiFrames = {
    1: AchiFrame(
      textureRect: Rect.fromLTWH(353, 1, 137, 126),
      rotated: true,
      sourceSize: const Size(200, 161),
      spriteOffset: const Offset(9, -12),
    ),
    2: AchiFrame(
      textureRect: Rect.fromLTWH(193, 1, 158, 121),
      rotated: false,
      sourceSize: const Size(200, 161),
      spriteOffset: const Offset(21, -19),
    ),
    3: AchiFrame(
      textureRect: Rect.fromLTWH(1, 122, 158, 129),
      rotated: false,
      sourceSize: const Size(200, 161),
      spriteOffset: const Offset(15, -13),
    ),
    4: AchiFrame(
      textureRect: Rect.fromLTWH(160, 258, 158, 143),
      rotated: false,
      sourceSize: const Size(200, 161),
      spriteOffset: const Offset(2, -4),
    ),
    5: AchiFrame(
      textureRect: Rect.fromLTWH(320, 274, 156, 153),
      rotated: false,
      sourceSize: const Size(200, 161),
      spriteOffset: const Offset(-4, 1),
    ),
    6: AchiFrame(
      textureRect: Rect.fromLTWH(1, 253, 160, 157),
      rotated: true,
      sourceSize: const Size(200, 161),
      spriteOffset: const Offset(5, 2),
    ),
    7: AchiFrame(
      textureRect: Rect.fromLTWH(357, 129, 144, 143),
      rotated: false,
      sourceSize: const Size(200, 161),
      spriteOffset: const Offset(8, -4),
    ),
    8: AchiFrame(
      textureRect: Rect.fromLTWH(161, 129, 194, 127),
      rotated: false,
      sourceSize: const Size(200, 161),
      spriteOffset: const Offset(-3, -12),
    ),
    9: AchiFrame(
      textureRect: Rect.fromLTWH(1, 1, 190, 119),
      rotated: false,
      sourceSize: const Size(200, 161),
      spriteOffset: const Offset(5, -18),
    ),
    10: AchiFrame(
      textureRect: Rect.fromLTWH(353, 1, 137, 126),
      rotated: true,
      sourceSize: const Size(200, 161),
      spriteOffset: const Offset(9, -12),
    ),
  };

  // Update sprite sheet size constant
  final Size achiSpriteSheetSize = const Size(502, 428);

  // Add in _GameBoardState class
  late AnimationController _achiController;
  int _currentAchiFrame = 1;

  // Add method to start animation
  void _startAchiAnimation() {
    if (!mounted) return;
    _achiController.forward(from: 0);
  }

  // Add method to set specific frame
  void _setAchiFrame(int frame) {
    if (!mounted) return;
    setState(() {
      _currentAchiFrame = frame.clamp(1, 10); // Keep between 1-10
    });
  }

  // Update _buildAchiControls to add frame controls
  Widget _buildAchiControls() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Position controls
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Achi X: ${achiX.toStringAsFixed(3)}'),
                    Row(
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints.tight(Size(24, 24)),
                          icon: const Icon(Icons.remove, size: 18),
                          onPressed: () => setState(() => achiX -= 0.01),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints.tight(Size(24, 24)),
                          icon: const Icon(Icons.add, size: 18),
                          onPressed: () => setState(() => achiX += 0.01),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Achi Y: ${achiY.toStringAsFixed(3)}'),
                    Row(
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints.tight(Size(24, 24)),
                          icon: const Icon(Icons.remove, size: 18),
                          onPressed: () => setState(() => achiY -= 0.01),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints.tight(Size(24, 24)),
                          icon: const Icon(Icons.add, size: 18),
                          onPressed: () => setState(() => achiY += 0.01),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Achi Size: ${achiSize.toStringAsFixed(3)}'),
                    Row(
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints.tight(Size(24, 24)),
                          icon: const Icon(Icons.remove, size: 18),
                          onPressed: () => setState(() => achiSize -= 0.01),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints.tight(Size(24, 24)),
                          icon: const Icon(Icons.add, size: 18),
                          onPressed: () => setState(() => achiSize += 0.01),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Frame controls
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Frame: $_currentAchiFrame'),
                const SizedBox(width: 8),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints.tight(Size(24, 24)),
                  icon: const Icon(Icons.chevron_left, size: 18),
                  onPressed: () => _setAchiFrame(_currentAchiFrame - 1),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints.tight(Size(24, 24)),
                  icon: const Icon(Icons.chevron_right, size: 18),
                  onPressed: () => _setAchiFrame(_currentAchiFrame + 1),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _startAchiAnimation,
              child: const Text('Test Animation'),
            ),
          ],
        ),
      ),
    );
  }
}
