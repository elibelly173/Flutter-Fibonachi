import 'package:flutter/material.dart';
import 'package:math_practice/level_data.dart';
import 'screens/level_intro_screen.dart';

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

    print('Map dimensions: $mapWidth x $mapHeight');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Map View'),
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.save : Icons.edit),
            onPressed: () {
              setState(() {
                isEditing = !isEditing;
                if (!isEditing) {
                  // Print positions when saving
                  for (int i = 0; i < levelPositions.length; i++) {
                    print(
                        'Level ${i + 1}: LevelPosition(${levelPositions[i].x}, ${levelPositions[i].y}),');
                  }
                }
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Map Area
          Expanded(
            child: Stack(
              children: [
                SingleChildScrollView(
                  controller: _scrollController,
                  scrollDirection: Axis.vertical,
                  key: ValueKey(_aspectRatio),
                  child: SizedBox(
                    height: mapHeight,
                    child: Stack(
                      children: [
                        // Map Background
                        Image.asset(
                          'assets/images/mapback.jpg',
                          width: mapWidth,
                          height: mapHeight,
                          fit: BoxFit.fill,
                        ),
                        // Level Buttons
                        for (int i = 0; i < levelPositions.length; i++)
                          Positioned(
                            left: mapWidth * levelPositions[i].x,
                            top: mapHeight * (1 - levelPositions[i].y),
                            child: Builder(
                              builder: (context) {
                                final pixelX = mapWidth * levelPositions[i].x;
                                final pixelY = mapHeight * levelPositions[i].y;
                                print('Level ${i + 1} position: ($pixelX, $pixelY) from normalized (${levelPositions[i].x}, ${levelPositions[i].y})');
                                return GestureDetector(
                                  onTap: () {
                                    if (isEditing) {
                                      // In edit mode, just select the level for positioning
                                      setState(() {
                                        selectedLevelIndex = i;
                                      });
                                    } else {
                                      // In normal mode, show level intro
                                      setState(() {
                                        selectedLevelIndex = i;
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return LevelIntroScreen(
                                              levelData: LevelData(
                                                level: i + 1,
                                                name: "Level ${i + 1}",
                                                targetNumber: 20,
                                                time1: 10,
                                                time2: 80,
                                                time3: 300,
                                                x: levelPositions[i].x,
                                                y: levelPositions[i].y,
                                              ),
                                              onStart: () {
                                                Navigator.pop(context);
                                              },
                                              onClose: () {
                                                Navigator.pop(context);
                                              },
                                            );
                                          },
                                        );
                                      });
                                    }
                                  },
                                  child: Container(
                                    // Add a colored background to make buttons more visible for testing
                                    color: Colors.red.withOpacity(0.3),
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          'assets/images/levels_incomplete/${i + 1}.png',
                                          width: mapWidth * 0.1,
                                          height: mapWidth * 0.1,
                                        ),
                                        Text(
                                          'L${i + 1}: (${levelPositions[i].x.toStringAsFixed(2)}, ${levelPositions[i].y.toStringAsFixed(2)})',
                                          style: TextStyle(
                                            color: Colors.white,
                                            backgroundColor: Colors.black54,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                // Editor Panel
                if (isEditing && selectedLevelIndex >= 0)
                  Positioned(
                    right: 16,
                    top: 16,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Level ${selectedLevelIndex + 1}'),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('X: '),
                                SizedBox(
                                  width: 200,
                                  child: Slider(
                                    value: levelPositions[selectedLevelIndex].x,
                                    onChanged: (value) {
                                      setState(() {
                                        levelPositions[selectedLevelIndex] =
                                            LevelPosition(
                                                value,
                                                levelPositions[
                                                        selectedLevelIndex]
                                                    .y);
                                      });
                                    },
                                    min: 0,
                                    max: 1,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('Y: '),
                                SizedBox(
                                  width: 200,
                                  child: Slider(
                                    value: levelPositions[selectedLevelIndex].y,
                                    onChanged: (value) {
                                      setState(() {
                                        levelPositions[selectedLevelIndex] =
                                            LevelPosition(
                                                levelPositions[
                                                        selectedLevelIndex]
                                                    .x,
                                                value);
                                      });
                                    },
                                    min: 0,
                                    max: 1,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  Text('X Offset: ${xOffset.toStringAsFixed(3)}'),
                  Slider(
                    value: xOffset,
                    min: -0.2,
                    max: 0.2,
                    onChanged: (value) => setState(() => xOffset = value),
                  ),
                ],
              ),
              Row(
                children: [
                  Text('Y Offset: ${yOffset.toStringAsFixed(3)}'),
                  Slider(
                    value: yOffset,
                    min: -0.2,
                    max: 0.2,
                    onChanged: (value) => setState(() => yOffset = value),
                  ),
                ],
              ),
              Row(
                children: [
                  Text('Y Scale: ${yScale.toStringAsFixed(3)}'),
                  Slider(
                    value: yScale,
                    min: 0.5,
                    max: 1.5,
                    onChanged: (value) => setState(() => yScale = value),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
