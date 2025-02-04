// Test change

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
  LevelPosition(0.3741156445667631, 0.033198838013191595),   // Level 1
  LevelPosition(0.5076678216754811, 0.0422028069257579),     // Level 2
  LevelPosition(0.6083978535625661, 0.06808921754938622),    // Level 3
  LevelPosition(0.5336991782305707, 0.1029795970855807),     // Level 4
  LevelPosition(0.3707202502334886, 0.12323852713885479),    // Level 5
  LevelPosition(0.19415974490331636, 0.14237196107805822),   // Level 6
  LevelPosition(0.051553182905869854, 0.17163486004389866),  // Level 7
  LevelPosition(0.1353062431265936, 0.20427424735195152),    // Level 8
  LevelPosition(0.5, 0.2279096657474382),                    // Level 9
  LevelPosition(0.6480107874507463, 0.23353714631779215),    // Level 10
  LevelPosition(0.7091278854496521, 0.2639255413977035),     // Level 11
  LevelPosition(0.6208476327845657, 0.2965649287057564),     // Level 12
  LevelPosition(0.5303037838972982, 0.3325808043560217),     // Level 13
  LevelPosition(0.3571386729003994, 0.34271026938265864),    // Level 14
  LevelPosition(0.2281136882360426, 0.36859668000628687),    // Level 15
  LevelPosition(0.27904460323513103, 0.4034870595424813),    // Level 16
  LevelPosition(0.3899608181220327, 0.4259969818238968),     // Level 17
  LevelPosition(0.5246447933418439, 0.44175392742088826),    // Level 18
  LevelPosition(0.6208476327845659, 0.545299569915401),      // Level 19
  LevelPosition(0.4499461180098489, 0.556554531056109),      // Level 20
  LevelPosition(0.2779128051240405, 0.5835664377938079),     // Level 21
  LevelPosition(0.2654630259020411, 0.6882375764023911),     // Level 22
  LevelPosition(0.4488143198987572, 0.7039945219993818),     // Level 23
  LevelPosition(0.6480107874507461, 0.7118729947978781),     // Level 24
  LevelPosition(0.7906173494481916, 0.7490143665622138),     // Level 25
  LevelPosition(0.6581969704505639, 0.7771517694139839),     // Level 26
  LevelPosition(0.422782963343668, 0.7951597072391167),      // Level 27
  LevelPosition(0.22132289956949672, 0.8097911567220363),    // Level 28
  LevelPosition(0.13870163745986483, 0.8435560401441605),    // Level 29
  LevelPosition(0.30394416167912874, 0.8739444352240714),    // Level 30
  LevelPosition(0.5, 0.8930778691632745),                    // Level 31
  LevelPosition(0.3186575371233108, 0.9988745038859291),     // Level 32
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
