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
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/mapback.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          // Level buttons - add your level buttons here
          // Example of a level button:
          Positioned(
            left: size.width * 0.2,
            top: size.height * 0.3,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GameBoard()),
                );
              },
              child: Container(
                width: size.width * 0.1,
                height: size.width * 0.1,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/levels_incomplete/1.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          
          // Back button
          Positioned(
            left: size.width * 0.05,
            top: size.height * 0.05,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: size.width * 0.07,
                height: size.width * 0.07,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/close.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 