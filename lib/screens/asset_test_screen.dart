import 'package:flutter/material.dart';

class AssetTestScreen extends StatelessWidget {
  const AssetTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asset Test'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildTestSection(
              'Basic Assets',
              [
                'assets/images/close.png',
                'assets/images/continue.png',
                'assets/images/level_ground.png',
                'assets/images/Vinyet.png',
                'assets/images/number5.png',
                'assets/images/number10.png',
                'assets/images/number20.png',
              ],
            ),
            _buildTestSection(
              'Level Numbers (Complete)',
              List.generate(32,
                  (index) => 'assets/images/levels_complete/${index + 1}.png'),
            ),
            _buildTestSection(
              'Level Numbers (Incomplete)',
              List.generate(
                  32,
                  (index) =>
                      'assets/images/levels_incomplete/${index + 1}.png'),
            ),
            _buildTestSection(
              'Contents',
              List.generate(32,
                  (index) => 'assets/images/contents/content${index + 1}.png'),
            ),
            _buildTestSection(
              'Timer',
              List.generate(
                  5, (index) => 'assets/images/timer/${index + 1}.png'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestSection(String title, List<String> assetPaths) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...assetPaths.map((path) => _buildAssetTest(path)),
      ],
    );
  }

  Widget _buildAssetTest(String assetPath) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: Image.asset(
              assetPath,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.error,
                  color: Colors.red,
                );
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              assetPath,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
