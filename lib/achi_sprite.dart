import 'package:flutter/material.dart';

class AchiAnimation extends StatefulWidget {
  final double size;
  final VoidCallback? onAnimationComplete;
  
  const AchiAnimation({
    Key? key, 
    required this.size,
    this.onAnimationComplete,
  }) : super(key: key);

  @override
  State<AchiAnimation> createState() => _AchiAnimationState();
}

class _AchiAnimationState extends State<AchiAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _currentFrame = 1;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..addListener(() {
      setState(() {
        _currentFrame = (_controller.value * 9).floor() + 1;
        if (_currentFrame > 9) _currentFrame = 9;
      });
    })..addStatusListener((status) {
      if (status == AnimationStatus.completed && widget.onAnimationComplete != null) {
        widget.onAnimationComplete!();
      }
    });
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  void play() {
    _controller.forward(from: 0.0);
  }
  
  @override
  Widget build(BuildContext context) {
    // Define jump offsets for each frame
    final jumpOffsets = [
      0.0,   // Frame 1
      -5.0,  // Frame 2
      -15.0, // Frame 3
      -25.0, // Frame 4
      -30.0, // Frame 5
      -25.0, // Frame 6
      -15.0, // Frame 7
      -5.0,  // Frame 8
      0.0,   // Frame 9
    ];
    
    // Get jump offset for current frame
    final jumpOffset = jumpOffsets[_currentFrame - 1];
    
    return Transform.translate(
      offset: Offset(0, jumpOffset),
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: Image.asset(
          'assets/images/achianim/frame$_currentFrame.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
} 