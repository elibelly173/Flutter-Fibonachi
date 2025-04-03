import 'package:flutter/material.dart';
import 'package:math_practice/utils/safe_state.dart';

class YourScreen extends StatefulWidget {
  const YourScreen({super.key});

  // ... (existing code)
  @override
  _YourScreenState createState() => _YourScreenState();
}

class _YourScreenState extends State<YourScreen> with SafeState<YourScreen> {
  // ... (existing code)

  @override
  void initState() {
    super.initState();
    // ... (existing code)
  }

  @override
  void dispose() {
    // ... (existing code)
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ... (existing code)
    return const Scaffold(
      // ... (existing code)
    );
  }
} 