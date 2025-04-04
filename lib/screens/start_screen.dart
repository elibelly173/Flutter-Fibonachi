import 'package:flutter/material.dart';
import 'package:math_practice/screens/map_view.dart';
import 'package:math_practice/utils/safe_state.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> with SafeState<StartScreen> {
  @override
  void initState() {
    super.initState();

    // Move precaching to after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Precache images
      precacheImage(const AssetImage('assets/images/start.png'), context);
      precacheImage(
          const AssetImage(
              'assets/images/GameBoard/Clock/v3/Clock/Dial Circle.png'),
          context);
      precacheImage(
          const AssetImage(
              'assets/images/GameBoard/Clock/v3/Clock/Dial Lines.png'),
          context);
      precacheImage(
          const AssetImage('assets/images/GameBoard/Clock/v3/Clock/Dial.png'),
          context);

      // Precache number keys
      for (int i = 1; i <= 9; i++) {
        precacheImage(AssetImage('assets/images/key/key$i.png'), context);
      }
      precacheImage(const AssetImage('assets/images/key/key10.png'), context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MapView()),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/start.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
