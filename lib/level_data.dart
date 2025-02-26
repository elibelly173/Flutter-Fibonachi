// Test change

class LevelPosition {
  double x;
  double y;

  LevelPosition(this.x, this.y);

  // Factory constructor to convert from Cocos2d coordinates
  factory LevelPosition.fromCocos2d(double cocosX, double cocosY) {
    // Convert from Cocos2d coordinates to normalized Flutter coordinates
    double flutterX = cocosX / 100;  // Convert percentage to decimal
    double flutterY = cocosY / 100;  // Convert percentage to decimal
    
    print('Converting Cocos2d ($cocosX, $cocosY) to Flutter ($flutterX, $flutterY)');
    return LevelPosition(flutterX, flutterY);
  }
}

List<LevelPosition> levelPositions = [
  // Original Cocos2d coordinates from plist
  LevelPosition.fromCocos2d(39.5, 8.5),    // Level 1
  LevelPosition.fromCocos2d(56.5, 14.0),   // Level 2
  LevelPosition.fromCocos2d(66.5, 25.0),   // Level 3
  LevelPosition.fromCocos2d(53.5, 35.0),   // Level 4
  LevelPosition.fromCocos2d(37.5, 42.0),   // Level 5
  LevelPosition.fromCocos2d(19.5, 48.5),   // Level 6
  LevelPosition.fromCocos2d(5.5, 58.5),    // Level 7
  LevelPosition.fromCocos2d(13.5, 69.5),   // Level 8
  LevelPosition.fromCocos2d(50.0, 77.5),   // Level 9
  LevelPosition.fromCocos2d(64.5, 79.5),   // Level 10
  LevelPosition.fromCocos2d(70.5, 89.5),   // Level 11
  LevelPosition.fromCocos2d(62.0, 101.0),  // Level 12
  LevelPosition.fromCocos2d(53.0, 113.0),  // Level 13
  LevelPosition.fromCocos2d(35.5, 116.5),  // Level 14
  LevelPosition.fromCocos2d(22.5, 125.5),  // Level 15
  LevelPosition.fromCocos2d(27.5, 137.5),  // Level 16
  LevelPosition.fromCocos2d(38.5, 145.0),  // Level 17
  LevelPosition.fromCocos2d(52.0, 150.5),  // Level 18
  LevelPosition.fromCocos2d(62.0, 185.5),  // Level 19
  LevelPosition.fromCocos2d(45.0, 189.5),  // Level 20
  LevelPosition.fromCocos2d(27.5, 198.5),  // Level 21
  LevelPosition.fromCocos2d(26.5, 234.5),  // Level 22
  LevelPosition.fromCocos2d(45.0, 239.5),  // Level 23
  LevelPosition.fromCocos2d(64.5, 242.5),  // Level 24
  LevelPosition.fromCocos2d(79.0, 255.0),  // Level 25
  LevelPosition.fromCocos2d(65.5, 264.5),  // Level 26
  LevelPosition.fromCocos2d(42.0, 270.5),  // Level 27
  LevelPosition.fromCocos2d(22.0, 275.5),  // Level 28
  LevelPosition.fromCocos2d(13.5, 287.0),  // Level 29
  LevelPosition.fromCocos2d(30.0, 297.5),  // Level 30
  LevelPosition.fromCocos2d(50.0, 304.0),  // Level 31
  LevelPosition.fromCocos2d(31.5, 340.0),  // Level 32
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
