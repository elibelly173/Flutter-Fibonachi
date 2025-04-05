import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' show pi, min;
import 'dart:ui' as ui;
import 'package:flutter/services.dart' show rootBundle;
import 'achi_sprite.dart';
import 'dart:io';
import 'utils/safe_state.dart';
import 'models/problem_generator.dart';
import 'dart:math' as math;
// import 'models/answer_checker.dart';

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
  final bool preserveAspectRatio;

  FiboSpritePainter({
    required this.sprite,
    required this.frame,
    required this.spriteSheetSize,
    this.preserveAspectRatio = true, // Default to preserving aspect ratio
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();

    if (frame.rotated) {
      // Get frame dimensions
      final frameWidth = frame.textureRect.height;
      final frameHeight = frame.textureRect.width;

      if (preserveAspectRatio) {
        // Calculate aspect ratio
        final aspectRatio = frameWidth / frameHeight;

        // Determine which dimension to fit to
        final fitToHeight = aspectRatio > 1.0;

        final targetWidth =
            fitToHeight ? size.height * aspectRatio : size.width;
        final targetHeight =
            fitToHeight ? size.height : size.width / aspectRatio;

        // Calculate offsets to center
        final xOffset = (size.width - targetWidth) / 2;
        final yOffset = (size.height - targetHeight) / 2;

        // Move to center, rotate, and position
        canvas.translate(size.width / 2, size.height / 2);
        canvas.rotate(-pi / 2);
        canvas.translate(-size.height / 2, -size.width / 2);

        // Draw with preserved aspect ratio
        canvas.drawImageRect(
          sprite,
          frame.textureRect,
          Rect.fromLTWH(0, 0, targetHeight, targetWidth),
          Paint(),
        );
      } else {
        // Original rotation code
        canvas.translate(size.width / 2, size.height / 2);
        canvas.rotate(-pi / 2);
        canvas.translate(-size.height / 2, -size.width / 2);
        canvas.drawImageRect(
          sprite,
          frame.textureRect,
          Rect.fromLTWH(0, 0, size.height, size.width),
          Paint(),
        );
      }
    } else {
      // Handle non-rotated frames
      if (preserveAspectRatio) {
        // Get frame dimensions
        final frameWidth = frame.textureRect.width;
        final frameHeight = frame.textureRect.height;

        // Calculate aspect ratio
        final aspectRatio = frameWidth / frameHeight;

        // Determine which dimension to fit to
        final fitToHeight = aspectRatio > 1.0;

        final targetWidth =
            fitToHeight ? size.height * aspectRatio : size.width;
        final targetHeight =
            fitToHeight ? size.height : size.width / aspectRatio;

        // Calculate offsets to center
        final xOffset = (size.width - targetWidth) / 2;
        final yOffset = (size.height - targetHeight) / 2;

        // Draw with preserved aspect ratio
        canvas.drawImageRect(
          sprite,
          frame.textureRect,
          Rect.fromLTWH(xOffset, yOffset, targetWidth, targetHeight),
          Paint(),
        );
      } else {
        // Original drawing code
        canvas.drawImageRect(
          sprite,
          frame.textureRect,
          Rect.fromLTWH(0, 0, size.width, size.height),
          Paint(),
        );
      }
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(FiboSpritePainter oldDelegate) {
    return oldDelegate.frame != frame ||
        oldDelegate.sprite != sprite ||
        oldDelegate.preserveAspectRatio != preserveAspectRatio;
  }
}

class AchiSpritePainter extends CustomPainter {
  final ui.Image sprite;
  final AchiFrame frame;
  final Size spriteSheetSize;
  final bool preserveAspectRatio;

  AchiSpritePainter({
    required this.sprite,
    required this.frame,
    required this.spriteSheetSize,
    this.preserveAspectRatio = true, // Default to preserving aspect ratio
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();

    if (frame.rotated) {
      // For rotated frames, we need a different approach
      // First get the dimensions of the frame
      final frameWidth = frame.textureRect.height;
      final frameHeight = frame.textureRect.width;

      // Calculate the scale to fit the frame in the container
      // while preserving aspect ratio
      final scaleWidth = size.width / frameHeight;
      final scaleHeight = size.height / frameWidth;
      final scale = min(scaleWidth, scaleHeight);

      // Calculate the dimensions of the scaled frame
      final scaledWidth = frameHeight * scale;
      final scaledHeight = frameWidth * scale;

      // Calculate the position to center the frame
      final left = (size.width - scaledWidth) / 2;
      final top = (size.height - scaledHeight) / 2;

      // Translate to the center of the container
      canvas.translate(size.width / 2, size.height / 2);
      // Rotate
      canvas.rotate(-pi / 2);
      // Translate back, but with dimensions swapped due to rotation
      canvas.translate(-size.height / 2, -size.width / 2);

      // Draw the rotated frame
      canvas.drawImageRect(
        sprite,
        frame.textureRect,
        Rect.fromLTWH(0, 0, scaledHeight, scaledWidth),
        Paint(),
      );
    } else {
      // For non-rotated frames
      // Get the dimensions of the frame
      final frameWidth = frame.textureRect.width;
      final frameHeight = frame.textureRect.height;

      // Calculate the scale to fit the frame in the container
      // while preserving aspect ratio
      final scaleWidth = size.width / frameWidth;
      final scaleHeight = size.height / frameHeight;
      final scale = min(scaleWidth, scaleHeight);

      // Calculate the dimensions of the scaled frame
      final scaledWidth = frameWidth * scale;
      final scaledHeight = frameHeight * scale;

      // Calculate the position to center the frame
      final left = (size.width - scaledWidth) / 2;
      final top = (size.height - scaledHeight) / 2;

      // Draw the frame
      canvas.drawImageRect(
        sprite,
        frame.textureRect,
        Rect.fromLTWH(left, top, scaledWidth, scaledHeight),
        Paint(),
      );
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(AchiSpritePainter oldDelegate) {
    return oldDelegate.frame != frame ||
        oldDelegate.sprite != sprite ||
        oldDelegate.preserveAspectRatio != preserveAspectRatio;
  }
}

class GameBoard extends StatefulWidget {
  final int level;

  const GameBoard({super.key, required this.level});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard>
    with TickerProviderStateMixin, SafeState {
  // Game state
  late int level;
  late int timer = 0;
  late int score = 0;
  late int rightCount = 0;
  late int problemCount = 0;
  late int wrongCount = 0;

  // Time thresholds
  late int targetTime; // 3 stars time
  late int targetTime1; // 4 stars time
  late int targetTime2 = 0; // 1 star time
  late int levelTime; // 2 stars time
  late int prevTime = 0;
  late double blueNumber = 0;
  late List<String> problemAnswers = [];

  // Answer handling
  late String answerString = "";
  late int answer = 0;
  late bool isNegative = false;

  // Animation flags
  late bool showingAnswer = false;
  late bool dimFlag = false;
  late bool firstEnterFlag = false;

  // Game mode flags
  late bool fractionMode = false;
  late bool decimalMode = false;
  late int axisMode = 0;

  // Game state variables
  late List<int> selectedNumbers = [];

  // UI positioning constants
  late double _homeButtonX = 0.025; // X position at 2.5% from left
  late double _homeButtonY = 0.03; // Y position at 3% from top
  late double _homeButtonSize = 0.07; // Size at 7% of screen width

  // Add these three variables here:
  late double leftArrowX = 0.40 - 0.02; // X position at 38% from left
  late double leftArrowY = 0.57; // Y position at 57% from top
  late double leftArrowSize = 0.17; // Size at 17% of screen width

  // Grid layout constants
  final double _gridWidth = 0.8; // 80% of screen width
  final double _gridHeight = 0.6; // 60% of screen height
  final double _gridY = 0.3; // 30% from top

  // Coconut constants
  late double _coconutRowHeight = 0.05; // Reduced from 0.08
  late double _coconutRowBottom = 0.03; // Keep at 3% from bottom
  late double _coconutSize = 0.045; // Reduced from 0.065
  late double _coconutRowWidth = 0.85; // Removed 'final' keyword

  // Home button state
  late bool _isHomePressed = false;

  // Add to state variables
  late List<Widget> problemWidgets = [];

  // Keep these
  late Image achiSprite;
  late Image fiboSprite;

  // Add adjustment variables
  late double clockX = 0.635; // X position at 63.5% from left
  late double clockY = 0.82; // Y position at 82% from bottom
  late double clockSize = 0.07; // Size at 7% of screen width

  // Update initial score board values
  late double scoreX = 0.41; // 41% from left
  late double scoreY = 0.85; // 85% from bottom
  late double scoreSize = 0.2; // 20% of screen width

  // Add at the top with other variables
  late Timer? _clockTimer;

  // Add with other state variables
  late Image treeSprite;
  late String currentTree = 'tree10';
  late bool _isDisposed = false;

  // Update tree position variables
  late double treeX = 0.72; // X position at 72%
  late double treeY = 0.11; // Y position at 11%
  late double treeSize = 0.28; // Size at 28%

  // Add tick tracking
  late int currentTicks = 0;

  // Keep tick position variables relative to tree
  late double tickOffsetX = 0.14; // Update from 0.08
  late double tickOffsetY = 0.165; // Update from 0.20
  late double tickScale = 0.5; // Update from 0.35

  // Update Fibo position variables
  late double fiboX = 0.802; // Update X position
  late double fiboY = 0.191; // Update Y position
  late double fiboSize = 0.099; // Update size

  // Add state for Fibo selection
  late bool _isFiboSelected = false;

  // Add near other Fibo variables
  late int _currentFrame = 0; // Track which frame we're showing

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
  late ui.Image? _fiboSprite;

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

    try {
      final data = await rootBundle.load('assets/images/achianim/achianim.png');
      final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
      final frame = await codec.getNextFrame();

      if (!mounted) return;
      setState(() {
        _achiSprite = frame.image;
        _achiImagesLoaded = true;
      });
    } catch (e) {
      print('Error loading Achi sprite: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    print("GameBoard initState started");
    level = widget.level;
    _setTreeType();

    // Initialize controller just once
    _customTextController = TextEditingController();

    // Generate problems for this level
    generateProblems();

    print("Loading Fibo sprite...");
    _loadFiboSprite();
    print("Loading Achi sprite...");
    _loadAchiSprite();

    // Initialize tree after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("Post frame callback executed");
      if (!mounted) return;
      _initializeTree();
    });

    // Animation controllers setup
    print("Setting up animation controllers");
    _fiboController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..addListener(() {
        if (!mounted) return;
        safeSetState(() {
          _currentFrame = (_fiboController.value * 13).floor();
        });
      });

    _achiController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..addListener(() {
        if (!mounted) return;
        safeSetState(() {
          // Explicitly map animation values to frames
          final value = _achiController.value;
          if (value < 0.001) {
            _currentAchiFrame = 1; // Ensure we start at frame 1
          } else if (value >= 0.999) {
            _currentAchiFrame = 9; // Ensure we end at frame 9
          } else {
            // Distribute the remaining frames evenly
            _currentAchiFrame = ((value * 7) + 1).floor() + 1;
          }
        });
      });

    // Set the initial frame to the standing position
    safeSetState(() {
      _currentAchiFrame = 3;
    });

    print("GameBoard initState completed");

    // Start the timer
    int timerValue =
        0; // Add this instead of using the Timer object as a counter

    // Then update the timer initialization to:
    _clockTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (mounted && !levelCompleteFlag) {
        safeSetState(() {
          timerValue +=
              1; // Use timerValue instead of trying to increment the Timer object

          // Update the clock visual
          if (timerValue <= targetTime1 * 10) {
            // Blue timer
          } else if (timerValue > targetTime1 * 10 &&
              timerValue < targetTime * 10) {
            // Green timer
          } else if (timerValue > targetTime * 10 &&
              timerValue < levelTime * 10) {
            // Yellow timer
          } else {
            // Red timer
          }
        });
      }
    });

    // Add this with your other initializations
    _customTextController = TextEditingController();
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
    if (!mounted) return;

    try {
      safeSetState(() {
        treeSprite = Image.asset(
          'assets/images/$currentTree/tree.png',
          width: MediaQuery.of(context).size.width * treeSize,
          fit: BoxFit.contain,
        );
      });
    } catch (e) {
      print('Error initializing tree: $e');
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _fiboController.dispose();
    _achiController.dispose();
    _clockTimer?.cancel();
    _customTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Background
            Image.asset(
              'assets/images/gameboard.png',
              width: screenWidth,
              height: screenHeight,
              fit: BoxFit.fill,
            ),

            // Debug text
            Positioned(
              top: 10,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  "Game Board Level ${widget.level}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // Add tree sprite
            Positioned(
              left: screenWidth * treeX,
              bottom: screenHeight * treeY,
              child: Image.asset(
                'assets/images/$currentTree/tree.png',
                width: screenWidth * treeSize,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  print('Error loading tree: $error');
                  return Container(
                    width: screenWidth * treeSize,
                    height: screenWidth * treeSize * 1.5,
                    color: Colors.brown.withOpacity(0.5),
                    child: Center(
                      child: Text(
                        'TREE',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Achi character (standing position - frame 3)
            Positioned(
              left: screenWidth * achiX,
              bottom: screenHeight * achiY,
              child: SizedBox(
                width: screenWidth * achiSize,
                height: screenWidth * achiSize,
                child: Image.asset(
                  'assets/images/achianim/frame3.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // Fibo character (single image)
            Positioned(
              left: screenWidth * fiboX,
              bottom: screenHeight * fiboY,
              child: Container(
                width: screenWidth * fiboSize,
                height: screenWidth * fiboSize * 2,
                child: Image.asset(
                  'assets/images/fibo/fiboplaceholder.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    print('Error loading fiboplaceholder.png: $error');
                    return Container(
                      width: screenWidth * fiboSize,
                      height: screenWidth * fiboSize * 2,
                      color: Colors.green.withOpacity(0.7),
                      child: Center(
                        child: Text(
                          'FIBO',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Back button (original image)
            Positioned(
              left: screenWidth * _homeButtonX,
              top: screenHeight * _homeButtonY, // Use top instead of bottom
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Image.asset(
                  'assets/images/game/home.png',
                  width: screenWidth * _homeButtonSize,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    print('Error loading home button: $error');
                    return Container(
                      width: screenWidth * _homeButtonSize,
                      height: screenWidth * _homeButtonSize,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child:
                          Icon(Icons.arrow_back, color: Colors.white, size: 30),
                    );
                  },
                ),
              ),
            ),

            // Clock
            Positioned(
              left: screenWidth * clockX,
              bottom: screenHeight * clockY,
              child: _buildClock(screenWidth),
            ),

            // Score board
            Positioned(
              left: screenWidth * scoreX,
              bottom: screenHeight * scoreY,
              child: Image.asset(
                'assets/images/game/Score.png',
                width: screenWidth * scoreSize,
                fit: BoxFit.contain,
              ),
            ),

            // Keys (coconuts)
            ..._buildCoconuts(screenWidth, screenHeight),

            // Achi's thought bubble
            Positioned(
              left: screenWidth * thoughtBubbleX,
              top: screenHeight * thoughtBubbleY,
              child: Container(
                width: screenWidth * thoughtBubbleSize,
                height: screenWidth * thoughtBubbleSize * 0.8,
                child: Center(
                  child: buildCurrentProblem(),
                ),
              ),
            ),

            // Achi's problem bubble
            Positioned(
              left: screenWidth * speechBubbleAchiX,
              top: screenHeight * speechBubbleAchiY,
              child: Image.asset(
                'assets/images/game/problem_small.png',
                width: screenWidth * speechBubbleAchiSize,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  print('Error loading problem bubble: $error');
                  return Container(
                    width: screenWidth * speechBubbleAchiSize,
                    height: screenWidth * speechBubbleAchiSize * 0.7,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(child: Text('Problem')),
                  );
                },
              ),
            ),

            // Achi's thought bubble
            Positioned(
              left: screenWidth * speechBubbleFiboX,
              top: screenHeight * speechBubbleFiboY,
              child: Container(
                width: screenWidth * speechBubbleFiboSize,
                height: screenWidth * speechBubbleFiboSize * 0.7,
                child: Center(
                  child: Text(
                    userAnswer,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
            ),

            // Left arrow image
            Positioned(
              left: screenWidth * leftArrowX,
              top: screenHeight * leftArrowY,
              child: GestureDetector(
                onTap: () {
                  // Handle left arrow press (previous problem)
                  print('Left arrow pressed');
                },
                child: Image.asset(
                  'assets/images/game/left.png',
                  width: screenWidth * leftArrowSize,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    print('Error loading left arrow: $error');
                    return Container(
                      width: screenWidth * leftArrowSize,
                      height: screenWidth * leftArrowSize,
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.7),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.arrow_back, color: Colors.white),
                    );
                  },
                ),
              ),
            ),

            // Position adjustment controls
            Positioned(
              bottom: 5,
              left: 5,
              child: Container(
                padding: EdgeInsets.all(6),
                color: Colors.white.withOpacity(0.6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "Left Arrow (${leftArrowX.toStringAsFixed(2)},${leftArrowY.toStringAsFixed(2)},${leftArrowSize.toStringAsFixed(2)})",
                        style: TextStyle(fontSize: 10)),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildMiniButton("X-", () => leftArrowX -= 0.01),
                        _buildMiniButton("X+", () => leftArrowX += 0.01),
                        _buildMiniButton("Y-", () => leftArrowY -= 0.01),
                        _buildMiniButton("Y+", () => leftArrowY += 0.01),
                        _buildMiniButton("S-", () => leftArrowSize -= 0.01),
                        _buildMiniButton("S+", () => leftArrowSize += 0.01),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build the clock
  Widget _buildClock(double screenWidth) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Base clock
        Image.asset(
          'assets/images/GameBoard/Clock/v3/Clock/Dial Circle.png',
          width: screenWidth * clockSize,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            print('Error loading clock base: $error');
            return Container(
              width: screenWidth * clockSize,
              height: screenWidth * clockSize,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
            );
          },
        ),
        // Rings
        Opacity(
          opacity: _getRingOpacity('Green'),
          child: Image.asset(
            'assets/images/GameBoard/Clock/v3/Clock/Green.png',
            width: screenWidth * clockSize,
            fit: BoxFit.contain,
          ),
        ),
        Opacity(
          opacity: _getRingOpacity('Red'),
          child: Image.asset(
            'assets/images/GameBoard/Clock/v3/Clock/Red.png',
            width: screenWidth * clockSize,
            fit: BoxFit.contain,
          ),
        ),
        Opacity(
          opacity: _getRingOpacity('Yellow'),
          child: Image.asset(
            'assets/images/GameBoard/Clock/v3/Clock/Yellow.png',
            width: screenWidth * clockSize,
            fit: BoxFit.contain,
          ),
        ),
        // Dial lines
        Image.asset(
          'assets/images/GameBoard/Clock/v3/Clock/Dial Lines.png',
          width: screenWidth * clockSize,
          fit: BoxFit.contain,
        ),
        // Clock hand
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
    );
  }

  // Helper method to build coconuts (keys)
  List<Widget> _buildCoconuts(double screenWidth, double screenHeight) {
    final coconuts = <Widget>[];

    // Calculate spacing to fit all keys
    final keyWidth = screenWidth * _coconutSize;
    final totalWidth = screenWidth * _coconutRowWidth;
    final availableSpace = totalWidth - (keyWidth * 10); // 10 keys
    final spacing = availableSpace / 9; // 9 spaces between 10 keys

    // Add keys 1-9 and 0 (as key10)
    for (int i = 1; i <= 10; i++) {
      final keyNumber = i == 10 ? 0 : i; // Key 10 is for digit 0
      final keyIndex = i - 1; // 0-based index

      // Calculate position with even spacing
      final leftPosition = screenWidth * (0.5 - _coconutRowWidth / 2) +
          keyIndex * (keyWidth + spacing);

      coconuts.add(
        Positioned(
          left: leftPosition,
          bottom: screenHeight * _coconutRowBottom,
          child: GestureDetector(
            onTap: () {
              int keyNumber = i == 10 ? 0 : i; // Key 10 is for digit 0
              onNumberKeyPressed(keyNumber);
            },
            child: Image.asset(
              'assets/images/key/key${i == 10 ? 10 : i}.png',
              width: keyWidth,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                print('Error loading key${i == 10 ? 10 : i}: $error');
                return Container(
                  width: keyWidth,
                  height: keyWidth,
                  color: Colors.orange.withOpacity(0.5),
                  child: Center(child: Text('$keyNumber')),
                );
              },
            ),
          ),
        ),
      );
    }

    return coconuts;
  }

  // Update the _navigateBack method to force navigation
  void _navigateBack() {
    // Force navigation back to previous screen
    Navigator.of(context).pop();
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
          Container(
            width: screenWidth * clockSize,
            height: screenWidth * clockSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: Colors.black, width: 1),
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/GameBoard/Clock/v3/Clock/Dial Circle.png',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  print('First path failed, trying alternative...');
                  return Image.asset(
                    'assets/images/GameBoard/Clock/Dial Circle.png',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      print('Second path failed, using fallback');
                      return Container(
                        color: Colors.grey.withOpacity(0.7),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          // Color rings (second layer)
          Opacity(
            opacity: _getRingOpacity('Blue'),
            child: Image.asset(
              'assets/images/GameBoard/Clock/v3/Clock/Blue.png',
              width: screenWidth * clockSize,
              fit: BoxFit.contain,
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
    if (!_isDisposed && mounted) {
      setState(() {
        // Show Achi animation
        achiSprite = Image.asset(
          'assets/images/achianim/achiAnim1.png',
          width: MediaQuery.of(context).size.width * 0.22,
        );
      });
    }

    // Animate through frames
    for (int i = 1; i <= 10; i++) {
      Future.delayed(Duration(milliseconds: 80 * i), () {
        if (!_isDisposed && mounted) {
          setState(() {
            achiSprite = Image.asset(
              'assets/images/achianim/achiAnim$i.png',
              width: MediaQuery.of(context).size.width * 0.22,
            );
          });
        }
      });
    }
  }

  void animateFailure() {
    if (!_isDisposed && mounted) {
      setState(() {
        // Show Fibo animation
        fiboSprite = Image.asset(
          'assets/images/fibo/fibo0.png',
          width: MediaQuery.of(context).size.width * 0.15,
        );
      });
    }

    // Animate through frames
    for (int i = 0; i < 14; i++) {
      Future.delayed(Duration(milliseconds: 50 * i), () {
        if (!_isDisposed && mounted) {
          setState(() {
            fiboSprite = Image.asset(
              'assets/images/fibo/fibo$i.png',
              width: MediaQuery.of(context).size.width * 0.15,
            );
          });
        }
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
      if (!_isDisposed && mounted) {
        setState(() {
          problemWidgets[rightCount] = AnimatedOpacity(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOut,
            opacity: 0,
            child: problemWithBubble,
          );
        });
      }
    });

    Future.delayed(const Duration(milliseconds: 400), () {
      if (!_isDisposed && mounted) {
        setState(() {
          problemWidgets.removeAt(rightCount);
        });
      }
    });
  }

  // Helper method to add new problem widget
  void addProblemWidget(Widget problemWidget) {
    if (!_isDisposed && mounted) {
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
  }

  void generateProblem() {
    // Placeholder implementation
    if (!_isDisposed && mounted) {
      setState(() {
        // Will implement actual problem generation later
      });
    }
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
  double achiX = 0.155; // X position at 15.5% from left
  double achiY = 0.185; // Y position at 18.5% from bottom
  double achiSize = 0.1; // Size at 10% of screen width
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
  };

  // Update sprite sheet size constant
  final Size achiSpriteSheetSize = const Size(502, 428);

  // Add in _GameBoardState class
  late AnimationController _achiController;
  int _currentAchiFrame = 1;

  // Add this boolean flag to track animation state
  bool _isAnimating = false;

  // Replace the playAchiAnimation method with this corrected sequence
  void playAchiAnimation() {
    if (!mounted || _isAnimating) return;

    _isAnimating = true;
    print("Starting direct animation with correct sequence");

    // Start with frame 3 (standing position)
    safeSetState(() {
      _currentAchiFrame = 3;
    });

    // Use the correct frame sequence
    Future.delayed(Duration(milliseconds: 0), () {
      if (!mounted) return;
      safeSetState(() => _currentAchiFrame = 3); // Start standing
      print("Set frame to 3 (standing)");
    });

    Future.delayed(Duration(milliseconds: 100), () {
      if (!mounted) return;
      safeSetState(() => _currentAchiFrame = 2); // Begin jump
      print("Set frame to 2 (begin jump)");
    });

    Future.delayed(Duration(milliseconds: 200), () {
      if (!mounted) return;
      safeSetState(() => _currentAchiFrame = 1); // Rising
      print("Set frame to 1 (rising)");
    });

    Future.delayed(Duration(milliseconds: 300), () {
      if (!mounted) return;
      safeSetState(() => _currentAchiFrame = 4); // Higher
      print("Set frame to 4 (higher)");
    });

    Future.delayed(Duration(milliseconds: 400), () {
      if (!mounted) return;
      safeSetState(() => _currentAchiFrame = 5); // Peak
      print("Set frame to 5 (peak)");
    });

    Future.delayed(Duration(milliseconds: 500), () {
      if (!mounted) return;
      safeSetState(() => _currentAchiFrame = 6); // Starting to fall
      print("Set frame to 6 (starting to fall)");
    });

    Future.delayed(Duration(milliseconds: 600), () {
      if (!mounted) return;
      safeSetState(() => _currentAchiFrame = 7); // Falling
      print("Set frame to 7 (falling)");
    });

    Future.delayed(Duration(milliseconds: 700), () {
      if (!mounted) return;
      safeSetState(() => _currentAchiFrame = 8); // Almost landed
      print("Set frame to 8 (almost landed)");
    });

    Future.delayed(Duration(milliseconds: 800), () {
      if (!mounted) return;
      safeSetState(() => _currentAchiFrame = 9); // Back on ground
      print("Set frame to 9 (back on ground)");
      _isAnimating = false;
    });
  }

  // Add method to set specific frame
  void _setAchiFrame(int frame) {
    safeSetState(() {
      _currentAchiFrame = frame.clamp(1, 9);
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
                          onPressed: () {
                            if (!_isDisposed && mounted) {
                              setState(() => achiX -= 0.01);
                            }
                          },
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints.tight(Size(24, 24)),
                          icon: const Icon(Icons.add, size: 18),
                          onPressed: () {
                            if (!_isDisposed && mounted) {
                              setState(() => achiX += 0.01);
                            }
                          },
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
                          onPressed: () {
                            if (!_isDisposed && mounted) {
                              setState(() => achiY -= 0.01);
                            }
                          },
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints.tight(Size(24, 24)),
                          icon: const Icon(Icons.add, size: 18),
                          onPressed: () {
                            if (!_isDisposed && mounted) {
                              setState(() => achiY += 0.01);
                            }
                          },
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
                          onPressed: () {
                            if (!_isDisposed && mounted) {
                              setState(() => achiSize -= 0.01);
                            }
                          },
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints.tight(Size(24, 24)),
                          icon: const Icon(Icons.add, size: 18),
                          onPressed: () {
                            if (!_isDisposed && mounted) {
                              setState(() => achiSize += 0.01);
                            }
                          },
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
              onPressed: playAchiAnimation,
              child: const Text('Test Animation'),
            ),
          ],
        ),
      ),
    );
  }

  // Add these methods to control Fibo
  void _startFiboAnimation() {
    if (_fiboController.isAnimating) {
      _fiboController.stop();
    } else {
      _fiboController.reset();
      _fiboController.forward();
    }
  }

  void _setFiboFrame(int frame) {
    safeSetState(() {
      _currentFrame = frame.clamp(0, 13);
    });
  }

  // Add a new method for Fibo controls
  Widget _buildFiboControls() {
    return Positioned(
      right: 20,
      top: 20,
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
                    Text('Fibo X: ${fiboX.toStringAsFixed(3)}'),
                    Row(
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints.tight(Size(24, 24)),
                          icon: const Icon(Icons.remove, size: 18),
                          onPressed: () {
                            if (!_isDisposed && mounted) {
                              setState(() => fiboX -= 0.01);
                            }
                          },
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints.tight(Size(24, 24)),
                          icon: const Icon(Icons.add, size: 18),
                          onPressed: () {
                            if (!_isDisposed && mounted) {
                              setState(() => fiboX += 0.01);
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Fibo Y: ${fiboY.toStringAsFixed(3)}'),
                    Row(
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints.tight(Size(24, 24)),
                          icon: const Icon(Icons.remove, size: 18),
                          onPressed: () {
                            if (!_isDisposed && mounted) {
                              setState(() => fiboY -= 0.01);
                            }
                          },
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints.tight(Size(24, 24)),
                          icon: const Icon(Icons.add, size: 18),
                          onPressed: () {
                            if (!_isDisposed && mounted) {
                              setState(() => fiboY += 0.01);
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Fibo Size: ${fiboSize.toStringAsFixed(3)}'),
                    Row(
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints.tight(Size(24, 24)),
                          icon: const Icon(Icons.remove, size: 18),
                          onPressed: () {
                            if (!_isDisposed && mounted) {
                              setState(() => fiboSize -= 0.01);
                            }
                          },
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints.tight(Size(24, 24)),
                          icon: const Icon(Icons.add, size: 18),
                          onPressed: () {
                            if (!_isDisposed && mounted) {
                              setState(() => fiboSize += 0.01);
                            }
                          },
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
                Text('Frame: $_currentFrame'),
                const SizedBox(width: 8),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints.tight(Size(24, 24)),
                  icon: const Icon(Icons.chevron_left, size: 18),
                  onPressed: () => _setFiboFrame(_currentFrame - 1),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints.tight(Size(24, 24)),
                  icon: const Icon(Icons.chevron_right, size: 18),
                  onPressed: () => _setFiboFrame(_currentFrame + 1),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _startFiboAnimation,
              child: const Text('Test Fibo Animation'),
            ),
          ],
        ),
      ),
    );
  }

  // Add these variables
  List<AssetImage> _achiFrames = [];
  bool _achiImagesLoaded = false;

  // Add this method
  void safeSetState(VoidCallback fn) {
    if (mounted && !_isDisposed) {
      setState(fn);
    }
  }

  // Add these variables with your other UI constants
  double thoughtBubbleX = 0.09; // X position at 9% from left
  double thoughtBubbleY = 0.08; // Y position at 8% from top
  double thoughtBubbleSize = 0.27; // Size at 27% of screen width

  double speechBubbleAchiX = 0.28; // X: 0.28 (28% from left)
  double speechBubbleAchiY = 0.48; // Y: 0.48 (48% from top)
  double speechBubbleAchiSize = 0.25; // Size: 0.25 (25% of screen width)

  double speechBubbleFiboX = 0.65; // X: 0.65 (65% from left)
  double speechBubbleFiboY = 0.37; // Y: 0.37 (37% from top)
  double speechBubbleFiboSize = 0.17; // Size: 0.17 (17% of screen width)

  Widget _buildMiniButton(String label, VoidCallback onPressed) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2),
      child: ElevatedButton(
        onPressed: () => safeSetState(onPressed),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(2),
          minimumSize: Size(24, 20),
          textStyle: TextStyle(fontSize: 8),
        ),
        child: Text(label),
      ),
    );
  }

  // Inside _GameBoardState, add these variables
  List<Map<String, dynamic>> problems = [];
  int currentProblemIndex = 0;
  String userAnswer = "";

  // Add the generateProblems method
  void generateProblems() {
    problems.clear();

    // Generate 10 simple problems for this level
    for (int i = 0; i < 10; i++) {
      problems.add({'problem': "5 + 3", 'answer': "8"});
    }
  }

  // Add these helper methods to your _GameBoardState class
  MathProblem _generateAdditionProblem() {
    final random = math.Random();
    final int a = 1 + random.nextInt(9);
    final int b = 1 + random.nextInt(9);

    final String problem = "$a + $b";
    final String answer = "${a + b}";

    return MathProblem(problem: problem, answer: answer, level: 1);
  }

  MathProblem _generateAddSubProblem() {
    final random = math.Random();
    final bool isAddition = random.nextBool();
    final int a = 5 + random.nextInt(10);
    final int b = 1 + random.nextInt(5);

    final String operation = isAddition ? "+" : "-";
    final String problem = "$a $operation $b";
    final String answer = isAddition ? "${a + b}" : "${a - b}";

    return MathProblem(problem: problem, answer: answer, level: 6);
  }

  MathProblem _generateMultiplicationProblem() {
    final random = math.Random();
    final int a = 1 + random.nextInt(9);
    final int b = 1 + random.nextInt(9);

    final String problem = "$a × $b";
    final String answer = "${a * b}";

    return MathProblem(problem: problem, answer: answer, level: 11);
  }

  MathProblem _generateDivisionProblem() {
    final random = math.Random();
    final int b = 1 + random.nextInt(9);
    final int answer = 1 + random.nextInt(9);
    final int a = b * answer;

    final String problem = "$a ÷ $b";

    return MathProblem(problem: problem, answer: "$answer", level: 16);
  }

  MathProblem _generateFractionProblem(int level) {
    final random = math.Random();
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

  MathProblem _generateMixedProblem(int level) {
    final random = math.Random();
    final int operation = random.nextInt(4);

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

  int _findGCD(int a, int b) {
    while (b != 0) {
      int t = b;
      b = a % b;
      a = t;
    }
    return a;
  }

  // Add this method to handle number key input
  void onNumberKeyPressed(int number) {
    if (!showingAnswer) {
      // Animate the answer bubble showing
      safeSetState(() {
        showingAnswer = true;
        userAnswer += number.toString();
      });
    } else {
      // Just append the number
      safeSetState(() {
        userAnswer += number.toString();
      });
    }
  }

  // Add this method to handle enter key
  void onEnterKeyPressed() {
    if (userAnswer.isNotEmpty) {
      checkAnswer();
    }
  }

  // Add this method to handle delete key
  void onDeleteKeyPressed() {
    safeSetState(() {
      userAnswer = "";
    });
  }

  // Add this method to add a tick to the tree
  void addTick(int tickNumber) {
    // Implementation depends on your tree visualization
    print("Added tick $tickNumber");
  }

  // Add a method to build the current problem
  Widget buildCurrentProblem() {
    return Text(
      "5 + 3",
      style: TextStyle(
        color: Colors.black,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
