class LevelPosition {
  double x;
  double y;

  LevelPosition(this.x, this.y);

  // Factory constructor to convert from Cocos2d coordinates
  factory LevelPosition.fromCocos2d(double cocosX, double cocosY) {
    // Use the actual displayed map dimensions
    const displayWidth = 1036.0;
    const displayHeight = 4548.8;
    const aspectRatio = displayWidth / displayHeight;
    
    // Apply a consistent transformation for all levels
    double flutterX = (cocosX / 100) - (cocosY / 500);  // Adjust X based on height
    double flutterY = (cocosY / 100) * 0.27;
    
    print('Converting Cocos2d ($cocosX, $cocosY) to Flutter ($flutterX, $flutterY)');
    return LevelPosition(flutterX, flutterY);
  }
}

List<LevelPosition> levelPositions = [
  // Level 1
  LevelPosition.fromCocos2d(39.5, 8.5),

  // Level 2
  LevelPosition.fromCocos2d(56.5, 14.0),

  // Level 3
  LevelPosition.fromCocos2d(66.5, 25.0),

  // Add more levels using original Cocos2d coordinates
  // Format: LevelPosition.fromCocos2d(x, y)
  // where x and y are the original percentage values from Cocos2d
];

class LevelData {
  final int level;
  final String name;
  final int targetNumber;
  final int time1;
  final int time2;
  final int time3;
  final double x;
  final double y;

  const LevelData({
    required this.level,
    required this.name,
    required this.targetNumber,
    required this.time1,
    required this.time2,
    required this.time3,
    required this.x,
    required this.y,
  });
}
