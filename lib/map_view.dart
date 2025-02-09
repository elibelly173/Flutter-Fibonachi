import 'package:flutter/material.dart';
import 'package:math_practice/level_data.dart';
import 'screens/level_intro_screen.dart';
import 'package:flutter/gestures.dart';

class LevelPosition {
  final double x;
  final double y;
  
  const LevelPosition(this.x, this.y);
}

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late ScrollController _scrollController;
  double _aspectRatio = 1.0;
  int selectedLevelIndex = -1;
  bool isEditing = false;
  double xOffset = 0.0;
  double yOffset = 0.0;
  double yScale = 1.0;
  bool isEditMode = true;
  int selectedButton = -1;
  Map<int, Offset> buttonOffsets = {};
  bool _isMapLoaded = false;
  double overlay31Bottom = 0.866213851001381;
  double overlay31Height = 0.133506210074240;
  double overlay19Bottom = 0.426655255452924;
  double overlay19Height = 0.330612806457182;
  double overlay13Bottom = 0.2795;
  double overlay13Height = 0.224211106555018;
  double overlay7Bottom = 0.143599000021581;
  double overlay7Height = 0.173000000000000;

  final List<LevelPosition> levelPositions = [
    LevelPosition(0.3741156445667631, 0.033198838013191595),   // Level 1
    LevelPosition(0.5076678216754811, 0.0422028069257579),     // Level 2
    LevelPosition(0.6083978535625661, 0.06808921754938622),    // Level 3
    LevelPosition(0.5336991782305707, 0.1029795970855807),     // Level 4
    LevelPosition(0.3707202502334886, 0.12323852713885479),    // Level 5
    LevelPosition(0.19415974490331636, 0.14237196107805822),   // Level 6
    LevelPosition(0.051553182905869854, 0.17163486004389866),  // Level 7
    LevelPosition(0.1353062431265936, 0.20427424735195152),    // Level 8
    LevelPosition(0.5, 0.2279096657474382),                    // Level 9
    LevelPosition(0.6480107874507463, 0.23353714631779215),    // Level 10
    LevelPosition(0.7091278854496521, 0.2639255413977035),     // Level 11
    LevelPosition(0.6208476327845657, 0.2965649287057564),     // Level 12
    LevelPosition(0.5303037838972982, 0.3325808043560217),     // Level 13
    LevelPosition(0.3571386729003994, 0.34271026938265864),    // Level 14
    LevelPosition(0.2281136882360426, 0.36859668000628687),    // Level 15
    LevelPosition(0.27904460323513103, 0.4034870595424813),    // Level 16
    LevelPosition(0.3899608181220327, 0.4259969818238968),     // Level 17
    LevelPosition(0.5246447933418439, 0.44175392742088826),    // Level 18
    LevelPosition(0.6208476327845659, 0.545299569915401),      // Level 19
    LevelPosition(0.4499461180098489, 0.556554531056109),      // Level 20
    LevelPosition(0.2779128051240405, 0.5835664377938079),     // Level 21
    LevelPosition(0.2654630259020411, 0.6882375764023911),     // Level 22
    LevelPosition(0.4488143198987572, 0.7039945219993818),     // Level 23
    LevelPosition(0.6480107874507461, 0.7118729947978781),     // Level 24
    LevelPosition(0.7906173494481916, 0.7490143665622138),     // Level 25
    LevelPosition(0.6581969704505639, 0.7771517694139839),     // Level 26
    LevelPosition(0.422782963343668, 0.7951597072391167),      // Level 27
    LevelPosition(0.22132289956949672, 0.8097911567220363),    // Level 28
    LevelPosition(0.13870163745986483, 0.8435560401441605),    // Level 29
    LevelPosition(0.30394416167912874, 0.8739444352240714),    // Level 30
    LevelPosition(0.5, 0.8930778691632745),                    // Level 31
    LevelPosition(0.3186575371233108, 0.9988745038859291),     // Level 32
  ];
  
  final ScrollBehavior _scrollBehavior = const MaterialScrollBehavior().copyWith(
    dragDevices: {
      PointerDeviceKind.mouse,
      PointerDeviceKind.touch,
      PointerDeviceKind.trackpad,
    },
  );

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      final screenWidth = MediaQuery.of(context).size.width;
      final mapHeight = screenWidth * _aspectRatio;
      // Calculate offset to show bottom of map
      final maxScroll = _scrollController.position.maxScrollExtent;
      print('Scrolling to maxScroll: $maxScroll'); // Debug print
      _scrollController.jumpTo(maxScroll);
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Load image and set aspect ratio
      AssetImage('assets/images/mapback.jpg')
          .resolve(const ImageConfiguration())
          .addListener(
        ImageStreamListener((ImageInfo info, bool _) {
          final double imageWidth = info.image.width.toDouble();
          final double imageHeight = info.image.height.toDouble();
          setState(() {
            _aspectRatio = imageHeight / imageWidth;
          });
          
          // Add a small delay to ensure layout is complete
          Future.delayed(Duration(milliseconds: 50), () {
            _scrollToBottom();
          });
        }),
      );
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double mapWidth = MediaQuery.of(context).size.width;
    double mapHeight = mapWidth * _aspectRatio;

    return Scaffold(
      body: MouseRegion(
        child: GestureDetector(
          onVerticalDragUpdate: (details) {
            _scrollController.jumpTo(
              (_scrollController.offset - details.delta.dy).clamp(
                0.0,
                _scrollController.position.maxScrollExtent,
              ),
            );
          },
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            controller: _scrollController,
            child: Stack(
              children: [
                // Map Background
                Image.asset(
                  'assets/images/mapback.jpg',
                  width: mapWidth,
                  height: mapHeight,
                  fit: BoxFit.fill,
                  frameBuilder: (context, child, frame, _) {
                    if (frame != null && !_isMapLoaded) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        setState(() {
                          _isMapLoaded = true;
                        });
                      });
                    }
                    return child;
                  },
                ),

                // Section overlays
                if (_isMapLoaded) ...[
                  // Section 1 (1-6)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Opacity(
                      opacity: 0.4,
                      child: Image.asset(
                        'assets/images/mapback/1-6.png',
                        width: mapWidth,
                        height: mapHeight * 0.166,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  
                  // Section 2 (7-12)
                  Positioned(
                    bottom: mapHeight * 0.144,
                    left: 0,
                    child: Opacity(
                      opacity: 0.4,
                      child: Image.asset(
                        'assets/images/mapback/7-12.png',
                        width: mapWidth,
                        height: mapHeight * 0.173,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  
                  // Section 3 (13-18)
                  Positioned(
                    bottom: mapHeight * 0.278,
                    left: 0,
                    child: Opacity(
                      opacity: 0.4,
                      child: Image.asset(
                        'assets/images/mapback/13-18.png',
                        width: mapWidth,
                        height: mapHeight * 0.224,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  
                  // Section 4 (19-24)
                  Positioned(
                    bottom: mapHeight * overlay19Bottom,
                    left: 0,
                    child: Opacity(
                      opacity: 0.603,
                      child: Image.asset(
                        'assets/images/mapback/19-24.png',
                        width: mapWidth,
                        height: mapHeight * overlay19Height,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  
                  // Section 5 (25-30)
                  Positioned(
                    bottom: mapHeight * 0.714,
                    left: 0,
                    child: Opacity(
                      opacity: 0.4,
                      child: Image.asset(
                        'assets/images/mapback/25-30.png',
                        width: mapWidth,
                        height: mapHeight * 0.158,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  
                  // Section 6 (31-32)
                  Positioned(
                    bottom: mapHeight * overlay31Bottom,
                    left: 0,
                    child: Opacity(
                      opacity: 0.603,
                      child: Image.asset(
                        'assets/images/mapback/31-32.png',
                        width: mapWidth,
                        height: mapHeight * overlay31Height,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ],

                // Level Buttons
                for (int i = 0; i < levelPositions.length; i++)
                  Positioned(
                    left: mapWidth * (buttonOffsets[i]?.dx ?? levelPositions[i].x),
                    top: mapHeight * (1 - (buttonOffsets[i]?.dy ?? levelPositions[i].y)),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedButton = i;
                          if (!buttonOffsets.containsKey(i)) {
                            buttonOffsets[i] = Offset(levelPositions[i].x, levelPositions[i].y);
                          }
                        });
                      },
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/levels_incomplete/${i + 1}.png',
                            width: mapWidth * 0.1,
                            height: mapWidth * 0.1,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
