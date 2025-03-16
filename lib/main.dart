import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:math_practice/map_view.dart';
// import 'screens/asset_test_screen.dart';  // Comment this out or remove it

void main() {
  // Keep this initialization code
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]).then((_) {
    runApp(const MathPracticeApp());
  });
}

class MathPracticeApp extends StatelessWidget {
  const MathPracticeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Math Practice',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const StartScreen(), // Changed back from AssetTestScreen
    );
  }
}

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
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
      body: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MapView()),
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
      ),
    );
  }
}
