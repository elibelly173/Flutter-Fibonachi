import 'package:flutter/material.dart';
import 'package:math_practice/screens/game_board.dart';
import 'package:math_practice/utils/safe_state.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> with SafeState<MapView> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Image.asset(
            'assets/images/mapback.jpg',
            width: screenWidth,
            height: screenHeight,
            fit: BoxFit.cover,
          ),

          // Level 1
          _buildLevelButton(context, 1, 0.15, 0.10),

          // Level 2
          _buildLevelButton(context, 2, 0.30, 0.15),

          // Level 3
          _buildLevelButton(context, 3, 0.45, 0.12),

          // Level 4
          _buildLevelButton(context, 4, 0.60, 0.18),

          // Level 5
          _buildLevelButton(context, 5, 0.70, 0.25),

          // Level 6
          _buildLevelButton(context, 6, 0.82, 0.20),

          // Level 7
          _buildLevelButton(context, 7, 0.85, 0.32),

          // Level 8
          _buildLevelButton(context, 8, 0.80, 0.40),

          // Level 9
          _buildLevelButton(context, 9, 0.65, 0.38),

          // Level 10
          _buildLevelButton(context, 10, 0.50, 0.35),

          // Add remaining levels with their specific coordinates
          // Level 11-32 (add all the original coordinates here)
          _buildLevelButton(context, 11, 0.35, 0.40),
          _buildLevelButton(context, 12, 0.20, 0.38),
          // ... continue with the rest of your original level positions

          // Back button
          Positioned(
            top: 20,
            left: 20,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelButton(
      BuildContext context, int level, double x, double y) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Determine if level is completed (you'll need to implement this logic)
    bool isCompleted = false; // Replace with your completion check

    return Positioned(
      left: screenWidth * x,
      top: screenHeight * y,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GameBoard(level: level)),
          );
        },
        child: Image.asset(
          isCompleted
              ? 'assets/images/levels_complete/$level.png'
              : 'assets/images/levels_incomplete/$level.png',
          width: screenWidth * 0.10,
          height: screenWidth * 0.10,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
