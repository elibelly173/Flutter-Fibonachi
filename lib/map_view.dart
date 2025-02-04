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
  bool isEditMode = true;
  int selectedButton = -1;
  Map<int, Offset> buttonOffsets = {};
  
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
          if (selectedButton >= 0) ...[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text('Adjusting Level ${selectedButton + 1}'),
                  Row(
                    children: [
                      SizedBox(width: 20),
                      Text('Left/Right:'),
                      Expanded(
                        child: Slider(
                          value: buttonOffsets[selectedButton]?.dx ?? 0.2,
                          min: 0.0,
                          max: 1.0,
                          onChanged: (value) => setState(() {
                            buttonOffsets[selectedButton] = Offset(value, 
                                buttonOffsets[selectedButton]?.dy ?? levelPositions[selectedButton].y);
                          }),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(width: 20),
                      Text('Up/Down:'),
                      Expanded(
                        child: Slider(
                          value: buttonOffsets[selectedButton]?.dy ?? levelPositions[selectedButton].y,
                          min: 0.0,
                          max: 1.0,
                          onChanged: (value) => setState(() {
                            buttonOffsets[selectedButton] = Offset(
                                buttonOffsets[selectedButton]?.dx ?? levelPositions[selectedButton].x, 
                                value);
                          }),
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      print('\nFinal Button Positions:');
                      for (int i = 0; i < levelPositions.length; i++) {
                        final pos = buttonOffsets[i] ?? Offset(levelPositions[i].x, levelPositions[i].y);
                        print('Level ${i + 1}: (${pos.dx}, ${pos.dy})');
                      }
                    },
                    child: Text('Save All Positions'),
                  ),
                ],
              ),
            ),
          ],
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
