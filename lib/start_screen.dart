@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Stack(
      children: [
        // Background image that fills the entire screen
        Positioned.fill(
          child: Image.asset(
            'assets/images/start.png',
            fit: BoxFit.cover,
          ),
        ),
        // Gesture detector for tapping
        Positioned.fill(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const MapScreen()),
              );
            },
          ),
        ),
      ],
    ),
  );
} 