import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'game_board.dart'; // Add this import
import 'utils/safe_state.dart'; // Add this import

class LevelPosition {
  final double x;
  final double y;

  const LevelPosition(this.x, this.y);
}

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> with SafeState {
  late ScrollController _scrollController;
  double _aspectRatio = 1.0;
  bool _isMapLoaded = false;
  bool _areImagesLoaded = false;
  int _selectedLevel = -1;
  bool _isDisposed = false;
  final double _levelGroundWidth = 0.55; // Starting at 55% of screen width
  final double _levelGroundHeight = 0.08; // Starting at 8% from bottom

  // Group all overlay constants together with consistent formatting
  final double overlay31Bottom = 0.866213851001381;
  final double overlay31Height = 0.133506210074240;
  final double overlay19Bottom = 0.426655255452924;
  final double overlay19Height = 0.330612806457182;
  final double overlay13Bottom = 0.278400000000000;
  final double overlay13Height = 0.224211106555018;
  final double overlay7Bottom = 0.143599000021581;
  final double overlay7Height = 0.173000000000000;
  final double overlay25Bottom = 0.714000000000000;
  final double overlay25Height = 0.158000000000000;

  // Add this constant with your other overlay constants
  final double overlay1Bottom = 0.0; // Starting from bottom of map
  final double overlay1Height =
      0.143599000021581; // Set to match exactly where overlay7 begins

  final List<LevelPosition> levelPositions = [
    LevelPosition(0.3741156445667631, 0.033198838013191595), // Level 1
    LevelPosition(0.5076678216754811, 0.0422028069257579), // Level 2
    LevelPosition(0.6083978535625661, 0.06808921754938622), // Level 3
    LevelPosition(0.5336991782305707, 0.1029795970855807), // Level 4
    LevelPosition(0.3707202502334886, 0.12323852713885479), // Level 5
    LevelPosition(0.19415974490331636, 0.14237196107805822), // Level 6
    LevelPosition(0.051553182905869854, 0.17163486004389866), // Level 7
    LevelPosition(0.1353062431265936, 0.20427424735195152), // Level 8
    LevelPosition(0.5, 0.2279096657474382), // Level 9
    LevelPosition(0.6480107874507463, 0.23353714631779215), // Level 10
    LevelPosition(0.7091278854496521, 0.2639255413977035), // Level 11
    LevelPosition(0.6208476327845657, 0.2965649287057564), // Level 12
    LevelPosition(0.5303037838972982, 0.3325808043560217), // Level 13
    LevelPosition(0.3571386729003994, 0.34271026938265864), // Level 14
    LevelPosition(0.2281136882360426, 0.36859668000628687), // Level 15
    LevelPosition(0.27904460323513103, 0.4034870595424813), // Level 16
    LevelPosition(0.3899608181220327, 0.4259969818238968), // Level 17
    LevelPosition(0.5246447933418439, 0.44175392742088826), // Level 18
    LevelPosition(0.6208476327845659, 0.545299569915401), // Level 19
    LevelPosition(0.4499461180098489, 0.556554531056109), // Level 20
    LevelPosition(0.2779128051240405, 0.5835664377938079), // Level 21
    LevelPosition(0.2654630259020411, 0.6882375764023911), // Level 22
    LevelPosition(0.4488143198987572, 0.7039945219993818), // Level 23
    LevelPosition(0.6480107874507461, 0.7118729947978781), // Level 24
    LevelPosition(0.7906173494481916, 0.7490143665622138), // Level 25
    LevelPosition(0.6581969704505639, 0.7771517694139839), // Level 26
    LevelPosition(0.422782963343668, 0.7951597072391167), // Level 27
    LevelPosition(0.22132289956949672, 0.8097911567220363), // Level 28
    LevelPosition(0.13870163745986483, 0.8435560401441605), // Level 29
    LevelPosition(0.30394416167912874, 0.8739444352240714), // Level 30
    LevelPosition(0.5, 0.8930778691632745), // Level 31
    LevelPosition(0.3186575371233108, 0.9988745038859291), // Level 32
  ];

  final ScrollBehavior _scrollBehavior =
      const MaterialScrollBehavior().copyWith(
    dragDevices: PointerDeviceKind.values.toSet(), // Enable all input devices
  );

  final double _closeButtonX = 0.543; // 54.3% from left
  final double _closeButtonY = 0.567; // 56.7% from bottom
  final double _closeButtonSize = 0.10; // 10% of level ground width

  final double _levelNumberX = 0.885; // 88.5% from left (center of image)
  final double _levelNumberY = 0.616; // 61.6% from bottom
  final double _levelNumberSize = 0.37; // 37% of level ground width

  final double _timerX = 1.15; // 115% from left
  final double _timerY = 0.28; // 28% from bottom
  final double _timerSize = 0.17; // 17% of level ground width

  final double _contentX = 0.88; // 88% from left
  final double _contentY = 0.50; // 50% from bottom
  final double _contentSize = 0.65; // 65% of level ground width

  final double _targetX = 0.61; // 61% from left

  // Add these with your other state variables
  final double _continueX = 0.872; // 87.2% from left
  final double _continueY = -0.001; // -0.1% from bottom
  final double _continueSize = 0.29; // 29% of level ground width

  // Update target size
  final double _targetSize = 0.162; // 16.2% of level ground width

  // Track which levels are unlocked
  int unlockedLevel = 0; // Set to 0 to make all levels appear incomplete

  // First, enable all unlocked levels for testing
  bool level1to6Unlocked = false;
  bool level7to12Unlocked = false;
  bool level13to18Unlocked = false;
  bool level19to24Unlocked = false;
  bool level25to30Unlocked = false;
  bool level31to32Unlocked = false;

  // Update these state variables with your final values
  double overlay1HeightFactor = 0.166; // 16.60% for levels 1-6
  double overlay7HeightFactor = 0.1731; // 17.31% for levels 7-12
  double overlay13HeightFactor = 0.2244; // 22.44% for levels 13-18
  double overlay19HeightFactor = 0.3309; // 33.09% for levels 19-24
  double overlay25HeightFactor = 0.1579; // 15.79% for levels 25-30
  double overlay31HeightFactor = 0.134; // 13.40% for levels 31-32

  // Add this method to find lowest incomplete level
  int _findLowestIncompleteLevel() {
    // For now, return 1 since all levels are incomplete
    // Later we'll check game progress to find actual lowest incomplete level
    return 1;
  }

  // Modify scroll method to scroll to a specific level
  void _scrollToLevel(int level) {
    if (_scrollController.hasClients) {
      final screenWidth = MediaQuery.of(context).size.width;
      final mapHeight = screenWidth * _aspectRatio;
      final levelY = levelPositions[level - 1].y;

      // Calculate from bottom again
      final scrollPosition =
          mapHeight * (1 - levelY) - (MediaQuery.of(context).size.height / 2);
      _scrollController.jumpTo(
          scrollPosition.clamp(0, _scrollController.position.maxScrollExtent));
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    // Set your finalized overlay height values
    overlay1HeightFactor = 0.166; // 16.60% for levels 1-6
    overlay7HeightFactor = 0.1731; // 17.31% for levels 7-12
    overlay13HeightFactor = 0.2244; // 22.44% for levels 13-18
    overlay19HeightFactor = 0.3309; // 33.09% for levels 19-24
    overlay25HeightFactor = 0.1579; // 15.79% for levels 25-30
    overlay31HeightFactor = 0.134; // 13.40% for levels 31-32

    // Set overlay unlocked states based on current progress
    level1to6Unlocked = unlockedLevel >= 1;
    level7to12Unlocked = unlockedLevel >= 7;
    level13to18Unlocked = unlockedLevel >= 13;
    level19to24Unlocked = unlockedLevel >= 19;
    level25to30Unlocked = unlockedLevel >= 25;
    level31to32Unlocked = unlockedLevel >= 31;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _preloadImages();
      _scrollToLevel(_findLowestIncompleteLevel());

      AssetImage('assets/images/mapback.jpg')
          .resolve(const ImageConfiguration())
          .addListener(
        ImageStreamListener((ImageInfo info, bool _) {
          final double imageWidth = info.image.width.toDouble();
          final double imageHeight = info.image.height.toDouble();
          safeSetState(() {
            _aspectRatio = imageHeight / imageWidth;
          });
        }),
      );
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final mapHeight = screenWidth * _aspectRatio;

    return Scaffold(
      body: Stack(
        children: [
          // Scrolling map content
          SingleChildScrollView(
            controller: _scrollController,
            child: Container(
              width: screenWidth,
              height: mapHeight,
              child: Stack(
                children: [
                  // Background image
                  Image.asset(
                    'assets/images/mapback.jpg',
                    width: screenWidth,
                    height: mapHeight,
                    fit: BoxFit.cover,
                  ),

                  // Overlay sections FIRST (so buttons appear on top)
                  // Level 1-6 overlay (if not unlocked)
                  if (!level1to6Unlocked)
                    Positioned(
                      left: 0,
                      bottom: 0,
                      width: screenWidth,
                      height: mapHeight * overlay1HeightFactor,
                      child: Opacity(
                        opacity: 0.8,
                        child: Image.asset(
                          'assets/images/mapback/1-6.png',
                          width: screenWidth,
                          fit: BoxFit.fill,
                          alignment: Alignment.bottomCenter,
                        ),
                      ),
                    ),

                  // Level 7-12 overlay (if not unlocked)
                  if (!level7to12Unlocked)
                    Positioned(
                      left: 0,
                      bottom: mapHeight * overlay7Bottom,
                      width: screenWidth,
                      height: mapHeight * overlay7HeightFactor,
                      child: Opacity(
                        opacity: 0.8,
                        child: Image.asset(
                          'assets/images/mapback/7-12.png',
                          width: screenWidth,
                          fit: BoxFit.fill,
                          alignment: Alignment.bottomCenter,
                        ),
                      ),
                    ),

                  // Level 13-18 overlay (if not unlocked)
                  if (!level13to18Unlocked)
                    Positioned(
                      left: 0,
                      bottom: mapHeight * overlay13Bottom,
                      width: screenWidth,
                      height: mapHeight * overlay13HeightFactor,
                      child: Opacity(
                        opacity: 0.8,
                        child: Image.asset(
                          'assets/images/mapback/13-18.png',
                          width: screenWidth,
                          fit: BoxFit.fill,
                          alignment: Alignment.bottomCenter,
                        ),
                      ),
                    ),

                  // Level 19-24 overlay (if not unlocked)
                  if (!level19to24Unlocked)
                    Positioned(
                      left: 0,
                      bottom: mapHeight * overlay19Bottom,
                      width: screenWidth,
                      height: mapHeight * overlay19HeightFactor,
                      child: Opacity(
                        opacity: 0.8,
                        child: Image.asset(
                          'assets/images/mapback/19-24.png',
                          width: screenWidth,
                          fit: BoxFit.fill,
                          alignment: Alignment.bottomCenter,
                        ),
                      ),
                    ),

                  // Level 25-30 overlay (if not unlocked)
                  if (!level25to30Unlocked)
                    Positioned(
                      left: 0,
                      bottom: mapHeight * overlay25Bottom,
                      width: screenWidth,
                      height: mapHeight * overlay25HeightFactor,
                      child: Opacity(
                        opacity: 0.8,
                        child: Image.asset(
                          'assets/images/mapback/25-30.png',
                          width: screenWidth,
                          fit: BoxFit.fill,
                          alignment: Alignment.bottomCenter,
                        ),
                      ),
                    ),

                  // Level 31-32 overlay (if not unlocked)
                  if (!level31to32Unlocked)
                    Positioned(
                      left: 0,
                      bottom: mapHeight * overlay31Bottom,
                      width: screenWidth,
                      height: mapHeight * overlay31HeightFactor,
                      child: Opacity(
                        opacity: 0.8,
                        child: Image.asset(
                          'assets/images/mapback/31-32.png',
                          width: screenWidth,
                          fit: BoxFit.fill,
                          alignment: Alignment.bottomCenter,
                        ),
                      ),
                    ),

                  // Level buttons AFTER overlays so they're on top
                  ...List.generate(32, (index) {
                    final level = index + 1;
                    final isUnlocked = level <= unlockedLevel;
                    final position = levelPositions[index];

                    return Positioned(
                      left: screenWidth * position.x,
                      top: mapHeight * (1 - position.y),
                      child: GestureDetector(
                        onTap: () {
                          // Allow tapping on any level for testing purposes
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GameBoard(level: level),
                            ),
                          );
                        },
                        child: Image.asset(
                          'assets/images/levels_incomplete/$level.png',
                          width: screenWidth * 0.12,
                          fit: BoxFit.contain,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),

          // Back button
          Positioned(
            top: 20,
            left: 20,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: Colors.white.withOpacity(0.7),
              child: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getTimeValue(int level) {
    // For now, return '30' for all levels
    return '30'; // This will look for 'timer30.png' in the assets
  }

  // Add this method to get the target number for each level
  String _getTargetNumber(int level) {
    String filename = '';
    // From the plist data
    switch (level) {
      case 1:
      case 2:
      case 3:
      case 4:
      case 5:
      case 6:
      case 7:
      case 8:
      case 9:
      case 10:
      case 11:
      case 12:
      case 13:
      case 14:
        filename = 'number20'; // First 14 levels have target 20
        break;
      case 15:
      case 18:
      case 19:
      case 21:
      case 22:
      case 23:
      case 29:
      case 30:
      case 31:
      case 32:
        filename = 'number10'; // These levels have target 10
        break;
      case 20:
      case 24:
      case 25:
      case 26:
      case 27:
      case 28:
        filename = 'number5'; // These levels have target 5
        break;
      default:
        filename = 'number20'; // Default value
    }
    return filename;
  }

  Future<void> _preloadImages() async {
    await precacheImage(const AssetImage('assets/images/mapback.jpg'), context);

    safeSetState(() {
      _areImagesLoaded = true;
    });

    // Load everything else in parallel
    Future.wait([
      // Map sections
      precacheImage(const AssetImage('assets/images/mapback/1-6.png'), context),
      precacheImage(
          const AssetImage('assets/images/mapback/7-12.png'), context),
      precacheImage(
          const AssetImage('assets/images/mapback/13-18.png'), context),
      precacheImage(
          const AssetImage('assets/images/mapback/19-24.png'), context),
      precacheImage(
          const AssetImage('assets/images/mapback/25-30.png'), context),
      precacheImage(
          const AssetImage('assets/images/mapback/31-32.png'), context),

      // All level buttons at once
      for (int i = 1; i <= 32; i++)
        precacheImage(
            AssetImage('assets/images/levels_incomplete/$i.png'), context),
    ]);
  }
}
