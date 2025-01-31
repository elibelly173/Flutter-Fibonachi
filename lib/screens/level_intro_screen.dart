import 'package:flutter/material.dart';
import '../level_data.dart';

class LevelIntroScreen extends StatelessWidget {
  final LevelData levelData;
  final VoidCallback onStart;
  final VoidCallback onClose;

  const LevelIntroScreen({
    required this.levelData,
    required this.onStart,
    required this.onClose,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Close button
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Image.asset('assets/images/close.png'),
                onPressed: onClose,
              ),
            ),

            // Level number and name
            Text(
              'Level ${levelData.level}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              levelData.name,
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const SizedBox(height: 24),

            // Problem count
            Text(
              '${levelData.targetNumber} Problems',
              style: Theme.of(context).textTheme.titleMedium,
            ),

            const SizedBox(height: 24),

            // Time requirements
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTimeRequirement('⭐⭐⭐⭐', levelData.time1),
                _buildTimeRequirement('⭐⭐⭐', levelData.time2),
                _buildTimeRequirement('⭐⭐', levelData.time3),
              ],
            ),

            const SizedBox(height: 32),

            // Start button
            ElevatedButton(
              onPressed: onStart,
              child: const Text('Start'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeRequirement(String stars, int seconds) {
    return Column(
      children: [
        Text(stars),
        const SizedBox(height: 8),
        Text('$seconds sec'),
      ],
    );
  }
}
