import 'package:flutter/material.dart';
import 'package:math_practice/utils/safe_state.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  _GameBoardState createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> with SafeState<GameBoard> {
  // Define variables for your game elements
  late double dialSize;


  @override
  void dispose() {
    // Clean up any controllers or timers here
    super.dispose();
  }

  Widget buildDialCircle() {
    dialSize = MediaQuery.of(context).size.width * 0.3; // Adjust size as needed

    return Positioned(
      left: MediaQuery.of(context).size.width * 0.5 - (dialSize / 2),
      top:
          MediaQuery.of(context).size.height * 0.4, // Adjust position as needed
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Layer 1: Dial Circle (base layer)
          Container(
            width: dialSize,
            height: dialSize,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/GameBoard/Clock/v3/Clock/Dial Circle.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),

          // Layer 2: Dial Lines
          Container(
            width: dialSize,
            height: dialSize,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/GameBoard/Clock/v3/Clock/Dial Lines.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),

          // Layer 3: Color indicators (Blue/Green/Yellow/Red)
          Container(
            width: dialSize,
            height: dialSize,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/GameBoard/Clock/v3/Clock/yellow.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),

          // Debug border to see the entire clock area
          Container(
            width: dialSize,
            height: dialSize,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red, width: 2),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/gameboard.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Add your dial circle
          buildDialCircle(),

          // Add other game elements here
        ],
      ),
    );
  }
}
